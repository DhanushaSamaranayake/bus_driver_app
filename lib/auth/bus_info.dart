import 'package:bus_driver_app/SplashScreen/splash_screen.dart';
import 'package:bus_driver_app/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BusInfo extends StatefulWidget {
  const BusInfo({Key? key}) : super(key: key);

  @override
  _BusInfo createState() => _BusInfo();
}

class _BusInfo extends State<BusInfo> {
  TextEditingController busModelTexteditingController = TextEditingController();
  TextEditingController busNumberTexteditingController =
      TextEditingController();
  TextEditingController busColorTexteditingController = TextEditingController();

  List<String> busTypesList = ["Semi", "Luxury", "Normal"];
  String? selectedBustype;

  saveBusInfo() {
    Map driverBusInfoMap = {
      "bus_color": busColorTexteditingController.text.trim(),
      "bus_number": busNumberTexteditingController.text.trim(),
      "bus_model": busModelTexteditingController.text.trim(),
      "bus_type": selectedBustype,
    };
    DatabaseReference driversRef =
        FirebaseDatabase.instance.ref().child("drivers");
    driversRef
        .child(currentFirebaseUser!.uid)
        .child("bus_details")
        .set(driverBusInfoMap);

    Fluttertoast.showToast(msg: "Bus Details Saved Successfully");
    Navigator.push(
        context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("assets/images/logo1.png"),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              " Write Bus Details",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: busModelTexteditingController,
              keyboardType: TextInputType.text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13.0,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                prefixIcon: const Icon(
                  Icons.bus_alert,
                  color: Colors.black,
                ),
                labelText: "Bus Model",
                hintText: "Bus Model",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10.0,
                ),
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: busNumberTexteditingController,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13.0,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                prefixIcon: const Icon(
                  Icons.bus_alert,
                  color: Colors.black,
                ),
                labelText: "Bus Number",
                hintText: "Bus Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10.0,
                ),
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: busColorTexteditingController,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13.0,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                prefixIcon: const Icon(
                  Icons.color_lens,
                  color: Colors.black,
                ),
                labelText: "Bus Color",
                hintText: "Bus Color",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10.0,
                ),
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButton(
              iconSize: 20,
              //dropdownColor: Color.fromARGB(122, 0, 0, 0),
              hint: const Text('Please Choose Bus Type',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  )),
              value: selectedBustype,
              onChanged: (newValue) {
                setState(() {
                  selectedBustype = newValue.toString();
                });
              },
              items: busTypesList.map((bus) {
                return DropdownMenuItem(
                  child: Text(
                    bus,
                    style: TextStyle(
                      color: Color.fromARGB(163, 0, 0, 0),
                      fontSize: 16, // Modify the font size
                      fontWeight: FontWeight.bold, // Modify the font weight
                      fontStyle: FontStyle.italic, // Add italic style
                    ),
                  ),
                  value: bus,
                );
              }).toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if (busColorTexteditingController.text.isNotEmpty &&
                      busNumberTexteditingController.text.isNotEmpty &&
                      busModelTexteditingController.text.isNotEmpty &&
                      selectedBustype != null) {
                    saveBusInfo();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  primary: Colors.transparent,
                  onPrimary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: Colors.red),
                  ),
                  elevation: 0, // Remove button elevation
                ),
                child: const Text(
                  "Save Now",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ))
          ],
        ),
      ),
    );
  }
}
