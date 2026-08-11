# Container Assignment: Premium Info Card

### Objective
Build a beautiful, interactive **Product Promo Card** using a single decorated `Container` as the main wrapper, styled with a shadow, borders, rounded corners, padding, and alignment.

---

### Specifications

1. **Card Container**:
   - Width: `300`
   - Height: `180`
   - Background Color: Dark slate/surface color (`0xFF1E293B`)
   - Border Radius: `16` (rounded corners)
   - Border: A thin silver border (`0xFFE2E8F0`) with a width of `1.0`
   - Padding: `16.0` on all sides
   - Margin: `20.0` to separate it from other layout items
   - Box Shadow: Add a subtle glow/drop shadow with a blur radius of `12`, color black with `0.4` opacity, offset `(0, 6)`.

2. **Content Layout (Child)**:
   - Use a `Column` inside the Container.
   - Display a "Pro" badge at the top right.
   - Display a Course Title (e.g., `"Flutter Advanced UI Masterclass"`) with a bold white text style.
   - Display a subtitle/description text (e.g., `"Master animations, custom paint, and dynamic layouts"`).
   - Display an author row at the bottom.

---

### Bonus Challenge
Implement a **linear gradient border** or a **transform rotation** (e.g., tilt the card slightly by 2 degrees using `Matrix4.rotationZ` inside the `transform` property) to make it look extremely premium!
