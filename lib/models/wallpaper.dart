import 'package:cloud_firestore/cloud_firestore.dart';

class Wallpaper {
  final String url;
  final String category;
  final String name;
  final String id;
  bool isFavorite;

  Wallpaper.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : this.url = snapshot['url'],
        this.category = snapshot['tag'],
        this.name = snapshot['name'],
        this.id = snapshot.id,
        this.isFavorite = false;
}
