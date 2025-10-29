import 'package:firebase_test/notification_service.dart';
import 'package:flutter/material.dart';

class CardFullScreen extends StatefulWidget {
  final String title;
  final String subTitle;

  const CardFullScreen({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  State<CardFullScreen> createState() => _CardFullScreenState();
}

class _CardFullScreenState extends State<CardFullScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hourController = TextEditingController();
  final _minuteController = TextEditingController();

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Card Full Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Title: $widget.title', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text('Subtitle: $widget.subTitle', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                throw Exception();
              },
              child: Text("Throw Exception"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                throw FormatException("Format Exception");
              },
              child: Text("Format Exception"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                NotificationService().showNotification(
                  1,
                  widget.title,
                  widget.subTitle,
                );
              },
              child: Text("Show instant Notification"),
            ),
            const SizedBox(height: 20),
            Divider(
              height: 50,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _hourController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Hour (0-23)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter hour';
                              }
                              final hour = int.tryParse(value);
                              if (hour == null || hour < 0 || hour > 23) {
                                return 'Enter hour (0-23)';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _minuteController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Minute (0-59)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter minute';
                              }
                              final minute = int.tryParse(value);
                              if (minute == null || minute < 0 || minute > 59) {
                                return 'Enter minute (0-59)';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final hour = int.parse(_hourController.text);
                        final minute = int.parse(_minuteController.text);
                        
                        NotificationService().scheduleNotification(
                          1,
                          widget.title,
                          widget.subTitle,
                          hour,
                          minute,
                        );
                        
                        // Show a confirmation
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Notification scheduled for ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}'),
                          ),
                        );
                      }
                    },
                    child: const Text("Schedule Notification"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
