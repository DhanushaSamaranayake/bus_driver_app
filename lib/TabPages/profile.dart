import 'package:bus_driver_app/global/global.dart';
import 'package:bus_driver_app/widgets/info_design_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);
  @override
  State<ProfileTabPage> createState() => _ProfileTabPage();
}

class _ProfileTabPage extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 200,
          ),
          Text(
            onlineDriverData.name!,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Text(
            titleRating + " " + "driver",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          InfoDesignUIWidget(
            textInfo: onlineDriverData.email!,
            iconData: Icons.email,
          ),
          InfoDesignUIWidget(
            textInfo: onlineDriverData.bus_color! +
                " " +
                onlineDriverData.bus_model! +
                " " +
                onlineDriverData.bus_number!,
            iconData: Icons.directions_bus,
          ),
          const SizedBox(
            height: 10,
          ),
          InfoDesignUIWidget(
            textInfo: onlineDriverData!.phone,
            iconData: Icons.phone_iphone,
          ),
          ElevatedButton(
              onPressed: () {
                fAuth.signOut();
                SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  shadowColor: Colors.black,
                  elevation: 5),
              child: const Text("Log Out"))
        ],
      )),
    );
  }
}
