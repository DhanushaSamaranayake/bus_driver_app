import 'package:bus_driver_app/infoHandler/appInfo.dart';
import 'package:bus_driver_app/widgets/history_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TripsHistoryScreen extends StatefulWidget {
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
              Navigator.pop(context);
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
            tripHistoryModel: Provider.of<AppInfo>(context, listen: false)
                .allHistoryTripList[i],
          );
        },
        itemCount: Provider.of<AppInfo>(context, listen: false)
            .allHistoryTripList
            .length,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}
