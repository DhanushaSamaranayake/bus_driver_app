import 'dart:async';
import 'package:bus_driver_app/assistants/assistents_methods.dart';
import 'package:bus_driver_app/assistants/custom_googleMap_theme.dart';
import 'package:bus_driver_app/global/global.dart';
import 'package:bus_driver_app/models/direction_detailsinfo.dart';
import 'package:bus_driver_app/models/userRideRequest_Information.dart';
import 'package:bus_driver_app/widgets/progress.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewTripScreen extends StatefulWidget {
  UserRideRequestInformation? userRideRequest;

  NewTripScreen({
    this.userRideRequest,
  });

  @override
  State<NewTripScreen> createState() => _NewTripScreen();
}

class _NewTripScreen extends State<NewTripScreen> {
  GoogleMapController? newTripGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(6.927079, 79.861244),
    zoom: 14.4746,
  );

  String? buttonTitle = "Arrived";
  Color? buttonColor = Colors.green;

  Set<Marker> setOfMarkers = Set<Marker>();
  Set<Circle> setOfCircle = Set<Circle>();
  Set<Polyline> setOfPolyline = Set<Polyline>();
  List<LatLng> polyLinePositionCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  double mapPadding = 0;
  BitmapDescriptor? iconAnimatedMarker;
  var geoLocator = Geolocator();
  Position? onlineDriverCurrentPosition;

  //1. when driver accepts the user ride request
  //originLatLng = driverCurrent Location
  // destinationLatLng = user PickUp Location

  //setp2. user already pickedup the user in a bus
  //originLatLng = user PickUp Location => driver current location
  // destinationLatLng = user dropOff location
  Future<void> drawPolyLineFromOriginToDestination(
      LatLng originLatLng, LatLng destinationLatLng) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );

    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);

    Navigator.pop(context);

    print("These are points = ");
    print(directionDetailsInfo!.encodedPoints);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo!.encodedPoints!);

    polyLinePositionCoordinates.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        polyLinePositionCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setOfPolyline.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.purpleAccent,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polyLinePositionCoordinates,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      setOfPolyline.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newTripGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      setOfMarkers.add(originMarker);
      setOfMarkers.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      setOfCircle.add(originCircle);
      setOfCircle.add(destinationCircle);
    });
  }

  @override
  void initState() {
    super.initState();

    saveAssignedDriverDetailsToUserRideRequest();
  }

  createDriverIconMarker() {
    if (iconAnimatedMarker == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "assets/images/car.png")
          .then((value) {
        iconAnimatedMarker = value;
      });
    }
  }

  getDriversLocationUpdatesAtRealTime() {
    streamSubscriptionPositionDriverLivePosition =
        Geolocator.getPositionStream().listen((Position position) {
      driverCurrentPosition = position;
      onlineDriverCurrentPosition = position;

      LatLng latLngLiveDriverPosition = LatLng(
          onlineDriverCurrentPosition!.latitude,
          onlineDriverCurrentPosition!.longitude);

      Marker animatingMarker = Marker(
        markerId: const MarkerId("AnimatedMarker"),
        position: latLngLiveDriverPosition,
        icon: iconAnimatedMarker!,
        //rotation: AssistantMethods.createRandomNumber(360),
        infoWindow: const InfoWindow(title: "Current Location"),
      );

      setState(() {
        CameraPosition cameraPosition = CameraPosition(
          target: latLngLiveDriverPosition,
          zoom: 16,
        );
        newTripGoogleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        setOfMarkers.removeWhere(
            (element) => element.markerId.value == "AnimatedMarker");
        setOfMarkers.add(animatingMarker);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    createDriverIconMarker();
    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(bottom: mapPadding),
          mapType: MapType.normal,
          myLocationEnabled: true,
          markers: setOfMarkers,
          circles: setOfCircle,
          polylines: setOfPolyline,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newTripGoogleMapController = controller;

            setState(() {
              mapPadding = 350;
            });
            //black theme googlemap
            blackThemeGoogleMap(newTripGoogleMapController);

            var driverCurrentLatLng = LatLng(driverCurrentPosition!.latitude,
                driverCurrentPosition!.longitude);

            var userPickUpLatLng = widget.userRideRequest!.originLatLng;
            //var userPickUpLatLng = LatLng(6.715870, 79.906105);
            //var userPickupLocation = LatLng(widget.userDetailsInfo!.originLatLng.latitude, widget.userDetailsInfo!.originLatLng.longitude);

            drawPolyLineFromOriginToDestination(
                driverCurrentLatLng, userPickUpLatLng!);
            getDriversLocationUpdatesAtRealTime();
          },
        ),

        //UI
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white30,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,
                      0.7,
                    ),
                  ),
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                children: [
                  //duration
                  Text(
                    "10 min",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),
                  //user name - icon
                  Row(
                    children: [
                      Text(
                        widget.userRideRequest!.userName!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.phone_android),
                      )
                    ],
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  //user pickup location with icon
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/origin.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequest!.originAddress!,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //user dropoff location with icon
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/destination.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequest!.destinationAddress!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: buttonColor,
                        onPrimary: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                      icon: Icon(
                        Icons.directions_bus,
                        color: Colors.white,
                        size: 25,
                      ),
                      label: Text(
                        buttonTitle!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }

  saveAssignedDriverDetailsToUserRideRequest() {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .child(widget.userRideRequest!.rideRequestId!);

    Map driverLocationDataMap = {
      "latitude": driverCurrentPosition!.latitude.toString(),
      "longitude": driverCurrentPosition!.longitude.toString(),
    };
    databaseReference.child("driverLocation").set(driverLocationDataMap);

    databaseReference.child("status").set("accepted");
    databaseReference.child("driverId").set(onlineDriverData.id);
    databaseReference.child("driverName").set(onlineDriverData.name);
    databaseReference.child("driverPhone").set(onlineDriverData.phone);
    databaseReference.child("bus_details").set(
        onlineDriverData.bus_color.toString() +
            onlineDriverData.bus_model.toString());

    saveRideRequestIdToDriverHistory();
  }

  saveRideRequestIdToDriverHistory() {
    DatabaseReference tripsHistoryRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("tripsHistory");

    tripsHistoryRef.child(widget.userRideRequest!.rideRequestId!).set(true);
  }
}
