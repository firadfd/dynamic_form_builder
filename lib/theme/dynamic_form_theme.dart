import 'package:flutter/material.dart';

class DynamicFormTheme {
  final InputDecoration? inputDecoration;
  final EdgeInsetsGeometry? fieldPadding;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final Color? errorColor;
  final Widget? loader;

  const DynamicFormTheme({
    this.inputDecoration,
    this.fieldPadding,
    this.labelStyle,
    this.hintStyle,
    this.errorColor,
    this.loader,
  });

  /// Merges with default InputDecoration
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
