# Pre-Push Check - Full Verification Pipeline

Run all checks before pushing. This is the "hardening phase" that vibe coders skip.

**This command does NOT push automatically.** It runs checks and reports results. You decide what happens next.

## Pipeline

### Step 1: Detect Project Type & Run Tests

First, figure out what kind of project this is and run appropriate tests:

**Python:**
- Look for `pytest.ini`, `setup.py`, `pyproject.toml`, or `test*.py` files
- Run: `pytest` or `python -m pytest`
- Also run: `python -m py_compile` on main files for syntax check

**Node/JavaScript:**
- Look for `package.json`
- Run: `npm test` or `yarn test`
- Check for lint: `npm run lint` if available

**Go:**
- Look for `go.mod`
- Run: `go test ./...`
- Run: `go vet ./...`

**Rust:**
- Look for `Cargo.toml`
- Run: `cargo test`
- Run: `cargo clippy` if available

**Other:**
- Look for Makefile with `test` target
- Look for docker-compose with test services
- Report if no tests found (this is a finding!)

### Step 2: Run Adversarial Code Review

Execute the `/review` command logic:
- Get git diff
- Review with senior-dev-who-hates-this-code mindset
- Categorize findings by severity

### Step 3: Run Security Audit

Execute the `/security-audit` command logic:
- Check for common vibe coder security mistakes
- Apply the "blast radius" question
- Categorize findings

### Step 4: Report Everything

Present a unified report:

```
## Pre-Push Check Results

### Test Results
- Status: PASSED / FAILED / NO TESTS FOUND
- [Details of any failures]

### Code Review
- Status: READY / HAS ISSUES
- Critical: X | High: X | Medium: X | Low: X
- [Summary of top issues]

### Security Audit
- Risk Level: LOW / MEDIUM / HIGH / CRITICAL
- [Summary of findings]

### Overall Verdict
[READY TO PUSH / NEEDS ATTENTION / DO NOT PUSH]

### Action Items
1. [Most important thing to fix]
2. [Second thing]
3. [etc.]
```

## Important

- **Do NOT push automatically**
- **Do NOT fix issues automatically**
- Present findings and WAIT for user decision
- User may say "ship it anyway" for low-risk items - that's their call

## Quick Mode

If user runs `/check quick`, skip the security audit and just run:
1. Tests
2. Quick review (one pass, critical issues only)
