import 'dart:convert';
import 'dart:math';

import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:provider/provider.dart';
import 'package:realheros_durga/data_models/DirectionDetails.dart';
import 'package:realheros_durga/data_models/address.dart';
import 'package:realheros_durga/data_models/appdata.dart';
import 'package:realheros_durga/data_models/global_variables.dart';
import 'package:realheros_durga/data_models/webrequest.dart';
import 'package:http/http.dart' as http;

class WebMethods {
  static Future<String> findCordinateAddress(
      LocationData position, context, String _userName) async {
    String placeAddress = '';

    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyAHs-OqTZ_P8h2BvbH3WvjtsdAaTMTwwk8');
    var response = await WebRequest.getRequest(url);

    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];

      Address pickupAddress = new Address();
      pickupAddress.longitude = position.longitude;
      pickupAddress.latitude = position.latitude;
      pickupAddress.placeName = placeAddress;
      pickupAddress.name = _userName;

      Provider.of<AppData>(context, listen: false)
          .updatePickupAddress(pickupAddress);
    } else {
      return 'failed';
    }

    return placeAddress;
  }

  static Future<DirectionDetails> getDirectionalDetails(
      LatLng startPosition, LatLng endPosition) async {
    var url = Uri.parse(
        "https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=AIzaSyAHs-OqTZ_P8h2BvbH3WvjtsdAaTMTwwk8");
    var response = await WebRequest.getRequest(url);

    if (response == 'failed') {
      return null;
    }

    DirectionDetails directionDetails = new DirectionDetails();

    directionDetails.durationText =
        response['routes'][0]['legs'][0]['duration']['text'];

    directionDetails.durationValue =
        response['routes'][0]['legs'][0]['duration']['value'];
    directionDetails.distanceText =
        response['routes'][0]['legs'][0]['distance']['text'];

    directionDetails.distanceValue =
        response['routes'][0]['legs'][0]['distance']['value'];
    directionDetails.encodedPoints =
        response['routes'][0]['overview_polyline']['points'];

    return directionDetails;
  }

  static void disablehomeTabLocationUpdates() {
    homeTabPositionStream.pause();
    Geofire.removeLocation('${currentUser.uid}');
  }

  static void enablehometabLocationUpdates() {
    homeTabPositionStream.resume();
    Geofire.setLocation(
        currentUser.uid, currentPosition.latitude, currentPosition.longitude);
  }

  static sendNotification(String token, context, String requestID) async {
    var name = Provider.of<AppData>(context, listen: false).pickupAddress;
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverkey,
    };

    Map notificationMap = {
      "title": "EMERGENCY",
      "body": "${name.name} is Requesting for help.."
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'dare_id': requestID,
    };

    Map bodyMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token,
    };
    var url1 = Uri.parse('https://fcm.googleapis.com/fcm/send');

    var response =
        await http.post(url1, headers: headerMap, body: jsonEncode(bodyMap));

    print(response.body);
  }
}
