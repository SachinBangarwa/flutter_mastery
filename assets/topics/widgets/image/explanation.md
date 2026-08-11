# Introduction to Image Widget

The `Image` widget in Flutter is the core component used to render graphics/images from different providers. It can draw images packaged as assets, downloaded over the web, fetched from disk storage, or created dynamically in memory.

---

# Why use it?
- **Multiple Sources**: Offers helper constructors like `Image.asset()`, `Image.network()`, `Image.file()`, and `Image.memory()` to fit various app requirements.
- **Handling states**: Built-in support for showing loaders (`loadingBuilder`) and error fallbacks (`errorBuilder`) if the image fails to resolve.
- **Advanced fitting**: `BoxFit` property ensures images fill, stretch, scale, or clip dynamically inside layouts.

---

# Key Properties

### 1. `image`
Accepts an `ImageProvider` which is responsible for resolving the image pixels asynchronously.

### 2. `fit`
Determines how the image rectangle should fit inside its container bounds:
- `BoxFit.cover`: Scales the image as small as possible while still covering the entire area (crops excess parts).
- `BoxFit.contain`: Scales the image as large as possible to fit entirely inside the container without cropping (keeps aspect ratio).
- `BoxFit.fill`: Stretches the image to fill the bounds exactly (distorts aspect ratio).

### 3. `loadingBuilder`
A callback that is triggered repeatedly during web image load, allowing you to show loading spinners or progress bar percentages.

### 4. `errorBuilder`
A callback triggered if an error occurs during image fetching (e.g. 404 URL or offline state), allowing you to render a local fallback placeholder or error icon.
