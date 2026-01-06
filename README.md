# Vibe Check

Slash commands for Claude Code that catch bugs and security issues before you ship.

## Why This Exists

AI-generated code often has problems that aren't obvious until production:

- **Edge cases** - What happens with empty input? Null values? Concurrent access?
- **Security holes** - Tokens stored wrong, admin actions only checked on frontend, SQL injection
- **Bad assumptions** - Code that works in dev but breaks with real data

The issue isn't AI coding - it's skipping the review step. These commands force that step.

## Commands

| Command | What it does |
|---------|-------------|
| `/review` | Adversarial code review - finds bugs and edge cases |
| `/security-audit` | Security checklist for common mistakes |
| `/check` | Full pipeline: tests + review + security audit |
| `/check quick` | Fast mode: tests + critical issues only |

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

## Usage

Just type the command:

```
/review
/security-audit
/check
```

**Important:** Commands report findings and wait. They don't auto-fix or auto-push.

---

## Command Details

### `/review` - Adversarial Code Review

Reviews your code as a senior dev who's seen too many production incidents. Checks the git diff and asks:

- What would break in production that works in dev?
- What edge cases aren't handled?
- What happens with empty inputs, null values, missing data?
- What happens under load or with concurrent access?
- Are there race conditions?
- What assumptions might not hold?
- Is error handling useful or does it swallow important info?
- Are there security issues (injection, auth bypass, data exposure)?
- Will this be a nightmare to debug at 3am?

**Output:** Findings categorized as CRITICAL / HIGH / MEDIUM / LOW with a recommendation.

**Best practice:** Run 2-3 passes. After that you get diminishing returns - it starts inventing scenarios like "what if user enters negative number during a solar eclipse."

---

### `/security-audit` - Security Checklist

Checks for the mistakes that get vibe-coded apps hacked. Based on real security findings from apps with tens of thousands of users.

#### The Mindset

Before looking at code, assume:
- Every API endpoint will be called directly (not through your UI)
- Tokens will leak eventually
- Users will do things you didn't imagine
- Third parties will fail or change behavior

#### What It Checks

**Authentication & Tokens:**
- Tokens have appropriate expiry (not "never" or "10 years")
- Tokens not stored in localStorage for sensitive apps
- Refresh tokens in httpOnly cookies, not JS-accessible
- Token scopes are minimal (not "full access" because it was easier)
- One leaked token ≠ full account takeover
- API keys not hardcoded or in git

**Authorization & Permissions:**
- Admin/sensitive actions validated SERVER-SIDE (not just hidden buttons)
- Users can only access THEIR data (IDOR vulnerabilities)
- Role checks at API level, not just frontend
- No "edit admin=true in devtools" vulnerabilities

**Input Validation & Injection:**
- SQL uses parameterized queries (no string concatenation)
- User input sanitized before rendering (XSS)
- File uploads validated (type, size, no path traversal)
- Command execution doesn't include unsanitized user input

**Data Exposure:**
- Secrets not in code, logs, or error messages
- API responses don't leak extra fields (password hashes, internal IDs)
- Error messages don't reveal system internals
- Debug endpoints disabled in production

**Third-Party & OAuth:**
- OAuth scopes are MINIMAL
- Third-party failures handled gracefully
- Webhook signatures validated
- External data treated as untrusted

**The killer question:** "If this token leaks, what's the blast radius?"

---

### `/check` - Full Pipeline

Runs everything in sequence:

1. **Detect project type** - Python, Node, Go, Rust, or other
2. **Run tests** - pytest, npm test, go test, cargo test, or Makefile
3. **Run code review** - Adversarial review on git diff
4. **Run security audit** - Full security checklist
5. **Report verdict** - READY TO PUSH / NEEDS ATTENTION / DO NOT PUSH

**Quick mode:** `/check quick` skips security audit, runs one review pass for critical issues only.

---

## Make Claude Suggest These Automatically

Add to your `~/.claude/CLAUDE.md`:

```markdown
## Code Quality Commands

**Suggest `/check` when:**
- User says "ready to push" or "let's commit"
- A feature or fix is complete
- User asks to create a PR
- Multiple files changed

**Suggest `/review` when:**
- User finishes writing a function or feature
- Code has been refactored
- User seems unsure if something is correct

**Suggest `/security-audit` when:**
- Code handles API keys, tokens, or secrets
- Auth or permission logic added/changed
- User input is being processed
- External APIs being integrated
```

---

## Background

Based on discussions from r/ClaudeAI and r/vibecoding:

> "Every first pass from Claude (even Opus) ships with problems I would've been embarrassed to merge. We're talking missed edge cases, subtle bugs, the works."

> "The real issue isn't vibecoding itself... it's when people stop. Problems start when people treat the output as 'done' and skip the phase where software actually gets hardened."

> "A vibe coded AI app doing $3k MRR listed for $50k, 39k users, full access to linked tiktok + youtube accounts, 16 security findings, and nobody noticed until someone external looked at it."

These commands force the hardening phase that separates hobby projects from production code.

---

## How It Works

These are Claude Code slash commands - markdown files in `~/.claude/commands/` that Claude reads when you type the command. They're prompts that tell Claude how to review your code.

No external services. No API calls. Just instructions for Claude.

---

## License

MIT - Use it, fork it, improve it.
