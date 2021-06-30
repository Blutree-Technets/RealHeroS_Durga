import 'dart:async';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:realheros_durga/data_models/NearbyDare.dart';
import 'package:realheros_durga/data_models/appdata.dart';
import 'package:realheros_durga/data_models/darehelper.dart';
import 'package:realheros_durga/data_models/global_variables.dart';
import 'package:realheros_durga/data_models/webmethods.dart';
import 'package:realheros_durga/helpers/NoDaresDialog.dart';

class EmergencyPage extends StatefulWidget {
  EmergencyPage({
    Key key,
  }) : super(key: key);

  @override
  _EmergencyPageState createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  GoogleMapController emergencycontroller;
  Completer<GoogleMapController> _controller = Completer();
  MapType _currentMapType = MapType.normal;
  Location location = new Location();
  LatLng _center;
  double requestDetailSheetHeight = (Platform.isAndroid) ? 195 : 220;
  double mapBottomPaddding = 0;
  double requestSheetheight = 0;

  // ignore: non_constant_identifier_names
  Set<Marker> _Markers = {};
  // ignore: non_constant_identifier_names
  Set<Circle> _Circles = {};
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = new PolylinePoints();

  List<NearByDare> availableDares;

  StreamSubscription<Event> dareSubscription;

  String status = '';
  String darenameDetails = '';
  String dareNumber = '';
  String dareTime = '';
  bool isRequestingLatLngDetails = false;
  @override
  void initState() {
    //setupPositionLocator(context);
    getUserLocation();
    currentLatLng(context);
    createRequest();
    availableDares = DareHelper.nearByDareList;

    super.initState();
  }

  getUserLocation() async {
    var currentLocation = await location.getLocation();
    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    emergencycontroller = controller;
    setState(() {
      mapBottomPaddding = (Platform.isAndroid) ? 195 : 190;
    });
    findDares();
  }

  void currentLatLng(context) {
    var currentLoc = Provider.of<AppData>(context, listen: false).pickupAddress;
    LatLng loc = LatLng(currentLoc.latitude, currentLoc.longitude);
    Marker currentLocation = Marker(
      markerId: MarkerId('currentLocation'),
      position: loc,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
          title: currentLoc.placeName,
          onTap: () {
            showAlertDailogMarker(context);
          }),
    );
    setState(() {
      _Markers.add(currentLocation);
    });

