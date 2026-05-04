import 'package:flutter/widgets.dart';
import 'field_type.dart';
import 'dropdown_option.dart';
import 'conditional.dart';

/// Configuration for an individual form field.
class FieldConfig {
  /// Unique identifier for the field, used as the key in the form data map.
  final String key;

  /// The type of the field (e.g., text, dropdown, checkbox).
  final FieldType type;

  /// The label displayed for the field.
  final String? label;

  /// The hint text displayed when the field is empty.
  final String? hint;

  /// Validation rules for the field (e.g., {'required': true, 'minLength': 5}).
  final Map<String, dynamic>? validation;

  /// Initial value for the field.
  final dynamic initialValue;

  /// Whether the field is enabled for user interaction.
  final bool enabled;

  /// Whether the input text should be obscured (e.g., for password fields).
  final bool obscured;

  /// List of options for fields that require selection (like dropdown).
  final List<DropdownOption>? options;

  /// Defines conditional visibility logic for this field.
  final Conditional? conditional;

  /// Extra custom data associated with the field.
  final Map<String, dynamic>? extra;

  /// Custom properties to override the `InputDecoration` for this specific field.
  final Map<String, dynamic>? decorationProps;

  /// Custom widget to display at the beginning of the field.
  final Widget? prefix;

  /// Custom widget to display at the end of the field.
  final Widget? suffix;

  /// The color to use when the checkbox or switch is active.
  final Color? activeColor;

  /// The color of the thumb when the switch is active.
  final Color? activeThumbColor;

  /// The color of the checkmark in a checkbox.
  final Color? checkColor;

  /// The color of the track when the switch is inactive.
  final Color? inactiveTrackColor;

  /// The color of the thumb when the switch is inactive.
  final Color? inactiveThumbColor;

  /// Creates a new [FieldConfig] instance.
  const FieldConfig({
    required this.key,
    required this.type,
    this.label,
    this.hint,
    this.validation,
    this.initialValue,
    this.enabled = true,
    this.obscured = false,
    this.options,
    this.conditional,
    this.extra,
    this.decorationProps,
    this.prefix,
    this.suffix,
    this.activeColor,
    this.activeThumbColor,
    this.checkColor,
    this.inactiveTrackColor,
    this.inactiveThumbColor,
  });

  /// Creates a [FieldConfig] instance from a JSON map.
  factory FieldConfig.fromJson(Map<String, dynamic> json) {
    return FieldConfig(
      key: json['key'] as String,
      type: FieldType.values.byName(json['type'] as String),
      label: json['label'] as String?,
      hint: json['hint'] as String?,
      validation: json['validation'] as Map<String, dynamic>?,
      initialValue: json['initialValue'],
      enabled: json['enabled'] as bool? ?? true,
      obscured: json['obscured'] as bool? ?? false,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => DropdownOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      conditional: json['conditional'] != null
          ? Conditional.fromJson(json['conditional'] as Map<String, dynamic>)
          : null,
      extra: json['extra'] as Map<String, dynamic>?,
      decorationProps: json['decorationProps'] as Map<String, dynamic>?,
    );
  }

  /// Converts this [FieldConfig] instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'key': key,
        'type': type.name,
        if (label != null) 'label': label,
        if (hint != null) 'hint': hint,
        if (validation != null) 'validation': validation,
        if (initialValue != null) 'initialValue': initialValue,
        'enabled': enabled,
        'obscured': obscured,
        if (options != null)
          'options': options!.map((o) => o.toJson()).toList(),
        if (conditional != null) 'conditional': conditional!.toJson(),
        if (extra != null) 'extra': extra,
        if (decorationProps != null) 'decorationProps': decorationProps,
      };
}
