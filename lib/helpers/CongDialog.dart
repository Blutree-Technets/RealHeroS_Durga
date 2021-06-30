import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:realheros_durga/data_models/global_variables.dart';
import 'package:realheros_durga/data_models/webmethods.dart';

class CongDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 25),
            Image.asset(
              'assets/durga-india.png',
              width: 100,
            ),
            SizedBox(height: 15.0),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'CONGRATULATIONS!!!!\nYou have done a Great Job',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                )),
            SizedBox(height: 10.0),
            Container(
              width: 200,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.amber[600]),
                ),
                onPressed: () {
                  resetting();
                  Navigator.pop(context);
                  Navigator.pop(context);

                  WebMethods.enablehometabLocationUpdates();
                },
                child: Text('OK',
                    style: TextStyle(
                        color: Colors.red[900],
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void resetting() {
    DatabaseReference resettingRef = FirebaseDatabase.instance
        .reference()
        .child('Dare_Details/${currentUser.uid}/Help_Request');

    resettingRef.set('waiting');
  }
}
