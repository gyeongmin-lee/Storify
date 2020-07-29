import 'package:flutter/foundation.dart';

class Artist {
  Artist({@required this.name, this.artistImageUrl, this.href});
  final String name;
  final String artistImageUrl;
  final String href;

  factory Artist.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final href = json['href'];
    return Artist(name: name, href: href);
  }
}
