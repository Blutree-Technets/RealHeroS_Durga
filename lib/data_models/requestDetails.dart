import 'package:google_maps_flutter/google_maps_flutter.dart';

//add Phone Number
class RequestDetails {
  String request_name;
  String location_address;
  LatLng location;
  String dareID;
  String request_phone;

  RequestDetails(
      {this.request_name,
      this.location_address,
      this.location,
      this.dareID,
      this.request_phone});
}
