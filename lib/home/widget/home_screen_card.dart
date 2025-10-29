import 'package:firebase_test/home/widget/card_full_screen.dart';
import 'package:flutter/material.dart';

class HomeScreenCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const HomeScreenCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor: Colors.white,
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(Icons.cable_rounded),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return CardFullScreen(title: title, subTitle: subtitle);
              },
            ),
          );
        },
      ),
    );
  }
}
