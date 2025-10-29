import 'package:firebase_test/notification_service.dart';
import 'package:flutter/material.dart';

class CardFullScreen extends StatelessWidget {
  final String title;
  final String subTitle;

  const CardFullScreen({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Card Full Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Title: $title', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text('Subtitle: $subTitle', style: const TextStyle(fontSize: 20)),
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
                  title,
                  subTitle,
                );
              },
              child: Text("Show instant Notification"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                NotificationService().scheduleNotification(
                  1,
                  title,
                  subTitle,
                  11,
                  34
                );
              },
              child: Text("Show schedule Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
