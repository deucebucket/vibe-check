# DRY (Don't Repeat Yourself) Check

AI doesn't see duplication as a flaw - it sees it as a probability of success. It predicts patterns, and if repeating code worked before, it'll do it again.

The result: duplicated logic scattered across the codebase that drifts apart over time.

## Why This Matters

When the same logic appears in several places:
- Change one copy, forget the others → bugs
- Each copy evolves differently → inconsistency
- More code to maintain → slower development
- AI agents get confused → worse AI suggestions

## What DRY Actually Means

DRY is NOT just "don't copy-paste code."

The original definition from The Pragmatic Programmer:
> "Every piece of knowledge must have a single, unambiguous, authoritative representation within a system."

It's about **knowledge**, not code. Two pieces of code that look the same might represent different concepts and SHOULD be separate.

## Real Duplication vs Incidental Similarity

### Real Duplication (FIX IT)
Same business logic in multiple places:
- Validation rules copied to multiple endpoints
- Price calculation in both frontend and backend
- User permission checks scattered everywhere
- Configuration values hardcoded in multiple files

### Incidental Similarity (LEAVE IT)
Code that looks the same but represents different things:
- Two forms with similar structure but different purposes
- Similar-looking functions that handle different domains
- Boilerplate that's intentionally explicit

**Test:** If one changes, should the other change too?
- Yes → Real duplication, extract it
- No → Incidental similarity, leave it

## Checklist

### 1. Configuration & Constants
- [ ] Magic numbers are named constants
- [ ] Configuration is centralized, not scattered
- [ ] No hardcoded values that appear multiple times
- [ ] Environment-specific values in config, not code

### 2. Business Logic
- [ ] Validation rules defined once
- [ ] Calculations/formulas not duplicated
- [ ] Business rules in one place
- [ ] No copy-pasted logic with minor variations

### 3. Data Access
- [ ] Database queries not duplicated
- [ ] API calls wrapped in reusable functions
- [ ] Data transformation logic centralized

### 4. Error Handling
- [ ] Error messages not duplicated
- [ ] Error handling patterns consistent
- [ ] Common error handling extracted

### 5. UI/Presentation (if applicable)
- [ ] Reusable components for repeated UI patterns
- [ ] Styles not duplicated
- [ ] Common layouts extracted

## Red Flags

Watch for these patterns:

```python
# BAD: Same validation in multiple places
def create_user(email):
    if not '@' in email:
        raise ValueError("Invalid email")
    ...

def update_user(email):
    if not '@' in email:
        raise ValueError("Invalid email")
    ...

# GOOD: Validation in one place
def validate_email(email):
    if not '@' in email:
        raise ValueError("Invalid email")
    return email

def create_user(email):
    email = validate_email(email)
    ...
```

```python
# BAD: Same calculation repeated
total = price * quantity * 1.08  # tax calculation
...
order_total = item_price * item_qty * 1.08  # same calculation elsewhere

# GOOD: Calculation in one place
TAX_RATE = 0.08

def calculate_total(price, quantity):
    return price * quantity * (1 + TAX_RATE)
```

## Questions to Ask

1. **If this logic changes, how many places need updating?**
   - Good: One place
   - Bad: Multiple files/functions

2. **Is this string/number/value defined multiple times?**
   - Good: Single source of truth
   - Bad: Same value hardcoded in multiple places

3. **Are there functions that do almost the same thing?**
   - Good: Shared core with variations as parameters
   - Bad: Copy-pasted with minor changes

## Output Format

```
## DRY Analysis

### Overall: [CLEAN / HAS DUPLICATION / SIGNIFICANT ISSUES]

### Duplicated Logic Found
[List specific duplications with file locations]

### Duplicated Constants/Values
[List hardcoded values that appear multiple times]

### Similar Functions That Could Be Merged
[List functions that do almost the same thing]

### Recommendations
1. [Most important extraction]
2. [Second priority]
3. [etc.]

### Note on Incidental Similarity
[Any code that looks duplicated but should stay separate]
```

## Remember

- Duplication is a maintenance nightmare
- But not all similar code is duplication
- Extract when the knowledge is the same
- Leave separate when the concepts are different
- AI loves to duplicate - actively look for it
