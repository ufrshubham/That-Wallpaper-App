import 'package:flutter/material.dart';
import 'package:that_wallpaper_app/all_images.dart';
import 'package:that_wallpaper_app/fav.dart';
import 'package:that_wallpaper_app/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'That Wallpaper App!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'That Wallpaper App!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final pages = [AllImages(), Home(), Favorite()];
  final pageController = PageController(initialPage: 1);
  int currentSelected = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: pages.length,
        itemBuilder: (BuildContext context, int index) {
          return pages[index];
        },
        onPageChanged: (int index) {
          setState(() {
            currentSelected = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentSelected,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            title: Text('All Images'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favorites'),
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
      ),
    );
  }
}
