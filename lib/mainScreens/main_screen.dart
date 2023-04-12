import 'package:bus_driver_app/TabPages/earning.dart';
import 'package:bus_driver_app/TabPages/home.dart';
import 'package:bus_driver_app/TabPages/profile.dart';
import 'package:bus_driver_app/TabPages/rating.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int setectedIndex = 0;

  onItemClicked(int index) {
    setState(() {
      setectedIndex = index;
      tabController!.index = setectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          Home(),
          Earning(),
          RatingsTabPage(),
          ProfileTabPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: setectedIndex,
        onTap: onItemClicked,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: "Earning",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Rating",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 47, 111, 248),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 14),
        showSelectedLabels: true,
      ),
    );
  }
}
