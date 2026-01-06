# Code Understanding Check

"If you can't explain it simply, you don't understand it well enough." - Einstein

Many vibe coders ship code they don't understand. They hit a bug, ask AI, get an answer, repeat. This creates "pseudo-developers" who can't maintain, debug, or secure their own code.

**Rule: If you don't understand it, don't ship it.**

## The Feynman Technique for Code

Richard Feynman's learning method works for code too:

1. **Explain it simply** - Describe what the code does in plain language
2. **Identify gaps** - Where do you say "and then magic happens"?
3. **Fill the gaps** - Research until you can explain those parts
4. **Simplify** - If your explanation is complex, the code might need simplifying

## The Test

Before shipping any significant code, you must be able to answer:

### High Level
- [ ] What problem does this code solve?
- [ ] Why was this approach chosen over alternatives?
- [ ] What are the inputs and outputs?
- [ ] What are the failure modes?

### Implementation
- [ ] Can you trace the flow from input to output?
- [ ] What does each major function/class do?
- [ ] Why is each dependency needed?
- [ ] What would break if you removed any part?

### Edge Cases
- [ ] What happens with empty/null input?
- [ ] What happens with very large input?
- [ ] What happens when external services fail?
- [ ] What happens with malformed data?

### Integration
- [ ] How does this connect to the rest of the system?
- [ ] What data does it read/write?
- [ ] What other components depend on this?
- [ ] What happens if this component fails?

## Exercise: Explain the Code

For each significant piece of code you're about to ship, write a brief explanation:

```
## What This Code Does

### Purpose
[One sentence: what problem does this solve?]

### How It Works
[2-3 sentences: the high-level flow]

### Key Decisions
[Why this approach? What alternatives were considered?]

### Dependencies
[What external packages/services does this use and why?]

### Failure Modes
[What can go wrong and how is it handled?]

### Testing
[How do you know this works correctly?]
```

If you can't fill this out, **you don't understand the code well enough to ship it.**

## Red Flags: Signs You Don't Understand

- "It works, I don't know why"
- "The AI suggested this"
- "I copied this from Stack Overflow"
- Can't explain what a function does without reading it
- Don't know why a dependency is needed
- Can't predict what will happen with unusual input
- Don't know what error messages mean

## Questions to Force Understanding

Ask yourself (or ask AI to quiz you):

1. **What happens if I delete this line?**
2. **Why is this check/validation here?**
3. **What does this error message mean?**
4. **How would I debug this if it broke?**
5. **What's the performance characteristic of this?**
6. **What security implications does this have?**

## When AI Generates Complex Code

If AI generates something you don't understand:

1. **Ask it to explain** - "Explain this code step by step"
2. **Ask for simpler alternatives** - "Is there a simpler way to do this?"
3. **Ask about trade-offs** - "What are the downsides of this approach?"
4. **Research independently** - Don't just trust AI's explanation
5. **If still unclear, don't ship it** - Simplify or learn more first

## Output Format

When running this check, produce:

```
## Code Understanding Assessment

### Can You Explain It?
[Have the developer explain the code in their own words]

### Gaps Identified
[Parts that are unclear or hand-waved]

### Questions to Resolve
[Specific things to learn before shipping]

### Verdict
[READY - Developer understands the code]
[NEEDS STUDY - Gaps that must be filled]
[NOT READY - Significant lack of understanding]
```

## Remember

- Code you don't understand is a liability
- You'll have to debug this at 3am someday
- AI can write code, but you're responsible for it
- Understanding takes time - that's okay
- Shipping mystery code is technical debt
- If you can't explain it, you can't fix it
