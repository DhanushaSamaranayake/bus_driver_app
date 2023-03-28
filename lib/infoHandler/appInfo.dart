import 'package:bus_driver_app/models/directions.dart';
import 'package:flutter/cupertino.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOfLocation;

  void updatePickUpLocationAddress(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOfLocationAddress(Directions userDropOfAddress) {
    userDropOfLocation = userDropOfAddress;
    notifyListeners();
  }
}