    Circle currentLocationCircle = Circle(
      circleId: CircleId('currentLocationCircle'),
      strokeColor: Colors.green[700],
      strokeWidth: 5,
      radius: 15,
      center: loc,
      fillColor: Colors.green[700],
    );
    setState(() {
      _Circles.add(currentLocationCircle);
    });
  }

  showAlertDailogMarker(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text(
        'INFORMATION',
        style: TextStyle(color: Colors.black),
      ),
      content: Text(
        'This Location Is Recorded For Requesting Help',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      //backgroundColor: Colors.white,
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.amber[600]),
            ),
            child: Text(
              'OK',
              style: TextStyle(color: Colors.red[900]),
            ))
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void cancelRequest() {
    requestRef.remove();
    setState(() {
      _Markers.clear();
      _Circles.clear();
    });
  }

  void noDareFound() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => new NoDaresDialog());
  }

  void findDares() {
    if (availableDares.length == 0) {
      noDareFound();
    }
    for (int i = 0; i < availableDares.length; i++) {
      var dare = availableDares[i];
      notifyDares(dare);
      availableDares.removeAt(i);
      print(dare.key);
    }
  }

  void notifyDares(NearByDare dare) {
    DatabaseReference darehelpRef = FirebaseDatabase.instance
        .reference()
        .child('Dare_Details/${dare.key}/Help_Request');

    darehelpRef.set(requestRef.key);

    DatabaseReference tokenRef = FirebaseDatabase.instance
        .reference()
        .child('Dare_Details/${dare.key}/token');

    tokenRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        String token = snapshot.value.toString();

        WebMethods.sendNotification(token, context, requestRef.key);
      }
    });
  }

  showRequestSheet() {
    setState(() {
      requestDetailSheetHeight = 0;
      requestSheetheight = (Platform.isAndroid) ? 195 : 220;
      mapBottomPaddding = (Platform.isAndroid) ? 200 : 190;
    });
  }

  void createRequest() {
    requestRef = FirebaseDatabase.instance
        .reference()
        .child('Request/${currentUser.uid}');

    dareSubscription = requestRef.onValue.listen((event) {
      if (event.snapshot.value == null) {
        return;
      }

      if (event.snapshot.value['dare_name'] != null) {
        setState(() {
          darenameDetails = event.snapshot.value['dare_name'].toString();
        });
      }
      if (event.snapshot.value['dare_phone_number'] != null) {
        setState(() {
          dareNumber = event.snapshot.value['dare_phone_number'].toString();
        });
      }

      if (event.snapshot.value['dare_location'] != null) {
        setState(() {
          double dareLat = double.parse(
            event.snapshot.value['dare_location']['latitude'].toString(),
          );
          double dareLng = double.parse(
            event.snapshot.value['dare_location']['longitude'].toString(),
          );
          LatLng dareLocation = LatLng(dareLat, dareLng);
          var currentLoc =
              Provider.of<AppData>(context, listen: false).pickupAddress;
          LatLng loc = LatLng(currentLoc.latitude, currentLoc.longitude);

          if (status == 'accepted') {
            updateDareLoc(dareLocation);
            getDirection(loc, dareLocation);
          }
        });
      }

      if (event.snapshot.value['status'] != null) {
        setState(() {
          status = event.snapshot.value['status'].toString();
        });
      }

      if (status == 'accepted') {
        showRequestSheet();
      }
    });
  }

  void updateDareLoc(LatLng dareloc) async {
    if (!isRequestingLatLngDetails) {
      isRequestingLatLngDetails = true;
      var currentLoc =
          Provider.of<AppData>(context, listen: false).pickupAddress;
      LatLng loc = LatLng(currentLoc.latitude, currentLoc.longitude);

      var thisDetails = await WebMethods.getDirectionalDetails(dareloc, loc);

      if (thisDetails != null) {
        setState(() {
          dareTime = '${thisDetails.durationText}';
        });
      } else {
        return;
      }
    }
    isRequestingLatLngDetails = true;
  }

  final colorizeColors = [
    Colors.white,
    Colors.amber[700],
    Colors.red[900],
    Colors.black,
  ];

  final colorizeTextStyle = TextStyle(
    fontSize: 25.0,
    fontFamily: 'Horizon',
  );

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Emergency',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        alignment: Alignment.centerRight,
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
                    padding: EdgeInsets.only(bottom: mapBottomPaddding),
                    mapType: _currentMapType,
                    myLocationEnabled: true,
                    scrollGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    cameraTargetBounds: CameraTargetBounds.unbounded,
                    compassEnabled: true,
                    onMapCreated: _onMapCreated,
                    markers: _Markers,
                    circles: _Circles,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 15.0,
                    ),
                  ),
                ),

          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: AnimatedContainer(
              duration: new Duration(milliseconds: 8000),
              curve: Curves.easeIn,
              child: Container(
                height: requestDetailSheetHeight,
                width: double.infinity,
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
                  border: Border.all(width: 1.0, color: Colors.grey),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black45,
                        blurRadius: 20.0,
                        spreadRadius: 1.0,
                        offset: Offset(1.0, 1.0)),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: SizedBox(
                          width: 250.0,
                          child: Center(
                            child: AnimatedTextKit(
                              pause: Duration(milliseconds: 100),
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  'Requesting For Help...',
                                  textStyle: colorizeTextStyle,
                                  colors: colorizeColors,
                                  speed: Duration(milliseconds: 100),
                                ),
                              ],
                              isRepeatingAnimation: true,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          cancelRequest();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 35,
                            color: Colors.amber[700],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          'Cancel Request',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedContainer(
                  duration: Duration(seconds: 10),
                  curve: Curves.easeIn,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)),
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
                    ),
                    height: requestSheetheight,
                    width: double.infinity,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 2.0,
                          ),
                          Text('Dare is Arriving!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'Estimated time of Arrival: $dareTime',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text('$darenameDetails',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              FlutterPhoneDirectCaller.callNumber(dareNumber);
                            },
                            child: Container(
                              height: 50.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.white,
                              ),
                              child: Icon(Icons.call, color: Colors.amber[800]),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Call",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )))

          // ),
        ],
      ),
    );
  }

  Future<void> getDirection(LatLng currentLatLng, LatLng locationLatLng) async {
    var thisDetails =
        await WebMethods.getDirectionalDetails(currentLatLng, locationLatLng);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails.encodedPoints);
    print(results);

    polylineCoordinates.clear();
    if (results.isNotEmpty) {
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        print(polylineCoordinates);
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

    emergencycontroller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker currentMarker = Marker(
      markerId: MarkerId('current'),
      position: currentLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    Marker locationMarker = Marker(
      markerId: MarkerId('dare'),
      position: locationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    setState(() {
      _Markers.add(currentMarker);
      _Markers.add(locationMarker);
    });

    Circle currentCircle = Circle(
      circleId: CircleId('current'),
      strokeColor: Colors.red,
      strokeWidth: 4,
      radius: 12,
      center: currentLatLng,
      fillColor: Colors.red,
    );

    Circle locationCircle = Circle(
        circleId: CircleId('dare'),
        strokeColor: Colors.green,
        strokeWidth: 4,
        radius: 12,
        center: locationLatLng,
        fillColor: Colors.green);

    setState(() {
      _Circles.add(currentCircle);
      _Circles.add(locationCircle);
    });
  }
}
