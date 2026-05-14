## 1.4.0
- Added `DynamicStepperForm` for out-of-the-box multi-step form capabilities.
- Added `DynamicStep` model for logically grouping fields into a stepper.
- Included `DynamicFieldBuilder` typedef alias for API consistency and flexibility.
- Expanded JSON Serialization documentation showcasing the pre-existing `fromJson` power.
- Enhanced `fromJson` on `DynamicField` to intelligently parse `id` as an alias for `key`.

## 1.3.0
- Expose `submit()` and `reset()` methods on `DynamicFormController` for complete form lifecycle management.
- Added `visibleIf` property for intuitive, map-based conditional visibility.
- Expanded `README.md` to highlight "Theme-First" architecture and elite-tier capabilities.

## 1.2.0
- Renamed `FieldConfig` to `DynamicField` for intuitive modeling.
- Added explicit documentation for `key`, `type`, and `label` mapping.
- Added `decoration` and `style` parameters to `DynamicField` for enhanced styling flexibility.
- Introduced `validator` callback for advanced form validation.
- Added `customData` field to effortlessly pass custom parameters.
- Updated `README.md` with a comprehensive real-world Login Form snippet.

## 1.1.0
- Updated to latest Flutter APIs (resolved deprecation warnings for `activeColor` and `withOpacity`).
- Added `activeThumbColor` to `FieldConfig` for enhanced `Switch` customization.
- Comprehensive Dartdoc documentation for the entire public API (improved coverage to 100%).
- Improved code quality and resolved linting issues.

## 1.0.0
- Initial stable release.
- Added full UI customization for all field types.
- Support for `Widget` based prefix and suffix (Icons, Images, etc.).
- Built-in password visibility toggle.
- Added `submitButtonBuilder` for custom form submission buttons.
- Enhanced styling for Switch and Checkbox (custom colors).
- Improved `DynamicFormTheme` with granular decoration overrides.

