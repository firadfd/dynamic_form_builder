import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/validators.dart' show registerCustomValidator;

/// A controller that manages the state, values, and validation of a [DynamicForm].
class DynamicFormController extends ChangeNotifier {
  /// Global key for the [Form] widget managed by this controller.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _values = {};
  final Map<String, String?> _errors = {};
  final Map<String, List<VoidCallback>> _listeners = {};
  final StreamController<Map<String, dynamic>> _valueStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  /// A stream that emits the current form data whenever a value changes.
  Stream<Map<String, dynamic>> get valueStream => _valueStreamController.stream;

  /// Updates the value of a specific field and notifies listeners.
  void setValue(String key, dynamic value) {
    if (_values[key] != value) {
      _values[key] = value;
      _errors.remove(key);
      notifyListeners();
      _listeners[key]?.forEach((cb) => cb());
      _valueStreamController.add(formData);
    }
  }

  /// Retrieves the current value of a specific field.
  dynamic getValue(String key) => _values[key];

  /// Adds a listener for changes to a specific field's value.
  void addFieldListener(String key, VoidCallback callback) {
    _listeners.putIfAbsent(key, () => []).add(callback);
  }

  /// Removes a listener for changes to a specific field's value.
  void removeFieldListener(String key, VoidCallback callback) {
    _listeners[key]?.remove(callback);
  }

  /// Manually sets an error message for a specific field.
  void setFieldError(String key, String? error) {
    _errors[key] = error;
    notifyListeners();
  }

  /// Retrieves the current error message for a specific field.
  String? getFieldError(String key) => _errors[key];

  /// Triggers the validation of the entire form using the [formKey].
  /// Returns `true` if the form is valid, `false` otherwise.
  bool validate() => formKey.currentState?.validate() ?? false;

  /// Returns an unmodifiable map containing all current form field values.
  Map<String, dynamic> get formData => Map.unmodifiable(_values);

  /// Validates the form and returns the form data if valid, or null if invalid.
  Map<String, dynamic>? submit() {
    if (validate()) {
      return formData;
    }
    return null;
  }

  /// Resets the form to its initial state, clearing all values and errors.
  void reset() {
    _values.clear();
    _errors.clear();
    formKey.currentState?.reset();
    notifyListeners();
    _valueStreamController.add(formData);
  }

  /// Registers a custom validation function globally.
  void addCustomValidator(String key, String? Function(dynamic) fn) {
    registerCustomValidator(key, fn);
  }

  @override
  void dispose() {
    _listeners.clear();
    _valueStreamController.close();
    super.dispose();
  }
}
