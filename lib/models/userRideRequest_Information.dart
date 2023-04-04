import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserRideRequestInformation {
  LatLng? originLatLng;
  String? originAddress;
  LatLng? destinationLatLng;
  String? destinationAddress;
  String? rideRequestId;
  String? userPhone;
  String? userName;

  UserRideRequestInformation({
    this.originLatLng,
    this.originAddress,
    this.destinationLatLng,
    this.destinationAddress,
    this.rideRequestId,
    this.userPhone,
    this.userName,
  });
}
