import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realheros_durga/data_models/global_variables.dart';
import 'package:realheros_durga/data_models/requestDetails.dart';
import 'package:realheros_durga/data_models/webmethods.dart';
import 'package:realheros_durga/helpers/NotificationDialog.dart';

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  Future initialize(context) async {
    //foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage: $message");
      fetchDareInfo(getdareID(message), context);
    });
    //background[not terminated]
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessage: $message");
      fetchDareInfo(getdareID(message), context);
    });
  }

  Future<String> getToken() async {
    String token = await fcm.getToken();
    print('token: $token');

    DatabaseReference tokenref = FirebaseDatabase.instance
        .reference()
        .child('Dare_Details/${currentUser.uid}/token');
    tokenref.set('$token');
    //to sen to all
    fcm.subscribeToTopic('Dare_Details');
    fcm.subscribeToTopic('Request');
  }

  static String getdareID(RemoteMessage message) {
    if (Platform.isAndroid) {
      String dareID = message.data['dare_id'];
      if (dareID == currentUser.uid) {
        return null;
      }
      return dareID;
    }
  }

  // progressIndicator
  // Add Phone Number
  static void fetchDareInfo(String dareID, context) async {
    if (dareID != null) {
      String mp3uri = '';
      String duration = '';
      String distance = '';
      DatabaseReference dareRef =
          FirebaseDatabase.instance.reference().child('Request/$dareID');

      final ByteData data = await rootBundle.load('assets/alert.mp3');
      Directory tempDir = await getTemporaryDirectory();
      File tempFile = File('${tempDir.path}/alert.mp3');
      await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
      mp3uri = tempFile.uri.toString();

      audioPlayer.play(mp3uri);

      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      var currentLatLng =
          LatLng(currentPosition.latitude, currentPosition.longitude);

      dareRef.once().then((DataSnapshot snapshot) async {
        if (snapshot.value != null) {
          double locationLat =
              double.parse(snapshot.value['location']['latitude'].toString());
          double locationLng =
              double.parse(snapshot.value['location']['longitude'].toString());
          String locationAddress =
              snapshot.value['location_address'].toString();
          String name = snapshot.value['request_name'].toString();
          String phone_number = snapshot.value['request_phone'].toString();
          RequestDetails requestDetails = new RequestDetails();
          requestDetails.location = LatLng(locationLat, locationLng);
          requestDetails.location_address = locationAddress;
          requestDetails.request_name = name;
          requestDetails.dareID = dareID;
          requestDetails.request_phone = phone_number;
          print('${requestDetails.location_address}');
          var locationLatLng = requestDetails.location;

          var thisDetails = await WebMethods.getDirectionalDetails(
              currentLatLng, locationLatLng);

          if (thisDetails != null) {
            duration = thisDetails.durationText;
            distance = thisDetails.distanceText;
          }

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => new NotificationDialog(
              requestDetails: requestDetails,
              duration: duration,
              distance: distance,
            ),
          );
        } else {
          print('null2222');
        }
      });
    }
  }
}

// progressIndicator
//check here
//terminated
Future<void> backGroundMessage(
  RemoteMessage message,
) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  print('message: $message');

  PushNotificationService.fetchDareInfo(
      PushNotificationService.getdareID(message), context);
}
