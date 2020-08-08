import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'utilities.dart';

class CategoryWallpapers extends StatefulWidget {
  final String category;

  CategoryWallpapers({Key key, @required this.category}) : super(key: key);

  @override
  _CategoryWallpapersState createState() => _CategoryWallpapersState();
}

class _CategoryWallpapersState extends State<CategoryWallpapers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('That Wallpaper App!'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('wallpapers').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            // Get all documents of widget.category.
            var categoryDocuments = snapshot.data.documents
                .where((document) => (document.data['tag'] == widget.category));

            return ListView.builder(
              itemCount: categoryDocuments.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: InkResponse(
                    onTap: () async {
                      setWallpaper(
                          context: context,
                          imgUrl:
                              categoryDocuments.elementAt(index).data['url']);
                    },
                    child: CachedNetworkImage(
                      imageUrl: categoryDocuments.elementAt(index).data['url'],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
