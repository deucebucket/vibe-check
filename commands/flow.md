# UI Flow Test - Actually Click the Damn Buttons

**The problem:** API tests pass, Claude says "looks good," but the actual buttons are broken.

This command creates and runs interactive UI tests that **actually click through your app** like a real user. No more shipping broken buttons because the API worked.

---

## Two Modes: Live Testing vs Generated Tests

### `/live` - Test RIGHT NOW (Recommended)
Uses Chrome DevTools MCP to control a real browser:
- Claude clicks buttons in your running app
- Sees console errors immediately
- No test code to write
- **Requires:** `chrome-devtools` MCP installed

```
Run /live to test your running app interactively
```

### `/flow` - Generate Tests for Later
Creates Playwright test files you can run in CI:
- Test code you can commit
- Runs in pipelines
- Regression testing
- **Requires:** Playwright installed

---

**If your app is running and you just want to test it NOW, use `/live` instead.**

---

---

## Why This Exists

AI-generated tests focus on APIs:
```javascript
// AI writes this
test('user can login', async () => {
  const response = await api.post('/auth/login', credentials)
  expect(response.status).toBe(200)  // PASSES!
})

// But the actual login button is broken and nobody tested it
```

Meanwhile in production: "I can't click the login button" - every user

---

## Part 1: UI Discovery - Map the Battlefield

Before testing, we need to know what exists. This crawls your app and builds a map of all interactive elements.

### Option A: Playwright Crawler (Recommended)

Create `ui-discovery.js`:
```javascript
const { chromium } = require('playwright');

async function discoverUI(startUrl) {
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext();
  const page = await context.newPage();

  const discovered = {
    pages: new Set(),
    buttons: [],
    links: [],
    forms: [],
    inputs: [],
    modals: [],
    errors: []
  };

  const visited = new Set();
  const queue = [startUrl];

  while (queue.length > 0) {
    const url = queue.shift();
    if (visited.has(url)) continue;
    visited.add(url);

    try {
      await page.goto(url, { waitUntil: 'networkidle', timeout: 10000 });
      discovered.pages.add(url);

      // Find all interactive elements
      const elements = await page.evaluate(() => {
        const results = { buttons: [], links: [], forms: [], inputs: [] };

        // Buttons (including button-like elements)
        document.querySelectorAll('button, [role="button"], input[type="submit"], input[type="button"], .btn, [class*="button"]').forEach(el => {
          results.buttons.push({
            text: el.innerText || el.value || el.getAttribute('aria-label') || 'UNLABELED',
            selector: generateSelector(el),
            type: el.tagName,
            disabled: el.disabled,
            visible: isVisible(el)
          });
        });

        // Links
        document.querySelectorAll('a[href]').forEach(el => {
          const href = el.getAttribute('href');
          if (href && !href.startsWith('#') && !href.startsWith('javascript:')) {
            results.links.push({
              text: el.innerText || 'UNLABELED',
              href: href,
              selector: generateSelector(el),
              visible: isVisible(el)
            });
          }
        });

        // Forms
        document.querySelectorAll('form').forEach(el => {
          results.forms.push({
            action: el.action,
            method: el.method,
            selector: generateSelector(el),
            inputCount: el.querySelectorAll('input, textarea, select').length
          });
        });

        // Inputs
        document.querySelectorAll('input, textarea, select').forEach(el => {
          results.inputs.push({
            name: el.name || el.id || 'UNNAMED',
            type: el.type || el.tagName.toLowerCase(),
            required: el.required,
            selector: generateSelector(el),
            visible: isVisible(el)
          });
        });

        function generateSelector(el) {
          if (el.id) return `#${el.id}`;
          if (el.getAttribute('data-testid')) return `[data-testid="${el.getAttribute('data-testid')}"]`;
          if (el.name) return `[name="${el.name}"]`;
          // Fallback to text content for buttons
          if (el.innerText && el.innerText.length < 50) {
            return `text="${el.innerText.trim()}"`;
          }
          return null; // Need better selector
        }

        function isVisible(el) {
          const rect = el.getBoundingClientRect();
          const style = window.getComputedStyle(el);
          return rect.width > 0 && rect.height > 0 &&
                 style.visibility !== 'hidden' &&
                 style.display !== 'none' &&
                 style.opacity !== '0';
        }

        return results;
      });

      // Store discovered elements with page context
      elements.buttons.forEach(b => discovered.buttons.push({ ...b, page: url }));
      elements.links.forEach(l => discovered.links.push({ ...l, page: url }));
      elements.forms.forEach(f => discovered.forms.push({ ...f, page: url }));
      elements.inputs.forEach(i => discovered.inputs.push({ ...i, page: url }));

      // Queue internal links for crawling
      elements.links.forEach(link => {
        try {
          const fullUrl = new URL(link.href, url).href;
          if (fullUrl.startsWith(startUrl) && !visited.has(fullUrl)) {
            queue.push(fullUrl);
          }
        } catch (e) {}
      });

    } catch (error) {
      discovered.errors.push({ url, error: error.message });
    }
  }

  await browser.close();
  return discovered;
}

