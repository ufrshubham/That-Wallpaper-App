import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:that_wallpaper_app/utilities.dart';

import 'models/wallpaper.dart';

class WallpaperGallery extends StatefulWidget {
  final List<Wallpaper> wallpaperList;
  final int initialPage;

  WallpaperGallery(
      {Key key, @required this.wallpaperList, @required this.initialPage})
      : super(key: key);

  @override
  _WallpaperGalleryState createState() => _WallpaperGalleryState();
}

class _WallpaperGalleryState extends State<WallpaperGallery> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PhotoViewGallery.builder(
          pageController: _pageController,
          itemCount: widget.wallpaperList.length,
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: CachedNetworkImageProvider(
                widget.wallpaperList.elementAt(index).url,
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              width: 100.0,
              color: Color(IconTheme.of(context).color.value ^ 0xffffff),
              child: IconButton(
                icon: Icon(Icons.format_paint),
                onPressed: () async {
                  await setWallpaper(
                    context: context,
                    imgUrl: widget.wallpaperList
                        .elementAt(_pageController.page.toInt()).url,
                  );
                },
              ),
            ),
          ),
        )
      ]),
    );
  }
}
