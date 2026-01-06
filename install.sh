#!/bin/bash
# Vibe Check installer - adds slash commands to Claude Code

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"

echo "Installing Vibe Check commands..."

# Create Claude commands directory if it doesn't exist
mkdir -p "$CLAUDE_COMMANDS_DIR"

# Copy all commands
cp "$SCRIPT_DIR/commands/"*.md "$CLAUDE_COMMANDS_DIR/"

echo ""
echo "Installed commands:"
echo "  /review          - Adversarial code review"
echo "  /security-audit  - Security checklist"
echo "  /check           - Full pipeline (tests + review + security)"
echo "  /architecture    - Architecture anti-patterns"
echo "  /deps            - Dependency validation"
echo "  /tests           - Test quality check"
echo "  /observability   - Logging, metrics, error tracking"
echo "  /dry             - Code duplication check"
echo "  /understand      - Code comprehension check"
echo ""
echo "Commands installed to: $CLAUDE_COMMANDS_DIR"
echo ""
echo "Restart Claude Code to use them."
