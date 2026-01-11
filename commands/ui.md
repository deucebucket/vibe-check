# UI/UX Reality Check

**The Golden Rule: Humans can't see behind the veil.**

AI forgets that users can't see the 1s and 0s. They don't know if their click registered. They don't know if data is loading or the app crashed. They don't know if their form submission worked or vanished into the void.

Every action needs visible feedback. Every state needs visual representation. Silence is failure.

## Why AI-Generated UIs Feel Wrong

AI optimizes for "looks good in a screenshot" not "works for humans." The result:

- **Polished but soulless** - No personality, no brand voice, template soup
- **Happy path only** - Works in demos, breaks in production
- **Silent failures** - Actions happen with no feedback
- **Missing states** - No loading, no empty, no error handling
- **Homogeneous design** - Looks like every other AI site

Consumer enthusiasm for AI content dropped from 60% (2023) to 26% (2025). Users call it "AI slop" - uninspired, repetitive, soulless.

---

## Part 1: The Visibility Principle

**Nielsen's #1 Heuristic**: "The system should always keep users informed about what is going on, through appropriate feedback within reasonable time."

This is where AI fails most catastrophically. A lack of information equals a lack of control. Users who don't know what's happening feel helpless, frustrated, and will leave.

### Every Action Needs Feedback

| User Action | Required Feedback | AI Often Misses |
|-------------|-------------------|-----------------|
| Click button | Visual change (color, press state) | Button looks identical |
| Submit form | Loading → Success/Error message | Silent submission |
| Delete item | Confirmation → "Deleted" toast | Item just disappears |
| Save changes | "Saving..." → "Saved!" | Nothing happens |
| Load page | Skeleton/spinner → Content | Blank screen |
| Background process | Progress indicator | User thinks it crashed |
| Network request | Loading state → Result | Frozen UI |

### The Silence Test

For every interactive element, ask: **"If I couldn't see the code, would I know this worked?"**

```
BAD:  User clicks "Save" → Nothing visible happens → Data saves in background
GOOD: User clicks "Save" → Button shows spinner → Toast: "Changes saved!"

BAD:  User submits form → Page refreshes → Form is empty (did it work??)
GOOD: User submits form → Button: "Sending..." → Success message with next steps

BAD:  User deletes item → Item disappears → (Was that intentional? Can I undo?)
GOOD: User deletes item → "Item deleted" toast with "Undo" button (5 sec)
```

---

## Part 2: The Five States Every Screen Must Handle

AI generates the "happy path" - the ideal scenario where everything works perfectly. Real users hit every other state. 94.8% of websites fail basic accessibility tests. This is why.

### 1. Loading State
**What users see while data loads**

```
NO:  Blank white screen
NO:  Frozen UI with no indication
NO:  Just "Loading..." text
YES: Skeleton loaders matching content layout
YES: Spinner with context ("Loading your dashboard...")
YES: Progress bar for long operations (uploads, exports)
```

**Rules:**
- Under 1 second: No loader needed (feels instant)
- 1-10 seconds: Skeleton or spinner
- Over 10 seconds: Progress bar with percentage
- Skeleton loaders reduce perceived wait time by 31%

### 2. Empty State
**What users see when there's no data**

```
NO:  Blank area
NO:  "No data" in gray text
NO:  Technical message: "Query returned 0 results"
YES: Helpful illustration + clear explanation
YES: Call to action: "Create your first project"
YES: Example/template to get started
```

**Empty State Formula:**
1. Acknowledge the emptiness (don't pretend it's not empty)
2. Explain why it's empty (new account? no results? filtered out?)
3. Guide to next action (create, search differently, remove filters)

**Example:**
```
[Illustration of empty inbox]
"No messages yet"
"When someone sends you a message, it'll show up here."
[Button: "Invite teammates"]
```

### 3. Error State
**What users see when something breaks**

```
NO:  "Error"
NO:  "Error 500"
NO:  "Something went wrong"
NO:  Technical stack trace
NO:  Silent failure (worst!)
YES: What happened + Why + What to do next
```

**Error Message Formula:**
1. **What** went wrong (in human terms)
2. **Why** (if helpful and not technical)
3. **How** to fix it or what happens next

