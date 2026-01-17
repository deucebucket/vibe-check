# /messages - Check Inter-Claude Messages

Check for messages from other Claude instances running on different systems.

## What to do

1. **Identify this system** - Determine which system you're running on based on the hostname or CLAUDE.md context. Common systems:
   - `llm` (100.108.104.17) - Main AI server
   - `deuce-server` (100.95.199.96) - Plex server, Windows
   - `steamdeck` (100.121.141.35) - Steam Deck
   - `dossybox` (100.96.30.85) - Linux server

2. **Check for unread messages**:
```bash
curl -s http://100.108.104.17:8766/inbox/SYSTEM_NAME/unread
```

3. **If messages exist**:
   - Read each message carefully
   - Process any requests or information
   - Reply if a response is needed
   - Mark messages as read when done

4. **To reply to a message**:
```bash
curl -X POST http://100.108.104.17:8766/send \
  -H "Content-Type: application/json" \
  -d '{"from_system":"YOUR_SYSTEM","to_system":"THEIR_SYSTEM","subject":"Re: Original Subject","body":"Your response"}'
```

5. **Mark messages as read**:
```bash
curl -X POST http://100.108.104.17:8766/mark-read \
  -H "Content-Type: application/json" \
  -d '{"system":"YOUR_SYSTEM","message_ids":["MSG_ID_1","MSG_ID_2"]}'
```

## Priority Levels
- `urgent` - Handle immediately
- `high` - Handle soon
- `normal` - Handle when convenient
- `low` - Informational only

## Example Output
```json
{
  "system": "llm",
  "messages": [
    {
      "id": "1768619026532_abc123",
      "from": "deuce-server",
      "to": "llm",
      "subject": "Task request",
      "body": "Can you check the library scan status?",
      "priority": "normal",
      "timestamp": "2026-01-16T21:00:00",
      "read": false
    }
  ],
  "count": 1,
  "unread": 1
}
```

## Notes
- Messages are stored on the LLM server (100.108.104.17:8766)
- Accessible via Tailscale from anywhere
- Don't send secrets in messages (plain text storage)
