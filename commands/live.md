# Live Browser Testing - Test EVERYTHING

**Test your app across ALL browsers, check ALL logs, verify EVERYTHING works.**

This command uses browser automation MCPs to control real browsers - Chrome, Firefox, Safari, Edge - clicking buttons, filling forms, checking console errors, monitoring network requests, and catching every issue a real user would hit.

---

## Prerequisites

Install the browser MCPs:

```bash
# Playwright MCP - ALL browsers (Chrome, Firefox, Safari, Edge)
claude mcp add playwright --scope user npx @playwright/mcp@latest

# Chrome DevTools MCP - Chrome-specific deep inspection
claude mcp add chrome-devtools --scope user npx chrome-devtools-mcp@latest
```

Restart Claude Code after installing.

---

## The Full Testing Protocol

### Phase 1: Cross-Browser Testing

Test in ALL major browsers, not just Chrome:

```
Test localhost:3000 in:
1. Chrome (Chromium)
2. Firefox
3. Safari (WebKit)
4. Edge

For each browser:
- Navigate to homepage
- Click all buttons
- Fill all forms
- Check console for errors
- Check network for failures
- Report any browser-specific issues
```

**Why this matters:**
- CSS renders differently
- JavaScript APIs vary
- Event handling differs
- Layout bugs are browser-specific

### Phase 2: Console Log Analysis

Check EVERYTHING in the console:

| Level | What to Look For |
|-------|------------------|
| **Errors** | JavaScript exceptions, failed assertions, React errors |
| **Warnings** | Deprecation notices, performance warnings, accessibility issues |
| **Info** | Debug output that shouldn't be in production |
| **Network Errors** | CORS failures, 404s, 500s, timeouts |

```
List all console messages
Filter by type: error, warning
Check for:
- Uncaught exceptions
- Failed to load resource
- CORS policy blocked
- React/Vue/Angular errors
- Unhandled promise rejections
- Deprecation warnings
```

### Phase 3: Network Request Audit

Monitor ALL network traffic:

```
List all network requests and check for:

❌ FAILURES
- 4xx errors (client errors)
- 5xx errors (server errors)
- CORS blocked requests
- Timeout failures
- SSL/TLS errors

⚠️ WARNINGS
- Slow requests (> 3 seconds)
- Large payloads (> 1MB)
- Excessive requests (API spam)
- Missing caching headers
- Mixed content (HTTP on HTTPS)

✓ VERIFY
- Auth tokens being sent correctly
- API responses have expected structure
- No sensitive data in URLs
```

### Phase 4: Interactive Element Testing

Test EVERY clickable thing:

```javascript
// Find all interactive elements
const interactive = document.querySelectorAll(`
  button,
  a[href],
  input,
  select,
  textarea,
  [onclick],
  [role="button"],
  [role="link"],
  [role="checkbox"],
  [role="radio"],
  [role="tab"],
  [tabindex]:not([tabindex="-1"])
`);
```

For each element:
1. **Is it visible?** (not display:none, not zero-size)
2. **Is it clickable?** (not disabled, not covered)
3. **Does it respond?** (click and verify something happens)
4. **Any errors after click?** (check console)
5. **Correct behavior?** (expected action occurred)

### Phase 5: Form Testing

Test ALL forms with multiple scenarios:

```
For each form found:

1. HAPPY PATH
   - Fill with valid data
   - Submit
   - Verify success

2. VALIDATION
   - Submit empty (required fields)
   - Submit invalid email
   - Submit invalid phone
   - Submit too-short password
   - Verify error messages appear

3. EDGE CASES
   - Very long input (1000+ chars)
   - Special characters (!@#$%^&*)
   - Unicode (émojis 🎉, 日本語)
   - Script injection (<script>alert('xss')</script>)
   - SQL injection ('; DROP TABLE users;--)

4. ERROR RECOVERY
   - Cause a server error
   - Verify data preserved
   - Verify user can retry
```

### Phase 6: Navigation Testing

Test ALL routes and links:

