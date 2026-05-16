import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dynamic_field.dart';
import '../models/field_type.dart';
import '../controller/dynamic_form_controller.dart';
import '../theme/dynamic_form_theme.dart';
import '../utils/validators.dart';

/// Signature for a function that builds a form field widget.
typedef FieldBuilder = Widget Function(
  DynamicField config,
  DynamicFormController controller,
  DynamicFormTheme theme,
);

/// The default set of field builders provided by the library.
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
  FieldType.radio: _radioField,
  FieldType.slider: _sliderField,
  FieldType.file: _fileField,
  FieldType.phone: _phoneField,
  FieldType.multiSelect: _multiSelectField,
};

String? Function(dynamic)? _validatorFromConfig(DynamicField config) {
  if (config.validator != null) return config.validator;
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

Widget _textField(DynamicField config, DynamicFormController controller,
    DynamicFormTheme theme) {
  final initial = controller.getValue(config.key) ?? config.initialValue;
  return Padding(
    padding: theme.fieldPadding ?? const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      initialValue: initial?.toString() ?? '',
      style: config.style,
      decoration: config.decoration ?? theme
          .resolveDecoration(ThemeProvider.context,
              override: config.decorationOverride,
              prefix: config.prefix,
              suffix: config.suffix)
          .copyWith(labelText: config.label, hintText: config.hint),
      enabled: config.enabled,
      readOnly: config.readOnly,
      obscureText: config.obscured,
      autofillHints: config.autofillHints,
      keyboardType: _keyboardType(config.type),
      validator: _validatorFromConfig(config),
      onChanged: (v) {
        controller.setValue(config.key, v);
        config.onChanged?.call(v);
      },
    ),
  );
}

Widget _passwordField(DynamicField config, DynamicFormController controller,
    DynamicFormTheme theme) {
  return PasswordField(config: config, controller: controller, theme: theme);
}

/// A specialized text field for password entry with a visibility toggle.
class PasswordField extends StatefulWidget {
  /// The field configuration.
  final DynamicField config;

  /// The form controller.
  final DynamicFormController controller;

  /// The form theme.
  final DynamicFormTheme theme;

  /// Creates a new [PasswordField] instance.
  const PasswordField({
    super.key,
    required this.config,
    required this.controller,
    required this.theme,
  });

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
        style: widget.config.style,
        decoration: widget.config.decoration ?? widget.theme
            .resolveDecoration(ThemeProvider.context,
                override: widget.config.decorationOverride,
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
        readOnly: widget.config.readOnly,
        obscureText: _obscured,
        autofillHints: widget.config.autofillHints,
        keyboardType: TextInputType.visiblePassword,
        validator: _validatorFromConfig(widget.config),
        onChanged: (v) {
          widget.controller.setValue(widget.config.key, v);
          widget.config.onChanged?.call(v);
        },
      ),
    );
  }
}

Widget _multilineField(DynamicField config, DynamicFormController controller,
    DynamicFormTheme theme) {
  final initial = controller.getValue(config.key) ?? config.initialValue;
  return Padding(
    padding: theme.fieldPadding ?? const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      initialValue: initial?.toString() ?? '',
      style: config.style,
      decoration: config.decoration ?? theme
          .resolveDecoration(ThemeProvider.context,
              override: config.decorationOverride,
              prefix: config.prefix,
              suffix: config.suffix)
          .copyWith(labelText: config.label, hintText: config.hint),
      maxLines: 5,
      enabled: config.enabled,
      readOnly: config.readOnly,
      autofillHints: config.autofillHints,
      keyboardType: TextInputType.multiline,
      validator: _validatorFromConfig(config),
      onChanged: (v) {
        controller.setValue(config.key, v);
        config.onChanged?.call(v);
      },
    ),
  );
}

Widget _dropdownField(DynamicField config, DynamicFormController controller,
    DynamicFormTheme theme) {
  final current = controller.getValue(config.key);
  return Padding(
    padding: theme.fieldPadding ?? const EdgeInsets.only(bottom: 16),
    child: DropdownButtonFormField<String>(
      initialValue: current?.toString(),
      style: config.style,
      decoration: config.decoration ?? theme
          .resolveDecoration(ThemeProvider.context,
              override: config.decorationOverride,
              prefix: config.prefix,
              suffix: config.suffix)
          .copyWith(labelText: config.label, hintText: config.hint),
      items: config.options
              ?.map(
                  (o) => DropdownMenuItem(value: o.value, child: Text(o.label)))
              .toList() ??
          [],
      onChanged: config.enabled && !config.readOnly
          ? (v) {
              controller.setValue(config.key, v);
              config.onChanged?.call(v);
            }
          : null,
      validator: _validatorFromConfig(config),
    ),
  );
}

