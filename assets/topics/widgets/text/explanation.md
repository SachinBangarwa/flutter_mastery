# Introduction to Text Widget

In Flutter, the `Text` widget is one of the most basic yet essential widgets used to display a single style of text on the screen. The string can span multiple lines or be limited by styling constraints.

---

# Why use it?
- **Readability**: Used to convey core information to users (titles, body text, buttons).
- **Styling**: Through the `TextStyle` class, you can fully control fonts, colors, backgrounds, borders, spacing, and decorators.
- **Auto-wrap and clipping**: Supports advanced text layout behaviors like overflow truncation, ellipsis, soft wrapping, and maximum lines.

---

# Key Properties

### 1. `style`
Accepts a `TextStyle` class to customize the visual appearance:
- `fontSize`: The size of glyphs (in logical pixels).
- `fontWeight`: Boldness level (e.g., `FontWeight.w700` or `FontWeight.bold`).
- `color`: The color of the text.
- `letterSpacing`: Horizontal spacing between letters.
- `wordSpacing`: Horizontal spacing between words.
- `shadows`: A list of `Shadow` objects to draw shadows behind the text.

### 2. `textAlign`
Controls how text is aligned horizontally:
- `TextAlign.left` / `TextAlign.right`
- `TextAlign.center`
- `TextAlign.justify` (stretches lines to fill constraints)

### 3. `overflow`
Specifies how visual overflow is handled when text exceeds constraints:
- `TextOverflow.clip`: Simply truncates the text at the edge.
- `TextOverflow.fade`: Fades the last line to transparent.
- `TextOverflow.ellipsis`: Adds three dots (`...`) to denote cut-off content.

### 4. `maxLines`
An integer limiting the maximum number of lines allowed before truncation.

---

# Best Practices
- **Use Google Fonts**: Instead of default system fonts, use the `google_fonts` package to import custom web fonts.
- **RichText for Mixed Styles**: If you need to style words within a single paragraph differently (e.g., bolding just one word), use `RichText` with `TextSpan` instead of nesting multiple `Text` widgets.
