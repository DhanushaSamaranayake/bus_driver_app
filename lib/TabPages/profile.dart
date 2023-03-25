import 'package:bus_driver_app/SplashScreen/splash_screen.dart';
import 'package:bus_driver_app/global/global.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          child: const Text("Sign Out"),
          onPressed: () {
            fAuth.signOut();
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => const MySplashScreen()));
          }),
    );
  }
}
