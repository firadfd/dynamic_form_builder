import 'package:flutter/material.dart';
import '../utils/validators.dart' show registerCustomValidator;

class DynamicFormController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _values = {};
  final Map<String, String?> _errors = {};
  final Map<String, List<VoidCallback>> _listeners = {};

  void setValue(String key, dynamic value) {
    if (_values[key] != value) {
      _values[key] = value;
      _errors.remove(key);
      notifyListeners();
      _listeners[key]?.forEach((cb) => cb());
    }
  }

  dynamic getValue(String key) => _values[key];

  void addFieldListener(String key, VoidCallback callback) {
    _listeners.putIfAbsent(key, () => []).add(callback);
  }

  void removeFieldListener(String key, VoidCallback callback) {
    _listeners[key]?.remove(callback);
  }

  void setFieldError(String key, String? error) {
    _errors[key] = error;
    notifyListeners();
  }

  String? getFieldError(String key) => _errors[key];

  bool validate() => formKey.currentState?.validate() ?? false;

  Map<String, dynamic> get formData => Map.unmodifiable(_values);

  /// Register a custom validation function globally
  void addCustomValidator(String key, String? Function(dynamic) fn) {
    registerCustomValidator(key, fn);
  }

  @override
  void dispose() {
    _listeners.clear();
    super.dispose();
  }
}
