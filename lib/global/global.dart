import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bus_driver_app/models/driver_data.dart';
import 'package:bus_driver_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionPositionDriverLivePosition;
AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
Position? driverCurrentPosition;
DriverData onlineDriverData = DriverData();
