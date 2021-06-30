import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:realheros_durga/Home/slide_button.dart';
import 'package:realheros_durga/Drawer/Side_Drawer.dart';
import 'package:realheros_durga/data_models/NearbyDare.dart';
import 'package:realheros_durga/data_models/dareDetails.dart';
import 'package:realheros_durga/data_models/darehelper.dart';
import 'package:realheros_durga/data_models/global_variables.dart';
import 'package:realheros_durga/data_models/appdata.dart';
import 'package:realheros_durga/data_models/webmethods.dart';
import 'package:realheros_durga/helpers/pushnotificationservice.dart';
import 'package:location/location.dart' as locations;
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  final String uid;
  Dashboard({Key key, @required this.uid}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  GlobalKey<ScaffoldState> scaffoldKey1 = new GlobalKey<ScaffoldState>();
  GoogleMapController mapController;

  String token = '';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String _userName1;
  String phoneNumber;
  String _email;
  Completer<GoogleMapController> _controller = Completer();
  locations.Location location = new locations.Location();
  MapType _currentMapType = MapType.normal;
  Set<Marker> _Markers = {};
  Set<Marker> _Markers1 = {};
  bool nearByDareKeysLoaded = false;

  BitmapDescriptor nearbyIcon;
  bool GeoFireStart = false;
  bool value1 = false;
  double mapBottomPaddding = 0;

  Stream<dynamic> query;
  StreamSubscription subscription;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  @override
  void initState() {
    getCurrentUser();
    getToken();
    dareInfo();
    _getUserName1();
    getCurrentDareInfo(context);
    getUserLocation();
    startGeofireListener();

    AppData();
    super.initState();
  }

  void getUserLocation() async {
    // Position currentPosition2 = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.bestForNavigation,
    //     forceAndroidLocationManager: true);
    // print('gojja1');
    var location1 = await location.getLocation();
    print(location1);

    LatLng pos = LatLng(location1.latitude, location1.longitude);
    print('pos:$pos');

    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    String address =
        await WebMethods.findCordinateAddress(location1, context, _userName1);
    print(address);

    startGeofireListener();
  }

  void dareInfo() async {
    await FirebaseFirestore.instance
        .collection('DURGA')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        _userName1 = value.data()['fullname'].toString();
        phoneNumber = value.data()['phoneNumber'].toString();
        _email = value.data()['email'].toString();
        print(_userName1);
      });
    });

    dareDetailsRef = FirebaseDatabase.instance
        .reference()
        .child('Dare_Details/${currentUser.uid}');
    Map dareMap = {
      'created_at': DateTime.now().toString(),
      'Dare_name': '$_userName1',
      'Help_Request': 'waiting',
      //'History': '',
      'Dare_id': '${currentUser.uid}',
      'token': '$token',
      'dare_Phone_Number': '$phoneNumber',
    };

    dareDetailsRef.set(dareMap);
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    mapController = controller;
    getUserLocation();
    //safeZonemarkers();
    startGeofireListener();
    //showAlertDailog(context);
    setState(() {
      mapBottomPaddding = (Platform.isAndroid) ? 190 : 190;
      dareModeLocationOn(context);
      dareModeLocationUpdate();
    });
  }

  void getCurrentDareInfo(context) async {
    currentUser = FirebaseAuth.instance.currentUser;
    PushNotificationService pushNotificationService = PushNotificationService();

    DatabaseReference initdareRef = FirebaseDatabase.instance
        .reference()
        .child('Dare_Details/${currentUser.uid}');

    initdareRef.once().then((DataSnapshot snapshot) {
      if (snapshot != null) {
        currentDareInfo = DareDetails.fromSnapshot(snapshot);
      }
    });

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();
  }

  Future<void> getToken() async {
    token = await firebaseMessaging.getToken();
    print('$token');
    return FirebaseFirestore.instance
        .collection('DURGA')
        .doc(currentUser.uid)
        .update({'FCM-token': token});
  }
