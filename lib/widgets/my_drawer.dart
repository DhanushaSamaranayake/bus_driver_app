import 'package:bus_driver_app/SplashScreen/splash_screen.dart';
import 'package:bus_driver_app/TabPages/earning.dart';
import 'package:bus_driver_app/TabPages/profile.dart';
import 'package:bus_driver_app/TabPages/rating.dart';
import 'package:bus_driver_app/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatefulWidget {
  String? name;
  String? email;
  double? stars;

  MyDrawer({this.name, this.email, this.stars});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Drawer(
      child: ListView(
        children: [
          //drawer header
          Container(
              height: 170,
              color: Colors.white,
              child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFF0076CB),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.name.toString(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.email.toString(),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.orangeAccent,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.stars!.toStringAsFixed(1),
                                  style: const TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          ]),
                    ],
                  ))),

          const SizedBox(
            height: 20,
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => Earning()));
            },
            child: const ListTile(
              leading: Icon(
                Icons.money,
                size: 30,
                color: Color(0xFF0076CB),
              ),
              title: Text(
                "Earnings",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => ProfileTabPage()));
            },
            child: const ListTile(
              leading: Icon(
                Icons.person,
                size: 30,
                color: Color(0xFF0076CB),
              ),
              title: Text(
                "Visit Profile",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.help_center,
                size: 30,
                color: Color(0xFF0076CB),
              ),
              title: Text(
                "Help and Support",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => RatingsTabPage()));
            },
            child: const ListTile(
              leading: Icon(
                Icons.rate_review,
                size: 30,
                color: Color(0xFF0076CB),
              ),
              title: Text(
                "Ratings",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              fAuth.signOut();
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => MySplashScreen()));
            },
            child: const ListTile(
              leading: Icon(
                Icons.logout,
                size: 30,
                color: Color(0xFF0076CB),
              ),
              title: Text(
                "Sign out",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
