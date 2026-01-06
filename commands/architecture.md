# Architecture Anti-Pattern Check

AI-generated code is "highly functional but systematically lacking in architectural judgment." This command catches the structural problems that make code unmaintainable.

## What AI Gets Wrong

AI doesn't understand your system - it predicts patterns. It optimizes for "code that works" not "code that lasts." Common results:

- **God objects** - Classes/modules with too many responsibilities
- **Tight coupling** - Modules depend on each other's internal details
- **Over-engineering** - Simple problems buried under abstraction layers
- **No separation of concerns** - Business logic mixed with I/O, UI, data access
- **Premature abstraction** - Generic solutions for one-time problems

## Checklist

Review the codebase architecture for these anti-patterns:

### 1. God Objects / Bloated Modules
- [ ] No file over 500 lines without good reason
- [ ] No class/module doing more than one job
- [ ] No function over 50 lines
- [ ] Can you describe what each module does in one sentence?

### 2. Coupling
- [ ] Modules interact through clear interfaces, not internal details
- [ ] Changing one module doesn't require changing others
- [ ] No circular dependencies
- [ ] Database/API details don't leak into business logic

### 3. Separation of Concerns
- [ ] Business logic separate from I/O (files, network, database)
- [ ] Configuration separate from code
- [ ] UI/presentation separate from logic
- [ ] Validation at boundaries, not scattered everywhere

### 4. Over-Engineering
- [ ] No abstractions with only one implementation
- [ ] No "factory factory" patterns for simple object creation
- [ ] No premature optimization
- [ ] Complexity justified by actual requirements, not hypotheticals

### 5. Code Organization
- [ ] Related code is grouped together
- [ ] Clear folder/module structure
- [ ] Naming reflects purpose
- [ ] New developer could find things without a guide

## Questions to Ask

1. **If I needed to change how [X] works, how many files would I touch?**
   - Good: 1-2 files
   - Bad: 5+ files scattered across the codebase

2. **Can I test this module in isolation?**
   - Good: Yes, with minimal mocking
   - Bad: Need to set up half the application

3. **Could a new developer understand this in 30 minutes?**
   - Good: Clear structure, obvious flow
   - Bad: Need tribal knowledge to navigate

4. **What happens when requirements change?**
   - Good: Change is localized
   - Bad: Ripple effects everywhere

## Output Format

```
## Architecture Review

### Overall Health: [GOOD / NEEDS WORK / PROBLEMATIC]

### God Objects Found
[List files/classes that do too much, or "None"]

### Coupling Issues
[List tightly coupled modules, or "None"]

### Over-Engineering
[List unnecessary abstractions, or "None"]

### Recommendations
1. [Most important structural change]
2. [Second priority]
3. [etc.]
```

## Remember

AI creates code that works. Your job is to make it last.

"Don't delegate architecture to AI. Architect your AI."
