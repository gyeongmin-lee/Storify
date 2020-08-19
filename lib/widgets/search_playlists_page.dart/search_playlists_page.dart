import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/constants/values.dart' as Constants;
import 'package:storify/utils/debouncer.dart';

class SearchPlaylistsPage extends StatefulWidget {
  @override
  _SearchPlaylistsPageState createState() => _SearchPlaylistsPageState();
}

class _SearchPlaylistsPageState extends State<SearchPlaylistsPage> {
  TextEditingController _controller = TextEditingController();
  Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
    _debouncer = Debouncer(milliseconds: Constants.searchDebounceMillisecond);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _debouncer.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
    if (mounted) {
      _debouncer.run(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              autofocus: true,
              controller: _controller,
              maxLength: 50,
              style: TextStyles.primary.copyWith(fontSize: 18.0),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white12,
                  hintText: 'Search for playlists',
                  suffixIcon: _controller.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () => _controller.clear(),
                          child: Icon(Icons.close,
                              color: CustomColors.secondaryTextColor),
                        )
                      : null,
                  border: InputBorder.none,
                  counterText: '',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusColor: Colors.red,
                  hintStyle: TextStyle(
                      color: Colors.white38, fontWeight: FontWeight.w300)),
            )
          ],
        ),
      ),
    );
  }
}
