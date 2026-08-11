---
description: Playwright-driven QA pass on the pages/flows touched by the current diff.
---

# QA Pass

## Step 1 — Scope
Feature branch with pending changes → diff-aware: `git diff <base>` to find changed routes/components, test only those.
Explicit URL/page given → full mode: test that page directly.

## Step 2 — Test
Per affected page, via Playwright MCP:
- Golden path.
- One realistic edge case (empty state, error state, or whatever the diff actually changed).
- Console: any errors?
- Network tab: any failed requests?

## Step 3 — Report
One line per page: pass/fail + why. Screenshot only on failure. No narrative.

Something's broken → locate the source (grep the error/component name), fix, re-test the same page before moving on.
