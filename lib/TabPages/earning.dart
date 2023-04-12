import 'package:bus_driver_app/infoHandler/appInfo.dart';
import 'package:bus_driver_app/mainScreens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Earning extends StatefulWidget {
  const Earning({Key? key}) : super(key: key);

  @override
  _EarningState createState() => _EarningState();
}

class _EarningState extends State<Earning> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              //height: 100,
              width: double.infinity,
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 80),
                child: Column(
                  children: [
                    const Text(
                      "Total Earning",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "\Rs " +
                          Provider.of<AppInfo>(context, listen: false)
                              .driverTotalEarnings,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => TripsHistoryScreen()));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  elevation: 5,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/car_logo.png",
                        width: 100,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Total Trips Completed",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            Provider.of<AppInfo>(context, listen: false)
                                .allHistoryTripList
                                .length
                                .toString(),
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ));
  }
}