Widget _checkboxField(DynamicField config, DynamicFormController controller,
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
        onChanged: config.enabled && !config.readOnly
            ? (v) {
                field.didChange(v);
                controller.setValue(config.key, v);
                config.onChanged?.call(v);
              }
            : null,
      ),
    ),
  );
}

Widget _switchField(DynamicField config, DynamicFormController controller,
    DynamicFormTheme theme) {
  final initial =
      controller.getValue(config.key) ?? config.initialValue ?? false;
  return Padding(
    padding: theme.fieldPadding ?? const EdgeInsets.only(bottom: 8),
    child: FormField<bool>(
      initialValue: initial as bool,
      validator: _validatorFromConfig(config),
      builder: (field) => SwitchListTile(
        activeThumbColor: config.activeThumbColor ?? config.activeColor,
        activeTrackColor: (config.activeThumbColor ?? config.activeColor)
            ?.withValues(alpha: 0.5),
        inactiveThumbColor: config.inactiveThumbColor,
        inactiveTrackColor: config.inactiveTrackColor,
        title: Text(config.label ?? ''),
        value: field.value ?? false,
        onChanged: config.enabled && !config.readOnly
            ? (v) {
                field.didChange(v);
                controller.setValue(config.key, v);
                config.onChanged?.call(v);
              }
            : null,
      ),
    ),
  );
}

Widget _dateField(DynamicField config, DynamicFormController controller,
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
      style: config.style,
      decoration: config.decoration ?? theme
          .resolveDecoration(ThemeProvider.context,
              override: config.decorationOverride,
              prefix: config.prefix,
              suffix: config.suffix ?? const Icon(Icons.calendar_today))
          .copyWith(
            labelText: config.label,
            hintText: config.hint,
          ),
      onTap: config.enabled && !config.readOnly
          ? () async {
              final picked = await showDatePicker(
                context: ThemeProvider.context,
                initialDate: date ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                controller.setValue(config.key, picked);
                config.onChanged?.call(picked);
              }
            }
          : null,
      validator: _validatorFromConfig(config),
    ),
  );
}

Widget _timeField(DynamicField config, DynamicFormController controller,
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
      style: config.style,
      decoration: config.decoration ?? theme
          .resolveDecoration(ThemeProvider.context,
              override: config.decorationOverride,
              prefix: config.prefix,
              suffix: config.suffix ?? const Icon(Icons.access_time))
          .copyWith(
            labelText: config.label,
            hintText: config.hint,
          ),
      onTap: config.enabled && !config.readOnly
          ? () async {
              final picked = await showTimePicker(
                context: ThemeProvider.context,
                initialTime: time ?? TimeOfDay.now(),
              );
              if (picked != null) {
                controller.setValue(config.key, picked);
                config.onChanged?.call(picked);
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

Widget _radioField(DynamicField config, DynamicFormController controller,
    DynamicFormTheme theme) {
  final current = controller.getValue(config.key);
  return Padding(
    padding: theme.fieldPadding ?? const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (config.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(config.label!,
                style: theme.labelStyle ??
                    Theme.of(ThemeProvider.context).textTheme.titleMedium),
          ),
        ...(config.options ?? []).map((o) {
          return RadioListTile<String>(
            title: Text(o.label),
            value: o.value,
            groupValue: current?.toString(),
            activeColor: config.activeColor,
            onChanged: config.enabled && !config.readOnly
                ? (v) {
                    controller.setValue(config.key, v);
                    config.onChanged?.call(v);
                  }
                : null,
          );
        }),
      ],
    ),
  );
}

Widget _sliderField(DynamicField config, DynamicFormController controller,
    DynamicFormTheme theme) {
  final current = controller.getValue(config.key) ?? config.initialValue ?? 0.0;
  final double val = current is double
      ? current
      : (current is num ? current.toDouble() : double.tryParse(current.toString()) ?? 0.0);
  final min = (config.customData?['min'] as num?)?.toDouble() ?? 0.0;
  final max = (config.customData?['max'] as num?)?.toDouble() ?? 100.0;
  final divisions = config.customData?['divisions'] as int?;

  return Padding(
    padding: theme.fieldPadding ?? const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (config.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text('${config.label!} (${val.toStringAsFixed(1)})',
                style: theme.labelStyle ??
                    Theme.of(ThemeProvider.context).textTheme.titleMedium),
          ),
        Slider(
          value: val.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions,
          activeColor: config.activeColor,
          inactiveColor: config.inactiveTrackColor,
          onChanged: config.enabled && !config.readOnly
              ? (v) {
                  controller.setValue(config.key, v);
                  config.onChanged?.call(v);
                }
              : null,
        ),
      ],
    ),
  );
}

