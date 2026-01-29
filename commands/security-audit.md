# Security Audit for Vibe-Coded Apps

This audit catches the security mistakes that vibe coders commonly make. These are the issues that get apps with 39k users hacked.

**Stats that should scare you:**
- 45% of AI-generated code contains at least one flaw (Veracode 2025)
- 2000+ high-impact vulnerabilities found in 5600 vibe-coded apps (Escape.tech)
- 1 in 3 vibe-coded SaaS apps had gaping security holes when audited

## The Mindset

Before checking code, internalize these assumptions:
- **Assume every API endpoint will be called directly** (not through your UI)
- **Assume tokens will leak eventually**
- **Assume users will do things you didn't imagine**
- **Assume third parties will fail or change behavior**
- **Assume AI forgot basic security practices** (it probably did)

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

### 7. Vibe-Coding Specific Vulnerabilities

These are the issues AI generates constantly. Check specifically for these:

**Client-Side Auth (THE #1 AI MISTAKE):**
```javascript
// AI GENERATES THIS CONSTANTLY - IT'S BROKEN
if (localStorage.getItem('isAdmin') === 'true') {
  showAdminPanel()  // Anyone can set this in devtools!
}

// ALSO BROKEN
if (user.role === 'admin') {
  return <AdminButton />  // Hiding button != protecting route
}
```
- [ ] No localStorage/sessionStorage checks for auth decisions
- [ ] No client-side only role checks
- [ ] All admin logic verified server-side

**Hardcoded Credentials (AI DOES THIS):**
```javascript
// AI literally generates this
const db = mysql.connect({
  host: 'localhost',
  user: 'root',
  password: 'password123'  // In production code!
})
```
- [ ] No credentials hardcoded in any file
- [ ] No API keys in frontend JavaScript
- [ ] Check for: `password`, `secret`, `key`, `token` in code

**Business Logic Flaws (AI CAN'T DO LOGIC):**
```javascript
// AI generates code that allows:
// - Ordering negative quantities (get refund for nothing)
// - Setting negative prices (get paid to buy)
// - Changing other users' data by editing request
// - Skipping required steps in a flow
```
- [ ] Negative values validated where inappropriate
- [ ] Price/quantity manipulation not possible
- [ ] Users can't modify other users' resources
- [ ] Multi-step flows can't be bypassed

**Missing Input Sanitization:**
- [ ] All user input sanitized before database
- [ ] All user input escaped before HTML rendering
- [ ] File paths validated (no `../../../etc/passwd`)
- [ ] URLs validated before fetch/redirect

**"Hallucinated Bypass" - AI Removes Security:**
Sometimes AI removes security checks while "fixing" code. Check:
- [ ] Auth middleware still present on protected routes
- [ ] Rate limiting still active
- [ ] Validation still happening
- [ ] Compare with previous version if security feels lighter

### 8. Supabase/Firebase Specific

If using BaaS, these are the common disasters:

**Supabase:**
- [ ] RLS enabled on ALL tables with user data
- [ ] RLS policies actually restrict (not `USING (true)`)
- [ ] Tested: anon key can't read other users' data
- [ ] Service key ONLY used server-side
- [ ] No `select *` from users table possible via anon

**Firebase:**
- [ ] Security rules exist and are not `allow read, write: if true`
- [ ] Rules restrict by authenticated user
- [ ] Admin SDK only used server-side
- [ ] No public read of user collection

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
