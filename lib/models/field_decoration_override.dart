import 'package:flutter/material.dart';

/// Overrides for the [InputDecoration] of a specific [DynamicField].
/// 
/// This provides a type-safe way to override the default theme decoration
/// instead of using a generic Map.
class FieldDecorationOverride {
  /// Whether the decoration should be filled.
  final bool? filled;

  /// The fill color for the decoration.
  final Color? fillColor;

  /// The style for the error text.
  final TextStyle? errorStyle;

  /// The style for the label text.
  final TextStyle? labelStyle;

  /// The style for the hint text.
  final TextStyle? hintStyle;

  /// The default border for the field.
  final InputBorder? border;

  /// The border for the field when enabled.
  final InputBorder? enabledBorder;

  /// The border for the field when focused.
  final InputBorder? focusedBorder;

  /// A widget to display before the input.
  final Widget? prefix;

  /// A widget to display after the input.
  final Widget? suffix;

  /// Creates a new [FieldDecorationOverride] instance.
  const FieldDecorationOverride({
    this.filled,
    this.fillColor,
    this.errorStyle,
    this.labelStyle,
    this.hintStyle,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.prefix,
    this.suffix,
  });

  /// Tries to parse basic overrides from JSON, but complex types like
  /// [Color] or [InputBorder] are not supported natively via simple JSON.
  factory FieldDecorationOverride.fromJson(Map<String, dynamic> json) {
    return FieldDecorationOverride(
      filled: json['filled'] as bool?,
    );
  }

  /// Converts simple properties to JSON.
  Map<String, dynamic> toJson() => {
        if (filled != null) 'filled': filled,
      };
}
