import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realheros_durga/Authentication/StartUp.dart';
import 'package:realheros_durga/Home/Home.dart';
import 'package:realheros_durga/helpers/pushnotificationservice.dart';

import 'data_models/appdata.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      projectId: 'wsd-c9257',
      appId: '1:517676880304:android:1517e6dc3ecc2e773bc675',
      apiKey: 'AIzaSyAHs-OqTZ_P8h2BvbH3WvjtsdAaTMTwwk8',
      messagingSenderId: '517676880304',
      // googleAppID: '1:517676880304:android:1517e6dc3ecc2e773bc675',
      // apiKey: 'AIzaSyAZp_tCNZIB6DR97NByBoLcwgNnw0TEEqE',
      // databaseURL: 'https://wsd-c9257.firebaseio.com',
    ),
  );
  FirebaseMessaging.onBackgroundMessage(backGroundMessage);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: new StartUp(),
          routes: <String, WidgetBuilder>{
            '/home': (BuildContext context) => wsd(title: 'Home'),
          }),
    );
  }
}
