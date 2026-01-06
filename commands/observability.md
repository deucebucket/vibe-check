# Observability Check

AI-generated code focuses on the happy path. It works in dev, passes tests, and looks good when skimmed. But there's often no visibility into what it's doing in production.

When something breaks at 3am, you need to know:
- What happened?
- When did it happen?
- What was the input?
- What was the state?

Without observability, your code is invisible.

## The Three Pillars

### 1. Logging
What happened and when

### 2. Metrics
How is the system performing

### 3. Tracing
How do requests flow through the system

## Checklist

### Logging

- [ ] Errors are logged with stack traces
- [ ] Important operations are logged (not just errors)
- [ ] Log levels are used correctly (DEBUG, INFO, WARN, ERROR)
- [ ] Logs include context (user ID, request ID, relevant data)
- [ ] Sensitive data is NOT logged (passwords, tokens, PII)
- [ ] Logs are structured (JSON) not just print statements

**What to log:**
- Application startup/shutdown
- Authentication events (login, logout, failed attempts)
- Important business operations
- External API calls (request/response, timing)
- Database queries (in debug mode)
- Errors and exceptions with context

**What NOT to log:**
- Passwords, tokens, API keys
- Full credit card numbers
- Personal data (unless required and compliant)
- High-frequency operations that would flood logs

### Error Tracking

- [ ] Exceptions are caught and reported (not silently swallowed)
- [ ] Error context is captured (what was the user doing?)
- [ ] Errors are grouped/deduplicated
- [ ] Alerts exist for critical errors
- [ ] Errors include enough info to reproduce

### Metrics

- [ ] Request count and latency tracked
- [ ] Error rates tracked
- [ ] Resource usage tracked (CPU, memory, connections)
- [ ] Business metrics tracked (signups, transactions, etc.)
- [ ] Queue depths tracked (if applicable)

### Health Checks

- [ ] Health endpoint exists (/health or /healthz)
- [ ] Health check verifies dependencies (DB, external services)
- [ ] Health check is used by load balancer/orchestrator

## Red Flags in AI-Generated Code

Look for these patterns that indicate missing observability:

```python
# BAD: Silent failure
try:
    do_something()
except:
    pass

# BAD: Print instead of logging
print(f"Processing user {user_id}")

# BAD: No context in errors
raise Exception("Something went wrong")

# BAD: Logging sensitive data
logger.info(f"User login: {username}, password: {password}")
```

```python
# GOOD: Proper error handling with logging
try:
    result = do_something()
    logger.info("Operation completed", extra={"user_id": user_id, "result": result})
except SpecificError as e:
    logger.error("Operation failed", extra={"user_id": user_id, "error": str(e)}, exc_info=True)
    raise
```

## Questions to Ask

1. **If this crashes in production, will I know?**
   - Good: Error tracking captures it with context
   - Bad: Silent failure or just a stack trace in logs

2. **Can I trace a user's request through the system?**
   - Good: Request ID links all related logs
   - Bad: Logs are disconnected, can't follow the flow

3. **How will I know if performance degrades?**
   - Good: Metrics and alerts on latency/error rates
   - Bad: Users complain before I notice

4. **Can I answer "who did what when"?**
   - Good: Audit trail of important actions
   - Bad: No record of operations

## Output Format

```
## Observability Report

### Overall: [GOOD / NEEDS WORK / BLIND]

### Logging
- Status: [Adequate / Inadequate / Missing]
- Issues: [List problems]

### Error Tracking
- Status: [Adequate / Inadequate / Missing]
- Issues: [List problems]

### Metrics
- Status: [Adequate / Inadequate / Missing]
- Issues: [List problems]

### Health Checks
- Status: [Present / Missing]

### Sensitive Data Exposure
[List any logging of sensitive data, or "None found"]

### Recommendations
1. [Most important observability gap to fix]
2. [Second priority]
3. [etc.]
```

## Remember

- If you can't see it, you can't fix it
- Add observability to your prompts from the start
- Logs without context are useless
- Silent failures are the worst kind of bugs
- Production debugging without observability is guessing
