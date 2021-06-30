import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as locations;
import 'package:realheros_durga/data_models/global_variables.dart';
import 'package:realheros_durga/data_models/mapKitHelper.dart';
import 'package:realheros_durga/data_models/requestDetails.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:realheros_durga/data_models/webmethods.dart';
import 'package:realheros_durga/helpers/CongDialog.dart';
import 'package:realheros_durga/helpers/thankYouDialog.dart';

class DareMap extends StatefulWidget {
  final RequestDetails requestDetails;
  DareMap({this.requestDetails});
  @override
  _DareMapState createState() => _DareMapState();
}

class _DareMapState extends State<DareMap> {
  final RequestDetails requestDetails;
  _DareMapState({this.requestDetails});
  GoogleMapController dareMapController;
  Completer<GoogleMapController> _controller = Completer();

  double mapPaddingBottom = 0;
  MapType _currentMapType = MapType.normal;
  LatLng _center;
  locations.Location location = new locations.Location();

  Set<Marker> _markers = Set<Marker>();
  Set<Circle> _circles = Set<Circle>();
  Set<Polyline> _polylines = Set<Polyline>();

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = new PolylinePoints();

  Position myposition;
  var geolocator = Geolocator();
  BitmapDescriptor nearbyIcon;

  String status = 'accepted';
  String durationString = '';
  bool isRequestingDirection = false;

  @override
  void initState() {
    super.initState();
    acceptRequest();
    getUserLocation();
  }

  Future<void> getUserLocation() async {
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    LatLng positionLatLng =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    LatLng destinationLatLng = widget.requestDetails.location;
    var directionDetails = await WebMethods.getDirectionalDetails(
        positionLatLng, destinationLatLng);
    if (directionDetails != null) {
      setState(() {
        durationString = directionDetails.durationText;
      });
    }
    setState(() {
      _center = LatLng(currentPosition.latitude, currentPosition.longitude);
    });
  }

