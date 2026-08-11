# Text Widget Interview Q&A

### Q1: What is the difference between Text and RichText widgets?
**Answer:**
- `Text` displays a single string of text with a single style constraint for the entire widget.
- `RichText` allows you to render paragraphs with mixed styling (e.g. bolding a single word in a sentence or attaching click listeners to a specific word) by nesting multiple `TextSpan` elements.

---

### Q2: How do you handle text overflowing its parent container?
**Answer:**
You can wrap the `Text` widget in a bounded container (like `SizedBox` or `Expanded`) and specify:
1. `maxLines`: Limits the line count.
2. `overflow`: Uses `TextOverflow.ellipsis` to show three dots `...` at the end of the text.
3. `softWrap`: Boolean determining whether the text should wrap at soft line breaks.

---

### Q3: How can we load custom fonts in a Text widget?
**Answer:**
1. Download the font file (e.g., `.ttf`, `.otf`) and put it inside an `assets/fonts/` directory.
2. Register the font family in `pubspec.yaml` under the `fonts` section:
   ```yaml
   flutter:
     fonts:
       - family: CustomFont
         fonts:
           - asset: assets/fonts/CustomFont-Regular.ttf
   ```
3. Set `fontFamily: 'CustomFont'` inside the `TextStyle` property of the `Text` widget. Alternatively, use the `google_fonts` package for dynamic Google Fonts.
