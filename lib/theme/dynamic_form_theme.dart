import 'package:flutter/material.dart';

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
  /// [inputDecoration] with field-specific [props], [prefix], and [suffix].
  InputDecoration resolveDecoration(
    BuildContext context, {
    Map<String, dynamic>? props,
    Widget? prefix,
    Widget? suffix,
  }) {
    final defaultDeco = inputDecoration ?? const InputDecoration();

    return defaultDeco.copyWith(
      prefixIcon: prefix ?? (props?['prefix'] as Widget?),
      suffixIcon: suffix ?? (props?['suffix'] as Widget?),
      filled: props?['filled'] as bool?,
      fillColor: props?['fillColor'] as Color?,
      errorStyle: props?['errorStyle'] as TextStyle?,
      labelStyle: props?['labelStyle'] as TextStyle?,
      hintStyle: props?['hintStyle'] as TextStyle?,
      border: props?['border'] as InputBorder?,
      enabledBorder: props?['enabledBorder'] as InputBorder?,
      focusedBorder: props?['focusedBorder'] as InputBorder?,
    );
  }
}
