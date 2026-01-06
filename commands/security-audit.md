# Security Audit for Vibe-Coded Apps

This audit catches the security mistakes that vibe coders commonly make. These are the issues that get apps with 39k users hacked.

## The Mindset

Before checking code, internalize these assumptions:
- **Assume every API endpoint will be called directly** (not through your UI)
- **Assume tokens will leak eventually**
- **Assume users will do things you didn't imagine**
- **Assume third parties will fail or change behavior**

The killer question for every sensitive operation: **"If this token/credential leaks, what's the blast radius?"**

## Audit Checklist

Review the codebase (focus on recent changes, but check architecture too) for these categories:

### 1. Authentication & Tokens
- [ ] Tokens have appropriate expiry (not "never" or "10 years")
- [ ] Tokens are NOT stored in localStorage/sessionStorage for sensitive apps
- [ ] Refresh tokens are handled securely (httpOnly cookies, not JS-accessible)
- [ ] Token scopes are minimal (not "full access" because it was easier)
- [ ] One leaked token does NOT equal full account takeover
- [ ] API keys are not hardcoded or committed to git

### 2. Authorization & Permissions
- [ ] Admin/sensitive actions are validated SERVER-SIDE (not just hidden buttons)
- [ ] User can only access THEIR data (check for IDOR vulnerabilities)
- [ ] Role checks happen at API level, not just frontend
- [ ] No "edit admin=true in devtools" vulnerabilities

### 3. Input Validation & Injection
- [ ] SQL queries use parameterized statements (no string concatenation)
- [ ] User input is sanitized before rendering (XSS prevention)
- [ ] File uploads are validated (type, size, no path traversal)
- [ ] Command execution doesn't include user input unsanitized

### 4. Data Exposure
- [ ] Secrets not in code, logs, or error messages
- [ ] API responses don't leak extra fields (password hashes, internal IDs)
- [ ] Error messages don't reveal system internals
- [ ] Debug endpoints are disabled in production

### 5. Third-Party & OAuth
- [ ] OAuth scopes are MINIMAL (not full account access)
- [ ] Third-party API failures are handled gracefully
- [ ] Webhook signatures are validated
- [ ] External data is treated as untrusted

### 6. Audit Trail & Monitoring
- [ ] Sensitive actions are logged (who did what when)
- [ ] Failed auth attempts are logged
- [ ] There's a way to answer "who accessed X and when"

## Output Format

```
## Security Audit Results

### Overall Risk Level: [LOW/MEDIUM/HIGH/CRITICAL]

### Blast Radius Assessment
[What's the worst case if credentials leak?]

### Findings

#### Critical (Fix before shipping)
[List or "None found"]

#### High (Fix soon)
[List or "None found"]

#### Medium (Should fix)
[List or "None found"]

#### Recommendations
[Suggestions for hardening]

### Checklist Summary
[X/Y items passed]
```

Do NOT automatically fix issues. Report them and wait for direction.
