class Conditional {
  final String dependsOnKey;
  final List<dynamic> equals;
  final bool invert;

  const Conditional({
    required this.dependsOnKey,
    required this.equals,
    this.invert = false,
  });

  static Conditional fromJson(Map<String, dynamic> json) => Conditional(
        dependsOnKey: json['dependsOnKey'] as String,
        equals: json['equals'] as List<dynamic>,
        invert: json['invert'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'dependsOnKey': dependsOnKey,
        'equals': equals,
        if (invert) 'invert': invert,
      };
}
