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
            TextField(
              controller: busModelTexteditingController,
              keyboardType: TextInputType.text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13.0,
              ),
              decoration: const InputDecoration(
                  labelText: "Bus Model",
                  hintText: "Bus Model",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10.0,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  )),
            ),
            TextField(
              controller: busNumberTexteditingController,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13.0,
              ),
              decoration: const InputDecoration(
                  labelText: "Bus Number",
                  hintText: "Bus Number",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10.0,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  )),
            ),
            TextField(
              controller: busColorTexteditingController,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13.0,
              ),
              decoration: const InputDecoration(
                  labelText: "Bus Color",
                  hintText: "Bus Color",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10.0,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  )),
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
                    style: const TextStyle(color: Color.fromARGB(163, 0, 0, 0)),
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
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                ),
                child: const Text(
                  "Save Now",
                  style: TextStyle(
                      color: Color.fromARGB(137, 255, 255, 255), fontSize: 18),
                ))
          ],
        ),
      ),
    );
  }
}
