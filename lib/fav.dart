import 'package:flutter/material.dart';

import 'models/wallpaper.dart';

class Favorite extends StatefulWidget {
  final List<Wallpaper> wallpapersList;

  Favorite({Key key, this.wallpapersList}) : super(key: key);

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
