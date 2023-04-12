import 'package:bus_driver_app/models/tripHistory_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryDesignUi extends StatefulWidget {
  TripHistoryModel? tripHistoryModel;
  HistoryDesignUi({this.tripHistoryModel});

  @override
  State<HistoryDesignUi> createState() => _HistoryDesignUi();
}

class _HistoryDesignUi extends State<HistoryDesignUi> {
  String formatDateAndTime(String dateTimeFromDB) {
    DateTime dateTime = DateTime.parse(dateTimeFromDB);
    // dec 10                                 //2023                             //1.12 pm
    String formatedDateTime =
        "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)},";
    return formatedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(8, 8), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //driver name + fare amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        "User : " + widget.tripHistoryModel!.userName!,
                        style: const TextStyle(
                            fontSize: 18,
                            fontFamily: "Brand-Bold",
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      "\Rs ${widget.tripHistoryModel!.fareAmount}",
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: "Brand-Bold",
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                //bus details
                Row(
                  children: [
                    const Icon(Icons.phone_iphone, color: Colors.grey),
                    Text(
                      widget.tripHistoryModel!.userPhone!,
                      style: const TextStyle(
                          fontSize: 18, fontFamily: "Brand-Bold"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                //pickup address + icon
                Row(
                  children: [
                    //const Icon(Icons.location_on,color: Colors.grey),
                    Image.asset(
                      "assets/images/origin.png",
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          widget.tripHistoryModel!.originAddress!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 18, fontFamily: "Brand-Bold"),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                //dropoff address + icon
                Row(
                  children: [
                    //const Icon(Icons.location_on,color: Colors.grey),
                    Image.asset(
                      "assets/images/destination.png",
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          widget.tripHistoryModel!.destinationAddress!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 18, fontFamily: "Brand-Bold"),
                        ),
                      ),
                    ),
                  ],
                ),
                //trip date + time + intl
                const SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.date_range, color: Colors.grey),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      formatDateAndTime(widget.tripHistoryModel!.time!),
                      style: const TextStyle(
                          fontSize: 18, fontFamily: "Brand-Bold"),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
