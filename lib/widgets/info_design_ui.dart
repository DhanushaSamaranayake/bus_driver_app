import 'package:flutter/material.dart';

class InfoDesignUIWidget extends StatefulWidget {
  String? textInfo;
  IconData? iconData;

  InfoDesignUIWidget({this.textInfo, this.iconData});

  @override
  State<InfoDesignUIWidget> createState() => _InfoDesignUIWidgetState();
}

class _InfoDesignUIWidgetState extends State<InfoDesignUIWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        shadowColor: Colors.black,
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: ListTile(
            leading: Icon(widget.iconData, color: Colors.black),
            title: Text(
              widget.textInfo!,
              style: const TextStyle(color: Colors.black, fontSize: 18),
            )));
  }
}
