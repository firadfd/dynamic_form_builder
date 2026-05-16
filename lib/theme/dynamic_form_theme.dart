import 'package:flutter/material.dart';
import '../models/field_decoration_override.dart';

/// Theme configuration for customizing the appearance of [DynamicForm].
class DynamicFormTheme {
  /// The default [InputDecoration] to apply to all input fields in the form.
  final InputDecoration? inputDecoration;

  /// The padding around each form field.
  final EdgeInsetsGeometry? fieldPadding;

  /// The text style for field labels.
  final TextStyle? labelStyle;

  /// The text style for field hint text.
  final TextStyle? hintStyle;

  /// The color used for displaying validation errors.
  final Color? errorColor;

  /// A custom widget to display as a loader (e.g., during async operations).
  final Widget? loader;

  /// Creates a new [DynamicFormTheme] instance.
  const DynamicFormTheme({
    this.inputDecoration,
    this.fieldPadding,
    this.labelStyle,
    this.hintStyle,
    this.errorColor,
    this.loader,
  });

  /// Merges properties with the default [InputDecoration].
  ///
  /// This method resolves the final decoration for a field by combining the global
  /// [inputDecoration] with field-specific [override], [prefix], and [suffix].
  InputDecoration resolveDecoration(
    BuildContext context, {
    FieldDecorationOverride? override,
    Widget? prefix,
    Widget? suffix,
  }) {
    final defaultDeco = inputDecoration ?? const InputDecoration();

    return defaultDeco.copyWith(
      prefixIcon: prefix ?? override?.prefix,
      suffixIcon: suffix ?? override?.suffix,
      filled: override?.filled,
      fillColor: override?.fillColor,
      errorStyle: override?.errorStyle,
      labelStyle: override?.labelStyle,
      hintStyle: override?.hintStyle,
      border: override?.border,
      enabledBorder: override?.enabledBorder,
      focusedBorder: override?.focusedBorder,
    );
  }
}
