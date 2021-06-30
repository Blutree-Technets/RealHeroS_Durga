import 'package:flutter/cupertino.dart';
import 'package:realheros_durga/data_models/address.dart';

class AppData extends ChangeNotifier {
  Address pickupAddress;

  void updatePickupAddress(Address pickup) {
    pickupAddress = pickup;
    notifyListeners();
  }
}