// Future<void> upDateLocation() async {
//     location.onLocationChanged.listen((locations.LocationData cLoc) {
//       currentLocation = cLoc;
//     });
//   }

  Future<void> _getUserName1() async {
    await FirebaseFirestore.instance
        .collection('DURGA')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        _userName1 = value.data()['fullname'].toString();
        _email = value.data()['email'].toString();
      });
    });
  }

  showAlertDailog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text('Coming Soon!!'),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Center(child: Text('This Feature Is Not Yet Activated'))]),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
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

  void dareModeLocationOn(context) async {
    Geofire.initialize("Dares");
    var current = Provider.of<AppData>(context, listen: false).pickupAddress;

    Geofire.setLocation((currentUser.uid), current.latitude, current.longitude);
  }

  void dareModeLocationUpdate() {
    homeTabPositionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 4)
        .listen((Position position) {
      currentPosition = position;
      Geofire.setLocation(
          currentUser.uid, position.latitude, position.longitude);
    });
  }

  Future<void> startGeofireListener() async {
    Geofire.initialize("Dares");
    var current = Provider.of<AppData>(context, listen: false).pickupAddress;
    try {
      Geofire.queryAtLocation(current.latitude, current.longitude, 100)
          .listen((map) {
        print(map);
        if (map != null) {
          var callBack = map['callBack'];

          //latitude will be retrieved from map['latitude']
          //longitude will be retrieved from map['longitude']

          switch (callBack) {
            case Geofire.onKeyEntered:
              if (nearByDareKeysLoaded) {
                NearByDare nearByDare = new NearByDare();
                nearByDare.key = map['key'];
                nearByDare.latitude = map['latitude'];
                nearByDare.longitude = map['longitude'];
                DareHelper.nearByDareList.add(nearByDare);

                updateDaresOnMap();
              }
              break;

            case Geofire.onKeyExited:
              NearByDare nearByDare = new NearByDare();
              nearByDare.key = map['key'];
              DareHelper.removeFromList(nearByDare);
              updateDaresOnMap();
              break;

            case Geofire.onKeyMoved:
              NearByDare nearByDare = new NearByDare();
              nearByDare.key = map['key'];
              nearByDare.latitude = map['latitude'];
              nearByDare.longitude = map['longitude'];
              DareHelper.updatenearByLocation(nearByDare);

              updateDaresOnMap();
              break;

            case Geofire.onGeoQueryReady:
              nearByDareKeysLoaded = true;
              print(map['result']);
              print('darehelper_length : ${DareHelper.nearByDareList.length}');
              updateDaresOnMap();

              break;
          }
        }

        setState(() {});
      }).onError((error) {
        print(error);
      });
    } on PlatformException {}

    if (!mounted) return;
  }

  void safeZonemarkers() {
    firestore
        .collection('SafeZoneLocation')
        .get()
        .then((QuerySnapshot document) {
      var doc1 = document.docs.length;
      print('document:$doc1');
      document.docs.forEach((DocumentSnapshot doc) {
        print('safezone:$doc');
        var data = doc.get('name');
        print('name:$data');
        var pos = doc.get('position');
        GeoPoint pos1 = pos['geopoint'];
        print('loc:${pos1.latitude}');
        var safemarker = Marker(
          markerId: MarkerId('safeZones'),
          position: LatLng(pos1.latitude, pos1.longitude),
          infoWindow: InfoWindow(title: '$data'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        );
        _Markers.add(safemarker);
      });
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

  void updateDaresOnMap() {
    setState(() {
      _Markers.clear();
    });

    Set<Marker> tempmarkers = Set<Marker>();
    for (NearByDare dare in DareHelper.nearByDareList) {
      LatLng dareLoc = LatLng(dare.latitude, dare.longitude);

      Marker thisMarker = Marker(
        markerId: MarkerId('dare${dare.key}'),
        position: dareLoc,
        icon: nearbyIcon,
        //rotation: DareHelper.generateRandomNumber(360),
        anchor: Offset(1.0, 1.0),
      );
      tempmarkers.add(thisMarker);
      if (DareHelper.nearByDareList.length > 100) {
        break;
      }
    }
    setState(() {
      _Markers = tempmarkers;
    });
  }

  @override
  Widget build(BuildContext context) {
    createmarker();

    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey1,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Home",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        actions: [
          SizedBox(height: 40, width: 60),
          TextButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.black),
            ),
            onPressed: () {
              showAlertDailog(context);
            },
            child: Row(
              children: [
                Icon(
                  Icons.attach_money_rounded,
                  color: Colors.amber,
                ),
                Text(
                  '000',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(width: 8.0),
              ],
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              GoogleMap(
                padding: EdgeInsets.only(bottom: mapBottomPaddding),
                mapType: _currentMapType,
                markers: _Markers,
                myLocationEnabled: true,
                scrollGesturesEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                cameraTargetBounds: CameraTargetBounds.unbounded,
                compassEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: googleplex,
              ),
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  height: 195,
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
                    border: Border.all(width: 0.5, color: Colors.grey),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.red[900],
                          blurRadius: 10.0,
                          spreadRadius: 1.0,
                          offset: Offset(1.0, 1.0)),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 80,
                          width: double.infinity,
                          child: SlideButton(),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Divider(thickness: 1.0, color: Colors.red[900]),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GestureDetector(
                              onTap: () {
                                launch('tel:100');
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Icon(
                                      Icons.local_police_rounded,
                                      color: Colors.amber[800],
                                      size: 25,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    'Police',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                launch('tel:108');
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Icon(
                                      Icons.medical_services_rounded,
                                      color: Colors.amber[800],
                                      size: 25,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    'Ambulance',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.0),
                            GestureDetector(
                              onTap: () {
                                launch("tel:1091");
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Icon(
                                      Icons.person_outline_rounded,
                                      color: Colors.amber[900],
                                      size: 25,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    'Helpline',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
