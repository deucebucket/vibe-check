# Vibe Check

Slash commands for Claude Code that catch the problems vibe coders ship.

## The Problem

Research shows AI-generated code has serious issues:

| Problem | Stat | Source |
|---------|------|--------|
| More bugs | AI code creates 1.7x more issues | CodeRabbit |
| Security holes | 45% of AI code has vulnerabilities | Veracode |
| Fake packages | 21.7% of AI-suggested packages don't exist | UTSA |
| No testing | 36% of vibe coders skip QA entirely | arxiv |
| Logic errors | 2x more common in AI code | CodeRabbit |

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

### `/audit` - Full Push Audit

The "I'm about to push to production" command. Runs everything in sequence:

```
1. /deps          → Dependencies real and safe?
2. /dry           → Duplicated logic?
3. /architecture  → Structure maintainable?
4. /tests         → Tests meaningful?
5. /observability → Can see what's happening?
6. /review        → Bugs hiding?
7. /security-audit → Exploitable?
8. /understand    → Can YOU explain this?
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
