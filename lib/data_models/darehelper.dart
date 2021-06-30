import 'dart:math';

import 'package:realheros_durga/data_models/NearbyDare.dart';

class DareHelper {
  static List<NearByDare> nearByDareList = [];

  static void removeFromList(NearByDare dare) {
    //int index = nearByDareList.indexWhere((element) => element.key == dare.key);
    nearByDareList.removeWhere((element) => element.key == dare.key);
  }

  static void updatenearByLocation(NearByDare dare) {
    int index = nearByDareList.indexWhere((element) => element.key == dare.key);
    if (index >= 0) {
      nearByDareList[index].longitude = dare.longitude;
      nearByDareList[index].latitude = dare.latitude;
    } else {
      print('Error Loading');
    }
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int radInt = randomGenerator.nextInt(max);

    return radInt.toDouble();
  }
}