**Examples:**
```
BAD:  "Error 403"
GOOD: "You don't have permission to view this page. Contact your admin for access."

BAD:  "Invalid input"
GOOD: "Email address looks incomplete. Make sure it includes @ and a domain."

BAD:  "Network error"
GOOD: "Couldn't connect to the server. Check your internet and try again. [Retry button]"

BAD:  "Something went wrong"
GOOD: "We couldn't save your changes. Your work is backed up locally. We'll retry automatically when connection returns."
```

### 4. Success State
**What users see when actions complete**

```
NO:  Nothing (silence is not confirmation)
NO:  Page refresh with no message
NO:  Only visual change (not accessible)
YES: Clear confirmation message
YES: Toast/snackbar with undo option
YES: Celebration for major milestones
```

**Success State Options:**
- **Inline change**: Button → checkmark (for minor actions)
- **Toast notification**: "Changes saved" (auto-dismiss 3-4 sec)
- **Success page**: For major actions (checkout, signup)
- **Celebration**: Confetti, animation for milestones (use sparingly)

### 5. Partial/Edge States
**The states AI never considers**

- **Partial data**: What if only some data loads?
- **Stale data**: What if cached data is outdated?
- **Slow connection**: What if it takes 30 seconds?
- **Offline**: What happens with no internet?
- **Conflict**: What if someone else edited the same thing?
- **Quota reached**: What if user hits a limit?
- **Expired session**: What if their login times out?

---

## Part 3: AI NO-NOs (The Anti-Pattern Hall of Shame)

These patterns scream "AI generated this without human review." If you see these, fix them immediately.

### NO-NO #1: The Silent Button
```html
<!-- AI generates this constantly -->
<button onclick="saveData()">Save</button>

<!-- No loading state -->
<!-- No disabled state while saving -->
<!-- No success feedback -->
<!-- No error handling -->
<!-- User has no idea if it worked -->
```

**Fix:**
```
[Button: "Save"]           → User clicks
[Button: "Saving..." ⏳]   → Loading state (disabled)
[Button: "Saved ✓"]        → Success (reverts after 2s)
OR
[Button: "Save"] + Toast: "Changes saved!"
OR
[Button: "Save"] + Error: "Couldn't save. [Retry]"
```

### NO-NO #2: The Blank Void
```
User opens app for first time:
┌─────────────────────────────┐
│                             │
│                             │
│                             │
│                             │
│                             │
└─────────────────────────────┘

User: "Is this broken? Did it load? What do I do?"
```

**Fix:**
```
┌─────────────────────────────┐
│     📋 No projects yet      │
│                             │
│  Projects you create will   │
│  appear here.               │
│                             │
│  [+ Create first project]   │
└─────────────────────────────┘
```

### NO-NO #3: The Cryptic Error
```
┌─────────────────────────────┐
│  ❌ Error                   │
│                             │
│  Something went wrong.      │
│                             │
│  [OK]                       │
└─────────────────────────────┘
```

This tells the user NOTHING. What broke? Why? What can they do?

**Fix:**
```
┌─────────────────────────────┐
│  ❌ Couldn't upload file    │
│                             │
│  "report.pdf" is 25MB but   │
│  the limit is 10MB.         │
│                             │
│  [Try smaller file]  [Help] │
└─────────────────────────────┘
```

### NO-NO #4: The Unescapable Modal
```javascript
// AI generates modals missing:
// - Escape key to close
// - Click outside to close
// - Focus trap (Tab stays in modal)
// - Focus return (focus goes back to trigger on close)
// - Screen reader announcements
```

**Modal Accessibility Checklist:**
- [ ] Escape key closes modal
- [ ] Click backdrop closes modal (unless destructive action)
- [ ] Focus moves to modal on open
- [ ] Focus trapped inside modal
- [ ] Focus returns to trigger on close
- [ ] `aria-modal="true"` present
- [ ] Descriptive close button (not just "X")

### NO-NO #5: The Frozen Form
```
User fills form → Clicks submit → ???

Did it submit? Is it loading? Did it fail?
User clicks again → Now they submitted twice
```

