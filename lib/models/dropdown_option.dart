class DropdownOption {
  final String value;
  final String label;

  const DropdownOption({
    required this.value,
    required this.label,
  });

  static DropdownOption fromJson(Map<String, dynamic> json) => DropdownOption(
        value: json['value'] as String,
        label: json['label'] as String,
      );

  Map<String, dynamic> toJson() => {
        'value': value,
        'label': label,
      };
}
