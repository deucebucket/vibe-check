# Live Browser Testing

**Test your app in a REAL browser, controlled by Claude.**

This command uses Chrome DevTools MCP to interact with your running app - clicking buttons, filling forms, checking for errors - just like a real user would.

**No screenshots. No vision models. Direct DOM access.**

---

## Prerequisites

Chrome DevTools MCP must be installed:
```bash
claude mcp add chrome-devtools --scope user npx chrome-devtools-mcp@latest
```

Then restart Claude Code.

---

## Available Browser Tools

Once installed, Claude has access to:

### Navigation
| Tool | What it does |
|------|-------------|
| `navigate_page` | Go to a URL |
| `new_page` | Open new tab |
| `close_page` | Close tab |
| `list_pages` | See all open tabs |
| `select_page` | Switch to a tab |
| `wait_for` | Wait for element/network |

### UI Interaction
| Tool | What it does |
|------|-------------|
| `click` | Click an element |
| `fill` | Type into an input |
| `fill_form` | Fill entire form at once |
| `hover` | Hover over element |
| `press_key` | Press keyboard key |
| `handle_dialog` | Accept/dismiss alerts |
| `upload_file` | Upload a file |
| `drag` | Drag and drop |

### Inspection
| Tool | What it does |
|------|-------------|
| `evaluate_script` | Run JavaScript in page |
| `take_screenshot` | Capture the page |
| `take_snapshot` | Get DOM state |
| `list_console_messages` | See console output |
| `get_console_message` | Get specific message |
| `list_network_requests` | See all network calls |
| `get_network_request` | Inspect specific request |

### Performance
| Tool | What it does |
|------|-------------|
| `performance_start_trace` | Start recording |
| `performance_stop_trace` | Stop recording |
| `performance_analyze_insight` | Get Lighthouse-style analysis |

---

## Testing Protocol

### Step 1: Open the App

First, navigate to your running app:
```
Navigate to http://localhost:3000
```

Claude will use `navigate_page` to open Chrome and go to that URL.

### Step 2: Discover All Interactive Elements

