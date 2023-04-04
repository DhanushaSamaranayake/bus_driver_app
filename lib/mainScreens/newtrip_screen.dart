import 'dart:async';

import 'package:bus_driver_app/assistants/custom_googleMap_theme.dart';
import 'package:bus_driver_app/models/userRideRequest_Information.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewTripScreen extends StatefulWidget {
  UserRideRequestInformation? userRideRequestInformation;
  NewTripScreen({
    this.userRideRequestInformation,
  });

  @override
  State<NewTripScreen> createState() => _NewTripScreen();
}

class _NewTripScreen extends State<NewTripScreen> {
  GoogleMapController? newTripGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newTripGoogleMapController = controller;
            //black theme googlemap
            blackThemeGoogleMap(newTripGoogleMapController);
          },
        ),
      ],
    ));
  }
}
