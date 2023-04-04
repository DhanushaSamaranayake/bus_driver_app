import 'package:bus_driver_app/global/global.dart';
import 'package:bus_driver_app/models/userRideRequest_Information.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging() async {
    //1. terminated state(app is completely closed and opened directly from the push notification)
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        print("This is ride request ID : ");
        print(remoteMessage.data["rideRequestId"]);
        //display the ride requst infomation - user infomation who request a ride
        //print("Remote Message: ${remoteMessage.data}");
        readUserRideRequestInfomation(remoteMessage.data["rideRequestId"]);
      }
    });

    //2.foreground(when app is open and it receives notification)
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      //display the ride requst infomation - user infomation who request a ride
      //print("Remote Message: ${event.data}");
      print("This is ride request ID : ");
      print(remoteMessage!.data["rideRequestId"]);
      readUserRideRequestInfomation(remoteMessage.data["rideRequestId"]);
    });

    //3.background(when app is in the background and opened directly from the push notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      //display the ride requst infomation - user infomation who request a ride
      //print("Remote Message: ${event.data}");
      print("This is ride request ID : ");
      print(remoteMessage!.data["rideRequestId"]);
      readUserRideRequestInfomation(remoteMessage.data["rideRequestId"]);
    });
  }

  readUserRideRequestInfomation(String userRideRequestId) {
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .child(userRideRequestId)
        .once()
        .then((snapData) {
      if (snapData.snapshot.value != null) {
        double originLat = double.parse(
            (snapData.snapshot.value! as Map)["origin"]["latitude"]);
        double originLng = double.parse(
            (snapData.snapshot.value! as Map)["origin"]["longitude"]);
        String originAdress =
            (snapData.snapshot.value! as Map)["originAddress"];

        double destinationLat = double.parse(
            (snapData.snapshot.value! as Map)["destination"]["latitude"]);
        double destinationLng = double.parse(
            (snapData.snapshot.value! as Map)["destination"]["longitude"]);
        String destinationAdress =
            (snapData.snapshot.value! as Map)["destinationAddress"];

        String userName = (snapData.snapshot.value! as Map)["userName"];
        String userPhone = (snapData.snapshot.value! as Map)["userPhone"];

        UserRideRequestInformation userRideRequestInformation =
            UserRideRequestInformation();
        userRideRequestInformation.originLatLng = LatLng(originLng, originLat);
        userRideRequestInformation.originAddress = originAdress;
        userRideRequestInformation.destinationLatLng =
            LatLng(destinationLng, destinationLat);
        userRideRequestInformation.destinationAddress = destinationAdress;
        userRideRequestInformation.rideRequestId = userRideRequestId;
        userRideRequestInformation.userName = userName;
        userRideRequestInformation.userPhone = userPhone;
      } else {
        Fluttertoast.showToast(msg: "This Ride Request ID do not exists");
      }
    });
  }

  Future genarateAndGetToken() async {
    String? registrationToken = await messaging.getToken();
    print("FCM Register Token: ");
    print(registrationToken);
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("token")
        .set(registrationToken);

    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  }
}
