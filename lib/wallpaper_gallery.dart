import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
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
      body: Builder(
        builder: (BuildContext context) {
          return Stack(children: [
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
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.file_download),
                        onPressed: () async {
                          await _downloadWallpaper(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.format_paint),
                        onPressed: () async {
                          await setWallpaper(
                            context: context,
                            imgUrl: widget.wallpaperList
                                .elementAt(
                                  _pageController.page.toInt(),
                                )
                                .url,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]);
        },
      ),
    );
  }

  Future _downloadWallpaper(BuildContext context) async {
    var status = await Permission.storage.request();

    if (status.isGranted) {
      try {
        var imageId = await ImageDownloader.downloadImage(
          widget.wallpaperList
              .elementAt(
                _pageController.page.toInt(),
              )
              .url,
          destination: AndroidDestinationType.directoryPictures,
        );

        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Download completed.'),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () async {
                var path = await ImageDownloader.findPath(imageId);
                await ImageDownloader.open(path);
              },
            ),
          ),
        );
      } on PlatformException catch (error) {
        print(error);
      }
    } else {
      _showOpenSettingsAlert(context);
    }
  }

  void _showOpenSettingsAlert(BuildContext context) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Need access to storage.'),
        actions: [
          FlatButton(
            onPressed: () {
              openAppSettings();
            },
            child: Text('Open settings'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          )
        ],
      ),
    );
  }
}
