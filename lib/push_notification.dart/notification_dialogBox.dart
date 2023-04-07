import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bus_driver_app/global/global.dart';
import 'package:bus_driver_app/mainScreens/newtrip_screen.dart';
import 'package:bus_driver_app/models/userRideRequest_Information.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationDialogBox extends StatefulWidget {
  UserRideRequestInformation? userRideRequest;

  NotificationDialogBox({this.userRideRequest});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBox();
}

class _NotificationDialogBox extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 14),
              Image.asset(
                "assets/images/car_logo.png",
                width: 160,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "New Ride Request",
                style: TextStyle(
                    fontSize: 22,
                    fontFamily: "Brand Bold",
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    //origin location with icon
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
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    //destination location with icon
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
                  ],
                ),
              ),
              const Divider(
                height: 2,
                thickness: 2,
                color: Colors.redAccent,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //accept button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(5, 5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          audioPlayer.pause();
                          audioPlayer.stop();

                          audioPlayer = AssetsAudioPlayer();
                          //accept the rideRequest
                          acceptRideRequest(context);
                        },
                        child: const Text("Accept"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    //reject button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(5, 5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          audioPlayer.pause();
                          audioPlayer.stop();
                          audioPlayer = AssetsAudioPlayer();

                          Navigator.pop(context);
                        },
                        child: const Text("Reject"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  acceptRideRequest(BuildContext context) {
    String getRideRequestId = "";
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        getRideRequestId = snap.snapshot.value.toString();
      } else {
        Fluttertoast.showToast(msg: "This ride Request do not exists..");
      }

      if (getRideRequestId == widget.userRideRequest!.rideRequestId) {
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(currentFirebaseUser!.uid)
            .child("newRideStatus")
            .set("accepted");
        //trip started now - send driver to newridescreen
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) =>
                    NewTripScreen(userRideRequest: widget.userRideRequest)));
        ;
      } else {
        Fluttertoast.showToast(msg: "This ride Request do not exists..");
      }
    });
  }
}
