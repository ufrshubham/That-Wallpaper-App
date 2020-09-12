import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

enum SetWallpaperAs { Home, Lock, Both }

const _setAs = {
  SetWallpaperAs.Home: WallpaperManager.HOME_SCREEN,
  SetWallpaperAs.Lock: WallpaperManager.LOCK_SCREEN,
  SetWallpaperAs.Both: WallpaperManager.BOTH_SCREENS,
};

Future<void> setWallpaper({
  @required BuildContext context,
  @required String imgUrl,
}) async {
  var actionSheet = CupertinoActionSheet(
    title: Text('Set as'),
    actions: [
      CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop(SetWallpaperAs.Home);
          },
          child: Text('Home Screen')),
      CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop(SetWallpaperAs.Lock);
          },
          child: Text('Lock Screen')),
      CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop(SetWallpaperAs.Both);
          },
          child: Text('Both Screens')),
    ],
  );

  SetWallpaperAs option = await showCupertinoModalPopup(
      context: context, builder: (context) => actionSheet);

  if (option != null) {
    var cachedImg = await DefaultCacheManager().getSingleFile(imgUrl);

    if (cachedImg != null) {
      var croppedImg = await ImageCropper.cropImage(
        sourcePath: cachedImg.path,
        aspectRatio: CropAspectRatio(
          ratioX: MediaQuery.of(context).size.width,
          ratioY: MediaQuery.of(context).size.height,
        ),
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.blue,
          toolbarTitle: 'Crop Image',
          hideBottomControls: true,
        ),
      );

      if (croppedImg != null) {
        var result = await WallpaperManager.setWallpaperFromFile(
            croppedImg.path, _setAs[option]);

        if (result != null) {
          debugPrint(result);
        }
      }
    }
  }
}
