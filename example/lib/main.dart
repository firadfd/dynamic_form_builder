import 'package:flutter/material.dart';
import 'package:dynamic_field_builder/dynamic_field_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final controller = DynamicFormController();

  final config = [
    DynamicField(
        key: 'name',
        type: FieldType.text,
        label: 'Full Name',
        prefix: const Icon(Icons.person_outline, color: Colors.blue),
        decorationOverride: FieldDecorationOverride(
          filled: true,
          fillColor: Colors.blue.withValues(alpha: 0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
        validation: const {
          'required': true
        }),
    const DynamicField(
        key: 'email',
        type: FieldType.email,
        label: 'Email',
        prefix: Icon(Icons.email)),
    const DynamicField(
        key: 'password',
        type: FieldType.password,
        label: 'Password',
        prefix: Icon(Icons.lock),
        validation: {'minLength': 6}),
    const DynamicField(key: 'bio', type: FieldType.multiline, label: 'Bio'),
    const DynamicField(
        key: 'country',
        type: FieldType.dropdown,
        label: 'Country',
        options: [
          DropdownOption(value: 'us', label: 'United States'),
          DropdownOption(value: 'ca', label: 'Canada'),
        ]),
    const DynamicField(
        key: 'agree',
        type: FieldType.checkbox,
        label: 'I agree to terms',
        activeColor: Colors.blue,
        checkColor: Colors.white),
    DynamicField(
        key: 'notifications',
        type: FieldType.switch_,
        label: 'Enable notifications',
        initialValue: true,
        activeThumbColor: Colors.green,
        inactiveTrackColor: Colors.red.withValues(alpha: 0.3),
        inactiveThumbColor: Colors.red),
    const DynamicField(
        key: 'birthdate', type: FieldType.date, label: 'Birthdate'),
    const DynamicField(
        key: 'meeting_time', type: FieldType.time, label: 'Meeting time'),
    const DynamicField(
      key: 'subscription',
      type: FieldType.radio,
      label: 'Subscription Plan',
      options: [
        DropdownOption(value: 'starter', label: 'Starter (\$9.99/mo)'),
        DropdownOption(value: 'pro', label: 'Pro (\$19.99/mo)'),
        DropdownOption(value: 'premium', label: 'Premium (\$49.99/mo)'),
      ],
    ),
    const DynamicField(
      key: 'experience_rating',
      type: FieldType.slider,
      label: 'Rate your experience',
      initialValue: 5.0,
      activeColor: Colors.blue,
      customData: {
        'min': 0.0,
        'max': 10.0,
        'divisions': 10,
      },
    ),
    const DynamicField(
      key: 'phone_number',
      type: FieldType.phone,
      label: 'Phone Number',
      prefix: Icon(Icons.phone),
      customData: {
        'countryCode': '+1',
      },
    ),
    DynamicField(
      key: 'avatar',
      type: FieldType.file,
      label: 'Upload Avatar',
      customData: {
        'onFilePick': () async {
          // Simulated file picker delay
          await Future.delayed(const Duration(seconds: 1));
          return 'selected_avatar_image.png';
        }
      },
    ),
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
