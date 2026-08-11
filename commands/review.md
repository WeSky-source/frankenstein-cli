---
description: Diff review for the bug classes linters miss — SQL/N+1, race conditions, LLM trust-boundary violations, shell injection, enum completeness.
---

# Diff Review

Reviews `git diff <base>` (or specified files). Two passes. Cite file:line, suggest the fix, skip what's fine.

## Pass 1 — Critical

**SQL & data safety** — string-interpolated SQL (parameterize instead); N+1 from missing eager-load in a loop; bypassing model validation for direct writes; TOCTOU check-then-set that should be an atomic `WHERE`+`UPDATE`.

**Race conditions** — status transitions without atomic `WHERE old_status=? SET new_status`; find-or-create without a unique index; unsafe raw-HTML rendering on user-controlled data (XSS).

**LLM output trust boundary** — LLM-generated values written to DB/mailers without validation; structured tool output accepted without type/shape checks; LLM-generated URLs fetched without an allowlist (SSRF risk); LLM output stored in a vector DB/knowledge base without sanitization (stored prompt injection).

**Shell injection** — `shell=True` / `os.system()` with interpolated strings; `eval`/`exec` on generated code.

**Enum/value completeness** — new enum value, status, or tier: grep every file referencing sibling values, READ each one (not just grep), confirm it's handled. This is the one category that requires reading outside the diff.

## Pass 2 — Informational
Async/sync mixing, wrong column names in ORM calls, type coercion across serialization boundaries, O(n·m) view lookups, CI/CD publish-step correctness.

## Confidence gate
Every finding gets a confidence score, 1-10. Before it goes in the report: quote the exact line(s) that prove it. Can't quote it → confidence caps at 4-5, moves to an appendix, doesn't appear in the main report. This kills "field doesn't exist" false positives.

## Output
```
[P1] (confidence: 9/10) file:line — problem → fix
[P2] (confidence: 6/10, verify) file:line — problem → fix
```
No preamble, no "looks good overall." Nothing found → say so in one line.

Note: overlaps with the built-in `/code-review` skill. Use that for a full pass; use this for a fast, narrow pre-commit check.
