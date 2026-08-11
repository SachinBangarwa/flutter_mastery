# Introduction to TextField Widget

The `TextField` widget in Flutter is the primary input control that allows users to type text using a hardware or virtual on-screen keyboard. It is essential for login forms, search queries, messaging inputs, and profile edits.

---

# Why use it?
- **Capturing User Inputs**: Core interface element to capture text, numbers, emails, passwords, etc.
- **Custom Borders & Labels**: Integrates with `InputDecoration` to display standard Material Design outlines, labels, icons, and error text messages.
- **Interactive State hooks**: Support listening to live text changes via controllers or `onChanged` callbacks.

---

# Key Properties

### 1. `controller`
Accepts a `TextEditingController` which allows you to programmatically:
- Read the text currently typed in the input field.
- Clear the text.
- Set/change the text dynamically (e.g. autofill).

### 2. `decoration`
Takes an `InputDecoration` object to customize the visual boundary:
- `hintText`: Placeholder text shown when input is empty.
- `labelText`: Floats above the input field when active.
- `prefixIcon` / `suffixIcon`: Icons shown at the start or end of the input field.
- `border` / `enabledBorder` / `focusedBorder`: Custom outline boxes for different active states.

### 3. `obscureText`
A boolean determining whether to mask input text with dots/stars. Set to `true` for password inputs.

### 4. `keyboardType`
Accepts `TextInputType` to display specialized virtual keyboards:
- `TextInputType.number` (numbers only)
- `TextInputType.emailAddress` (includes '@' and '.com' key)
- `TextInputType.phone` (numerical keypad with '+')
