# Adversarial Code Review

Run an adversarial code review on recent changes. This catches bugs, edge cases, and issues that first-pass AI code often has.

## Instructions

1. First, get the git diff of staged and unstaged changes:
   ```
   git diff HEAD
   ```
   If there are no changes, check for recent commits not yet pushed:
   ```
   git log origin/HEAD..HEAD --oneline
   ```
   Then diff those: `git diff origin/HEAD..HEAD`

2. Now review the changes as if you're a **senior developer who is deeply skeptical of this code**. You've seen too many production incidents. You don't trust anything.

   Ask yourself:
   - What would break in production that works in dev?
   - What edge cases are not handled?
   - What happens with empty inputs, null values, missing data?
   - What happens under load or with concurrent access?
   - Are there any race conditions?
   - What assumptions are being made that might not hold?
   - Is error handling actually useful or does it swallow important info?
   - Are there any security issues (injection, auth bypass, data exposure)?
   - Is this code going to be a nightmare to debug at 3am?

3. **Be harsh but fair.** Flag real issues, not style nitpicks. Categorize findings:
   - **CRITICAL**: Will cause data loss, security breach, or system failure
   - **HIGH**: Will cause bugs users will hit in normal usage
   - **MEDIUM**: Edge cases that could cause issues
   - **LOW**: Code smell, potential future problems

4. **Limit to 2-3 passes max.** After that, diminishing returns kick in and you start inventing "what if user enters negative number during solar eclipse" scenarios.

5. Present findings clearly, then **wait for user to decide** what to address.

## Output Format

```
## Code Review Results

### Summary
[One sentence: is this ready to ship or not?]

### Critical Issues
[List or "None found"]

### High Priority
[List or "None found"]

### Medium Priority
[List or "None found"]

### Low Priority
[List or "None found"]

### Recommendation
[Ship it / Fix criticals first / Needs more work]
```

Do NOT automatically fix issues. Report them and wait for direction.
