import 'package:bus_driver_app/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
      }
    });

    //2.foreground(when app is open and it receives notification)
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      //display the ride requst infomation - user infomation who request a ride
      //print("Remote Message: ${event.data}");
      print("This is ride request ID : ");
      print(remoteMessage!.data["rideRequestId"]);
    });

    //3.background(when app is in the background and opened directly from the push notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      //display the ride requst infomation - user infomation who request a ride
      //print("Remote Message: ${event.data}");
      print("This is ride request ID : ");
      print(remoteMessage!.data["rideRequestId"]);
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
