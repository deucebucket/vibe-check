# Test Quality Check

36% of vibe coders skip QA entirely. AI-generated tests are often superficial - they validate the code exists, not that it works correctly.

Unit tests in vibe-coded projects often become "testing theater" - the illusion of safety while real bugs lurk in the cracks.

## The Problem with AI-Generated Tests

AI creates tests that:
- Pass because they test the implementation, not the behavior
- Miss edge cases because AI didn't think of them
- Have meaningless assertions ("assert result is not None")
- Don't cover the unhappy paths
- Test what the code does, not what it should do

## What Actually Matters

### Integration Tests > Unit Tests (for vibe coding)

If you don't understand the internals (and you probably don't), you must verify the externals:
- Does the API return correct responses?
- Does the database store and retrieve correctly?
- Does the full user flow work end-to-end?

### The Test Pyramid for Vibe Coders

```
         /\
        /  \        E2E Tests (few)
       /----\       Critical user journeys
      /      \
     /--------\     Integration Tests (some)
    /          \    Service interactions, API contracts
   /------------\
  /              \  Unit Tests (many, but meaningful)
 /________________\ Business logic, pure functions
```

## Checklist

### 1. Do Tests Exist?
- [ ] Test files exist for main modules
- [ ] Tests actually run (not skipped or broken)
- [ ] CI runs tests on every PR

### 2. Test Quality
- [ ] Tests check behavior, not implementation details
- [ ] Tests have meaningful assertions (not just "doesn't throw")
- [ ] Edge cases are covered (empty input, null, boundaries)
- [ ] Error cases are tested (what happens when things fail?)
- [ ] Tests are independent (can run in any order)

### 3. Coverage (Quality over Quantity)
- [ ] Critical business logic has tests
- [ ] API endpoints have integration tests
- [ ] Auth/permission logic is tested
- [ ] Data validation is tested
- [ ] Error handling paths are tested

### 4. Test Smells to Avoid
- [ ] No tests that just check "result is not None"
- [ ] No tests that mock everything (testing mocks, not code)
- [ ] No tests that duplicate implementation logic
- [ ] No flaky tests that sometimes pass/fail

## Questions to Ask

1. **If I break this function, will a test fail?**
   - Good: Yes, clearly
   - Bad: Maybe, or the wrong test fails

2. **Do tests document expected behavior?**
   - Good: Reading tests tells you how the code should work
   - Bad: Tests are cryptic or test implementation details

3. **What happens with bad input?**
   - Good: Tests verify error handling
   - Bad: Only happy path tested

4. **Are the critical paths covered?**
   - Good: Auth, payments, data integrity tested
   - Bad: Only simple CRUD tested

## Generate Better Tests

When asking AI to generate tests, be specific:

**Bad prompt:** "Write tests for this function"

**Good prompt:** "Write tests for this function that cover:
- Normal input with expected output
- Empty input
- Invalid input (wrong type, out of range)
- Boundary conditions
- Error cases
- What the function should NOT do"

## Output Format

```
## Test Quality Report

### Overall: [GOOD / NEEDS WORK / INADEQUATE]

### Coverage Assessment
- Critical paths covered: [Yes/No/Partial]
- Edge cases covered: [Yes/No/Partial]
- Error handling tested: [Yes/No/Partial]

### Test Smells Found
[List issues or "None"]

### Missing Tests
[List critical areas without tests]

### Recommendations
1. [Most important test to add]
2. [Second priority]
3. [etc.]

### Suggested Test Cases
[Specific test cases that should exist]
```

## Remember

- Tests that pass aren't necessarily good tests
- A test that never fails is useless
- Test behavior, not implementation
- Integration tests catch what unit tests miss
- YOU define test cases, AI implements them
