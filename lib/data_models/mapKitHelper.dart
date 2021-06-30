import 'package:maps_toolkit/maps_toolkit.dart';

class MapKitHelper {
  static double getMarkerRotation(
      sourceLat, sourceLng, destinationLat, destintionLng) {
    var rotation = SphericalUtil.computeHeading(
        LatLng(sourceLat, sourceLng), LatLng(destinationLat, destintionLng));

    return rotation;
  }
}