  void createmarker() {
    if (nearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        'assets/Picture1.png',
      ).then((icon) {
        nearbyIcon = icon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    createmarker();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Request Details',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: Stack(
        children: [
          _center == null
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.red[900]),
                    backgroundColor: Colors.white,
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    padding: EdgeInsets.only(bottom: mapPaddingBottom),
                    mapType: _currentMapType,
                    //markers: _Markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    scrollGesturesEnabled: true,
                    mapToolbarEnabled: true,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    circles: _circles,
                    markers: _markers,
                    polylines: _polylines,
                    cameraTargetBounds: CameraTargetBounds.unbounded,
                    compassEnabled: true,
                    onMapCreated: (GoogleMapController controller) async {
                      _controller.complete(controller);
                      dareMapController = controller;

                      Position currentPosition1 =
                          await Geolocator.getCurrentPosition(
                              desiredAccuracy:
                                  LocationAccuracy.bestForNavigation);
                      setState(() {
                        mapPaddingBottom = (Platform.isAndroid) ? 260 : 260;
                      });

                      var currentLatLng = LatLng(currentPosition1.latitude,
                          currentPosition1.longitude);
                      var locationLatLng = widget.requestDetails.location;

                      await getDirection(currentLatLng, locationLatLng);

                      getLocationUpdate();
                    },
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 15.0,
                    ),
                  ),
                ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE65100),
                    Color(0xFFE65100),
                    Color(0xFFC62828),
                    Color(0xFFC62828),
                  ],
                  stops: [0.1, 0.4, 0.7, 0.9],
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red[900],
                    blurRadius: 15.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.5, 0.5),
                  ),
                ],
              ),
              height: 265,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      durationString,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      'Request Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 18.0,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              '${widget.requestDetails.request_name}',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 18.0,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              '${widget.requestDetails.location_address} ',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: TextButton(
                                child: Text('Request Completed',
                                    style: TextStyle(
                                        color: Colors.red[900],
                                        fontWeight: FontWeight.bold)),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.amber[700])),
                                onPressed: () async {
                                  endRequest();
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Expanded(
                            child: Container(
                              child: TextButton(
                                child: Text('Call',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                style: ButtonStyle(
                                    enableFeedback: true,
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.green[700])),
                                onPressed: () async {
                                  FlutterPhoneDirectCaller.callNumber(
                                      widget.requestDetails.request_phone);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void endRequest() async {
    dareRef.child('status').set('Request ended');

    darePositionStream.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => new CongDialog(),
    );
  }

  void acceptRequest() {
    String dareId = widget.requestDetails.dareID;

    dareRef = FirebaseDatabase.instance.reference().child('Request/$dareId');

    DatabaseReference dareRef1 =
        FirebaseDatabase.instance.reference().child('Request/$dareId/status');
    dareRef1.once().then((DataSnapshot snapshot) {
      if (snapshot.value != 'accepted') {
        dareRef.child('status').set('accepted');
        dareRef.child('dare_name').set('${currentDareInfo.darename}');
        dareRef.child('dare_phone_number').set('${currentDareInfo.phone}');
        dareRef.child('dare_id').set('${currentDareInfo.id}');

        Map dare_location = {
          'latitude': currentPosition.latitude.toString(),
          'longitude': currentPosition.longitude.toString(),
        };

        dareRef.child('dare_location').set(dare_location);

        DatabaseReference historyRef = FirebaseDatabase.instance
            .reference()
            .child('Dare_Details/${currentUser.uid}/History/$dareId');

        historyRef.set(true);
      }
      else{
        showDialog(context: context, barrierDismissible:false,
        builder: (BuildContext context) => new ThankyouDialog(),);
      }
    });
  }

  void getLocationUpdate() {
    LatLng oldPosition = LatLng(0, 0);

    darePositionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.bestForNavigation)
        .listen((Position position) {
      myposition = position;
      currentPosition = position;
      LatLng positionLatLng = LatLng(position.latitude, position.longitude);

      var rotation = MapKitHelper.getMarkerRotation(
          oldPosition.latitude,
          oldPosition.longitude,
          positionLatLng.latitude,
          positionLatLng.longitude);
      Marker movingMarker = Marker(
        markerId: MarkerId('movingMarker'),
        position: positionLatLng,
        icon: nearbyIcon,
        rotation: rotation,
        infoWindow: InfoWindow(title: 'CURRENT LOCATION'),
      );

      setState(() {
        CameraPosition cp =
            new CameraPosition(target: positionLatLng, zoom: 17);
        dareMapController.animateCamera(CameraUpdate.newCameraPosition(cp));

        _markers.remove(movingMarker);
        _markers.add(movingMarker);
      });

      oldPosition = positionLatLng;
      updateDareLocationDetails();

      Map locationMap = {
        'latitude': myposition.latitude.toString(),
        'longitude': myposition.longitude.toString(),
      };
      dareRef.child('dare_location').set(locationMap);
    });
  }

  void updateDareLocationDetails() async {
    if (!isRequestingDirection) {
      isRequestingDirection = true;
      if (myposition == null) {
        return;
      }
      var positionLatLng = LatLng(myposition.latitude, myposition.longitude);
      LatLng destinationLatLng;
      if (status == 'accepted') {
        destinationLatLng = widget.requestDetails.location;
      } else {
        print('not yet accepted request');
      }

      var directionDetails = await WebMethods.getDirectionalDetails(
          positionLatLng, destinationLatLng);
      if (directionDetails != null) {
        setState(() {
          durationString = directionDetails.durationText;
        });
      }
    }
    isRequestingDirection = false;
  }

  // should add ProgressDialog Indicator
  Future<void> getDirection(LatLng currentLatLng, LatLng locationLatLng) async {
    var thisDetails =
        await WebMethods.getDirectionalDetails(currentLatLng, locationLatLng);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails.encodedPoints);

    polylineCoordinates.clear();
    if (results.isNotEmpty) {
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    _polylines.clear();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyid'),
        color: Color.fromARGB(255, 95, 109, 237),
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      _polylines.add(polyline);
    });

    LatLngBounds bounds;

    if (currentLatLng.latitude > locationLatLng.latitude &&
        currentLatLng.longitude > locationLatLng.longitude) {
      bounds =
          LatLngBounds(southwest: locationLatLng, northeast: currentLatLng);
    } else if (currentLatLng.longitude > locationLatLng.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(currentLatLng.latitude, locationLatLng.longitude),
          northeast: LatLng(locationLatLng.latitude, currentLatLng.longitude));
    } else if (currentLatLng.latitude > locationLatLng.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(locationLatLng.latitude, currentLatLng.longitude),
          northeast: LatLng(currentLatLng.latitude, locationLatLng.longitude));
    } else {
      bounds =
          LatLngBounds(southwest: currentLatLng, northeast: locationLatLng);
    }

    dareMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker currentMarker = Marker(
      markerId: MarkerId('current'),
      position: currentLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker locationMarker = Marker(
      markerId: MarkerId('location'),
      position: locationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers.add(currentMarker);
      _markers.add(locationMarker);
    });

    Circle currentCircle = Circle(
      circleId: CircleId('current'),
      strokeColor: Colors.green,
      strokeWidth: 4,
      radius: 12,
      center: currentLatLng,
      fillColor: Colors.green,
    );

    Circle locationCircle = Circle(
        circleId: CircleId('location'),
        strokeColor: Colors.red,
        strokeWidth: 4,
        radius: 12,
        center: locationLatLng,
        fillColor: Colors.red);

    setState(() {
      _circles.add(currentCircle);
      _circles.add(locationCircle);
    });
  }
}