Run JavaScript to find everything clickable:
```javascript
// Claude runs this via evaluate_script
const elements = [];
document.querySelectorAll('button, a, input, select, textarea, [onclick], [role="button"]').forEach(el => {
  const rect = el.getBoundingClientRect();
  elements.push({
    tag: el.tagName,
    text: el.innerText?.slice(0, 50) || el.value || el.placeholder || '',
    type: el.type || '',
    id: el.id,
    class: el.className,
    visible: rect.width > 0 && rect.height > 0,
    disabled: el.disabled,
    selector: el.id ? `#${el.id}` : null
  });
});
elements;
```

### Step 3: Test Each Button

For each button found:
1. Click it
2. Check for console errors
3. Check for network errors
4. Verify something changed

```
Click the "Submit" button
→ Check console for errors
→ Check if success message appeared
→ Report result
```

### Step 4: Test Forms

For each form:
1. Fill with test data
2. Submit
3. Check response
4. Verify validation works

```
Fill the login form:
- email: test@example.com
- password: TestPass123!
Click Submit
Check for success or error message
```

### Step 5: Check for Console Errors

```
List all console messages
Filter for errors and warnings
Report any issues found
```

### Step 6: Check Network Requests

```
List all network requests
Check for failed requests (4xx, 5xx)
Check for slow requests (> 3 seconds)
Report any issues
```

---

## Quick Commands

### Full Site Audit
```
"Go to localhost:3000 and test every button and form. Report what's broken."
```

### Specific Flow Test
```
"Test the signup flow: go to /signup, fill the form with test data, submit, and verify success."
```

### Error Check
```
"Go to localhost:3000, click around, and tell me if there are any console errors."
```

### Performance Check
```
"Analyze the performance of localhost:3000 and tell me what's slow."
```

---

## What Claude Checks

### Buttons
- [ ] Does the button respond to clicks?
- [ ] Does clicking trigger the expected action?
- [ ] Any console errors after clicking?
- [ ] Any failed network requests?

### Forms
- [ ] Can all fields be filled?
- [ ] Does submit trigger correctly?
- [ ] Does validation work?
- [ ] Is data preserved on error?
- [ ] Is there success/error feedback?

### Links
- [ ] Do internal links navigate correctly?
- [ ] Any 404s?
- [ ] Any broken external links?

### Console
- [ ] Any JavaScript errors?
- [ ] Any warnings that indicate bugs?
- [ ] Any failed assertions?

### Network
- [ ] Any failed API calls?
- [ ] Any extremely slow requests?
- [ ] Any CORS errors?

### DOM Issues
- [ ] Any elements with zero size?
- [ ] Any elements off-screen?
- [ ] Any overlapping clickable elements?

---

## DOM Inspection Scripts

Claude can run these to check for issues:

### Find Broken Buttons (no click handler)
```javascript
[...document.querySelectorAll('button')].filter(b => {
  const listeners = getEventListeners?.(b) || {};
  return !listeners.click && !b.onclick && !b.form;
}).map(b => b.innerText);
```

### Find Overlapping Elements
```javascript
const clickables = [...document.querySelectorAll('button, a, [onclick]')];
const overlaps = [];
for (let i = 0; i < clickables.length; i++) {
  for (let j = i + 1; j < clickables.length; j++) {
    const r1 = clickables[i].getBoundingClientRect();
    const r2 = clickables[j].getBoundingClientRect();
    if (!(r1.right < r2.left || r1.left > r2.right || r1.bottom < r2.top || r1.top > r2.bottom)) {
      overlaps.push([clickables[i].innerText, clickables[j].innerText]);
    }
  }
}
overlaps;
```

### Find Tiny Touch Targets
```javascript
[...document.querySelectorAll('button, a, input')].filter(el => {
  const r = el.getBoundingClientRect();
  return r.width > 0 && (r.width < 44 || r.height < 44);
}).map(el => ({ text: el.innerText?.slice(0, 30), size: `${r.width}x${r.height}` }));
```

### Find Missing Labels
```javascript
[...document.querySelectorAll('input, select, textarea')].filter(el => {
  const id = el.id;
  const label = id ? document.querySelector(`label[for="${id}"]`) : null;
  const ariaLabel = el.getAttribute('aria-label');
  const ariaLabelledBy = el.getAttribute('aria-labelledby');
  return !label && !ariaLabel && !ariaLabelledBy && !el.placeholder;
}).map(el => el.name || el.id || el.type);
```

### Find Console Errors
```javascript
// Claude uses list_console_messages tool
// Then filters for type: 'error'
```

---

## Output Format

```
## Live Browser Test Results

### App: [URL]
### Test Date: [date]

### Elements Found
- Buttons: X
- Links: X
- Forms: X
- Inputs: X

### Button Test Results
| Button | Clicked | Response | Errors |
|--------|---------|----------|--------|
| Submit | ✓ | Success toast | None |
| Delete | ✓ | Nothing happened | Console error |
| Cancel | ✓ | Modal closed | None |

### Form Test Results
| Form | Filled | Submitted | Result |
|------|--------|-----------|--------|
| Login | ✓ | ✓ | Redirected to /dashboard |
| Signup | ✓ | ✓ | Validation error shown |

### Console Errors
[List any errors found]

### Network Failures
[List any failed requests]

### DOM Issues
- Overlapping elements: [count]
- Tiny touch targets: [count]
- Missing labels: [count]

### Verdict
[ALL WORKING / ISSUES FOUND / BROKEN]

### Issues to Fix
1. [Critical issues]
2. [High priority]
3. [Low priority]
```

---

## Tips

1. **Start the app first** - Claude can't test what's not running
2. **Use localhost URLs** - Claude controls your local Chrome
3. **Check the Chrome window** - You can watch Claude clicking around
4. **Be specific** - "Test the checkout flow" is better than "test everything"
5. **Run multiple times** - Some bugs only show up intermittently

---

## Integration with /flow

`/live` tests a running app interactively.
`/flow` generates test code to run later.

Use `/live` for:
- Quick smoke tests
- Debugging specific issues
- Verifying a fix works

Use `/flow` for:
- CI/CD pipelines
- Regression testing
- Documentation

---

## Remember

**The browser knows everything.** We're not guessing from screenshots - we're directly querying the DOM, checking the console, inspecting network requests.

If a button is broken, we WILL find it.
