import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:realheros_durga/Maps/DareMap.dart';
import 'package:realheros_durga/data_models/global_variables.dart';
import 'package:realheros_durga/data_models/requestDetails.dart';
import 'package:realheros_durga/data_models/webmethods.dart';
import 'package:toast/toast.dart';

// ignore: must_be_immutable
class NotificationDialog extends StatelessWidget {
  final RequestDetails requestDetails;
  String duration;
  String distance;

  GlobalKey dialog = new GlobalKey();

  NotificationDialog({this.requestDetails, this.duration, this.distance});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: dialog,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 5.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 25),
            Image.asset(
              'assets/durga-india.png',
              width: 100,
            ),
            SizedBox(height: 8.0),
            Text(
              'Requesting For Help...',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.person),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '${requestDetails.request_name} ',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_pin),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '${requestDetails.location_address} ',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.timelapse_rounded),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '$duration ',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.social_distance),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '$distance',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.orange,
              thickness: 2.0,
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: TextButton(
                        child: Text('DECLINE',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.red[800])),
                        onPressed: () async {
                          audioPlayer.stop();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: TextButton(
                        child: Text('ACCEPT',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.green[800])),
                        onPressed: () async {
                          audioPlayer.stop();
                          checkAvailability();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  void checkAvailability() {
    DatabaseReference newRequestRef = FirebaseDatabase.instance
        .reference()
        .child('Dare_Details/${currentUser.uid}/Help_Request');

    newRequestRef.once().then((DataSnapshot snapshot) {
      Navigator.pop(dialog.currentContext);
      //Navigator.pop(dialog.currentContext);
      String thisRequestID = '';
      if (snapshot != null) {
        thisRequestID = snapshot.value.toString();
      } else {
        print('Request not found');
      }

      if (thisRequestID == requestDetails.dareID) {
        newRequestRef.set('accepted');
        Navigator.pop(dialog.currentContext);
        WebMethods.disablehomeTabLocationUpdates();

        Navigator.push(
            dialog.currentContext,
            MaterialPageRoute(
                builder: (context) => new DareMap(
                      requestDetails: requestDetails,
                    )));

        print('${requestDetails.request_name}');
      } else if (thisRequestID == 'cancelled') {
        Toast.show("Request has been cancelled", dialog.currentContext,
            duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
      } else if (thisRequestID == 'timeout') {
        Toast.show("Request has timed out", dialog.currentContext,
            duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
      } else {
        Toast.show("request not found_1", dialog.currentContext,
            duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
      }
    });
  }
}
