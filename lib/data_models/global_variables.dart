import 'dart:async';

import 'package:audioplayer/audioplayer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:realheros_durga/data_models/dareDetails.dart';

DatabaseReference requestRef;
User currentUser;
DatabaseReference dareLocRef;
DatabaseReference dareDetailsRef;
Position currentPosition;
DatabaseReference dareRef;

String serverkey =
    "key=AAAAeIfyUbA:APA91bEhI34_c2yLFSnkG6rJYpktfi3DK7YwX7bLP8yM2ZjFAq7iJCnT_Czh5LIFlTj8iEnZup4ULvrWSFev5ji2RpdpcIqLuBQFHtI2gPmVdaeBflSVcbSgd1SIyilup9vwbQLPzykc";

Future getCurrentUser() async {
  currentUser = FirebaseAuth.instance.currentUser;
  return currentUser != null ? currentUser.uid : CircularProgressIndicator();
}

StreamSubscription<Position> homeTabPositionStream;

StreamSubscription<Position> darePositionStream;

StreamSubscription<Position> dashboardPositionStream;

class NotiKeys {
  static final notiKey1 = GlobalKey();
}

AudioPlayer audioPlayer = new AudioPlayer();

DareDetails currentDareInfo;

final CameraPosition googleplex =
    CameraPosition(target: LatLng(12.967638, 77.52363), zoom: 14.4746);
