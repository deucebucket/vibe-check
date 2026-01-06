#!/bin/bash
# Vibe Check installer - adds slash commands to Claude Code

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"

echo "Installing Vibe Check commands..."

# Create Claude commands directory if it doesn't exist
mkdir -p "$CLAUDE_COMMANDS_DIR"

# Copy commands
cp "$SCRIPT_DIR/commands/review.md" "$CLAUDE_COMMANDS_DIR/"
cp "$SCRIPT_DIR/commands/security-audit.md" "$CLAUDE_COMMANDS_DIR/"
cp "$SCRIPT_DIR/commands/check.md" "$CLAUDE_COMMANDS_DIR/"

echo ""
echo "Installed commands:"
echo "  /review          - Adversarial code review"
echo "  /security-audit  - Security checklist"
echo "  /check           - Full pipeline (tests + review + security)"
echo ""
echo "Commands installed to: $CLAUDE_COMMANDS_DIR"
echo ""
echo "Start a new Claude Code session to use them!"
