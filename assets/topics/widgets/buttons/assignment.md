# Assignment

## Challenge: Build a Multi-State E-Commerce Checkout Action Panel

### Objective
Design and implement a complete, production-ready Checkout Action Panel widget in Flutter demonstrating proper button hierarchy, state management, loading handling, and error resilience.

---

### Requirements

#### 1. UI Layout & Hierarchy
- **Primary CTA**: `ElevatedButton` for `"Place Order ($99.99)"`.
- **Secondary Action**: `OutlinedButton` for `"Add Gift Card"`.
- **Tertiary Action**: `TextButton` for `"View Return Policy"`.
- **Floating Action**: A `FloatingActionButton.extended` that shows current cart items count (e.g., `"3 Items"`).

#### 2. Functional Requirements
- **State Machine**:
  - `Idle`: Normal interactive buttons.
  - `Processing`: `ElevatedButton` displays a spinner, disables all other buttons (`onPressed: null`).
  - `Success`: Replaces primary button child with a checkmark icon + `"Order Placed!"` in green.
  - `Error`: Displays an error banner and turns the primary button red with `"Retry Payment"`.

- **Form Validation Integration**:
  - Include a checkbox `"I agree to Terms & Conditions"`.
  - Disabling the checkbox MUST immediately disable the `ElevatedButton` (`onPressed: null`).

#### 3. Styling Standards
- Apply a custom `ButtonStyle` using `.styleFrom()` with `RoundedRectangleBorder` (border radius: `12.0`).
- Ensure all touch targets meet minimum 48px height requirements.

---

### Submission Checklist
- [ ] Primary, Secondary, and Tertiary buttons are clearly visible with proper design hierarchy.
- [ ] Disabling terms checkbox correctly disables the primary button.
- [ ] Tapping "Place Order" shows a 2-second loading indicator and disables duplicate taps.
- [ ] Visual feedback (Success / Error state) is clearly displayed upon completion.