```
1. Crawl the site, find all internal links
2. Visit each page
3. Check for:
   - 404 pages
   - Redirect loops
   - Slow page loads
   - Console errors on each page
   - Missing content
   - Broken layouts

4. Test browser navigation:
   - Back button works
   - Forward button works
   - Refresh preserves state (where expected)
   - Deep links work directly
```

### Phase 7: Accessibility Audit

Test keyboard and screen reader access:

```
1. KEYBOARD NAVIGATION
   - Tab through all elements
   - Verify focus is visible
   - Verify focus order is logical
   - Escape closes modals
   - Enter activates buttons

2. ACCESSIBILITY TREE
   - All images have alt text
   - All inputs have labels
   - ARIA roles are correct
   - Heading hierarchy is valid
   - Color contrast passes

3. SCREEN READER
   - Playwright's accessibility snapshot
   - Verify all content is announced
   - Verify interactive elements are labeled
```

### Phase 8: Performance Check

Test speed and efficiency:

```
1. PAGE LOAD
   - Time to first paint
   - Time to interactive
   - Largest contentful paint
   - Total blocking time

2. RUNTIME
   - Memory usage over time
   - CPU usage during interactions
   - Animation frame rate (60fps target)
   - Layout thrashing

3. NETWORK
   - Total transfer size
   - Number of requests
   - Waterfall analysis
   - Cache effectiveness
```

### Phase 9: State Management

Test data persistence and state:

```
1. REFRESH TEST
   - Fill form partially
   - Refresh page
   - Is data preserved? (if it should be)

2. MULTI-TAB
   - Open app in two tabs
   - Make change in tab 1
   - Does tab 2 reflect it? (if it should)

3. LOGOUT/LOGIN
   - Log out
   - Verify protected data is cleared
   - Log back in
   - Verify state is restored

4. SESSION
   - Close browser
   - Reopen
   - Is session preserved correctly?
```

### Phase 10: Error Handling

Deliberately break things:

```
1. NETWORK FAILURES
   - Simulate offline mode
   - Does app handle gracefully?
   - Are there retry mechanisms?

2. API ERRORS
   - What happens on 500 response?
   - What happens on timeout?
   - Is error displayed to user?

3. INVALID DATA
   - Send malformed API response
   - Does app crash or handle it?

4. EDGE CASES
   - Empty lists
   - Very long lists (1000+ items)
   - Missing images
   - Invalid URLs
```

---

## Quick Commands

### Full Audit (All Browsers)
```
"Test localhost:3000 in Chrome, Firefox, and Safari. Click every button,
fill every form, check all console errors and network requests.
Report everything that's broken."
```

### Single Browser Quick Test
```
"Go to localhost:3000 in Chrome and click through the main user flows.
Report any errors."
```

### Console Error Hunt
```
"Navigate through all pages of localhost:3000 and collect every
console error and warning. List them all."
```

### Network Audit
```
"Monitor all network requests on localhost:3000 while I click around.
Report any failures, slow requests, or errors."
```

### Form Fuzzing
```
"Find all forms on localhost:3000 and test them with valid data,
invalid data, empty data, and edge cases. Report validation issues."
```

### Accessibility Check
```
"Check localhost:3000 for accessibility issues - keyboard navigation,
focus states, ARIA labels, color contrast."
```

### Performance Profile
```
"Profile the performance of localhost:3000 - page load time,
network requests, runtime performance. What's slow?"
```

### Cross-Browser Comparison
```
"Open localhost:3000 in Chrome, Firefox, and Safari simultaneously.
Report any differences in appearance or behavior."
```

---

## Browser-Specific Tools

### Chrome DevTools MCP
Best for:
- Deep performance profiling
- Network throttling
- JavaScript debugging
- Memory analysis

### Playwright MCP
Best for:
- Cross-browser testing (Chrome, Firefox, Safari, Edge)
- Accessibility tree inspection
- Consistent API across browsers
- Screenshot comparison

---

## What Gets Checked

