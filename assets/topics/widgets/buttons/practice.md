# Practice

Build these 4 hands-on exercises in your Flutter codebase to test your button implementation skills!

---

## Exercise 1: Button Hierarchy Screen
Create a single column containing the three core Material buttons with identical labels to see their visual contrast:
1. Primary `ElevatedButton` for "Confirm Purchase".
2. Secondary `OutlinedButton` for "Apply Coupon".
3. Tertiary `TextButton` for "Cancel Order".

**Requirements:**
- Give all buttons a uniform width using `SizedBox` or `ConstrainedBox`.
- Print a custom message in the console when each button is pressed.

---

## Exercise 2: Async Loading Button
Build a stateful widget button that simulates an API request:
- Initial State: Shows an `ElevatedButton.icon` with a `Save` icon and text `'Save Profile'`.
- On Tap:
  - Changes state to loading (`onPressed` becomes `null`).
  - Displays a small `CircularProgressIndicator` inside the button instead of the icon.
  - Waits for a `Future.delayed(const Duration(seconds: 2))`.
  - Reverts back to normal state and displays a `SnackBar` saying `"Profile Saved Successfully!"`.

---

## Exercise 3: Custom Glassmorphic / Gradient Action Button
Create a custom pill-shaped button using `Container`, `BoxDecoration`, `Material`, and `InkWell`:
- Background: Linear Gradient from `Colors.teal` to `Colors.blue`.
- Rounded corners (`BorderRadius.circular(30)`).
- Add a subtle shadow using `BoxShadow`.
- Ensure touch ripple animation works without clipping the gradient background.

---

## Exercise 4: Custom Toggle Like Button with Counter
Create an interactive `IconButton` that tracks a favorite count:
- Has an `isLiked` boolean state and a `likeCount` integer state.
- Icon displays `Icons.favorite_border` (grey) when unliked and `Icons.favorite` (red) when liked.
- Displays the current count next to the icon.
- Tapping toggles the state and increments / decrements the count accordingly.
