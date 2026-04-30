import 'package:flutter/material.dart';
import 'package:dynamic_field_builder/dynamic_field_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: ThemeProvider.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final controller = DynamicFormController();

  final config = [
    FieldConfig(
        key: 'name',
        type: FieldType.text,
        label: 'Full Name',
        prefix: const Icon(Icons.person_outline, color: Colors.blue),
        decorationProps: {
          'filled': true,
          'fillColor': Colors.blue.withOpacity(0.05),
          'border': OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        },
        validation: const {
          'required': true
        }),
    const FieldConfig(
        key: 'email',
        type: FieldType.email,
        label: 'Email',
        prefix: Icon(Icons.email)),
    const FieldConfig(
        key: 'password',
        type: FieldType.password,
        label: 'Password',
        prefix: Icon(Icons.lock),
        validation: {'minLength': 6}),
    const FieldConfig(key: 'bio', type: FieldType.multiline, label: 'Bio'),
    const FieldConfig(
        key: 'country',
        type: FieldType.dropdown,
        label: 'Country',
        options: [
          DropdownOption(value: 'us', label: 'United States'),
          DropdownOption(value: 'ca', label: 'Canada'),
        ]),
    const FieldConfig(
        key: 'agree',
        type: FieldType.checkbox,
        label: 'I agree to terms',
        activeColor: Colors.blue,
        checkColor: Colors.white),
    FieldConfig(
        key: 'notifications',
        type: FieldType.switch_,
        label: 'Enable notifications',
        initialValue: true,
        activeColor: Colors.green,
        inactiveTrackColor: Colors.red.withOpacity(0.3),
        inactiveThumbColor: Colors.red),
    const FieldConfig(
        key: 'birthdate', type: FieldType.date, label: 'Birthdate'),
    const FieldConfig(
        key: 'meeting_time', type: FieldType.time, label: 'Meeting time'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Form Builder')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DynamicForm(
          config: config,
          controller: controller,
          theme: const DynamicFormTheme(
            inputDecoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
          ),
          onSubmit: (values) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Form Values'),
                content: Text(values.toString()),
              ),
            );
          },
        ),
      ),
    );
  }
}
