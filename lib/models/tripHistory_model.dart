import 'package:firebase_database/firebase_database.dart';

class TripHistoryModel {
  String? time;
  String? destinationAddress;
  String? originAddress;
  String? fareAmount;
  String? status;
  String? userName;
  String? userPhone;

  TripHistoryModel(
      {this.time,
      this.destinationAddress,
      this.originAddress,
      this.fareAmount,
      this.status,
      this.userName,
      this.userPhone});

  TripHistoryModel.fromSnapshot(DataSnapshot dataSnapshot) {
    time = (dataSnapshot.value as Map)["time"];
    destinationAddress = (dataSnapshot.value as Map)["destinationAddress"];
    originAddress = (dataSnapshot.value as Map)["originAddress"];
    fareAmount = (dataSnapshot.value as Map)["fareAmount"];
    status = (dataSnapshot.value as Map)["status"];
    userName = (dataSnapshot.value as Map)["userName"];
    userPhone = (dataSnapshot.value as Map)["userPhone"];
  }
}
