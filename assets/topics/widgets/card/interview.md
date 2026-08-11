# Card Widget Interview Q&A

### Q1: Does the Card widget have margin or padding by default?
**Answer:**
- A `Card` widget has a small default **margin** (usually 4.0 logical pixels on all sides) to separate it from surrounding widgets.
- However, a `Card` has **no padding** by default. Any child widget (like a Column or Text) will touch the edges of the card unless you explicitly wrap the child in a `Padding` widget.

---

### Q2: How can we customize the border and corner shape of a Card?
**Answer:**
You can use the `shape` property and pass a `RoundedRectangleBorder`:
```dart
Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
    side: BorderSide(color: Colors.red, width: 2.0),
  ),
  child: ...
)
```

---

### Q3: Why is my content (like an image) overflowing the rounded corners of the Card? How do we fix it?
**Answer:**
By default, the `clipBehavior` of a `Card` is set to `Clip.none`, meaning child widgets can paint outside the card bounds. 
To fix this and force child widgets (like a header image) to be clipped within the card's rounded corners, set `clipBehavior: Clip.antiAlias`.
