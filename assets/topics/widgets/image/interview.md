# Image Widget Interview Q&A

### Q1: What are the different ways to instantiate the Image widget in Flutter?
**Answer:**
There are four primary factory constructors:
1. `Image.asset()`: Loads an image registered in `pubspec.yaml` assets.
2. `Image.network()`: Loads an image asynchronously from a web URL.
3. `Image.file()`: Loads an image from a local file directory path (useful for camera uploads).
4. `Image.memory()`: Renders raw bytes (`Uint8List`) as an image (useful for dynamic image generation).

---

### Q2: What is the purpose of image caching in Flutter?
**Answer:**
Flutter has a built-in `ImageCache` system (managed by `PaintingBinding.instance.imageCache`). When an image is resolved (e.g. from network or assets), it is stored in memory. If the same image URL/asset is loaded elsewhere in the app, it displays instantly without re-downloading or re-decoding, saving bandwidth and CPU cycles.

---

### Q3: How do we show a circular image in Flutter?
**Answer:**
There are two common ways:
1. Wrap the `Image` widget inside a `ClipRRect` widget and apply `borderRadius`:
   ```dart
   ClipRRect(
     borderRadius: BorderRadius.circular(100),
     child: Image.network(...),
   )
   ```
2. Use the `CircleAvatar` widget and pass the image provider to its `backgroundImage` property:
   ```dart
   CircleAvatar(
     backgroundImage: NetworkImage(...),
     radius: 50,
   )
   ```
