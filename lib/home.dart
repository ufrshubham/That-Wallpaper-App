import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;

  Home({Key key, this.snapshot}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Home!',
          style: TextStyle(fontSize: 30.0),
        ),
      ),
    );
  }
}
