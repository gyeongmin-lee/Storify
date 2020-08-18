import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/widgets/_common/base_scaffold.dart';
import 'package:storify/widgets/browse_page/browse_page.dart';
import 'package:storify/widgets/my_playlists_page/my_playlists_page.dart';
import 'package:storify/widgets/profile_page/profile_page.dart';
import 'package:storify/widgets/saved_playlists_page/saved_playlists_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Map<String, dynamic>> _widgetOptions = [
    {
      'titleText': 'MY PLAYLISTS',
      'hideAppBar': false,
      'widget': MyPlaylistsPage.create(),
    },
    {
      'titleText': '',
      'hideAppBar': true,
      'widget': BrowsePage(),
    },
    {
      'hideAppBar': false,
      'titleText': 'SAVED PLAYLISTS',
      'widget': SavedPlaylistsPage(),
    },
    {
      'hideAppBar': true,
      'titleText': 'PROFILE',
      'widget': ProfilePage(),
    },
  ];

  static const _bottomNavigationSpacing = const EdgeInsets.only(bottom: 3.0);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      titleText: _widgetOptions.elementAt(_selectedIndex)['titleText'],
      hideAppBar: _widgetOptions.elementAt(_selectedIndex)['hideAppBar'],
      bottomNavigationBar: Theme(
        data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Padding(
                padding: _bottomNavigationSpacing,
                child: Icon(Icons.library_music),
              ),
              title: Text('MY PLAYLISTS'),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: _bottomNavigationSpacing,
                child: Icon(Icons.search),
              ),
              title: Text('BROWSE'),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: _bottomNavigationSpacing,
                child: Icon(Icons.collections_bookmark),
              ),
              title: Text('SAVED PLAYLISTS'),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: _bottomNavigationSpacing,
                child: Icon(Icons.account_circle),
              ),
              title: Text('PROFILE'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: CustomColors.primaryTextColor,
          unselectedItemColor: Colors.white30,
          elevation: 0,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyles.primary.copyWith(fontSize: 10.0),
          unselectedLabelStyle: TextStyles.secondary.copyWith(fontSize: 10.0),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white.withOpacity(0.05),
          iconSize: 24.0,
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex)['widget'],
    );
  }
}
