import 'package:flutter/material.dart';
import '../models/dynamic_step.dart';
import '../controller/dynamic_form_controller.dart';
import '../theme/dynamic_form_theme.dart';
import 'dynamic_form.dart';

/// A multi-step form widget that uses Flutter's native [Stepper].
class DynamicStepperForm extends StatefulWidget {
  /// The list of steps defining the form structure.
  final List<DynamicStep> steps;

  /// Optional controller to manage form state and validation externally.
  final DynamicFormController? controller;

  /// Optional theme to customize the appearance of the form and its fields.
  final DynamicFormTheme? theme;

  /// Callback function triggered when all steps are completed and validated.
  final void Function(Map<String, dynamic> values)? onSubmit;

  /// The type of stepper (vertical or horizontal).
  final StepperType type;

  /// Creates a new [DynamicStepperForm] instance.
  const DynamicStepperForm({
    super.key,
    required this.steps,
    this.controller,
    this.theme,
    this.onSubmit,
    this.type = StepperType.vertical,
  });

  @override
  State<DynamicStepperForm> createState() => _DynamicStepperFormState();
}

class _DynamicStepperFormState extends State<DynamicStepperForm> {
  late DynamicFormController _controller;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? DynamicFormController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  bool _validateCurrentStep() {
    return _controller.validate();
  }

  void _onStepContinue() {
    if (!_validateCurrentStep()) return;

    if (_currentStep < widget.steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      if (widget.onSubmit != null) {
        widget.onSubmit!(_controller.formData);
      }
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _controller.formKey,
      child: Stepper(
        type: widget.type,
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        onStepTapped: (step) {
          if (step < _currentStep || _validateCurrentStep()) {
            setState(() => _currentStep = step);
          }
        },
        steps: widget.steps.map((step) {
          final index = widget.steps.indexOf(step);
          return Step(
            title: Text(step.title),
            subtitle: step.subtitle != null ? Text(step.subtitle!) : null,
            isActive: step.isActive && _currentStep >= index,
            state: _currentStep > index ? StepState.complete : StepState.indexed,
            content: DynamicForm(
              config: step.fields,
              controller: _controller,
              theme: widget.theme,
              wrapInForm: false, // Prevent nested Forms with the same key
            ),
          );
        }).toList(),
      ),
    );
  }
}
