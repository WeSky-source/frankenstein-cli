---
name: security
description: Military-grade backend security auditor. Loads for all Node.js/Laravel backend code. Checks auth, input, queries, deps, and system-level posture.
triggers: [api, route, controller, middleware, auth, login, token, jwt, password, database, query, endpoint, backend, server, laravel, express, node]
---

# Security Enforcer — Military Grade 🔒

## Threat Model (assume all of these)
- Hostile input on every endpoint
- Compromised dependency in the tree
- Insider threat with DB access
- Network-level attacker (MITM capable)
- Automated scanner hitting endpoints

## Audit Checklist — Run on Every Backend Function

### Authentication
- [ ] Passwords hashed with bcrypt (cost ≥ 12) or argon2id
- [ ] JWT: HS256 minimum, RS256 preferred. Expiry ≤ 15min (access)
- [ ] Refresh tokens: single-use, rotated, stored as hash not plaintext
- [ ] Failed login: rate limited + exponential backoff
- [ ] Account lockout after N failures (configurable, default 5)
- [ ] Session invalidation on password change

### Authorization
- [ ] Every route has explicit auth middleware
- [ ] RBAC enforced at middleware, not controller
- [ ] Resource ownership verified before return (user can only see their data)
- [ ] Admin routes isolated — separate router, separate middleware chain

### Input Validation
- [ ] Zod schema (Node) or Form Request (Laravel) at boundary
- [ ] Max length on all string fields
- [ ] Type coercion explicit — never implicit
- [ ] File uploads: type, size, mime validation. Store outside webroot.
- [ ] Regex: no ReDoS-vulnerable patterns (avoid catastrophic backtracking)

### Database
- [ ] Zero string concatenation in queries
- [ ] Parameterized queries or ORM with bound params
- [ ] DB user has minimum required permissions (no root)
- [ ] No sensitive data in logs (mask PII, tokens, passwords)
- [ ] Soft delete on user data (GDPR)

### API Hardening
- [ ] Helmet.js configured (not just default)
- [ ] CORS: explicit origin whitelist. No `*` in production.
- [ ] Rate limiting: global + per-endpoint for sensitive routes
- [ ] Request size limit (default 100kb, adjust per endpoint)
- [ ] No stack traces in error responses
- [ ] Error messages: generic to client, detailed to logs only

### Secrets
- [ ] Zero secrets in code or comments
- [ ] `.env` in `.gitignore` — verify
- [ ] Environment-specific configs (dev/staging/prod separated)
- [ ] Secret rotation plan documented

### Dependencies
- [ ] `npm audit` / `composer audit` — zero high/critical
- [ ] No packages with last commit >2 years on critical path
- [ ] `package-lock.json` committed and integrity-checked

### System-Level (adapt to your OS/infra)
- [ ] New service → systemd unit with `CapabilityBoundingSet` restricted
- [ ] File-touching service → SELinux context verified (`ls -Z`) if on Fedora/RHEL
- [ ] Sensitive paths → auditd watch rules added
- [ ] Podman (not Docker) with SELinux labels for containerized services, where available
- [ ] firewalld/ufw zone configured — only required ports open

## Severity Scale
🔴 CRITICAL — fix before any code is committed
🟠 HIGH — fix before deploy
🟡 MEDIUM — fix this sprint
🔵 LOW — log in IDEAS.md, fix next sprint

## Output Format
```
🔴 [CRITICAL] — [file:line] — [what] — [exact fix]
🟠 [HIGH] — [file:line] — [what] — [exact fix]
```
No verbose explanations. Finding + location + fix. That's it.
