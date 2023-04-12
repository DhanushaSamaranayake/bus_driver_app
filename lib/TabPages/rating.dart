import 'package:bus_driver_app/global/global.dart';
import 'package:bus_driver_app/infoHandler/appInfo.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class RatingsTabPage extends StatefulWidget {
  const RatingsTabPage({Key? key}) : super(key: key);

  @override
  State<RatingsTabPage> createState() => _RatingsTabPage();
}

class _RatingsTabPage extends State<RatingsTabPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRatingNumber();
  }

  getRatingNumber() {
    setState(() {
      ratingsNumber = double.parse(
          Provider.of<AppInfo>(context, listen: false).driverTotalRatings);
    });
    setupRatingTitle();
  }

  setupRatingTitle() {
    if (ratingsNumber == 1) {
      setState(() {
        titleRating = "Very Bad";
      });
    }
    if (ratingsNumber == 2) {
      setState(() {
        titleRating = " Bad";
      });
    }
    if (ratingsNumber == 3) {
      setState(() {
        titleRating = "Good";
      });
    }
    if (ratingsNumber == 4) {
      setState(() {
        titleRating = "Very Good";
      });
    }
    if (ratingsNumber == 5) {
      setState(() {
        titleRating = "Excellent";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Your Rating",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SmoothStarRating(
                rating: ratingsNumber,
                allowHalfRating: false,
                color: Colors.green,
                borderColor: Colors.green,
                starCount: 5,
                size: 45,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                titleRating,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
