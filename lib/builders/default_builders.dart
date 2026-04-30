import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/field_config.dart';
import '../models/field_type.dart';
import '../controller/dynamic_form_controller.dart';
import '../theme/dynamic_form_theme.dart';
import '../utils/validators.dart';

typedef FieldBuilder = Widget Function(
  FieldConfig config,
  DynamicFormController controller,
  DynamicFormTheme theme,
);

final Map<FieldType, FieldBuilder> defaultBuilders = {
  FieldType.text: _textField,
  FieldType.email: _textField,
  FieldType.password: _passwordField,
  FieldType.number: _textField,
  FieldType.multiline: _multilineField,
  FieldType.dropdown: _dropdownField,
  FieldType.checkbox: _checkboxField,
  FieldType.switch_: _switchField,
  FieldType.date: _dateField,
  FieldType.time: _timeField,
};

String? Function(dynamic)? _validatorFromConfig(FieldConfig config) {
  return (value) => defaultValidator(config.validation, value);
}

TextInputType _keyboardType(FieldType type) {
  switch (type) {
    case FieldType.email:
      return TextInputType.emailAddress;
    case FieldType.number:
      return TextInputType.number;
    case FieldType.multiline:
      return TextInputType.multiline;
    default:
      return TextInputType.text;
  }
}

Widget _textField(FieldConfig config, DynamicFormController controller,
    DynamicFormTheme theme) {
  final initial = controller.getValue(config.key) ?? config.initialValue;
  return Padding(
    padding: theme.fieldPadding ?? const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      initialValue: initial?.toString() ?? '',
      decoration: theme
          .resolveDecoration(ThemeProvider.context,
              props: config.decorationProps,
              prefix: config.prefix,
              suffix: config.suffix)
          .copyWith(labelText: config.label, hintText: config.hint),
      enabled: config.enabled,
      obscureText: config.obscured,
      keyboardType: _keyboardType(config.type),
      validator: _validatorFromConfig(config),
      onChanged: (v) => controller.setValue(config.key, v),
    ),
  );
}

Widget _passwordField(FieldConfig config, DynamicFormController controller,
    DynamicFormTheme theme) {
  return PasswordField(config: config, controller: controller, theme: theme);
}

class PasswordField extends StatefulWidget {
  final FieldConfig config;
  final DynamicFormController controller;
  final DynamicFormTheme theme;

  const PasswordField({
    Key? key,
    required this.config,
    required this.controller,
    required this.theme,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final initial = widget.controller.getValue(widget.config.key) ??
        widget.config.initialValue;
    return Padding(
      padding: widget.theme.fieldPadding ?? const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: initial?.toString() ?? '',
        decoration: widget.theme
            .resolveDecoration(ThemeProvider.context,
                props: widget.config.decorationProps,
                prefix: widget.config.prefix,
                suffix: widget.config.suffix)
            .copyWith(
              labelText: widget.config.label,
              hintText: widget.config.hint,
              suffixIcon: IconButton(
                icon: Icon(_obscured ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscured = !_obscured),
              ),
            ),
        enabled: widget.config.enabled,
        obscureText: _obscured,
        keyboardType: TextInputType.visiblePassword,
        validator: _validatorFromConfig(widget.config),
        onChanged: (v) => widget.controller.setValue(widget.config.key, v),
      ),
    );
  }
}

Widget _multilineField(FieldConfig config, DynamicFormController controller,
    DynamicFormTheme theme) {
  final initial = controller.getValue(config.key) ?? config.initialValue;
  return Padding(
    padding: theme.fieldPadding ?? const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      initialValue: initial?.toString() ?? '',
      decoration: theme
          .resolveDecoration(ThemeProvider.context,
              props: config.decorationProps,
              prefix: config.prefix,
              suffix: config.suffix)
          .copyWith(labelText: config.label, hintText: config.hint),
      maxLines: 5,
      enabled: config.enabled,
      keyboardType: TextInputType.multiline,
      validator: _validatorFromConfig(config),
      onChanged: (v) => controller.setValue(config.key, v),
    ),
  );
}

Widget _dropdownField(FieldConfig config, DynamicFormController controller,
    DynamicFormTheme theme) {
  final current = controller.getValue(config.key);
  return Padding(
    padding: theme.fieldPadding ?? const EdgeInsets.only(bottom: 16),
    child: DropdownButtonFormField<String>(
      initialValue: current?.toString(),
      decoration: theme
          .resolveDecoration(ThemeProvider.context,
              props: config.decorationProps,
              prefix: config.prefix,
              suffix: config.suffix)
          .copyWith(labelText: config.label, hintText: config.hint),
      items: config.options
              ?.map(
                  (o) => DropdownMenuItem(value: o.value, child: Text(o.label)))
              .toList() ??
          [],
      onChanged:
          config.enabled ? (v) => controller.setValue(config.key, v) : null,
      validator: _validatorFromConfig(config),
    ),
  );
}