### Every Button
- [ ] Visible and not hidden
- [ ] Not disabled unexpectedly
- [ ] Responds to click
- [ ] Triggers expected action
- [ ] No console errors after click
- [ ] Works in all browsers

### Every Form
- [ ] All fields fillable
- [ ] Validation works correctly
- [ ] Submit triggers correctly
- [ ] Success/error feedback shown
- [ ] Data preserved on error
- [ ] Works in all browsers

### Every Link
- [ ] Points to valid destination
- [ ] No 404s
- [ ] Opens correctly (same tab vs new tab)
- [ ] Works in all browsers

### Every Page
- [ ] Loads without errors
- [ ] No console errors
- [ ] No network failures
- [ ] Renders correctly in all browsers
- [ ] Responsive on mobile/tablet

### Console
- [ ] No JavaScript errors
- [ ] No unhandled promise rejections
- [ ] No deprecation warnings (or they're acknowledged)
- [ ] No debug logs in production

### Network
- [ ] All requests succeed
- [ ] No CORS errors
- [ ] No timeouts
- [ ] No excessive requests
- [ ] Reasonable response times

### Accessibility
- [ ] Keyboard navigable
- [ ] Focus visible
- [ ] All inputs labeled
- [ ] Images have alt text
- [ ] Color contrast passes

### Performance
- [ ] Page loads in < 3 seconds
- [ ] Time to interactive < 5 seconds
- [ ] No memory leaks
- [ ] Smooth animations (60fps)

---

## Output Format

```
## Live Browser Test Results

### App: [URL]
### Date: [timestamp]

---

## Cross-Browser Results

| Browser | Version | Status | Issues |
|---------|---------|--------|--------|
| Chrome | 121 | ✓ Pass | 0 |
| Firefox | 122 | ⚠ Issues | 2 |
| Safari | 17 | ✓ Pass | 0 |
| Edge | 121 | ✓ Pass | 0 |

### Browser-Specific Issues
[List any issues that only appear in specific browsers]

---

## Console Errors

### Critical (Errors)
| Page | Error | Count |
|------|-------|-------|
| /dashboard | Uncaught TypeError: x is undefined | 3 |

### Warnings
| Page | Warning | Count |
|------|---------|-------|
| /settings | React warning: key prop | 12 |

---

## Network Issues

### Failed Requests
| URL | Status | Page |
|-----|--------|------|
| /api/user | 500 | /dashboard |

### Slow Requests (> 3s)
| URL | Time | Page |
|-----|------|------|
| /api/analytics | 4.2s | /home |

---

## Button Test Results

| Button | Page | Chrome | Firefox | Safari | Errors |
|--------|------|--------|---------|--------|--------|
| Submit | /form | ✓ | ✓ | ✓ | None |
| Delete | /list | ✓ | ✗ | ✓ | Firefox: no response |

---

## Form Test Results

| Form | Valid | Invalid | Empty | Edge Cases |
|------|-------|---------|-------|------------|
| Login | ✓ | ✓ | ✓ | ✓ |
| Signup | ✓ | ⚠ | ✓ | ✗ XSS possible |

---

## Accessibility Issues

| Issue | Element | Page | Severity |
|-------|---------|------|----------|
| Missing label | input#email | /contact | High |
| Low contrast | .muted-text | /about | Medium |

---

## Performance Summary

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| First Paint | 1.2s | < 1.5s | ✓ |
| Interactive | 3.4s | < 3s | ⚠ |
| Total Size | 2.4MB | < 2MB | ⚠ |

---

## Overall Verdict

**Status: [PASS / ISSUES FOUND / CRITICAL FAILURES]**

### Must Fix Before Ship
1. [Critical issues]

### Should Fix
2. [High priority issues]

### Nice to Fix
3. [Low priority issues]

### Browser-Specific Fixes
4. [Issues only in certain browsers]
```

---

## Remember

**Test like your users will use it.**

They'll use Chrome AND Firefox AND Safari. They'll click buttons AND submit forms AND refresh pages. They'll have slow connections AND old browsers AND screen readers.

We check ALL of it. No exceptions.
