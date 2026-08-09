# Introduction

Buttons are fundamental interactive widgets in Flutter that allow users to trigger actions, submit forms, navigate between screens, or alter app states with a single tap or long press. Flutter provides a rich set of Material Design 3 button widgets out of the box, as well as Cupertino (iOS style) buttons and custom button construction capabilities.

The core Flutter Material buttons include:
- **`ElevatedButton`**: A filled button with subtle elevation and shadow, suitable for primary call-to-action (CTA) buttons.
- **`TextButton`**: A flat button without borders or background color by default, ideal for secondary/tertiary actions or dialog buttons.
- **`OutlinedButton`**: A button with a visible border outline and transparent background, great for medium-emphasis actions.
- **`IconButton`**: A compact circular icon button commonly used in app bars, toolbars, and card headers.
- **`FloatingActionButton` (FAB)**: A floating circular button representing the primary action on a screen.

---

# Why use it

1. **User Interaction**: Provides clear visual affordance indicating that an element can be tapped.
2. **Built-in State Management**: Handles hover, focus, press, and disabled visual states automatically using Material Design guidelines.
3. **Accessibility**: Integrated with screen readers (Semantics), keyboard navigation, and tap target sizing standards.
4. **Design Consistency**: Supports central theme customization through `ThemeData` (`elevatedButtonTheme`, `textButtonTheme`, etc.), making global styling effortless.

---

# Properties

Here are the key properties shared across most Flutter buttons:

| Property | Type | Description |
| :--- | :--- | :--- |
| `onPressed` | `VoidCallback?` | Called when the button is tapped. Set to `null` to disable the button. |
| `onLongPress` | `VoidCallback?` | Called when the button is long-pressed. |
| `style` | `ButtonStyle?` | Customizes colors, padding, shape, elevation, and state-dependent properties. |
| `child` | `Widget` | The content inside the button (usually a `Text` or `Row` widget). |
| `icon` | `Widget` | Used in `.icon` constructors (e.g. `ElevatedButton.icon`). |
| `label` | `Widget` | Used alongside `icon` in `.icon` constructors. |

### Understanding `ButtonStyle`

Flutter buttons use `ButtonStyle` for advanced customization, frequently configured using `WidgetStateProperty` (formerly `MaterialStateProperty`):

- **`backgroundColor`**: Controls background color.
- **`foregroundColor`**: Controls text/icon color.
- **`padding`**: Inner spacing inside the button.
- **`shape`**: Defines border shapes like `RoundedRectangleBorder`, `StadiumBorder`, or `BeveledRectangleBorder`.
- **`elevation`**: Shadow height above the surface.

---

# Examples

### 1. Basic ElevatedButton
```dart
ElevatedButton(
  onPressed: () {
    print('Button Pressed!');
  },
  child: const Text('Submit Order'),
)
```

### 2. Custom Styled OutlinedButton with Icon
```dart
OutlinedButton.icon(
  onPressed: () {},
  icon: const Icon(Icons.download),
  label: const Text('Download Invoice'),
  style: OutlinedButton.styleFrom(
    foregroundColor: Colors.deepPurple,
    side: const BorderSide(color: Colors.deepPurple, width: 2),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)
```

### 3. Disabled State Handling
```dart
ElevatedButton(
  onPressed: isLoading ? null : () => handleSubmit(),
  child: isLoading 
      ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        )
      : const Text('Save Changes'),
)
```

### 4. Custom Gradient Button using InkWell
```dart
Container(
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [Colors.blue, Colors.purple],
    ),
    borderRadius: BorderRadius.circular(30),
  ),
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        print('Gradient Tap');
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        child: Text(
          'Get Started',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  ),
)
```

---

# Best Practices

1. **Hierarchy & Intent**: Use only **one** primary `ElevatedButton` per screen area to direct user focus. Use `OutlinedButton` for secondary choices and `TextButton` for subtle actions (e.g. Cancel).
2. **Tap Target Size**: Ensure buttons have a minimum tap area of **48x48 logical pixels** for mobile usability.
3. **Use `.styleFrom()`**: Prefer `ElevatedButton.styleFrom()` or `TextButton.styleFrom()` over raw `ButtonStyle` for simpler, cleaner code.
4. **Handle Loading States**: Always disable `onPressed` (pass `null`) while an async task or API call is in progress to prevent duplicate submissions.
5. **Theme Globals**: Define button themes in `ThemeData` rather than duplicating styles across individual screens.

---

# Common Mistakes

1. **Passing empty callback `() {}` instead of `null` when disabling**:
   - *Wrong*: `ElevatedButton(onPressed: isDisabled ? () {} : handleTap, ...)` -> Button appears active even when non-functional.
   - *Correct*: `ElevatedButton(onPressed: isDisabled ? null : handleTap, ...)` -> Automatically applies disabled styling.

2. **Overflowing Button Text**: Placing long text strings inside buttons without flexible layouts or max lines.
3. **Forgetting InkWell's Material Ancestor**: Placing `InkWell` directly inside a decorated `Container` without a translucent `Material` widget disables touch ripple effects.
4. **Hardcoding Fixed Heights without Constraints**: Setting explicit small heights which clips button text on device font scaling.

---

# Summary

Flutter provides flexible, theme-driven buttons for every UI scenario:
- `ElevatedButton` for high emphasis.
- `OutlinedButton` for medium emphasis.
- `TextButton` for low emphasis.
- `IconButton` and `FloatingActionButton` for quick actions.
- Custom `InkWell` + `Material` for bespoke designs like gradients.

Understanding `onPressed: null` for disabled state and using `.styleFrom()` will enable you to create clean, responsive, production-ready interfaces.
