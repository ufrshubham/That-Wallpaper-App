import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:that_wallpaper_app/all_images.dart';
import 'package:that_wallpaper_app/constants.dart';
import 'package:that_wallpaper_app/fav.dart';
import 'package:that_wallpaper_app/home.dart';
import 'package:that_wallpaper_app/models/wallpaper.dart';
import 'package:that_wallpaper_app/providers/fav_wallpaper_manager.dart';
import 'package:that_wallpaper_app/theme_manager.dart';

Future<void> main() async {
  await _initApp();

  runApp(MyHomePage(
    title: 'That Wallpaper App!',
  ));
}

Future _initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  var docDir = await getApplicationDocumentsDirectory();
  Hive.init(docDir.path);

  var favBox = await Hive.openBox(FAV_BOX);
  if (favBox.get(FAV_LIST_KEY) == null) {
    favBox.put(FAV_LIST_KEY, List<dynamic>());
  }

  var settings = await Hive.openBox(SETTINGS);
  if(settings.get(DARK_THEME_KEY) == null){
    settings.put(DARK_THEME_KEY, false);
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final pageController = PageController(initialPage: 1);
  int currentSelected = 1;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => FavWallpaperManager(),
      child: ValueListenableBuilder(
        valueListenable: ThemeManager.notifier,
        child: _buildScaffold(),
        builder: (BuildContext context, ThemeMode themeMode, Widget child) {
          return MaterialApp(
            title: widget.title,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeMode,
            home: child,
          );
        },
      ),
    );
  }

  Scaffold _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
          if (snapshot.hasData && snapshot.data.documents.isNotEmpty) {
            var wallpapersList = List<Wallpaper>();
            var favWallpaperManager = Provider.of<FavWallpaperManager>(context);

            snapshot.data.documents.forEach((documentSnapshot) {
              var wallpaper = Wallpaper.fromDocumentSnapshot(documentSnapshot);

              if (favWallpaperManager.isFavorite(wallpaper)) {
                wallpaper.isFavorite = true;
              }

              wallpapersList.add(wallpaper);
            });

            return PageView.builder(
              controller: pageController,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return _getPageAtIndex(index, wallpapersList);
              },
              onPageChanged: (int index) {
                setState(() {
                  currentSelected = index;
                });
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentSelected,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.image),
          label: 'All Images',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
      ],
      onTap: (int index) {
        setState(() {
          currentSelected = index;
          pageController.animateToPage(
            currentSelected,
            curve: Curves.fastOutSlowIn,
            duration: Duration(milliseconds: 400),
          );
        });
      },
    );
  }

  Widget _getPageAtIndex(int index, List<Wallpaper> wallpaperList) {
    switch (index) {
      case 0:
        return AllImages(
          wallpapersList: wallpaperList,
        );
        break;
      case 1:
        return Home(
          wallpapersList: wallpaperList,
        );
        break;
      case 2:
        return Favorite(
          wallpapersList: wallpaperList,
        );
        break;
      default:
        // Should never get hit.
        return CircularProgressIndicator();
        break;
    }
  }
}
