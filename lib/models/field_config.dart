import 'package:flutter/widgets.dart';
import 'field_type.dart';
import 'dropdown_option.dart';
import 'conditional.dart';

class FieldConfig {
  final String key;
  final FieldType type;
  final String? label;
  final String? hint;
  final Map<String, dynamic>? validation;
  final dynamic initialValue;
  final bool enabled;
  final bool obscured;
  final List<DropdownOption>? options;
  final Conditional? conditional;
  final Map<String, dynamic>? extra;
  final Map<String, dynamic>? decorationProps;
  final Widget? prefix;
  final Widget? suffix;
  final Color? activeColor;
  final Color? checkColor;
  final Color? inactiveTrackColor;
  final Color? inactiveThumbColor;

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
    this.checkColor,
    this.inactiveTrackColor,
    this.inactiveThumbColor,
  });

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
