import 'package:flutter/material.dart';
import '../models/dynamic_field.dart';
import '../models/field_type.dart';
import '../controller/dynamic_form_controller.dart';
import '../theme/dynamic_form_theme.dart';
import '../builders/default_builders.dart';

/// The main widget for building a dynamic form based on a list of [DynamicField].
class DynamicForm extends StatefulWidget {
  /// The list of field configurations defining the form structure.
  final List<DynamicField> config;

  /// Optional controller to manage form state and validation externally.
  final DynamicFormController? controller;

  /// Optional theme to customize the appearance of the form and its fields.
  final DynamicFormTheme? theme;

  /// Map of custom builders to handle custom field types or override default ones.
  final Map<String, FieldBuilder>? customBuilders;

  /// Callback function triggered when the form is submitted and validation passes.
  final void Function(Map<String, dynamic> values)? onSubmit;

  /// Optional wrapper widget to wrap the entire form.
  final Widget Function(Widget form)? wrapper;

  /// Optional builder to provide a custom submit button.
  final Widget Function(VoidCallback onSubmit)? submitButtonBuilder;

  /// Optional initial values to pre-populate the form.
  final Map<String, dynamic>? initialValues;

  /// Whether to wrap the fields in a Flutter [Form] widget. Defaults to true.
  final bool wrapInForm;

  /// Creates a new [DynamicForm] instance.
  const DynamicForm({
    super.key,
    required this.config,
    this.controller,
    this.theme,
    this.customBuilders,
    this.onSubmit,
    this.wrapper,
    this.submitButtonBuilder,
    this.initialValues,
    this.wrapInForm = true,
  });

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  late DynamicFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? DynamicFormController();
    _controller.addListener(_onControllerChanged);
    _initValues();
  }

  void _initValues() {
    if (widget.initialValues != null) {
      widget.initialValues!.forEach((key, value) {
        _controller.setValue(key, value);
      });
    }
    for (var field in widget.config) {
      if (field.initialValue != null &&
          _controller.getValue(field.key) == null) {
        _controller.setValue(field.key, field.initialValue);
      }
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onControllerChanged);
    }
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  bool _isVisible(DynamicField field) {
    if (field.visibleIf != null) {
      for (var entry in field.visibleIf!.entries) {
        if (_controller.getValue(entry.key) != entry.value) return false;
      }
    }

    final cond = field.conditional;
    if (cond == null) return true;
    final depValue = _controller.getValue(cond.dependsOnKey);
    final show = cond.equals.contains(depValue);
    return cond.invert ? !show : show;
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? const DynamicFormTheme();
    final visibleFields = widget.config.where(_isVisible).toList();

    final formBody = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...visibleFields.map((field) => _buildField(field, theme)),
        if (widget.onSubmit != null)
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: widget.submitButtonBuilder != null
                ? widget.submitButtonBuilder!(_submit)
                : ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Submit'),
                  ),
          ),
      ],
    );

    final form = widget.wrapInForm
        ? Form(
            key: _controller.formKey,
            child: formBody,
          )
        : formBody;

    return widget.wrapper != null ? widget.wrapper!(form) : form;
  }

  void _submit() {
    if (_controller.validate()) {
      widget.onSubmit!(_controller.formData);
    }
  }

  Widget _buildField(DynamicField config, DynamicFormTheme theme) {
    if (config.type == FieldType.group) {
      return Padding(
        padding: theme.fieldPadding ?? const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (config.label != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  config.label!,
                  style: theme.labelStyle ??
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                ),
              ),
            if (config.fields != null)
              ...config.fields!.where(_isVisible).map((f) => _buildField(f, theme)),
          ],
        ),
      );
    }
    if (config.type == FieldType.custom) {
      final builderKey = config.extra?['builderKey'] as String? ?? config.key;
      final customBuilder = widget.customBuilders?[builderKey];
      if (customBuilder != null) {
        return customBuilder(config, _controller, theme);
      }
      // Fallback for missing custom builder
      return Padding(
        padding: theme.fieldPadding ?? const EdgeInsets.only(bottom: 8),
        child: Text('No builder registered for "$builderKey"'),
      );
    }
    final builder = widget.customBuilders?[config.type.name] ??
        defaultBuilders[config.type];
    if (builder == null) {
      return const SizedBox.shrink();
    }
    return builder(config, _controller, theme);
  }
}
