/// The types of fields supported by the dynamic form builder.
enum FieldType {
  /// A standard text input field.
  text,

  /// A numeric input field.
  number,

  /// An email input field with email validation and keyboard type.
  email,

  /// A password input field with visibility toggle.
  password,

  /// A multi-line text input field.
  multiline,

  /// A dropdown selection field.
  dropdown,

  /// A checkbox field.
  checkbox,

  /// A toggle switch field.
  switch_,

  /// A date picker field.
  date,

  /// A time picker field.
  time,

  /// A custom field type that can be handled by a custom builder.
  custom,

  /// A radio button selection field.
  radio,

  /// A slider field for numeric values.
  slider,

  /// A file or image picker field.
  file,

  /// A phone number input field.
  phone,

  /// A dropdown that allows multiple selections.
  multiSelect,

  /// A logical grouping of multiple fields.
  group,
}