**Form Submission Flow:**
```
1. User clicks submit
2. IMMEDIATELY: Button changes to "Submitting..." + disabled
3. Form inputs disabled (prevent changes mid-submit)
4. On success: Clear message, redirect, or reset form
5. On error: Re-enable form, show inline errors, keep data
6. NEVER: Leave user wondering what happened
```

### NO-NO #6: The Premature Validator
```
User starts typing email:
"j" → ❌ Invalid email
"jo" → ❌ Invalid email
"joh" → ❌ Invalid email

User: "LET ME FINISH TYPING!"
```

**Validation Rules:**
- Validate on **blur** (when user leaves field), not on every keystroke
- Exception: Password strength meters (real-time is helpful)
- Exception: Username availability (check after pause)
- Exception: Character counters (show remaining)
- Remove error as soon as input is corrected
- Don't validate empty required fields until submit attempt

### NO-NO #7: The Missing Hover
```css
/* AI generates buttons with no states */
.button {
  background: blue;
  color: white;
}

/* Missing: */
.button:hover { }    /* What happens on hover? */
.button:focus { }    /* What about keyboard users? */
.button:active { }   /* What about click/tap? */
.button:disabled { } /* What does disabled look like? */
```

**Button State Checklist:**
- [ ] Default: Clear clickable appearance
- [ ] Hover: Subtle change (darken, shadow, lift)
- [ ] Focus: Visible outline (NEVER `outline: none` without replacement)
- [ ] Active/Pressed: "Pushed in" feeling
- [ ] Disabled: Grayed out + cursor: not-allowed + no hover effect
- [ ] Loading: Spinner + disabled + original text or "Loading..."

### NO-NO #8: The Vanishing Act
```
User clicks delete → Item disappears immediately

User: "Wait, did I click the right one? Can I undo?"
```

**Delete UX Pattern:**
```
Option A: Soft Delete (preferred)
- Item visually marked as deleted
- Toast: "Item deleted" [Undo - 5 seconds]
- Actually deletes after 5 seconds or page leave

Option B: Confirmation Dialog (for irreversible)
- "Delete 'Project X'?"
- "This cannot be undone."
- [Cancel] [Delete]

NEVER: Instant, silent, permanent deletion
```

### NO-NO #9: The Infinite Loader
```
User clicks load more:

Loading...
Loading...
Loading...  (30 seconds later)
Loading...  (user gives up)

Did it fail? Is the server slow? Is it stuck?
```

**Loading State Rules:**
- 0-1 second: Nothing needed
- 1-3 seconds: Simple spinner
- 3-10 seconds: Spinner with "Taking longer than usual..."
- 10+ seconds: Timeout with retry option
- Always: Ability to cancel
- Always: Handle timeout gracefully

### NO-NO #10: The Robot Voice
```
/* AI-generated microcopy */

"Error: NULL_POINTER_EXCEPTION in AuthService"
"Your request has been processed successfully."
"Please ensure all required fields are populated."
"Click here to proceed to the next step."
"We are currently experiencing technical difficulties."
```

**Human Voice Alternatives:**
```
"Something unexpected happened. We've logged it and will fix it." [Contact support]
"You're all set!"
"Oops, we need your email to continue."
"Continue"
"Our servers are having a moment. Back in a few minutes!"
```

---

## Part 4: The 10-Point UI Judgment Standard

Score each category 0-2:
- **0** = Missing or broken
- **1** = Present but weak
- **2** = Well implemented

### 1. Visibility of System Status (0-2)
- User always knows what's happening
- Loading states present and contextual
- Actions have visible feedback
- Progress shown for long operations

### 2. State Completeness (0-2)
- Loading state exists
- Empty state guides users
- Error state is helpful
- Success state confirms actions
- Edge cases handled

### 3. Accessibility Basics (0-2)
- Keyboard navigation works
- Focus states visible
- Color is not the only indicator
- Screen reader tested or ARIA present
- Interactive elements are large enough

### 4. Feedback Timing (0-2)
- Immediate response to clicks (<100ms)
- Loading indicators appear promptly
- Toasts auto-dismiss appropriately
- Validation happens at right time

### 5. Error Handling (0-2)
- Errors explain what happened
- Errors say how to fix it
- Recovery paths available
- No silent failures

