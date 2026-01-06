# Full Push Audit

Complete audit flow before pushing. Runs all checks in sequence, then requires you to explain what you're shipping.

**This is the "I'm about to push to production" command.**

## The Flow

```
/audit runs:

1. /deps          → Are dependencies real and safe?
2. /dry           → Is there duplicated logic?
3. /architecture  → Is the structure maintainable?
4. /tests         → Are tests meaningful?
5. /observability → Can we see what's happening in prod?
6. /review        → What bugs are hiding?
7. /security-audit → What can be exploited?
8. /understand    → Can YOU explain this code?

→ Final Report + Sign-off
```

## Instructions

Run each check in sequence. Track findings as you go.

### Phase 1: Foundation Checks

**1. Dependencies (`/deps` logic)**
- Verify all packages exist in official registries
- Check for known vulnerabilities
- Flag outdated or suspicious packages
- Record: PASS / ISSUES FOUND / CRITICAL

**2. DRY Check (`/dry` logic)**
- Scan for duplicated business logic
- Find hardcoded values in multiple places
- Identify functions that should be merged
- Record: CLEAN / HAS DUPLICATION

**3. Architecture (`/architecture` logic)**
- Check for god objects and bloated modules
- Assess coupling between components
- Look for over-engineering
- Record: GOOD / NEEDS WORK / PROBLEMATIC

### Phase 2: Quality Checks

**4. Tests (`/tests` logic)**
- Verify tests exist and run
- Assess test quality (behavior vs implementation)
- Check edge case and error coverage
- Record: ADEQUATE / INADEQUATE / MISSING

**5. Observability (`/observability` logic)**
- Check logging coverage
- Verify error tracking
- Look for silent failures
- Record: GOOD / NEEDS WORK / BLIND

### Phase 3: Risk Assessment

**6. Code Review (`/review` logic)**
- Adversarial review of changes
- Find bugs, edge cases, race conditions
- Categorize by severity
- Record: READY / HAS ISSUES / NOT READY

**7. Security Audit (`/security-audit` logic)**
- Check auth and token handling
- Look for injection vulnerabilities
- Assess blast radius
- Record: LOW RISK / MEDIUM RISK / HIGH RISK / CRITICAL

### Phase 4: Understanding Check

**8. Code Understanding (`/understand` logic)**

Before signing off, the developer must explain:

1. **What does this code do?** (One paragraph)
2. **Why this approach?** (Key decisions made)
3. **What could go wrong?** (Failure modes)
4. **How would you debug this at 3am?** (Troubleshooting plan)

If the developer can't answer these clearly, **the audit fails.**

## Output Format

```
## Push Audit Report

### Summary
Date: [date]
Files changed: [count]
Lines added/removed: [+X / -Y]

### Check Results

| Check | Status | Issues |
|-------|--------|--------|
| Dependencies | [PASS/FAIL] | [count] |
| DRY | [PASS/FAIL] | [count] |
| Architecture | [PASS/FAIL] | [count] |
| Tests | [PASS/FAIL] | [count] |
| Observability | [PASS/FAIL] | [count] |
| Code Review | [PASS/FAIL] | [count] |
| Security | [PASS/FAIL] | [count] |

### Critical Issues (Must Fix)
[List or "None"]

### High Priority Issues
[List or "None"]

### Medium/Low Issues
[List or "None - or can ship with known issues"]

### Overall Verdict
[READY TO PUSH / FIX REQUIRED / DO NOT PUSH]

---

## Developer Sign-Off

Before pushing, confirm you can answer:

[ ] I can explain what this code does
[ ] I understand why this approach was chosen
[ ] I know what could go wrong
[ ] I know how to debug this if it breaks

### Your Explanation
[Developer writes their understanding here]

---

## Final Decision
[APPROVED TO PUSH / NOT APPROVED]
```

## When to Use

- Before pushing to main/production
- Before creating a PR for review
- Before a release
- When you want to be thorough

## When NOT to Use

- Quick fixes you fully understand
- Small typo corrections
- Documentation-only changes

Use `/check` for everyday pushes. Use `/audit` when it matters.

## Remember

This is not bureaucracy - it's the difference between shipping code and shipping problems.

The `/understand` step at the end is the most important. If you can't explain it, you shouldn't ship it.
