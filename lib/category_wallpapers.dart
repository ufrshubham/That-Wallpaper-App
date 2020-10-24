import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:that_wallpaper_app/models/wallpaper.dart';
import 'package:that_wallpaper_app/providers/fav_wallpaper_manager.dart';
import 'package:that_wallpaper_app/wallpaper_gallery.dart';

import 'theme_manager.dart';

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
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_5),
            onPressed: () {
              if (ThemeManager.notifier.value == ThemeMode.dark) {
                ThemeManager.setTheme(ThemeMode.light);
              } else {
                ThemeManager.setTheme(ThemeMode.dark);
              }
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('wallpapers_2').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            // Get all wallpapers of widget.category.
            var wallpapers =
                _getWallpapersOfCurrentCategory(snapshot.data.documents);

            return ListView.builder(
              itemCount: wallpapers.length,
              itemBuilder: (BuildContext context, int index) {
                var favWallpaperManager =
                    Provider.of<FavWallpaperManager>(context);

                return ListTile(
                  title: InkResponse(
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WallpaperGallery(
                              wallpaperList: wallpapers, initialPage: index),
                        ),
                      );
                    },
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      height: 200.0,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                              wallpapers.elementAt(index).url),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          color: Color(
                              Theme.of(context).textTheme.caption.color.value ^
                                  0xffffff),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                wallpapers.elementAt(index).name,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w400),
                              ),
                              IconButton(
                                icon: Icon(
                                  wallpapers.elementAt(index).isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  if (wallpapers.elementAt(index).isFavorite) {
                                    favWallpaperManager.removeFromFav(
                                      wallpapers.elementAt(index),
                                    );
                                  } else {
                                    favWallpaperManager.addToFav(
                                      wallpapers.elementAt(index),
                                    );
                                  }
                                  wallpapers.elementAt(index).isFavorite =
                                      !wallpapers.elementAt(index).isFavorite;
                                },
                              )
                            ],
                          ),
                        ),
                      ),
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

  List<Wallpaper> _getWallpapersOfCurrentCategory(
      List<DocumentSnapshot> documents) {
    var list = List<Wallpaper>();

    var favWallpaperManager = Provider.of<FavWallpaperManager>(context);

    documents.forEach((document) {
      var wallpaper = Wallpaper.fromDocumentSnapshot(document);

      if (wallpaper.category == widget.category) {
        if (favWallpaperManager.isFavorite(wallpaper)) {
          wallpaper.isFavorite = true;
        }

        list.add(wallpaper);
      }
    });

    return list;
  }
}
