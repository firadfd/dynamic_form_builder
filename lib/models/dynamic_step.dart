import 'dynamic_field.dart';

/// Represents a single step in a multi-step form (Stepper).
class DynamicStep {
  /// The title of the step.
  final String title;

  /// Optional subtitle for the step.
  final String? subtitle;

  /// The list of fields to display in this step.
  final List<DynamicField> fields;

  /// Whether this step is active/enabled.
  final bool isActive;

  /// Creates a new [DynamicStep] instance.
  const DynamicStep({
    required this.title,
    this.subtitle,
    required this.fields,
    this.isActive = true,
  });

  /// Creates a [DynamicStep] instance from a JSON map.
  factory DynamicStep.fromJson(Map<String, dynamic> json) {
    return DynamicStep(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      fields: (json['fields'] as List<dynamic>)
          .map((e) => DynamicField.fromJson(e as Map<String, dynamic>))
          .toList(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Converts this [DynamicStep] instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'title': title,
        if (subtitle != null) 'subtitle': subtitle,
        'fields': fields.map((e) => e.toJson()).toList(),
        'isActive': isActive,
      };
}
