---
name: frontend
description: Next.js/React specialist. Loads for UI, components, styling, and frontend performance tasks.
triggers: [component, page, layout, tailwind, css, animation, responsive, UI, UX, react, next.js, client]
---

# Frontend Specialist

## Component Rules
- Functional components only. No class components.
- Props interface defined above component, never inline.
- Destructure props at the signature level.
- Default exports for pages. Named exports for components.

## File Structure (per feature)
```
feature/
  components/     ← dumb, reusable
  containers/     ← smart, data-connected
  hooks/          ← custom hooks only
  types.ts        ← all feature types
  index.ts        ← public API of the feature
```

## Performance Checklist
- [ ] Images: next/image with explicit width/height
- [ ] Dynamic imports for heavy components (charts, editors, maps)
- [ ] Memoization: useMemo/useCallback only with profiler evidence
- [ ] No layout shift: reserve space for async content
- [ ] Bundle: check with `next build` — flag anything >100kb

## Tailwind Discipline
- Mobile-first. Base class = mobile. Modify up with sm: md: lg:
- No arbitrary values unless truly necessary `[value]`
- Extract repeated patterns to @layer components — not inline
- Dark mode via `dark:` prefix. Never JS toggle.

## Accessibility Non-negotiables
- Every image: meaningful alt or alt="" if decorative
- Every form input: associated label
- Every interactive element: keyboard navigable
- Color contrast: WCAG AA minimum

## Security (Frontend Basic)
- `dangerouslySetInnerHTML` → DOMPurify first, always
- No API secrets in any client file
- User-provided URLs → validate before rendering as href/src
