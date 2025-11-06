import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_test/home/widget/add_item_full_screen.dart';
import 'package:firebase_test/home/widget/bnb_custom_painter.dart';
import 'package:firebase_test/home/widget/home_screen_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final size = MediaQuery
      .of(context)
      .size;

  Future<String> getTitle() async {
    try {
      FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(minutes: 5),),
      );
      await remoteConfig.fetchAndActivate();
      return remoteConfig.getString('title');
    }
    catch (e) {
      print(e);
    }
    return "My firebase test app";
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> tasksStream = FirebaseFirestore.instance
        .collection("tasks")
        .snapshots();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: FutureBuilder<String>(
          future: getTitle(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("My firebase test app");
            }
            return Text(snapshot.data ?? 'My Firebase Test App');
          },
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: tasksStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return HomeScreenCard(
                    title: snapshot.data!.docs[index]['title'],
                    subtitle: snapshot.data!.docs[index]['subTitle'],
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width,
              height: 80,
              // color: Colors.white,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BnbCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.6,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AddItemFullScreen();
                            },
                          ),
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.orange[500],
                      elevation: 0.1,
                      child: Icon(Icons.add_circle_outline),
                    ),
                  ),
                  Container(
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            FirebaseAnalytics.instance.logEvent(
                              name: 'bottom_navigation_tap',
                              parameters: {'index': 0},
                            );
                          },
                          icon: Icon(Icons.home),
                        ),
                        IconButton(
                          onPressed: () {
                            FirebaseAnalytics.instance.logEvent(
                              name: 'bottom_navigation_tap',
                              parameters: {'index': 1},
                            );
                          },
                          icon: Icon(Icons.business),
                        ),
                        Container(width: size.width * 0.20),
                        IconButton(
                          onPressed: () {
                            FirebaseAnalytics.instance.logEvent(
                              name: 'bottom_navigation_tap',
                              parameters: {'index': 2},
                            );
                          },
                          icon: Icon(Icons.school),
                        ),
                        IconButton(
                          onPressed: () {
                            FirebaseAnalytics.instance.logEvent(
                              name: 'bottom_navigation_tap',
                              parameters: {'index': 3},
                            );
                          },
                          icon: Icon(Icons.settings),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
