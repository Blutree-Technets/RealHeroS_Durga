import 'dart:io';
import 'package:audioplayer/audioplayer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:realheros_durga/Maps/emergency.dart';
import 'package:realheros_durga/data_models/NearbyDare.dart';
import 'package:realheros_durga/data_models/appdata.dart';
import 'package:realheros_durga/data_models/darehelper.dart';
import 'package:realheros_durga/data_models/global_variables.dart';
import 'package:slider_button/slider_button.dart';

class SlideButton extends StatefulWidget {
  @override
  _SlideButtonState createState() => _SlideButtonState();
}

enum PlayerState { stopped, playing, paused }

class _SlideButtonState extends State<SlideButton> {
  @override
  void initState() {
    _loadSound();
    _getUserName();
    super.initState();
  }

  String _userName;
  String phoneNumber;

  Future<void> _getUserName() async {
    FirebaseFirestore.instance
        .collection('DURGA')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        _userName = value.data()['fullname'].toString();
        phoneNumber = value.data()['phoneNumber'].toString();
      });
    });
  }

  // Add Phone Number
  void createRequest(context) {
    requestRef = FirebaseDatabase.instance
        .reference()
        .child('Request/${currentUser.uid}');
    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;

    Map locationMap = {
      'latitude': pickup.latitude.toString(),
      'longitude': pickup.longitude.toString(),
    };
    Map requestMap = {
      'created_at': DateTime.now().toString(),
      'request_name': '$_userName',
      'location_address': pickup.placeName,
      'location': locationMap,
      'request_phone': '$phoneNumber',
      'status': 'waiting',
    };

    requestRef.set(requestMap);
  }

  String mp3uri = '';
  bool songplaying = false;

  void _loadSound() async {
    final ByteData data = await rootBundle.load('assets/Police Siren.mp3');
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/Police Siren.mp3');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    mp3uri = tempFile.uri.toString();
  }

  void playSound() {
    AudioPlayer player = AudioPlayer();
    if (!songplaying) {
      player.play(mp3uri);
    } else {
      player.pause();
    }
    songplaying = songplaying;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.all(5.0),
      padding:
          const EdgeInsets.only(left: 12.0, top: 5.0, bottom: 5.0, right: 12.0),
      child: SliderButton(
        action: () {
          playSound();
          createRequest(context);

          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => new EmergencyPage()));
        },
        backgroundColor: Colors.amber[600],
        alignLabel: Alignment.center,
        dismissible: false,
        baseColor: Colors.red[900],
        buttonColor: Colors.white,
        buttonSize: 55,
        label: Text(
          "Slide for Emergency",
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.red),
        ),
        icon: Center(
          child: Icon(Icons.health_and_safety_sharp,
              color: Colors.amber[800], size: 30.0),
        ),
        boxShadow: BoxShadow(spreadRadius: 1.5, color: Colors.red[900]),
      ),
    );
  }
}