Widget _fileField(DynamicField config, DynamicFormController controller,
    DynamicFormTheme theme) {
  final current = controller.getValue(config.key)?.toString() ?? '';
  return Padding(
    padding: theme.fieldPadding ?? const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      key: ValueKey('${config.key}_$current'),
      initialValue: current,
      readOnly: true,
      style: config.style,
      decoration: config.decoration ??
          theme
              .resolveDecoration(ThemeProvider.context,
                  override: config.decorationOverride,
                  prefix: config.prefix,
                  suffix: config.suffix ?? const Icon(Icons.attach_file))
              .copyWith(
                labelText: config.label,
                hintText: config.hint ?? 'Tap to select file',
              ),
      onTap: config.enabled && !config.readOnly
          ? () async {
              if (config.customData != null &&
                  config.customData!['onFilePick'] != null) {
                final callback = config.customData!['onFilePick'] as Function;
                final result = await callback();
                if (result != null) {
                  controller.setValue(config.key, result);
                  config.onChanged?.call(result);
                }
              }
            }
          : null,
      validator: _validatorFromConfig(config),
    ),
  );
}

Widget _phoneField(DynamicField config, DynamicFormController controller,
    DynamicFormTheme theme) {
  final initial = controller.getValue(config.key) ?? config.initialValue;
  final prefixCode = config.customData?['countryCode']?.toString();
  return Padding(
    padding: theme.fieldPadding ?? const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      initialValue: initial?.toString() ?? '',
      style: config.style,
      decoration: config.decoration ??
          theme
              .resolveDecoration(ThemeProvider.context,
                  override: config.decorationOverride,
                  prefix: config.prefix ??
                      (prefixCode != null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text(prefixCode)],
                              ),
                            )
                          : null),
                  suffix: config.suffix)
              .copyWith(labelText: config.label, hintText: config.hint),
      enabled: config.enabled,
      readOnly: config.readOnly,
      autofillHints: config.autofillHints,
      keyboardType: TextInputType.phone,
      validator: _validatorFromConfig(config),
      onChanged: (v) {
        controller.setValue(config.key, v);
        config.onChanged?.call(v);
      },
    ),
  );
}

Widget _multiSelectField(DynamicField config, DynamicFormController controller,
    DynamicFormTheme theme) {
  final current = controller.getValue(config.key);
  final List<String> selected = current is List
      ? current.map((e) => e.toString()).toList()
      : (current != null ? [current.toString()] : []);

  return Padding(
    padding: theme.fieldPadding ?? const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (config.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              config.label!,
              style: theme.labelStyle ??
                  Theme.of(ThemeProvider.context).textTheme.titleMedium,
            ),
          ),
        Wrap(
          spacing: 8.0,
          children: (config.options ?? []).map((o) {
            final isSelected = selected.contains(o.value);
            return FilterChip(
              label: Text(o.label),
              selected: isSelected,
              onSelected: config.enabled && !config.readOnly
                  ? (val) {
                      if (val) {
                        selected.add(o.value);
                      } else {
                        selected.remove(o.value);
                      }
                      controller.setValue(config.key, List<String>.from(selected));
                      config.onChanged?.call(selected);
                    }
                  : null,
            );
          }).toList(),
        ),
      ],
    ),
  );
}

/// Utility to provide a BuildContext globally for showing dialogs and resolve themes.
/// 
/// Set [navigatorKey] in your [MaterialApp] or [CupertinoApp] to enable this.
class ThemeProvider {
  /// The global navigator key used to access the current [BuildContext].
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Retrieves the current [BuildContext] from the [navigatorKey].
  static BuildContext get context => navigatorKey.currentContext!;
}
