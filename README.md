# Vibe Check

Slash commands for Claude Code that catch bugs and security issues before you ship.

## The Problem

AI-generated code ships with:
- Edge cases that break in production
- Security holes (tokens stored wrong, frontend-only auth, SQL injection)
- Assumptions that don't hold under real usage

Most people skip the review step. These commands force it.

## Commands

| Command | What it does |
|---------|-------------|
| `/review` | Adversarial code review - finds bugs and edge cases |
| `/security-audit` | Security checklist for common mistakes |
| `/check` | Full pipeline: tests + review + security audit |

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

## Usage

Type the command in Claude Code:

```
/review          # Review recent changes
/security-audit  # Security checklist
/check           # Run everything before pushing
/check quick     # Just tests + quick review
```

Commands report results and wait. They don't auto-fix or auto-push.

## What They Check

### `/review`

Reviews code as a senior dev who's seen too many production incidents:
- What breaks in production that works in dev?
- What edge cases aren't handled?
- Empty inputs, null values, race conditions?
- Will this be a nightmare to debug at 3am?

Findings: CRITICAL / HIGH / MEDIUM / LOW

### `/security-audit`

Checks for mistakes that get apps hacked:
- Tokens stored insecurely or never expiring
- Admin actions only checked on frontend
- SQL injection, XSS, path traversal
- OAuth scopes too broad
- "If this token leaks, what's the blast radius?"

### `/check`

Full pipeline:
1. Detect project type (Python/Node/Go/Rust)
2. Run tests
3. Run code review
4. Run security audit
5. Report verdict: READY / NEEDS ATTENTION / DO NOT PUSH

## Make Claude Suggest These

Add to `~/.claude/CLAUDE.md`:

```markdown
## Code Quality Commands

Suggest `/check` when user is ready to push or commit.
Suggest `/review` after significant code changes.
Suggest `/security-audit` when code handles auth, tokens, or user input.
```

## License

MIT
