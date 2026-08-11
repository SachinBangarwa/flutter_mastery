# Introduction to Card Widget

A `Card` is a Material Design component in Flutter that represents a sheet of Material with rounded corners and a shadow (elevation). It is typically used to group related information together, such as product listings, user profiles, or dashboard stats.

---

# Why use it?
- **Visual Depth**: Automatically adds a drop shadow using elevation, making elements look raised.
- **Material Standard**: Adheres to Material Design guidelines for margins, padding, and corner rounding.
- **Logical Grouping**: Perfect container for containing structured widgets like `ListTile`, `Column`, `Row`, or buttons.

---

# Key Properties

### 1. `elevation`
Controls the size of the shadow beneath the card. A higher value creates a larger, more diffused shadow, giving the impression that the card is elevated higher off the screen.

### 2. `shape`
Accepts a `ShapeBorder` to customize card corners and borders:
- `RoundedRectangleBorder`: Configures standard corner rounding (`borderRadius`) and outline borders (`side`).
- `BeveledRectangleBorder`: Creates cut, angular corners.

### 3. `color`
Specifies the background color of the card. If null, the theme's card color is used.

### 4. `shadowColor`
Changes the color of the drop shadow. By default, it is black, but it can be styled (e.g. translucent blue for a glowing effect).

### 5. `clipBehavior`
Determines how the content inside the card is clipped if it overflows the rounded corners:
- `Clip.none`: No clipping (fastest).
- `Clip.antiAlias`: Smoothly clip elements to fit the card shape.

---

# Best Practices
- **Do not nest scrollables**: Cards are static containers. Do not put scrolling views like list views inside cards without specifying height bounds.
- **Card Padding**: Cards do not have padding by default. Always wrap the card's child in a `Padding` widget to prevent text from touching the card edges.
