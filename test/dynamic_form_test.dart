import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_field_builder/dynamic_field_builder.dart';

void main() {
  testWidgets('DynamicForm renders all field types', (WidgetTester tester) async {
    final controller = DynamicFormController();
    final config = [
      const DynamicField(key: 'text_field', type: FieldType.text, label: 'Text Field'),
      const DynamicField(key: 'email_field', type: FieldType.email, label: 'Email Field'),
      const DynamicField(key: 'pass_field', type: FieldType.password, label: 'Password Field'),
      const DynamicField(key: 'number_field', type: FieldType.number, label: 'Number Field'),
      const DynamicField(key: 'multiline_field', type: FieldType.multiline, label: 'Multiline Field'),
      const DynamicField(
        key: 'dropdown_field',
        type: FieldType.dropdown,
        label: 'Dropdown Field',
        options: [DropdownOption(value: '1', label: 'One')],
      ),
      const DynamicField(key: 'checkbox_field', type: FieldType.checkbox, label: 'Checkbox Field'),
      const DynamicField(key: 'switch_field', type: FieldType.switch_, label: 'Switch Field'),
      const DynamicField(key: 'date_field', type: FieldType.date, label: 'Date Field'),
      const DynamicField(key: 'time_field', type: FieldType.time, label: 'Time Field'),
      const DynamicField(
        key: 'radio_field',
        type: FieldType.radio,
        label: 'Radio Field',
        options: [DropdownOption(value: 'a', label: 'Option A')],
      ),
      const DynamicField(key: 'slider_field', type: FieldType.slider, label: 'Slider Field'),
      const DynamicField(key: 'file_field', type: FieldType.file, label: 'File Field'),
      const DynamicField(key: 'phone_field', type: FieldType.phone, label: 'Phone Field'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: ThemeProvider.navigatorKey,
        home: Scaffold(
          body: SingleChildScrollView(
            child: DynamicForm(
              config: config,
              controller: controller,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Text Field'), findsOneWidget);
    expect(find.text('Email Field'), findsOneWidget);
    expect(find.text('Password Field'), findsOneWidget);
    expect(find.text('Number Field'), findsOneWidget);
    expect(find.text('Multiline Field'), findsOneWidget);
    expect(find.text('Dropdown Field'), findsOneWidget);
    expect(find.text('Checkbox Field'), findsOneWidget);
    expect(find.text('Switch Field'), findsOneWidget);
    expect(find.text('Date Field'), findsOneWidget);
    expect(find.text('Time Field'), findsOneWidget);
    expect(find.text('Radio Field'), findsOneWidget);
    expect(find.textContaining('Slider Field'), findsOneWidget);
    expect(find.text('File Field'), findsOneWidget);
    expect(find.text('Phone Field'), findsOneWidget);
  });
}
