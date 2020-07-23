import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllImages extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;

  AllImages({Key key, this.snapshot}) : super(key: key);

  @override
  _AllImagesState createState() => _AllImagesState();
}

class _AllImagesState extends State<AllImages> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.snapshot.data.documents.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: GridTile(
            child: CachedNetworkImage(
              imageUrl: widget.snapshot.data.documents.elementAt(index)['url'],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
    );
  }
}