// Run discovery
const startUrl = process.argv[2] || 'http://localhost:3000';
discoverUI(startUrl).then(results => {
  console.log(JSON.stringify(results, (key, value) =>
    value instanceof Set ? [...value] : value, 2));
});
```

Run with:
```bash
node ui-discovery.js http://localhost:3000 > ui-map.json
```

### Option B: Quick Manual Inventory

If you can't run a crawler, manually list:

```markdown
## Pages
- / (home)
- /login
- /dashboard
- /settings
- /admin (protected)

## Critical Buttons
- Login button on /login
- Submit button on /register
- Save button on /settings
- Delete buttons in /dashboard
- Logout button in header

## Forms
- Login form
- Registration form
- Settings form
- Search form

## Modals
- Delete confirmation
- Settings saved notification
- Error dialogs
```

---

## Part 2: The Click Test Suite

Now that we know what exists, test that it actually works.

### Core Test: Every Button Should Do Something

```javascript
const { test, expect } = require('@playwright/test');
const uiMap = require('./ui-map.json');

// Test every discovered button
for (const button of uiMap.buttons) {
  test(`Button "${button.text}" on ${button.page} should respond`, async ({ page }) => {
    await page.goto(button.page);

    // Find the button
    const btn = button.selector
      ? await page.locator(button.selector)
      : await page.getByRole('button', { name: button.text });

    // Check it's visible
    await expect(btn).toBeVisible();

    // Check it's not disabled (unless it should be)
    if (!button.disabled) {
      await expect(btn).toBeEnabled();
    }

    // Click it and verify SOMETHING happens
    const [response] = await Promise.all([
      page.waitForResponse(resp => resp.status() < 500, { timeout: 5000 }).catch(() => null),
      page.waitForNavigation({ timeout: 5000 }).catch(() => null),
      btn.click()
    ]);

    // At minimum, no console errors should appear
    const consoleErrors = [];
    page.on('console', msg => {
      if (msg.type() === 'error') consoleErrors.push(msg.text());
    });

    expect(consoleErrors).toHaveLength(0);
  });
}
```

### Form Submission Test

```javascript
test.describe('Form submissions', () => {
  for (const form of uiMap.forms) {
    test(`Form on ${form.page} should submit`, async ({ page }) => {
      await page.goto(form.page);

      // Fill required fields with test data
      const inputs = await page.locator(`${form.selector} input[required], ${form.selector} textarea[required]`);
      const count = await inputs.count();

      for (let i = 0; i < count; i++) {
        const input = inputs.nth(i);
        const type = await input.getAttribute('type');

        switch (type) {
          case 'email':
            await input.fill('test@example.com');
            break;
          case 'password':
            await input.fill('TestPassword123!');
            break;
          case 'number':
            await input.fill('42');
            break;
          default:
            await input.fill('Test Value');
        }
      }

      // Find and click submit
      const submitBtn = await page.locator(`${form.selector} button[type="submit"], ${form.selector} input[type="submit"]`);
      await submitBtn.click();

      // Should see success or validation feedback (not silence)
      const feedback = await page.locator('.success, .error, [role="alert"], .toast, .notification').first();
      await expect(feedback).toBeVisible({ timeout: 5000 });
    });
  }
});
```

### Link Verification Test

```javascript
test.describe('Links should work', () => {
  for (const link of uiMap.links.filter(l => l.visible)) {
    test(`Link "${link.text}" should navigate`, async ({ page }) => {
      await page.goto(link.page);

      const linkEl = await page.locator(`a[href="${link.href}"]`).first();
      await expect(linkEl).toBeVisible();

      // Click and verify navigation
      await linkEl.click();
      await page.waitForLoadState('networkidle');

      // Should not be on error page
      const pageContent = await page.content();
      expect(pageContent).not.toContain('404');
      expect(pageContent).not.toContain('Not Found');
    });
  }
});
```

---

## Part 3: Visual Sanity Checks

Beyond clicking, verify things LOOK right.

### Element Size Sanity Test

```javascript
test('No absurdly sized elements', async ({ page }) => {
  await page.goto('/');

  const problems = await page.evaluate(() => {
    const issues = [];
    const viewport = { width: window.innerWidth, height: window.innerHeight };

    document.querySelectorAll('*').forEach(el => {
      const rect = el.getBoundingClientRect();
      const style = window.getComputedStyle(el);

      if (style.display === 'none' || style.visibility === 'hidden') return;

      // Check for tiny clickable elements (accessibility issue)
      if ((el.tagName === 'BUTTON' || el.tagName === 'A' || el.onclick) &&
          (rect.width < 44 || rect.height < 44) && rect.width > 0) {
        issues.push({
          type: 'too-small',
          element: el.tagName,
          text: el.innerText?.slice(0, 30),
          size: `${rect.width}x${rect.height}`,
          required: '44x44 minimum for touch'
        });
      }

      // Check for elements larger than viewport (overflow issue)
      if (rect.width > viewport.width * 1.1) {
        issues.push({
          type: 'overflow-x',
          element: el.tagName,
          class: el.className,
          width: rect.width,
          viewport: viewport.width
        });
      }

      // Check for suspiciously tiny content in large containers
      if (el.children.length === 1) {
        const child = el.children[0];
        const childRect = child.getBoundingClientRect();
        const containerArea = rect.width * rect.height;
        const childArea = childRect.width * childRect.height;

        if (containerArea > 10000 && childArea > 0 && childArea < containerArea * 0.1) {
          issues.push({
            type: 'tiny-in-large',
            container: `${el.tagName}.${el.className}`,
            containerSize: `${rect.width}x${rect.height}`,
            child: child.tagName,
            childSize: `${childRect.width}x${childRect.height}`,
            ratio: (childArea / containerArea * 100).toFixed(1) + '%'
          });
        }
      }
    });

    return issues;
  });

  if (problems.length > 0) {
    console.log('Visual issues found:', JSON.stringify(problems, null, 2));
  }
  expect(problems.filter(p => p.type === 'too-small').length).toBe(0);
  expect(problems.filter(p => p.type === 'overflow-x').length).toBe(0);
});
```

### Overlap Detection Test

```javascript
test('No overlapping interactive elements', async ({ page }) => {
  await page.goto('/');

  const overlaps = await page.evaluate(() => {
    const clickables = [...document.querySelectorAll('button, a, input, [onclick], [role="button"]')];
    const issues = [];

    for (let i = 0; i < clickables.length; i++) {
      for (let j = i + 1; j < clickables.length; j++) {
        const rect1 = clickables[i].getBoundingClientRect();
        const rect2 = clickables[j].getBoundingClientRect();

        // Skip invisible elements
        if (rect1.width === 0 || rect2.width === 0) continue;

        // Check for overlap
        const overlap = !(rect1.right < rect2.left ||
                         rect1.left > rect2.right ||
                         rect1.bottom < rect2.top ||
                         rect1.top > rect2.bottom);

        if (overlap) {
          issues.push({
            element1: `${clickables[i].tagName}: "${clickables[i].innerText?.slice(0, 20)}"`,
            element2: `${clickables[j].tagName}: "${clickables[j].innerText?.slice(0, 20)}"`,
            rect1: { left: rect1.left, top: rect1.top, width: rect1.width, height: rect1.height },
            rect2: { left: rect2.left, top: rect2.top, width: rect2.width, height: rect2.height }
          });
        }
      }
    }

    return issues;
  });

  expect(overlaps).toHaveLength(0);
});
```

### Text Visibility Test

```javascript
test('Text should be readable (not covered)', async ({ page }) => {
  await page.goto('/');

  const problems = await page.evaluate(() => {
    const issues = [];

    document.querySelectorAll('p, h1, h2, h3, h4, h5, h6, span, label, li').forEach(el => {
      const rect = el.getBoundingClientRect();
      const style = window.getComputedStyle(el);

      if (rect.width === 0 || style.display === 'none') return;

      // Check if text is same color as background (invisible)
      const textColor = style.color;
      const bgColor = style.backgroundColor;

      // Check if element is cut off
      if (el.scrollWidth > el.clientWidth && style.overflow !== 'scroll' && style.overflow !== 'auto') {
        issues.push({
          type: 'text-cutoff',
          text: el.innerText?.slice(0, 50),
          scrollWidth: el.scrollWidth,
          clientWidth: el.clientWidth
        });
      }

      // Check for text outside viewport
      if (rect.left < 0 || rect.right > window.innerWidth) {
        issues.push({
          type: 'text-offscreen',
          text: el.innerText?.slice(0, 50),
          position: { left: rect.left, right: rect.right }
        });
      }
    });

    return issues;
  });

  expect(problems).toHaveLength(0);
});
```

---

## Part 4: User Flow Tests

Test complete user journeys, not isolated elements.

### Critical Flow Template

```javascript
test.describe('Critical User Flows', () => {

  test('New user signup flow', async ({ page }) => {
    // Step 1: Land on home
    await page.goto('/');
    await expect(page.locator('text=Sign Up, text=Get Started, text=Register').first()).toBeVisible();

    // Step 2: Navigate to signup
    await page.click('text=Sign Up, text=Get Started, text=Register');
    await expect(page).toHaveURL(/signup|register/);

    // Step 3: Fill form
    await page.fill('[name="email"], [type="email"]', 'test@example.com');
    await page.fill('[name="password"], [type="password"]', 'TestPass123!');

    // Step 4: Submit
    await page.click('button[type="submit"]');

    // Step 5: Verify success (should see dashboard or confirmation)
    await expect(page.locator('text=Welcome, text=Dashboard, text=Verify your email')).toBeVisible({ timeout: 10000 });
  });

  test('Login flow', async ({ page }) => {
    await page.goto('/login');

    await page.fill('[name="email"], [type="email"]', 'existing@example.com');
    await page.fill('[name="password"], [type="password"]', 'ExistingPass123!');
    await page.click('button[type="submit"]');

    // Should redirect to dashboard or show error (not freeze)
    const result = await Promise.race([
      page.waitForURL(/dashboard|home/, { timeout: 5000 }).then(() => 'success'),
      page.locator('.error, [role="alert"]').waitFor({ timeout: 5000 }).then(() => 'error'),
    ]);

    expect(['success', 'error']).toContain(result);
  });

  test('Logout flow', async ({ page }) => {
    // Assume logged in
    await page.goto('/dashboard');

    await page.click('text=Logout, text=Sign Out, text=Log Out');

    // Should redirect to home or login
    await expect(page).toHaveURL(/login|\/$/);
  });
});
```

---

## Part 5: Quick Manual Flow Test

Can't set up Playwright? Do this manually:

### Pre-Launch Button Audit

Open your app and literally click every button:

```
## Button Audit - [DATE]

