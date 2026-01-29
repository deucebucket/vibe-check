# Vibe Check

Slash commands for Claude Code that catch the problems vibe coders ship.

## The Problem

Research shows AI-generated code has serious issues:

| Problem | Stat | Source |
|---------|------|--------|
| Security flaws | 45% of AI code has vulnerabilities | Veracode 2025 |
| Real-world audit | 1 in 3 vibe-coded apps had gaping holes | Reddit audit |
| Mass vulnerability | 2000+ vulnerabilities in 5600 apps | Escape.tech |
| More bugs | AI code creates 1.7x more issues | CodeRabbit |
| Fake packages | 21.7% of AI-suggested packages don't exist | UTSA |
| No testing | 36% of vibe coders skip QA entirely | arxiv |
| User abandonment | 88% abandon after 1 bad AI experience | UX research |
| "AI slop" fatigue | Enthusiasm dropped from 60% to 26% | 2023-2025 |

**Common disasters found:**
- Source maps leaking full source code (most common!)
- Supabase RLS "on" but empty (fake security)
- Admin routes unprotected (just hidden buttons)
- Client-side auth checks (localStorage.isAdmin = true)
- Tiny sprites in giant windows (visual disasters)
- Buttons that do nothing when clicked

The issue isn't AI - it's shipping code without review. These commands force the review step.

## Commands

| Command | What it checks |
|---------|----------------|
| `/review` | Bugs, edge cases, code quality |
| `/security-audit` | Auth, injection, tokens, data exposure |
| `/check` | Full pipeline: tests + review + security |
| `/audit` | **Everything** + requires you to explain the code |
| `/architecture` | God objects, coupling, over-engineering |
| `/deps` | Hallucinated packages, vulnerabilities |
| `/tests` | Test quality, coverage, missing tests |
| `/observability` | Logging, metrics, error tracking |
| `/dry` | Code duplication |
| `/understand` | Forces you to explain the code |
| `/ui` | UI/UX reality check - visual judgment, feedback, states, accessibility |
| `/shipping` | Deployment security - source maps, RLS, headers, exposed keys |
| `/flow` | UI flow testing - generate Playwright tests |
| `/live` | **NEW** Live browser testing - Claude controls Chrome via MCP |

## Install

```bash
git clone https://github.com/deucebucket/vibe-check.git
cd vibe-check
./install.sh
```

Or manually:
```bash
mkdir -p ~/.claude/commands
cp commands/*.md ~/.claude/commands/
```

Restart Claude Code after installing.

---

## Command Details

### `/review` - Adversarial Code Review

Reviews code as a senior dev who's seen too many production incidents.

**Checks:**
- What breaks in production that works in dev?
- Unhandled edge cases (empty input, null, boundaries)
- Race conditions and concurrency issues
- Error handling that swallows important info
- Code that's a nightmare to debug

**Output:** CRITICAL / HIGH / MEDIUM / LOW findings

---

### `/security-audit` - Security Checklist

Catches the security mistakes that get apps hacked.

**Checks:**
- Tokens stored insecurely or never expiring
- Admin actions only validated on frontend
- SQL injection, XSS, path traversal
- Hardcoded secrets
- OAuth scopes too broad
- "If this token leaks, what's the blast radius?"

---

### `/check` - Full Pipeline

Runs everything before you push:

1. Detect project type (Python/Node/Go/Rust)
2. Run tests
3. Adversarial code review
4. Security audit
5. Report verdict: READY / NEEDS ATTENTION / DO NOT PUSH

**Quick mode:** `/check quick` - tests + critical issues only

---

### `/architecture` - Architecture Anti-Patterns

AI creates code that works but lacks architectural judgment.

**Checks:**
- God objects doing too many things
- Tight coupling between modules
- Over-engineering for simple problems
- No separation of concerns
- Would a new dev understand this in 30 minutes?

---

### `/deps` - Dependency Validation

