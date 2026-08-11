# Frankenstein — a lean Claude Code brain

A personal Claude Code configuration for `{{YOUR_NAME}}`, built around one idea: **one lean `CLAUDE.md` beats a pile of mass-loaded files.** Skills load on trigger words, not on every request. Slash commands load on demand, not into startup context. Nothing here phones home.

This isn't a framework you install and configure — it's one engineer's setup, published so the parts might be useful to yours. Take what fits, delete what doesn't.

## What's in here

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
  scope-guard.sh                flags sessions where >10 files changed, points at IDEAS.md
commands/
  plan-ceo-review.md           scope/premise gate before architecture starts
  plan-eng-review.md           architecture lock — failure modes, diagrams, before code
  review.md                    diff review for SQL/N+1/races/LLM-trust-boundary bugs
  ship.md                      sync → test → audit → commit → push (asks before push)
  qa.md                        Playwright pass on pages the current diff touched
settings.example.json          hook + MCP wiring, no secrets, uses env var refs
settings.local.example.json    permission allow/deny/ask lists as a starting point
```

## Install

1. Copy `CLAUDE.md` to `~/.claude/CLAUDE.md`, edit the identity/stack sections to match you.
2. Copy `skills/` and `commands/` into `~/.claude/skills/` and `~/.claude/commands/`.
3. Copy `hooks/` into `~/.claude/hooks/`, `chmod +x` them.
4. Merge `settings.example.json` and `settings.local.example.json` into your own `~/.claude/settings.json` / `settings.local.json` — don't blind-overwrite, check what you already have.
5. Set `GITHUB_TOKEN` as an environment variable if you want the `github` MCP server working. Never paste it into a file.

Skills and commands only cost tokens when they fire — nothing here loads into every request except `CLAUDE.md` itself, which is why it's kept short.

## Why this exists

A framework called **gstack** (Garry Tan's Claude Code setup, [github.com/garrytan/gstack](https://github.com/garrytan/gstack)) turns Claude Code into a 23-skill virtual engineering team. It's real, well-used, and has good ideas in it. It's also ~80-90% infrastructure per skill file — its own telemetry, a self-updater, a state directory, cross-model orchestration — and by default it auto-edits your `CLAUDE.md`, auto-commits that edit, and ships `/ship` as "never ask before pushing."

`plan-ceo-review`, `plan-eng-review`, `review`, `ship`, and `qa` in this repo are rebuilt from reading gstack's actual source — the checklist logic and review heuristics that were genuinely worth keeping — stripped of everything else. Differences worth knowing if you've used gstack:

- No telemetry, no self-updater, no state directory.
- Nothing here edits your `CLAUDE.md` or commits on your behalf.
- `ship.md` asks before pushing. It does not override your permission settings.

## The islamic-foundation skill

This one's personal. It's the author's ethical reasoning layer — grounded in Islamic principles (trust, honesty, no dark patterns, no harm) — that shapes how architectural and ethical tradeoffs get reasoned through. It's included as-is because it's genuinely part of how this setup was built, not because it should be anyone else's default.

If it's not for you: delete `skills/islamic-foundation/`, nothing else depends on it.

## License

MIT. See `LICENSE`.
