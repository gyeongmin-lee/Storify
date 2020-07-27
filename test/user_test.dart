import 'package:flutter_test/flutter_test.dart';
import 'package:storify/models/user.dart';

const sampleUserData = {
  'display_name': 'Jake',
  'images': [
    {'url': 'some_image_url'}
  ],
  'id': '123',
};

final sampleUser =
    User(name: 'Jake', avatarImageUrl: 'some_image_url', id: '123');

void main() {
  group('fromJson', () {
    test('null', () {
      final user = User.fromJson(null);
      expect(user, null);
    });

    test('with all properties', () {
      final user = User.fromJson(sampleUserData);
      expect(user, sampleUser);
    });

    test('with empty image', () {
      final user =
          User.fromJson({'display_name': 'Jake', 'images': [], 'id': '123'});
      expect(user, User(name: 'Jake', avatarImageUrl: null, id: '123'));
    });
  });
}