21.7% of AI-suggested packages don't exist. Attackers exploit this.

**Checks:**
- All packages exist in official registries
- No known vulnerabilities (CVEs)
- No severely outdated packages
- Lock files committed
- Suspicious/unfamiliar packages flagged

---

### `/tests` - Test Quality

36% of vibe coders skip QA. AI-generated tests are often superficial.

**Checks:**
- Tests exist and actually run
- Tests check behavior, not just implementation
- Edge cases covered
- Error cases tested
- No "testing theater" (tests that can't fail)

---

### `/observability` - Observability Check

AI focuses on happy paths. Production code needs visibility.

**Checks:**
- Errors logged with context
- No silent failures (empty catch blocks)
- No sensitive data in logs
- Health endpoints exist
- Metrics for latency/error rates

---

### `/dry` - DRY (Don't Repeat Yourself)

AI duplicates code because it predicts patterns, not designs systems.

**Checks:**
- Duplicated business logic
- Hardcoded values in multiple places
- Similar functions that should be merged
- Configuration scattered vs centralized

---

### `/understand` - Code Understanding

If you can't explain it, don't ship it.

**Forces you to answer:**
- What does this code do?
- Why this approach?
- What are the failure modes?
- What happens with unusual input?
- How would you debug this?

---

### `/ui` - UI/UX Reality Check

**The Golden Rule: Humans can't see behind the veil.**

AI forgets users can't see the 1s and 0s. They don't know if their click registered, if data is loading, or if the app crashed. Every action needs visible feedback.

**NEW: Visual Judgment**

Now includes critical eye for visual problems AI misses:
- Tiny elements in giant containers (the "small sprite in huge window" problem)
- Elements overlapping or covering text
- Amateur design red flags (inconsistent spacing, fonts, alignment)
- The "AI look" - generic template soup that looks like every other AI site
- Proportion and scale issues

**Checks:**
- **Visual judgment** - Actually LOOK at the screen, not just validate existence
- **Visibility of system status** - Does every action have feedback?
- **Five states** - Loading, empty, error, success, edge cases all handled?
- **Accessibility** - Keyboard navigation, focus states, screen reader support?
- **Button states** - Hover, focus, active, disabled, loading?
- **Form validation** - Inline errors, helpful messages, data preserved on error?
- **Microcopy** - Human voice or robot speak?
- **The 14 common visual bugs** - Contrast, alignment, overflow, responsiveness, etc.
- **Amateur red flags** - Pixelated images, inconsistent icons, random spacing

**Output:** 20-point scoring system + specific visual issues + priority fixes

**Use for:** Any UI before users see it

---

### `/shipping` - Deployment Security Check

**Run BEFORE deploying to production.** Catches config issues that code review misses.

These are the exact vulnerabilities found in 1/3 of vibe-coded apps audited:

**Checks:**
- **Source maps** - Are you leaking your full source code? (Most common issue!)
- **Supabase RLS** - Is it "on" but empty? (Fake security)
- **Protected routes** - Is /admin actually protected, or just hidden?
- **HTTP headers** - CSP, HSTS, X-Frame-Options present?
- **Exposed secrets** - API keys in your frontend JS bundle?
- **Rate limiting** - Can bots hammer your auth endpoints forever?
- **Debug endpoints** - /debug accessible in production?

**Framework-specific checks for:** Next.js, Vite, React, Supabase, Firebase, Vercel

**Use for:** Before every production deploy

---

### `/flow` - UI Flow Testing (Generate Tests)

**API tests pass. Buttons are broken. This catches that.**

Generates Playwright test code that clicks through your app like a real user.

**Includes:**
- **UI Discovery** - Crawl your app and map all buttons, forms, links
- **Button tests** - Does every button actually do something when clicked?
- **Form tests** - Do forms submit and show feedback?
- **Visual sanity** - Overlap detection, size validation, text cutoff
- **User flow tests** - Complete journeys (signup, login, checkout)

**Use for:** CI/CD pipelines, regression testing, test documentation

---

### `/live` - Live Browser Testing (Interactive)

**Claude controls a real browser and tests your running app.**

Uses Chrome DevTools MCP to directly interact with your app - no screenshots, no vision models, just direct DOM access.

**Prerequisites:**
```bash
claude mcp add chrome-devtools --scope user npx chrome-devtools-mcp@latest
```

**Capabilities (26 tools):**
- **Click, fill, hover** - Interact with any element
- **Run JavaScript** - Query the DOM directly
- **Console access** - See all errors and warnings
- **Network monitoring** - See all API calls and failures
- **Performance analysis** - Lighthouse-style insights

**Example usage:**
```
"Go to localhost:3000 and click every button. Report which ones don't work."
"Test the signup flow with test@example.com and password123"
"Check localhost:3000 for console errors"
```

**What it checks:**
- Every button actually responds to clicks
- Forms submit and show feedback
- No console errors
- No failed network requests
- No overlapping clickable elements
- No tiny touch targets

**Use for:** Quick smoke tests, debugging, verifying fixes work

---

### `/audit` - Full Push Audit

The "I'm about to push to production" command. Runs everything in sequence:

```
1. /deps          → Dependencies real and safe?
2. /dry           → Duplicated logic?
3. /architecture  → Structure maintainable?
4. /tests         → Tests meaningful?
5. /observability → Can see what's happening?
6. /ui            → Does UI give feedback? (if frontend)
7. /review        → Bugs hiding?
8. /security-audit → Exploitable?
9. /understand    → Can YOU explain this?
```

Ends with a sign-off checklist:
- [ ] I can explain what this code does
- [ ] I understand why this approach was chosen
- [ ] I know what could go wrong
- [ ] I know how to debug this if it breaks

**Use for:** Production pushes, PRs, releases
**Skip for:** Quick fixes, typos, docs-only changes

---

## Suggested Workflow

### Quick Changes
```
/review
```

### Before Pushing
```
/check
```

### Before Production / PR / Release
```
/audit
```

### When Unsure
```
/understand
```

---

## Make Claude Suggest These

Add to `~/.claude/CLAUDE.md`:

```markdown
## Vibe Check Commands

**Suggest `/check` when:**
- User says "ready to push" or "let's commit"
- Feature or fix is complete
- Creating a PR

**Suggest `/review` when:**
- Significant code written or changed
- User seems unsure

**Suggest `/security-audit` when:**
- Auth, tokens, or secrets involved
- User input being processed

**Suggest `/deps` when:**
- New dependencies added
- Setting up a project

**Suggest `/understand` when:**
- Complex code generated
- User accepted code without questions

**Suggest `/ui` when:**
- Any frontend/UI code being shipped
- User says "looks good" without testing
- Forms, buttons, modals generated
- Before any user-facing release

**Suggest `/shipping` when:**
- About to deploy to production
- Using Supabase, Firebase, or similar BaaS
- First deploy of a new project
- User asks about security headers or config

**Suggest `/flow` when:**
- Need test code for CI/CD
- Building regression test suite
- Documenting expected behavior

**Suggest `/live` when:**
- App is running and needs quick test
- User says "the API works" or "buttons work"
- Debugging a specific UI issue
- Before demo or launch
- Verifying a fix actually works
```

---

## Why This Exists

> "Every first pass from Claude ships with problems I would've been embarrassed to merge."

> "The real issue isn't vibecoding itself... it's when people treat the output as 'done' and skip the phase where software gets hardened."

> "A vibe coded app with 39k users had 16 security findings that nobody noticed until an external audit."

> "I don't think I have ever seen so much technical debt being created in such a short period of time during my 35-year career."

These commands force the hardening phase.

---

## How It Works

These are Claude Code slash commands - markdown files in `~/.claude/commands/` that tell Claude how to review your code.

No external services. No API calls. Just structured prompts.

---

## License

MIT
