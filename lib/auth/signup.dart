import 'package:bus_driver_app/auth/bus_info.dart';
import 'package:bus_driver_app/auth/login.dart';
import 'package:bus_driver_app/global/global.dart';
import 'package:bus_driver_app/widgets/progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreen createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  TextEditingController nameTexteditingController = TextEditingController();
  TextEditingController emailTexteditingController = TextEditingController();
  TextEditingController phoneTexteditingController = TextEditingController();
  TextEditingController passwordTexteditingController = TextEditingController();

  validateForm() {
    if (nameTexteditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "Name must be atleast 3 characters. ");
    } else if (!emailTexteditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not valid. ");
    } else if (phoneTexteditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Phone number is mandatory. ");
    } else if (passwordTexteditingController.text.length < 6) {
      Fluttertoast.showToast(msg: "Password must be atleast 6 characters. ");
    } else {
      saveDriverInfoNow();
      //Navigator.push(context, MaterialPageRoute(builder: (c) => const BusInfoScreen()));
    }
  }

  saveDriverInfoNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Registering, Please wait...",
          );
        });

    final User? firebaseUser = (await fAuth
            .createUserWithEmailAndPassword(
      email: emailTexteditingController.text.trim(),
      password: passwordTexteditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      Map driverMap = {
        "id": firebaseUser.uid,
        "name": nameTexteditingController.text.trim(),
        "email": emailTexteditingController.text.trim(),
        "phone": phoneTexteditingController.text.trim(),
      };

      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).set(driverMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "New user account has been created.");
      Navigator.push(context, MaterialPageRoute(builder: (c) => BusInfo()));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "New user account has not been created.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("assets/images/logo1.png"),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Register as a Driver",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextField(
                controller: nameTexteditingController,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13.0,
                ),
                decoration: const InputDecoration(
                    labelText: "Name",
                    hintText: "Name",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    )),
              ),
              TextField(
                controller: emailTexteditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13.0,
                ),
                decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "Email",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    )),
              ),
              TextField(
                controller: phoneTexteditingController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13.0,
                ),
                decoration: const InputDecoration(
                    labelText: "Phone",
                    hintText: "Phone",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    )),
              ),
              TextField(
                controller: passwordTexteditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13.0,
                ),
                decoration: const InputDecoration(
                    labelText: "Password",
                    hintText: "Password",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    validateForm();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    onPrimary: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(
                        color: Color.fromARGB(137, 255, 255, 255),
                        fontSize: 18),
                  )),
              TextButton(
                  child: const Text("Already have an Account? Login here",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      )),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => const LoginScreen()));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
