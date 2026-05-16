# dynamic_field_builder

[![pub package](https://img.shields.io/pub/v/dynamic_field_builder.svg)](https://pub.dev/packages/dynamic_field_builder)

**Build beautiful, reactive Flutter forms from a Dart map or JSON config — with zero boilerplate and full UI control.**

- 🔁 **Server‑driven UI ready** – define your entire form as JSON and ship it over the wire.
- 🎯 **Reactive & performant** – single controller holds all state, streams values and errors.
- 🎨 **100% customizable** – replace any internal widget, theme globally or per field.
- ✅ **Powerful validation** – declarative rules + custom async validators.
- 🧩 **Conditional visibility** – show/hide fields based on other fields’ values.
- ⚡ **Batteries included** – text, number, email, password (with toggle), multiline, dropdown, checkbox, switch, date, time, plus custom types.

---

## 📸 Preview

![Hero](https://github.com/firadfd/dynamic_form_builder/raw/main/assets/images/hero.gif)

*The Power of Dynamic Forms: From simple inputs to complex, themed interfaces.*

*Fully customizable UI: One codebase, limitless designs.*

---

## 🚀 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  dynamic_field_builder: ^2.0.0
```

Then run `flutter pub get`.

---

## 🏁 Quick start

```dart
import 'package:dynamic_field_builder/dynamic_field_builder.dart';

final config = [
  DynamicField(
    key: 'name', 
    type: FieldType.text, 
    label: 'Full Name',
    prefix: Icon(Icons.person),
    validation: {'required': true}
  ),
  DynamicField(
    key: 'password', 
    type: FieldType.password, 
    label: 'Password',
    prefix: Icon(Icons.lock),
  ),
  DynamicField(
    key: 'country', 
    type: FieldType.dropdown, 
    label: 'Country',
    options: [
      DropdownOption(value: 'us', label: 'United States'),
      DropdownOption(value: 'ca', label: 'Canada'),
    ]
  ),
];

DynamicForm(
  config: config,
  onSubmit: (values) => print(values),
)
```

---

## 💻 Real-world Example: Login Form

```dart
import 'package:dynamic_field_builder/dynamic_field_builder.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final controller = DynamicFormController();

  final config = [
    DynamicField(
      key: 'email',
      type: FieldType.email,
      label: 'Email Address',
      prefix: const Icon(Icons.email_outlined),
      validation: {'required': true},
      validator: (val) {
        if (val == null || !val.toString().contains('@')) return 'Invalid email format';
        return null;
      },
    ),
    DynamicField(
      key: 'password',
      type: FieldType.password,
      label: 'Password',
      prefix: const Icon(Icons.lock_outline),
      validation: {'required': true, 'minLength': 6},
    ),
    DynamicField(
      key: 'remember_me',
      type: FieldType.checkbox,
      label: 'Remember me',
      initialValue: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome Back', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            DynamicForm(
              config: config,
              controller: controller,
              submitButtonBuilder: (onSubmit) => ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: const Text('Login'),
              ),
              onSubmit: (values) {
                print('Login with: ${values["email"]} / ${values["password"]}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## ✨ Features deep‑dive

### 1. Declarative field config (`DynamicField`)

| Property          | Description                                                        |
|-------------------|--------------------------------------------------------------------|
| `key`             | Unique field identifier                                            |
| `type`            | One of `FieldType` (text, email, password, number, group, multiSelect, ...) |
| `label` / `hint`  | Display text                                                       |
| `validation`      | Built‑in rules (`required`, `minLength`, `regex`, …)               |
| `validator`       | Custom validation callback, similar to `TextFormField`             |
| `prefix` / `suffix`| Custom **Widgets** (Icons, Images, etc.) for the field             |
| `activeColor`     | Custom color for Checkbox when active                             |
| `activeThumbColor`| Custom color for Switch thumb when active                        |
| `checkColor`      | Custom color for Checkbox tick                                     |
| `options`         | For `dropdown`, `radio`, or `multiSelect` fields                                              |
| `conditional`     | Show/hide based on other field value (complex)                     |
| `visibleIf`       | Show/hide based on other field value (simple map)                  |
| `readOnly`        | Makes the field read-only                                          |
| `onChanged`       | Callback triggered when the field value changes                    |
| `autofillHints`   | Autofill hints for the OS keyboard                                 |
| `fields`          | Nested fields, used when `type` is `FieldType.group`               |
| `decorationOverride` | Override `InputDecoration` using type-safe `FieldDecorationOverride`|
| `decoration`      | Custom `InputDecoration` parameter                                 |
| `style`           | Custom `TextStyle` parameter                                       |
| `customData`      | Additional Map to pass extra parameters (e.g. slider min/max)      |

### 2. Password Visibility Toggle
The `password` field type now comes with a built-in visibility toggle. It automatically adds a suffix icon that allows users to show or hide their password.

### 3. Prefix & Suffix Widgets
Unlike other libraries that only allow `IconData`, we allow any `Widget`.
```dart
DynamicField(
  key: 'profile',
  type: FieldType.text,
  prefix: CircleAvatar(backgroundImage: AssetImage('assets/user.png')),
  suffix: TextButton(onPressed: () {}, child: Text('Verify')),
)
```

### 4. Custom Submit Button
Don't like the default button? Provide your own:
```dart
DynamicForm(
  config: config,
  submitButtonBuilder: (onSubmit) => MyCustomButton(
    onTap: onSubmit,
    title: 'SIGN UP',
  ),
  onSubmit: (values) => save(values),
)
```

### 5. Validation that grows with you
```dart
DynamicField(
  key: 'password',
  type: FieldType.password,
  validation: {
    'required': true,
    'minLength': 8,
    'regex': r'^(?=.*[A-Z])(?=.*\d).+$',
  },
)
```

### 6. Conditional visibility
Show a field only when another field meets a condition:
```dart
DynamicField(
  key: 'other_pet',
  type: FieldType.text,
  label: 'Which pet?',
  conditional: Conditional(
    dependsOnKey: 'has_pet',
    equals: [true],
  ),
),
```

### 7. Complete UI theming
**Global theme via `DynamicFormTheme`**:
```dart
DynamicForm(
  config: config,
  theme: DynamicFormTheme(
    inputDecoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    fieldPadding: const EdgeInsets.only(bottom: 20),
  ),
)
```

**Per-field overrides**:
```dart
DynamicField(
  key: 'email',
  type: FieldType.email,
  decorationOverride: FieldDecorationOverride(
    filled: true,
    fillColor: Colors.blue.withValues(alpha: 0.1),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
  ),
)
```

### 8. Using `customData` for Advanced Components
Pass arbitrary properties to complex fields like `slider` or `file` via `customData`:
```dart
DynamicField(
  key: 'rating',
  type: FieldType.slider,
  label: 'Rate your experience',
  initialValue: 5.0,
  customData: {
    'min': 0.0,
    'max': 10.0,
    'divisions': 10,
  },
),
DynamicField(
  key: 'avatar',
  type: FieldType.file,
  label: 'Profile Picture',
  customData: {
    'onFilePick': () async {
      // Trigger your actual file picker logic here
      return 'user_avatar.png';
    }
  },
)
```

### 9. Reactive `DynamicFormController` & Form Lifecycle
Grab the controller to read values, reset the form, or trigger validation programmatically:
```dart
final controller = DynamicFormController();

// Listen to the live form value stream!
controller.valueStream.listen((Map<String, dynamic> values) {
  print('Form updated: $values');
});

// Validate whole form
if (controller.validate()) {
  print(controller.formData); 
}

// Or use the submit method which validates and returns the data:
final data = controller.submit();
if (data != null) {
  // save to DB
}

// Reset the form to its initial state
controller.reset();
```

### 10. Pre-populating Forms (`initialValues`)
If you're building an edit form, pass `initialValues` directly to the `DynamicForm` widget to pre-fill the fields.
```dart
DynamicForm(
  config: config,
  initialValues: {
    'name': 'John Doe',
    'country': 'us',
  },
)
```

### 11. Multi-Step Forms (Stepper)
Break down complex forms into a native `Stepper` seamlessly:
```dart
final steps = [
  DynamicStep(
    title: 'Personal Info',
    fields: [
      DynamicField(key: 'name', type: FieldType.text, label: 'Name'),
    ],
  ),
  DynamicStep(
    title: 'Account Details',
    fields: [
      DynamicField(key: 'email', type: FieldType.email, label: 'Email'),
    ],
  ),
];

DynamicStepperForm(
  steps: steps,
  onSubmit: (values) => print('All steps complete: $values'),
)
```

### 12. JSON Serialization
Fetch JSON directly from your API and render forms without writing any mapping code:
```dart
final jsonFromServer = [
  {"id": "username", "type": "text", "label": "Username"},
  {"id": "password", "type": "password", "label": "Password"}
];

final fields = jsonFromServer.map((e) => DynamicField.fromJson(e)).toList();

DynamicFieldBuilder( // (Alias for DynamicForm)
  config: fields,
)
```

---

## 📚 Full API reference
- **`DynamicForm`** (or **`DynamicFieldBuilder`**) – The main widget (supports `initialValues`).
- **`DynamicStepperForm`** – The multi-step form widget.
- **`DynamicFormController`** – State & validation (with `valueStream`).
- **`DynamicFormTheme`** – Global appearance.
- **`DynamicField`** / **`DynamicStep`** / **`FieldType`** / **`Conditional`** / **`DropdownOption`** – Data models.

---

## 🤝 Contributing
PRs welcome! Feel free to open issues or propose enhancements.

> **Disclaimer**: This package has no community yet — no issues filed, no PRs, no Stack Overflow presence — you're on your own if you hit a bug. We highly appreciate early adopters who report issues!

---

## 📄 License
MIT – see [LICENSE](LICENSE) file.