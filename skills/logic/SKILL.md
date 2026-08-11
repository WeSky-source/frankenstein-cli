---
name: logic
description: Deep reasoning engine for complex business logic, algorithm design, and edge case analysis. Loads when function complexity exceeds simple CRUD.
triggers: [algorithm, logic, business rule, edge case, calculation, flow, state machine, validation logic, complex, reasoning]
---

# Logic Reasoner

## Protocol — Before Writing Any Complex Function

### Step 1 — Define (1 sentence)
What does this function do? If you need more than one sentence, split the function.

### Step 2 — Edge Cases (enumerate all)
- Empty / null / undefined inputs
- Zero values and negative numbers
- Maximum values (overflow risk?)
- Concurrent execution (race condition risk?)
- Partial failure (what's the rollback?)
- Malformed input that passes type checks

### Step 3 — State Map (if stateful)
Draw the state transitions before writing code:
```
state A --[trigger]--> state B --[trigger]--> state C
         --[error]---> state ERROR
```

### Step 4 — Write the function

### Step 5 — Verify
Walk through each edge case from Step 2.
Does the function handle all of them?
If not, fix before moving on.

---

## Code Patterns ({{YOUR_NAME}}'s style — edit to taste)

### Early return over nesting
```ts
// ❌ nested hell
function process(input) {
  if (input) {
    if (input.valid) {
      if (input.data) {
        return transform(input.data)
      }
    }
  }
}

// ✅ flat and clear
function process(input) {
  if (!input) return null
  if (!input.valid) return null
  if (!input.data) return null
  return transform(input.data)
}
```

### Result pattern for operations that can fail
```ts
type Result<T> = { ok: true; data: T } | { ok: false; error: string }

function riskyOp(input: Input): Result<Output> {
  if (!valid(input)) return { ok: false, error: 'Invalid input' }
  return { ok: true, data: compute(input) }
}
```

### No implicit state mutation
```ts
// ❌ mutates input
function addItem(cart, item) {
  cart.items.push(item)
  return cart
}

// ✅ returns new state
function addItem(cart, item) {
  return { ...cart, items: [...cart.items, item] }
}
```

---

## Scope Change Detection

If while reasoning about a function you realize:
- The function needs data it shouldn't own → wrong layer, refactor first
- The function is doing 2+ jobs → split before implementing
- The logic requires a new model/table → STOP, log in IDEAS.md, discuss scope

---

## Complexity Budget

- Cyclomatic complexity > 10 → mandatory refactor
- Function > 40 lines → split
- More than 3 parameters → use an options object
- Boolean parameter → almost always wrong (use separate functions)
