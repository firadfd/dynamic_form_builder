/// Represents an option in a dropdown selection field.
class DropdownOption {
  /// The underlying value of the option.
  final String value;

  /// The human-readable label displayed for the option.
  final String label;

  /// Creates a new [DropdownOption] instance.
  const DropdownOption({
    required this.value,
    required this.label,
  });

  /// Creates a [DropdownOption] instance from a JSON map.
  static DropdownOption fromJson(Map<String, dynamic> json) => DropdownOption(
        value: json['value'] as String,
        label: json['label'] as String,
      );

  /// Converts this [DropdownOption] instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'value': value,
        'label': label,
      };
}