### Page: /
- [ ] Header nav links work
- [ ] CTA button responds
- [ ] Footer links work

### Page: /login
- [ ] Login button submits form
- [ ] "Forgot password" link works
- [ ] "Sign up" link works
- [ ] Show/hide password toggle works

### Page: /dashboard
- [ ] Sidebar navigation works
- [ ] Each action button responds
- [ ] Modals open and close properly
- [ ] Delete buttons have confirmation

### Page: /settings
- [ ] Save button shows feedback
- [ ] Cancel button works
- [ ] All toggles respond
- [ ] Form validation works

### Modals & Popups
- [ ] Can close with X button
- [ ] Can close with Escape key
- [ ] Can close by clicking backdrop
- [ ] Focus is trapped inside modal
```

---

## Part 6: The Flow Test Protocol

When to run these tests:

### Before Every Push
```bash
# Quick smoke test - critical flows only
npx playwright test --grep @critical
```

### Before Merging PRs
```bash
# Full flow test
npx playwright test
```

### Before Production Deploy
```bash
# Full test + visual regression
npx playwright test
npx playwright test --update-snapshots  # If visual changes are intentional
```

---

## Output Format

When Claude runs this check:

```
## UI Flow Test Results

### Discovery Summary
- Pages found: X
- Buttons found: X
- Forms found: X
- Links found: X

