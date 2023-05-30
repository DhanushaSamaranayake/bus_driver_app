import 'package:bus_driver_app/SplashScreen/splash_screen.dart';
import 'package:bus_driver_app/auth/signup.dart';
import 'package:bus_driver_app/global/global.dart';
import 'package:bus_driver_app/widgets/progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  TextEditingController emailTexteditingController = TextEditingController();
  TextEditingController passwordTexteditingController = TextEditingController();

  validateForm() {
    if (!emailTexteditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not valid. ");
    } else if (passwordTexteditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password must be atleast 6 characters. ");
    } else {
      loginDriverNow();
      //Navigator.push(context, MaterialPageRoute(builder: (c) => const BusInfoScreen()));
    }
  }

  loginDriverNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(
          message: "Login, Please wait...",
        );
      },
    );

    try {
      final User? firebaseUser = (await fAuth.signInWithEmailAndPassword(
        email: emailTexteditingController.text.trim(),
        password: passwordTexteditingController.text.trim(),
      ))
          .user;

      if (firebaseUser != null) {
        DatabaseReference driversRef =
            FirebaseDatabase.instance.ref().child("drivers");
        //checking is the driver detials is exist or not
        driversRef.child(firebaseUser.uid).once().then((driverKey) {
          final snap = driverKey.snapshot;
          if (snap.value != null) {
            currentFirebaseUser = firebaseUser;
            Fluttertoast.showToast(msg: "Login, Please wait...");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()),
            );
          } else {
            Fluttertoast.showToast(msg: "No record exist with this email..");
            fAuth.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()),
            );
          }
        });
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Error occurred during Login. ");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + e.message!);
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error occurred during Login. ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("assets/images/logo1.png"),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Login as a Driver",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: emailTexteditingController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10.0,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                prefixIcon: const Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                labelText: "Email",
                hintText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10.0,
                ),
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: passwordTexteditingController,
              keyboardType: TextInputType.text,
              obscureText: true,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10.0,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                labelText: "Password",
                hintText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10.0,
                ),
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  validateForm();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  primary: Colors.transparent,
                  onPrimary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: Colors.blue),
                  ),
                  elevation: 0, // Remove button elevation
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                )),
            TextButton(
                child: const Text("Don't have an account? Sign up here",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    )),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const SignupScreen()));
                }),
          ],
        ),
      )),
    );
  }
}
