# Changelog

All notable changes to vibe-check will be documented in this file.

## [2.1.0] - 2026-01-29

### Added

- **`/live`** - Comprehensive live browser testing
  - **ALL browsers**: Chrome, Firefox, Safari, Edge via Playwright MCP
  - **ALL console logs**: Errors, warnings, info, network failures
  - **ALL network requests**: Monitor, audit, catch failures
  - **ALL interactive elements**: Click every button, fill every form
  - **ALL accessibility**: Keyboard nav, ARIA, focus states, contrast
  - **ALL performance**: Load time, runtime, memory, animations
  - 10 testing phases covering everything a user could encounter

### Changed

- **`/flow`** - Now references `/live` for interactive testing
  - `/flow` generates test code for CI/CD
  - `/live` tests running apps interactively
  - Clear guidance on when to use each

### Prerequisites

```bash
# Cross-browser testing (Chrome, Firefox, Safari, Edge)
claude mcp add playwright --scope user npx @playwright/mcp@latest

# Chrome-specific deep inspection
claude mcp add chrome-devtools --scope user npx chrome-devtools-mcp@latest
```

---

## [2.0.0] - 2026-01-29

### Added

- **`/shipping`** - Deployment security check
  - Source maps exposure detection
  - Supabase RLS misconfiguration checks
  - Protected routes verification (middleware vs hidden buttons)
  - HTTP security headers (HSTS, CSP, X-Frame-Options)
  - Exposed secrets in frontend bundles
  - Rate limiting verification
  - Debug endpoint checks
  - Framework-specific guidance for Next.js, Vite, Supabase, Firebase, Vercel

- **`/flow`** - UI flow testing
  - Playwright-based UI discovery crawler
  - Button click testing (does every button actually work?)
  - Form submission testing
  - Link verification
  - Visual sanity checks (overlap detection, size validation)
  - User flow test templates (signup, login, logout)
  - Ready-to-run test code samples

### Changed

- **`/ui`** - Major enhancement with Visual Judgment
  - Added Part 0: Visual Judgment section
  - Now catches proportion issues (tiny elements in large containers)
  - Overlap and collision detection
  - "AI Look" detection (generic template soup)
  - 14 common visual bugs checklist
  - Amateur design red flags checklist
  - Professional gut check protocol
  - Information display checks
  - Visual review protocol for Claude

- **`/security-audit`** - Vibe-coding specific vulnerabilities
  - Client-side auth detection (localStorage.isAdmin)
  - Hardcoded credentials patterns
  - Business logic flaw checks (negative quantities, price manipulation)
  - "Hallucinated bypass" detection
  - Supabase/Firebase specific checks
  - Updated stats (45% vulnerability rate, 2000+ vulns in 5600 apps)

- **`/audit`** - Expanded pipeline
  - Now runs 11 checks (was 9)
  - Added /flow for UI testing
  - Added /shipping for deployment security
  - Updated output format with new check categories
  - Enhanced UI/UX check descriptions

- **README** - Major update
  - Added new stats from 2025-2026 research
  - Common disasters found section
  - Documentation for /shipping and /flow
  - Updated /ui documentation with visual judgment
  - Updated suggested workflow

### Research Sources

Based on findings from:
- Reddit r/VibeCodeDevs audit (1 in 3 apps had gaping holes)
- Escape.tech (2000+ vulnerabilities in 5600 vibe-coded apps)
- Veracode 2025 (45% of AI code has vulnerabilities)
- Intigriti security research
- Nielsen Norman Group (10 web design mistakes)
- BrowserStack, DevClass, Stack Overflow articles

---

## [1.1.0] - 2026-01-16

### Added
- **`/messages`** - Inter-Claude messaging check

---

## [1.0.0] - 2026-01-11

### Added
- **`/ui`** - UI/UX reality check
  - Visibility of system status
  - Five states coverage (loading, empty, error, success, edge)
  - Accessibility basics
  - AI NO-NO patterns
  - 20-point scoring system

- **`/audit`** - Full push audit with sign-off

### Changed
- **`/check`** - Now includes UI check for frontend projects

---

## [0.1.0] - 2026-01-06

### Added
Initial release with core commands:
- `/review` - Adversarial code review
- `/security-audit` - Security checklist
- `/check` - Full pipeline
- `/architecture` - Architecture anti-patterns
- `/deps` - Dependency validation
- `/tests` - Test quality check
- `/observability` - Observability check
- `/dry` - DRY check
- `/understand` - Code understanding check
