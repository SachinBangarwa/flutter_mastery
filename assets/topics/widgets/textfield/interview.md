# TextField Widget Interview Q&A

### Q1: What is the difference between TextField and TextFormField?
**Answer:**
- `TextField` is a basic, standalone input field widget.
- `TextFormField` is a helper widget that wraps a `TextField` but integrates directly with a `Form` ancestor widget. It has built-in support for validation (`validator` callback) and automatically displays error text below the input field if the validation fails.

---

### Q2: How can you capture live changes in a TextField?
**Answer:**
There are two common ways:
1. Pass an `onChanged` callback function to the `TextField`. It is triggered on every keystroke and receives the current string value.
2. Bind a `TextEditingController` to the `TextField` and attach a listener to it via `controller.addListener()`.

---

### Q3: Why is it important to dispose of a TextEditingController?
**Answer:**
A `TextEditingController` allocates internal memory listeners to monitor text changes. If you do not call `controller.dispose()` in the state's `dispose()` method when the screen is destroyed, it can cause **memory leaks**, slowing down or crashing the application over time.