Widget _checkboxField(FieldConfig config, DynamicFormController controller,
    DynamicFormTheme theme) {
  final initial =
      controller.getValue(config.key) ?? config.initialValue ?? false;
  return Padding(
    padding: theme.fieldPadding ?? const EdgeInsets.only(bottom: 8),
    child: FormField<bool>(
      initialValue: initial as bool,
      validator: _validatorFromConfig(config),
      builder: (field) => CheckboxListTile(
        activeColor: config.activeColor,
        checkColor: config.checkColor,
        title: Text(config.label ?? ''),
        value: field.value,
        onChanged: config.enabled
            ? (v) {
                field.didChange(v);
                controller.setValue(config.key, v);
              }
            : null,
      ),
    ),
  );
}

Widget _switchField(FieldConfig config, DynamicFormController controller,
    DynamicFormTheme theme) {
  final initial =
      controller.getValue(config.key) ?? config.initialValue ?? false;
  return Padding(
    padding: theme.fieldPadding ?? const EdgeInsets.only(bottom: 8),
    child: FormField<bool>(
      initialValue: initial as bool,
      validator: _validatorFromConfig(config),
      builder: (field) => SwitchListTile(
        activeColor: config.activeColor,
        activeTrackColor: config.activeColor?.withOpacity(0.5),
        inactiveThumbColor: config.inactiveThumbColor,
        inactiveTrackColor: config.inactiveTrackColor,
        title: Text(config.label ?? ''),
        value: field.value ?? false,
        onChanged: config.enabled
            ? (v) {
                field.didChange(v);
                controller.setValue(config.key, v);
              }
            : null,
      ),
    ),
  );
}

Widget _dateField(FieldConfig config, DynamicFormController controller,
    DynamicFormTheme theme) {
  final stored = controller.getValue(config.key);
  final date = stored is DateTime
      ? stored
      : (stored != null ? DateTime.tryParse(stored.toString()) : null);
  final dateStr = date != null ? DateFormat.yMd().format(date) : '';

  return Padding(
    padding: theme.fieldPadding ?? const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      key: ValueKey('${config.key}_$dateStr'),
      initialValue: dateStr,
      readOnly: true,
      decoration: theme
          .resolveDecoration(ThemeProvider.context,
              props: config.decorationProps,
              prefix: config.prefix,
              suffix: config.suffix ?? const Icon(Icons.calendar_today))
          .copyWith(
            labelText: config.label,
            hintText: config.hint,
          ),
      onTap: config.enabled
          ? () async {
              final picked = await showDatePicker(
                context: ThemeProvider.context,
                initialDate: date ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                controller.setValue(config.key, picked);
              }
            }
          : null,
      validator: _validatorFromConfig(config),
    ),
  );
}

Widget _timeField(FieldConfig config, DynamicFormController controller,
    DynamicFormTheme theme) {
  final stored = controller.getValue(config.key);
  final time = stored is TimeOfDay
      ? stored
      : (stored != null ? _tryParseTime(stored.toString()) : null);
  final timeStr = time != null ? time.format(ThemeProvider.context) : '';

  return Padding(
    padding: theme.fieldPadding ?? const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      key: ValueKey('${config.key}_$timeStr'),
      initialValue: timeStr,
      readOnly: true,
      decoration: theme
          .resolveDecoration(ThemeProvider.context,
              props: config.decorationProps,
              prefix: config.prefix,
              suffix: config.suffix ?? const Icon(Icons.access_time))
          .copyWith(
            labelText: config.label,
            hintText: config.hint,
          ),
      onTap: config.enabled
          ? () async {
              final picked = await showTimePicker(
                context: ThemeProvider.context,
                initialTime: time ?? TimeOfDay.now(),
              );
              if (picked != null) {
                controller.setValue(config.key, picked);
              }
            }
          : null,
      validator: _validatorFromConfig(config),
    ),
  );
}

TimeOfDay? _tryParseTime(String s) {
  try {
    final parts = s.split(':');
    if (parts.length == 2) {
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    }
  } catch (_) {}
  return null;
}

/// Utility to provide a BuildContext globally for showing dialogs.
/// Set this from your app's root widget.
class ThemeProvider {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext get context => navigatorKey.currentContext!;
}
