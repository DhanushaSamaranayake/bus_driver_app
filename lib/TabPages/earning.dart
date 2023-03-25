import 'package:flutter/material.dart';

class Earning extends StatefulWidget {
  const Earning({Key? key}) : super(key: key);

  @override
  _EarningState createState() => _EarningState();
}

class _EarningState extends State<Earning> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Earning"),
      ),
    );
  }
}
