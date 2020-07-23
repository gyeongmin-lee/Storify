import 'package:flutter/foundation.dart';

class User {
  User({@required this.id, @required this.name, @required this.avatarImageUrl});
  final String name;
  final String avatarImageUrl;
  final String id;

  User.fromJson(Map<String, dynamic> json)
      : name = json['display_name'],
        avatarImageUrl = json['images'][0]['url'],
        id = json['id'];
}
