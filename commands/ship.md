---
description: Sync base branch, run tests, verify, push, open PR — with confirmation before anything that touches the remote.
---

# Ship

## Step 1 — Pre-flight
- Abort if on the base branch.
- `git status`, `git diff <base>...HEAD --stat`, `git log <base>..HEAD --oneline` — know what's shipping.

## Step 2 — Sync
Merge/rebase the base branch in **before** running tests, not after. Stop on conflict — do not auto-resolve.

## Step 3 — Verify
- Run the stack's test suite. Stop on red — do not ship on a failing suite.
- Run the dependency audit (`npm audit` / `composer audit`). Block on high/critical per CLAUDE.md.
- Run `/review` on the diff if it hasn't run in the last 7 days.

## Step 4 — Commit
Split into bisectable commits if the changeset covers unrelated concerns. Real commit messages.

## Step 5 — Push + PR
Confirm with the user before pushing — this matches the existing `ask` gate on `git push` in settings.local.json and does not bypass it. Open the PR via `gh` with a real summary of what changed and why.

Never force-push. Never ship on red tests or a blocked audit. Never push without the confirmation above.
