/// Defines a condition for field visibility or behavior based on another field's value.
class Conditional {
  /// The key of the field that this condition depends on.
  final String dependsOnKey;

  /// The list of values that, if matched by the target field, will satisfy the condition.
  final List<dynamic> equals;

  /// If true, the condition is satisfied when the target field's value is NOT in the [equals] list.
  final bool invert;

  /// Creates a new [Conditional] instance.
  const Conditional({
    required this.dependsOnKey,
    required this.equals,
    this.invert = false,
  });

  /// Creates a [Conditional] instance from a JSON map.
  static Conditional fromJson(Map<String, dynamic> json) => Conditional(
        dependsOnKey: json['dependsOnKey'] as String,
        equals: json['equals'] as List<dynamic>,
        invert: json['invert'] as bool? ?? false,
      );

  /// Converts this [Conditional] instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'dependsOnKey': dependsOnKey,
        'equals': equals,
        if (invert) 'invert': invert,
      };
}
