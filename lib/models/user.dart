import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class User extends Equatable {
  User({@required this.id, @required this.name, @required this.avatarImageUrl});
  final String name;
  final String avatarImageUrl;
  final String id;

  factory User.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    final name = json['display_name'];
    final avatarImageUrl =
        json['images'].length != 0 ? json['images'][0]['url'] : null;
    final id = json['id'];
    return User(name: name, avatarImageUrl: avatarImageUrl, id: id);
  }

  @override
  List<Object> get props => [name, avatarImageUrl, id];
}
