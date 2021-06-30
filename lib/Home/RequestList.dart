import 'package:flutter/material.dart';
import 'package:realheros_durga/Drawer/Side_Drawer.dart';

class RequestList extends StatefulWidget {
  @override
  _RequestListState createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      // ignore: missing_required_param
      drawer: AppDrawer(),

      body: Center(
        child: Container(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFE65100),
                        Color(0xFFE65100),
                        Color(0xFFC62828),
                        Color(0xFFD50000),
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9],
                    ),
                  ),
                  child: ListView(children: [
                    Text('item1'),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.green,
                      child: Text('item2'),
                    ),
                  ]),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFE65100),
                        Color(0xFFE65100),
                        Color(0xFFC62828),
                        Color(0xFFD50000),
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9],
                    ),
                  ),
                  child: ListView(children: [
                    Text('item1'),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.green,
                      child: Text('item2'),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
