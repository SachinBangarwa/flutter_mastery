# Interview Questions

### Q1: What is the difference between `ElevatedButton`, `OutlinedButton`, and `TextButton` in Flutter?
**Answer:**
These three buttons represent different emphasis levels in Material Design 3:
- **`ElevatedButton` (High Emphasis)**: Contains a filled background color and elevation shadow. Used for primary call-to-action (e.g. "Pay Now", "Login").
- **`OutlinedButton` (Medium Emphasis)**: Has a visible border line with a transparent background. Used for secondary actions (e.g. "Filter Results", "View Details").
- **`TextButton` (Low Emphasis)**: Has no border or elevation shadow. Used for tertiary actions or inline dialog buttons (e.g. "Cancel", "Skip", "Learn More").

---

### Q2: How do you disable a button in Flutter and what happens visually when you do?
**Answer:**
In Flutter, passing `null` to the `onPressed` (or `onLongPress`) parameter disables the button:
```dart
ElevatedButton(
  onPressed: isDisabled ? null : () => doAction(),
  child: const Text('Submit'),
)
```
When `onPressed` is `null`:
1. Tap and ripple responses are disabled.
2. The button's colors automatically shift to the disabled theme colors defined by `ThemeData` (`disabledBackgroundColor`, `disabledForegroundColor`).
3. Screen readers register the element as non-interactive.

---

### Q3: What is the difference between `ElevatedButton.styleFrom()` and creating a raw `ButtonStyle` using `WidgetStateProperty`?
**Answer:**
- **`ElevatedButton.styleFrom()`** is a convenient factory helper that takes direct values (like `Colors.blue` or `EdgeInsets.all(12)`) and internally wraps them into `WidgetStateProperty` mappings for standard button states.
- **Raw `ButtonStyle`** allows fine-grained control over specific widget states (pressed, hovered, focused, disabled, dragged) using `WidgetStateProperty.resolveWith()`:

```dart
ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
    if (states.contains(WidgetState.disabled)) return Colors.grey;
    if (states.contains(WidgetState.pressed)) return Colors.indigo;
    return Colors.blue;
  }),
)
```

---

### Q4: How do you create a custom button with a gradient background and ripple animation?
**Answer:**
Since standard Material buttons do not directly accept a `Gradient` in `ButtonStyle`, you wrap a `DecoratedBox` or `Container` with `Material` and `InkWell`:

```dart
Container(
  decoration: BoxDecoration(
    gradient: const LinearGradient(colors: [Colors.orange, Colors.red]),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {},
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Text('Gradient Button', style: TextStyle(color: Colors.white)),
      ),
    ),
  ),
)
```
*Note:* `Material(color: Colors.transparent)` is mandatory so that the `InkWell` splash animation renders above the gradient container.

---

### Q5: How can you prevent rapid double-tapping on a button (Debouncing)?
**Answer:**
Rapid double-tapping can trigger duplicate API calls or navigation pushes. Common approaches to prevent it include:

1. **State-based disabling**: Setting a `_isLoading = true` flag upon tap and rebuilding with `onPressed: _isLoading ? null : _handleTap`.
2. **Debouncer / Timer utility**: Using a custom `Debouncer` class to ignore taps occurring within a short window (e.g. 500ms).

```dart
bool _isProcessing = false;

void _handlePress() async {
  if (_isProcessing) return;
  setState(() => _isProcessing = true);
  
  await performAsyncWork();
  
  if (mounted) setState(() => _isProcessing = false);
}
```

---

### Q6: What is `FloatingActionButton` (FAB) and where should it be placed in a `Scaffold`?
**Answer:**
A `FloatingActionButton` represents the primary single action for a screen (e.g. "Create Email", "Add Contact"). It is passed into `Scaffold.floatingActionButton` and can be anchored using `Scaffold.floatingActionButtonLocation` (e.g. `centerDocked`, `endFloat`).
