import 'package:flutter/material.dart';
import '../models/field_config.dart';
import '../models/field_type.dart';
import '../controller/dynamic_form_controller.dart';
import '../theme/dynamic_form_theme.dart';
import '../builders/default_builders.dart';

class DynamicForm extends StatefulWidget {
  final List<FieldConfig> config;
  final DynamicFormController? controller;
  final DynamicFormTheme? theme;
  final Map<String, FieldBuilder>? customBuilders;
  final void Function(Map<String, dynamic> values)? onSubmit;
  final Widget Function(Widget form)? wrapper;
  final Widget Function(VoidCallback onSubmit)? submitButtonBuilder;

  const DynamicForm({
    Key? key,
    required this.config,
    this.controller,
    this.theme,
    this.customBuilders,
    this.onSubmit,
    this.wrapper,
    this.submitButtonBuilder,
  }) : super(key: key);

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

  bool _isVisible(FieldConfig field) {
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

    final form = Form(
      key: _controller.formKey,
      child: Column(
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
      ),
    );

    return widget.wrapper != null ? widget.wrapper!(form) : form;
  }

  void _submit() {
    if (_controller.validate()) {
      widget.onSubmit!(_controller.formData);
    }
  }

  Widget _buildField(FieldConfig config, DynamicFormTheme theme) {
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