### Button Test Results
- Tested: X buttons
- Passed: X
- Failed: X
- [List failures with page and button name]

### Form Test Results
- Tested: X forms
- Passed: X
- Failed: X
- [List failures]

### Visual Sanity Results
- Overflow issues: X
- Tiny buttons: X
- Overlapping elements: X
- Cut-off text: X
- [List all issues]

### User Flow Results
- Signup flow: PASS/FAIL
- Login flow: PASS/FAIL
- Logout flow: PASS/FAIL
- [Other critical flows]

### Broken Buttons Found
[List every button that didn't respond]

### Verdict
[READY / FIX BUTTONS FIRST / MAJOR ISSUES]
```

---

## Common Failures This Catches

1. **Buttons with no click handlers** - Looks like a button, does nothing
2. **Forms that submit to nowhere** - Action URL wrong or missing
3. **Links to non-existent pages** - 404s waiting to happen
4. **Modals that can't close** - User is trapped
5. **Tiny touch targets** - Can't tap on mobile
6. **Overlapping clickables** - Wrong thing gets clicked
7. **Elements off-screen** - Content pushed out of viewport
8. **Frozen UI** - No loading state, user thinks it crashed
9. **Double-submission** - No disabled state while processing
10. **Silent failures** - Action fails but no feedback shown

---

## Remember

**API tests passing means nothing if the button is broken.**

The user doesn't call your API. The user clicks your button. Test what they actually do.
