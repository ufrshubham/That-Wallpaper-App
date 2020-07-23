import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Favorite extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  
  Favorite({Key key, this.snapshot}) : super(key: key);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Favorite!',
          style: TextStyle(fontSize: 30.0),
        ),
      ),
    );
  }
}
