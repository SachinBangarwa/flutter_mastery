# Introduction to Icon Widget

The `Icon` widget in Flutter is used to render a graphical vector symbol on the screen. It displays glyphs from a specific icon font (most commonly the standard Material Design `Icons` library).

---

# Why use it?
- **Scalability**: Unlike raster images, icons are vector graphics, meaning they scale perfectly to any size/resolution without becoming blurry.
- **Material Theme Integration**: Icons easily integrate with the default application themes and adjust their colors automatically.
- **Accessibility**: Using `semanticLabel` enables talkback/voiceover accessibility support.

---

# Key Properties

### 1. `icon`
Accepts `IconData` indicating the font glyph to display. The default class is `Icons`, which exposes thousands of predefined Material Design shapes (like `Icons.search`, `Icons.home`, etc.).

### 2. `size`
The width and height of the icon in logical pixels. By default, it takes the value defined in `IconTheme` (typically `24.0`).

### 3. `color`
The color used to fill the icon vector. If null, the icon defaults to the color specified in the nearest `IconTheme` or the primary theme palette.

### 4. `semanticLabel`
A descriptive string for screen readers. Helpful for making interactive icons accessible to visually impaired users.
