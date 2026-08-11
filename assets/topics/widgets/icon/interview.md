# Icon Widget Interview Q&A

### Q1: How does Flutter render the Icon widget internally?
**Answer:**
Flutter renders icons using **Icon Fonts** (specifically MaterialIcons). An icon is represented by an `IconData` object containing a hexadecimal code point (e.g. `0xe25b` for a heart) inside that font. 
Flutter simply draws that specific character glyph from the font file on screen. This is highly efficient compared to loading png/jpg images.

---

### Q2: What is the difference between Icon and IconButton?
**Answer:**
- `Icon` is a static visual representation of a vector symbol. It does not handle tap/click inputs by default.
- `IconButton` wraps an `Icon` widget inside an interactive Material button that has `onPressed` callbacks, splash effects, and margins for touch target size.

---

### Q3: How do we render custom icons that are not in the Material Icons library?
**Answer:**
1. Generate an icon font (e.g. using IcoMoon or FlutterIcon.com) which generates a `.ttf` file and a custom Dart class.
2. Put the `.ttf` font file inside assets and declare it in `pubspec.yaml` under `fonts`.
3. Use the generated custom class to reference `IconData` and pass it to the `Icon` widget just like standard icons.
