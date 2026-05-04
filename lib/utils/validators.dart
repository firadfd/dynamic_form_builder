/// Signature for a custom validator function.
typedef CustomValidator = String? Function(dynamic value);

Map<String, CustomValidator> _customValidators = {};

/// Registers a custom validator function globally under a specific key.
void registerCustomValidator(String key, CustomValidator validator) {
  _customValidators[key] = validator;
}

/// The default validation logic for form fields.
///
/// Supports rules such as:
/// - `required`: boolean
/// - `minLength`: int
/// - `maxLength`: int
/// - `regex`: String pattern
/// - `numeric`: boolean
/// - `min`: num
/// - `max`: num
/// - `custom`: String (the key of a registered custom validator)
String? defaultValidator(Map<String, dynamic>? rules, dynamic value) {
  if (rules == null) return null;
  final str = value?.toString() ?? '';

  if (rules['required'] == true && str.trim().isEmpty) {
    return 'This field is required';
  }
  if (rules.containsKey('minLength')) {
    final min = rules['minLength'] as int;
    if (str.length < min) return 'Minimum $min characters';
  }
  if (rules.containsKey('maxLength')) {
    final max = rules['maxLength'] as int;
    if (str.length > max) return 'Maximum $max characters';
  }
  if (rules.containsKey('regex')) {
    final pattern = RegExp(rules['regex'] as String);
    if (!pattern.hasMatch(str)) return 'Invalid format';
  }
  if (rules.containsKey('custom')) {
    final customKey = rules['custom'] as String;
    final customFn = _customValidators[customKey];
    if (customFn != null) {
      return customFn(value);
    }
  }
  if (rules.containsKey('numeric') && rules['numeric'] == true) {
    if (double.tryParse(str) == null) return 'Must be a number';
  }
  if (rules.containsKey('min')) {
    final numMin = (rules['min'] as num).toDouble();
    final numVal = double.tryParse(str);
    if (numVal == null || numVal < numMin) return 'Minimum $numMin';
  }
  if (rules.containsKey('max')) {
    final numMax = (rules['max'] as num).toDouble();
    final numVal = double.tryParse(str);
    if (numVal == null || numVal > numMax) return 'Maximum $numMax';
  }
  return null;
}
