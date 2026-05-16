import 'package:flutter/material.dart';
import 'field_type.dart';
import 'dropdown_option.dart';
import 'conditional.dart';
import 'field_decoration_override.dart';

/// Configuration for an individual form field.
class DynamicField {
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

  /// Custom validation callback, similar to TextFormField's validator.
  final String? Function(dynamic)? validator;

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

  /// A simpler way to define conditional visibility based on key-value pairs.
  final Map<String, dynamic>? visibleIf;

  /// Extra custom data associated with the field.
  final Map<String, dynamic>? extra;

  /// Custom data to pass extra parameters without modifying core logic.
  final Map<String, dynamic>? customData;

  /// Custom properties to override the `InputDecoration` for this specific field.
  final FieldDecorationOverride? decorationOverride;

  /// Custom input decoration to override the default theme or decorationProps.
  final InputDecoration? decoration;

  /// Custom text style for the field input text.
  final TextStyle? style;

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

  /// Creates a new [DynamicField] instance.
  const DynamicField({
    required this.key,
    required this.type,
    this.label,
    this.hint,
    this.validation,
    this.validator,
    this.initialValue,
    this.enabled = true,
    this.obscured = false,
    this.options,
    this.conditional,
    this.visibleIf,
    this.extra,
    this.customData,
    this.decorationOverride,
    this.decoration,
    this.style,
    this.prefix,
    this.suffix,
    this.activeColor,
    this.activeThumbColor,
    this.checkColor,
    this.inactiveTrackColor,
    this.inactiveThumbColor,
  });

  /// Creates a [DynamicField] instance from a JSON map.
  factory DynamicField.fromJson(Map<String, dynamic> json) {
    return DynamicField(
      key: (json['key'] ?? json['id']) as String,
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
      visibleIf: json['visibleIf'] as Map<String, dynamic>?,
      extra: json['extra'] as Map<String, dynamic>?,
      customData: json['customData'] as Map<String, dynamic>?,
      decorationOverride: json['decorationOverride'] != null
          ? FieldDecorationOverride.fromJson(
              json['decorationOverride'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Converts this [DynamicField] instance to a JSON map.
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
        if (visibleIf != null) 'visibleIf': visibleIf,
        if (extra != null) 'extra': extra,
        if (customData != null) 'customData': customData,
        if (decorationOverride != null) 'decorationOverride': decorationOverride!.toJson(),
      };
}