### 6. Microcopy Quality (0-2)
- Human-friendly language
- No technical jargon exposed
- Consistent tone throughout
- Empathetic, not blaming

### 7. Interactive Element States (0-2)
- Buttons: hover, focus, active, disabled
- Inputs: focus, error, success
- Links: visited state where appropriate
- Consistent state patterns

### 8. User Control (0-2)
- Undo available for destructive actions
- Cancel available for long processes
- Changes can be reverted
- User isn't trapped

### 9. Visual Hierarchy (0-2)
- Clear primary action on each screen
- Secondary actions distinguishable
- Information has clear priority
- Scannable layout

### 10. Personality & Brand (0-2)
- Doesn't look like every other AI site
- Has consistent visual voice
- Illustrations/icons match tone
- Would pass "5 second brand test"

**Scoring:**
- 18-20: Ship it
- 14-17: Minor polish needed
- 10-13: Significant gaps - address before launch
- Below 10: Not ready for users

---

## Part 5: Quick Checklists

### Before Any User Sees It
- [ ] Click every button - did something visible happen?
- [ ] What happens with no data?
- [ ] What happens when loading takes 10 seconds?
- [ ] What happens when it fails?
- [ ] Can you navigate with only a keyboard?
- [ ] Read all text out loud - does it sound human?

### Form Checklist
- [ ] Submit button has loading state
- [ ] Errors show inline next to fields
- [ ] Errors explain how to fix
- [ ] Data isn't lost on error
- [ ] Success is clearly confirmed
- [ ] Required fields are marked
- [ ] Validation timing is appropriate

### Button Checklist
- [ ] Has hover state
- [ ] Has focus state (visible outline)
- [ ] Has active/pressed state
- [ ] Has disabled state when applicable
- [ ] Has loading state when applicable
- [ ] Size is at least 44x44px for touch

### Modal Checklist
- [ ] Escape key closes it
- [ ] Click backdrop closes it (if appropriate)
- [ ] Focus is trapped inside
- [ ] Focus returns on close
- [ ] Has accessible close button
- [ ] Can't interact with page behind

### Toast/Notification Checklist
- [ ] Appears near the action that triggered it
- [ ] Auto-dismisses in 3-5 seconds
- [ ] Has close button for accessibility
- [ ] Includes undo for destructive actions
- [ ] Doesn't stack more than 2-3

---

## Part 6: Testing Protocol

### The 3am Test
"If this broke at 3am, would the error message help someone fix it?"

### The Grandma Test
"Could someone non-technical understand what happened and what to do?"

### The Impatient User Test
"If someone clicks a button 5 times rapidly, what happens?"

### The Slow Network Test
"What happens on 3G? What about offline?"

### The Screen Reader Test
"Can you complete the task with your eyes closed, using only a screen reader?"

### The Angry User Test
"If someone is already frustrated, will this UI make it worse or better?"

---

## Output Format

```
## UI/UX Reality Check

### Visibility Score: [X/20]
[Break down by category]

### State Coverage
- Loading: [✓ Present / ⚠ Partial / ✗ Missing]
- Empty: [✓ Present / ⚠ Partial / ✗ Missing]
- Error: [✓ Present / ⚠ Partial / ✗ Missing]
- Success: [✓ Present / ⚠ Partial / ✗ Missing]

### AI NO-NOs Found
[List specific issues from anti-pattern section]

### Silent Failures
[Actions that complete without user feedback]

### Accessibility Gaps
[Keyboard, screen reader, color contrast issues]

### Robot Voice Detected
[Microcopy that sounds inhuman]

### What's Good
[Positive patterns found]

### Priority Fixes
1. [Most critical - blocks shipping]
2. [Should fix - affects trust]
3. [Nice to have - polish]

### Verdict
[SHIP IT / FIX FIRST / NOT READY]
```

---

## Remember

- **Users can't see behind the veil** - Every action needs visible feedback
- **Silence is failure** - No response = broken from user's perspective
- **AI makes screenshots, humans make experiences** - Static mockups aren't UX
- **The happy path is 10% of reality** - Handle the other 90%
- **Robots sound like robots** - Write like a human, not a system message
- **Accessibility isn't optional** - It's how real people use your product

"The design should speak to the user. A silent interface is a hostile interface."
