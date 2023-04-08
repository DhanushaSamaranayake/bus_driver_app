import 'dart:convert';

import 'package:bus_driver_app/assistants/req_assistens.dart';
import 'package:bus_driver_app/global/global.dart';
import 'package:bus_driver_app/global/map_key.dart';
import 'package:bus_driver_app/infoHandler/appInfo.dart';
import 'package:bus_driver_app/models/direction_detailsinfo.dart';
import 'package:bus_driver_app/models/directions.dart';
import 'package:bus_driver_app/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AssistantMethods {
  static Future<String> searchAddressForGeographCordinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error Occurred, Failed. No Response..") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }
    return humanReadableAddress;
  }

  static void readCurrentOnlineUserInfo() async {
    currentFirebaseUser = fAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapShot(snap.snapshot);
      }
    });
  }

  static Future<DirectionDetailsInfo?>
      obtainOriginToDestinationDirectionDetails(
          LatLng originPosition, LatLng destinationPosition) async {
    String urlobtainOriginToDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi = await RequestAssistant.receiveRequest(
        urlobtainOriginToDestinationDirectionDetails);

    if (responseDirectionApi == "Error Occurred, Failed. No Response..") {
      return null;
    }
    print("This is response  " + jsonEncode(responseDirectionApi));
    print("This is origin  " + originPosition.toString());
    print("This is destination  " + destinationPosition.toString());

    DirectionDetailsInfo directiondetailsInfo = DirectionDetailsInfo();
    directiondetailsInfo.encodedPoints =
        responseDirectionApi["routes"][0]["overview_polyline"]["points"];
    directiondetailsInfo.distanceText =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directiondetailsInfo.distanceValue =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];
    directiondetailsInfo.durationText =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directiondetailsInfo.durationValue =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directiondetailsInfo;
  }

  static pauseLiveLocationUpdates() {
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(currentFirebaseUser!.uid);
  }

  static resumeLiveLocationUpdates() {
    streamSubscriptionPosition!.resume();
    Geofire.setLocation(currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
  }

  static double calculateFareAmountFromOriginToDestination(
      DirectionDetailsInfo directionDetailsInfo) {
    double timeTraveledFarePerMin =
        (directionDetailsInfo.durationValue! / 60) * 0.2;
    double distanceTraveledFarePerKM =
        (directionDetailsInfo.durationValue! / 1000) * 0.2;
    //USD type currency
    double totalFareAmount = timeTraveledFarePerMin + distanceTraveledFarePerKM;

    //convert to local currency 1 USD = 320 LKR
    //double totalLocalAmount = totalFareAmount * 320;
    if (driverVehicleType == "Normal") {
      double resultFareAmount = (totalFareAmount.truncate()) / 2.0;
      return resultFareAmount;
    } else if (driverVehicleType == "Semi") {
      return totalFareAmount.truncate().toDouble();
    } else if (driverVehicleType == "Luxury") {
      double resultFareAmount = (totalFareAmount.truncate()) * 2.0;
      return resultFareAmount;
    } else {
      return totalFareAmount.truncate().toDouble();
    }
  }
}
