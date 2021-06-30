import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:realheros_durga/Drawer/Side_Drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  User currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String userName;
  String userEmail;
  int index;

  @override
  initState() {
    _getUserName1();

    super.initState();
  }

  Future<void> _getUserName1() async {
    FirebaseFirestore.instance
        .collection('DURGA')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        userName = value.data()['fullname'].toString();
        userEmail = value.data()['email'].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "RealHeroS Page",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      drawer: AppDrawer(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFB71C1C),
                      Color(0xFFD50000),
                      Color(0xFFC62828),
                      Color(0xFFE65100),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 0.0,
                    vertical: 0.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //SizedBox(height: 30.0),
                      _dispDetails(),
                      _leaderBoard(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _dispDetails() {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/Blutree-Durga.jpeg'),
            ),
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          //margin: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              SizedBox(height: 5.0),
              Positioned(
                  left: 5.0,
                  child: Text('Welcome,',
                      style: TextStyle(
                          fontFamily: 'Trueno',
                          fontSize: 25.0,
                          //fontWeight: FontWeight.bold,
                          color: Colors.white))),
              SizedBox(height: 20.0),
              userName == null // If user location has not been found
                  ? Center(
                      // Display Progress Indicator
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.red[900],
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.red[900]),
                      ),
                    )
                  : Text(
                      '$userName',
                      //"Name : " + user.userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
              SizedBox(height: 5.0),
              userEmail == null // If user location has not been found
                  ? Center(
                      // Display Progress Indicator
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.red[900]),
                        backgroundColor: Colors.red[900],
                        // Animation<Color>: Colors.red[900],
                      ),
                    )
                  : Text(
                      '$userEmail',
                      //"Email : " + user.email,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _leaderBoard() {
    return Center(
      child: Container(
          margin: EdgeInsets.fromLTRB(25, 150, 25, 80),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
          ),
          // padding: const EdgeInsets.fromLTRB(5, 15, 80, 10),
          child: Text(
            'Leader Board Coming Soon!!',
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                // decoration: TextDecoration.underline,
                decorationColor: Colors.red[900]),
          )),
    );
  }
}
