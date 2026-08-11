---
description: Architecture gate — lock design, failure modes, and diagrams before writing implementation code.
---

# Engineering Review

Run before implementation starts. Output is a short locked-design doc, not code.

## Prime Directives
1. Zero silent failures — every failure mode visible to system, team, or user.
2. Name every error. Not "handle errors" — the specific exception, what triggers it, what catches it, what the user sees. Catch-all handlers (`catch (Exception)`, bare `except:`) are a defect — call them out.
3. Trace all 4 paths for every new data flow: happy, nil/null input, empty/zero-length input, upstream error.
4. Map interaction edge cases: double-click, navigate-away-mid-action, slow connection, stale state, back button.
5. Observability (logs/metrics/traces) is scope, not a follow-up ticket.
6. Diagram every non-trivial flow — ASCII is fine, ambiguity is not.
7. Anything deferred goes in IDEAS.md or TODOS.md. Vague intentions don't count as decisions.

## Step 1 — Architecture
Components, data flow, one diagram.

## Step 2 — Failure Modes
What breaks first under load, bad input, partial outage, concurrent access?

## Step 3 — Data & Interfaces
Migrations needed? Reversible? Lock the API/type contract here — not mid-build.

## Step 4 — Budget Check
Does this fit the 40-line/200-line/3-nesting rules from CLAUDE.md by design, or is a violation already baked in?

Output: locked design + open risks list. Confirm with the user before implementation starts.
