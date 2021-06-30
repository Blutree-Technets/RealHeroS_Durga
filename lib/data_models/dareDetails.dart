import 'package:firebase_database/firebase_database.dart';

class DareDetails {
  String darename;
  String phone;
  String id;

  DareDetails({this.darename, this.phone, this.id});

  DareDetails.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    darename = snapshot.value['Dare_name'];
    phone = snapshot.value['dare_Phone_Number'];
  }
}
