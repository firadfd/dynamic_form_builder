/// A library for building reactive Flutter forms from a configuration map or JSON.
library;

export 'models/dynamic_field.dart';
export 'models/dynamic_step.dart';
export 'models/field_type.dart';
export 'models/dropdown_option.dart';
export 'models/conditional.dart';
export 'models/field_decoration_override.dart';
export 'controller/dynamic_form_controller.dart';
export 'theme/dynamic_form_theme.dart';
export 'builders/default_builders.dart';
export 'widgets/dynamic_form.dart';
export 'widgets/dynamic_stepper_form.dart';
export 'utils/validators.dart';

import 'widgets/dynamic_form.dart';

/// Alias for [DynamicForm] to match the package name and conventions.
typedef DynamicFieldBuilder = DynamicForm;
