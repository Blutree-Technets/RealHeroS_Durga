import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:realheros_durga/Authentication/Service/AuthService.dart';
import 'package:realheros_durga/Authentication/Views/login_page.dart';
import 'package:realheros_durga/General%20emergency/gen_emergency.dart';
import 'package:realheros_durga/Home/Home.dart';
import 'package:realheros_durga/Maps/maps.dart';
import 'package:realheros_durga/Maps/safezone.dart';
import 'package:realheros_durga/Others/About_Us.dart';
import 'package:realheros_durga/Others/Durga_Info.dart';
import 'package:realheros_durga/Profile/My_Profile.dart';
import 'package:realheros_durga/Terms%20and%20Conditions/tcu.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _userName;
  String _userEmail;

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<void> _getUserName() async {
    FirebaseFirestore.instance
        .collection('DURGA')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        _userName = value.data()['fullname'].toString();
        _userEmail = value.data()['email'].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE65100),
            Color(0xFFC62828),
            Color(0xFFD50000),
            Color(0xFFB71C1C),
          ],
          stops: [0.1, 0.4, 0.7, 0.9],
        ),
      ),
      //color: Colors.blue,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 60.0,
          ),
          Container(
              child: Column(children: [
            Container(
              width: 120,
              height: 100,
              decoration: BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                      // color: Colors.grey[100],
                      blurRadius: 20.0)
                ],
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.scaleDown,
                  image: AssetImage('assets/durga-india.png'),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            _userName == null
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xFFE65100),
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Color(0xFFE65100)),
                    ),
                  )
                : Text(
                    'Hello, $_userName',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            _userEmail == null
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Color(0xFFE65100)),
                      backgroundColor: Color(0xFFE65100),
                      // Animation<Color>: Colors.red[900],
                    ),
                  )
                : Text(
                    '$_userEmail',
                    //"Email : " + user.email,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
          ])),
          // _createHeader(),
          SizedBox(
            height: 10.0,
          ),
          _createDrawerItem(
              icon: Icons.home_outlined,
              text: 'Home',
              onTap: () => Navigator.push(
                    context,
                    // ignore: missing_required_param
                    MaterialPageRoute(builder: (context) => new wsd()),
                  )),
          // _createDrawerItem(
          //     icon: Icons.chat_outlined,
          //     text: 'Chat',
          //     onTap: () => Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => new StreamExample(
          //                   client: client, channel: channel)),
          //)),
          // _createDrawerItem(
          //     icon: Icons.map_outlined,
          //     text: 'Maps',
          //     onTap: () => Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => new UserMaps()),
          //         )),
          _createDrawerItem(
              icon: Icons.cast_for_education_outlined,
              text: 'Online Courses',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => new Durga()),
                  )),
          _createDrawerItem(
              icon: Icons.person_outlined,
              text: 'RealHeroS Page',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyProfilePage()),
                  )),
          _createDrawerItem(
              icon: Icons.health_and_safety_outlined,
              text: 'General Emergencies',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => new General_emer()),
                  )),
          _createDrawerItem(
              icon: Icons.add_business_outlined,
              text: 'Apply As SafeZone',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => new safezone()),
                  )),
          _createDrawerItem(
              icon: Icons.info_outline,
              text: 'About us',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => new AboutPage()),
                  )),
          Divider(
            thickness: 2.0,
            color: Colors.black,
          ),
          _createDrawerItem(
              icon: Icons.library_books_outlined,
              text: 'Terms and Conditions',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => new Terms()),
                  )),

          // new Container(
          //   child: ListTile(
          //       title: new Text(
          //         'Terms and Conditions',
          //         style: TextStyle(color: Colors.black87, fontSize: 16.0),
          //       ),
          //       leading: Icon(
          //         Icons.library_books_outlined,
          //         color: Colors.black,
          //       ),
          //       onTap: () => Navigator.push(
          //             context,
          //             MaterialPageRoute(builder: (context) => new Terms()),
          //           )),
          // ),
          new Container(
            child: ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Log out',
                        style: TextStyle(color: Colors.amber, fontSize: 16.0),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  AuthService().signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new LoginPage()));
                }),
          )
        ],
      ),
    ));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            //color: Colors.white
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: TextStyle(color: Colors.black87, fontSize: 16.0),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
