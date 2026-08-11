# Frankenstein — a lean Claude Code brain

## What this actually is

Claude Code reads a file called `CLAUDE.md` before it does anything — think of it like the note you'd leave a contractor on day one: "here's how we build things here, here's what to never do." Most setups either skip this entirely (so the AI improvises every session) or dump everything into one giant file that gets re-read on every single message — slow, expensive, and the important rules get buried in the noise.

Frankenstein splits it four ways instead of one:

- **A short core file** (`CLAUDE.md`) that's always loaded — philosophy and defaults, not a wall of edge cases.
- **Skills** that wake up only when relevant — a security checklist that loads when you're touching an API, a frontend guide that loads when you're touching a component. The rest of the time they cost nothing.
- **Commands** you type on purpose — `/review`, `/ship`, `/qa` — for workflows you don't want to re-explain from scratch every session.
- **Hooks** that run in the background automatically, no matter what — blocking a leaked API key or a `rm -rf /` before it happens, regardless of what the AI decides to do that day.

## Who this is for

- Solo devs and small teams running Claude Code daily on real projects — not an enterprise process rollout.
- Anyone on a metered or capped plan who feels the token cost of a bloated always-on prompt.
- Developers who already have opinions about code style and security and are tired of repeating them every session.
- People who want AI guardrails — destructive-command blocking, secret-leak blocking — without building that tooling themselves.

Not a great fit if you want a full multi-agent product with analytics, cross-model review, and a dozen more roles — [gstack](https://github.com/garrytan/gstack) covers that ground. This is the lighter alternative, built for one person's daily driver, not a platform.

## Why it holds up in real work

- **Loaded context is attention.** A model handed 3,000 lines of always-on rules tends to follow the first ones better than the last ones. Keep the always-on file short and every rule in it actually gets followed.
- **Hooks aren't a suggestion.** They're shell scripts the CLI runs, not the model "remembering" to be careful — a destructive command gets blocked even on a bad day.
- **Confirmation gates stay where you put them.** `/ship` still asks before it pushes. This setup doesn't quietly automate past the point a human should be looking.
- **It was used before it was published.** Every rule here came out of actual daily work, not a spec written in the abstract.

## Install

### The easy way

Open the same terminal window you already run `claude` in, paste this, hit enter:

```bash
curl -fsSL https://raw.githubusercontent.com/WeSky-source/frankenstein-cli/master/bootstrap.sh | bash
```

That's the whole install. It downloads everything, asks you one yes/no question (whether to include the personal `islamic-foundation` skill — everything else works fine without it), and tells you when it's done. No `git clone`, no `chmod`, no manually copying files around.

It's also safe to run again later — it never deletes anything of yours. If a file it wants to install already exists, it backs up the old one with a timestamp first, and only touches `settings.json` if you don't already have one.

**Not comfortable piping a script straight into bash?** That's a reasonable thing to be careful about. Read [`bootstrap.sh`](bootstrap.sh) and [`install.sh`](install.sh) first — both are short, plain bash, nothing hidden — or use the manual steps below instead.

<details>
<summary>Manual install (more steps, more visibility at each one)</summary>

```bash
git clone https://github.com/WeSky-source/frankenstein-cli.git
cd frankenstein-cli
./install.sh
```

Or entirely by hand, no script at all:

1. Copy `CLAUDE.md` to `~/.claude/CLAUDE.md`, edit the identity/stack sections to match you.
2. Copy `skills/` and `commands/` into `~/.claude/skills/` and `~/.claude/commands/`.
3. Copy `hooks/` into `~/.claude/hooks/`, `chmod +x` them.
4. Merge `settings.example.json` and `settings.local.example.json` into your own `~/.claude/settings.json` / `settings.local.json` — don't blind-overwrite, check what you already have.
5. Set `GITHUB_TOKEN` as an environment variable if you want the `github` MCP server working. Never paste it into a file.

</details>

## What's in the repo

```
CLAUDE.md                      root identity + philosophy, loaded every session
skills/
  frontend/SKILL.md            Next.js/React specialist — triggers on component/UI work
  logic/SKILL.md               edge-case reasoning for non-trivial business logic
  security/SKILL.md            backend security checklist — triggers on api/auth/db work
  islamic-foundation/SKILL.md  the author's personal ethical reasoning layer (see below)
hooks/
  pre-tool-gate.sh             blocks secret leaks, destructive commands, writes outside project root
  post-format.sh               auto-runs prettier/eslint/pint after Write/Edit
  scope-guard.sh               flags sessions where >10 files changed, points at IDEAS.md
commands/
  plan-ceo-review.md           scope/premise gate before architecture starts
  plan-eng-review.md           architecture lock — failure modes, diagrams, before code
  review.md                    diff review for SQL/N+1/races/LLM-trust-boundary bugs
  ship.md                      sync → test → audit → commit → push (asks before push)
  qa.md                        Playwright pass on pages the current diff touched
install.sh                     interactive installer — see Install above
settings.example.json          hook + MCP wiring, no secrets, uses env var refs
settings.local.example.json    permission allow/deny/ask lists as a starting point
```

## Why this exists

A framework called **gstack** (Garry Tan's Claude Code setup, [github.com/garrytan/gstack](https://github.com/garrytan/gstack)) turns Claude Code into a 23-skill virtual engineering team. It's real, well-used, and has good ideas in it. It's also ~80-90% infrastructure per skill file — its own telemetry, a self-updater, a state directory, cross-model orchestration — and by default it auto-edits your `CLAUDE.md`, auto-commits that edit, and ships `/ship` as "never ask before pushing."

`plan-ceo-review`, `plan-eng-review`, `review`, `ship`, and `qa` in this repo were rebuilt from reading gstack's actual source — the checklist logic and review heuristics that were genuinely worth keeping — stripped of everything else. Differences worth knowing if you've used gstack:

- No telemetry, no self-updater, no state directory.
- Nothing here edits your `CLAUDE.md` or commits on your behalf.
- `ship.md` asks before pushing. It does not override your permission settings.

## The islamic-foundation skill

This one's personal. It's the author's ethical reasoning layer — grounded in Islamic principles (trust, honesty, no dark patterns, no harm) — that shapes how architectural and ethical tradeoffs get reasoned through. It's included as-is because it's genuinely part of how this setup was built, not because it should be anyone else's default. The installer asks before adding it; skip it and everything else works exactly the same.

## License

MIT. See `LICENSE`.
