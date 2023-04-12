import 'package:bus_driver_app/models/directions.dart';
import 'package:bus_driver_app/models/tripHistory_model.dart';
import 'package:flutter/cupertino.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOfLocation;
  int counttotalTrips = 0;
  List<String> historyTripKeyList = [];
  List<TripHistoryModel> allHistoryTripList = [];
  String driverTotalEarnings = "0";

  void updatePickUpLocationAddress(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOfLocationAddress(Directions userDropOfAddress) {
    userDropOfLocation = userDropOfAddress;
    notifyListeners();
  }

  updateOverAllTripCounter(int overAllTripsCounter) {
    counttotalTrips = overAllTripsCounter;
    notifyListeners();
  }

  updateOverAllTripKeysList(List<String> tripKeysList) {
    historyTripKeyList = tripKeysList;
    notifyListeners();
  }

  updateTripHistoryList(TripHistoryModel eachHistoryTrips) {
    allHistoryTripList.add(eachHistoryTrips);
    notifyListeners();
  }

  updateDriverEarnings(String driverEarnings) {
    driverTotalEarnings = driverEarnings;
  }
}
