import 'package:flutter/material.dart';

class AllImages extends StatelessWidget {
  const AllImages({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'All Images!',
          style: TextStyle(fontSize: 30.0),
        ),
      ),
    );
  }
}
