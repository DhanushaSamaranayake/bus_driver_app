import 'package:bus_driver_app/infoHandler/appInfo.dart';
import 'package:bus_driver_app/widgets/history_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TripsHistoryScreen extends StatefulWidget {
  const TripsHistoryScreen({Key? key}) : super(key: key);
  @override
  State<TripsHistoryScreen> createState() => _TripsHistoryScreen();
}

class _TripsHistoryScreen extends State<TripsHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Trips History"),
        leading: IconButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            icon: const Icon(Icons.close)),
      ),
      body: ListView.separated(
        separatorBuilder: (context, i) => const Divider(
          height: 10,
          color: Colors.white,
          //thickness: 5,
        ),
        itemBuilder: (context, i) {
          return HistoryDesignUi(
            tripHistoryModel:
                Provider.of<AppInfo>(context).allHistoryTripList[i],
          );
        },
        itemCount: Set.from(Provider.of<AppInfo>(context).allHistoryTripList)
            .toList()
            .length,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}
