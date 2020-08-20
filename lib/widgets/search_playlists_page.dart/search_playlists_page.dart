import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/constants/values.dart' as Constants;
import 'package:storify/models/playlist.dart';
import 'package:storify/services/algolia_service.dart';
import 'package:storify/utils/debouncer.dart';
import 'package:storify/widgets/_common/status_indicator.dart';
import 'package:storify/widgets/player_page/player_page.dart';
import 'package:storify/widgets/playlist_item/playlist_item.dart';

class SearchPlaylistsPage extends StatefulWidget {
  @override
  _SearchPlaylistsPageState createState() => _SearchPlaylistsPageState();
}

class _SearchPlaylistsPageState extends State<SearchPlaylistsPage> {
  TextEditingController _controller = TextEditingController();
  Debouncer _debouncer;
  AlgoliaService _algoliaService = AlgoliaService();

  List<Playlist> _playlists = [];
  bool _isLoading = false;
  bool _isError = false;
  bool _isInitial = true;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(milliseconds: Constants.searchDebounceMillisecond);
  }

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.cancel();
    super.dispose();
  }

  Future<void> _search(String searchText) async {
    try {
      setState(() {
        _isLoading = true;
        _isError = false;
        _isInitial = false;
      });
      final searchResult = await _algoliaService.getSearchResult(searchText);
      setState(() => _playlists = searchResult);
    } catch (e) {
      print(e);
      _isError = true;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String searchText) {
    if (searchText == '') {
      _resetState();
    } else if (mounted) {
      _debouncer.run(() {
        _search(searchText);
      });
    }
  }

  void _resetState() {
    setState(() {
      _playlists = [];
      _isLoading = false;
      _isError = false;
      _isInitial = true;
    });
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
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white12,
                  hintText: 'Search for playlists',
                  suffixIcon: _controller.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _controller.clear();
                            _resetState();
                          },
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
            ),
            _buildSearchResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResult() {
    if (_isLoading) {
      return Expanded(
        child: StatusIndicator(
          status: Status.loading,
          message: 'Searching...',
        ),
      );
    }

    if (_isError) {
      return Expanded(
        child: StatusIndicator(
          status: Status.error,
          message: 'Failed to search playlists',
        ),
      );
    }

    if (_isInitial) {
      return Expanded(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Discover new playlists",
            style: TextStyles.primary
                .copyWith(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          SizedBox(
            height: 4.0,
          ),
          Text("Search for playlists by name or creator",
              style: TextStyles.secondary
                  .copyWith(fontWeight: FontWeight.w300, fontSize: 14.0)),
        ]),
      );
    }

    if (_playlists.isNotEmpty) {
      return Expanded(
        child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 0.0),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SvgPicture.asset('images/search_by_algolia.svg'),
                );
              }
              final playlist = _playlists[index - 1];
              return PlayListItem(
                  subtitleText: 'BY ${playlist.owner.name}',
                  playlist: playlist,
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PlayerPage.create(playlist: playlist)),
                      ));
            },
            itemCount: _playlists.length + 1,
            separatorBuilder: (context, index) => Divider(
                  color: Colors.white10,
                  thickness: 1.0,
                  height: 1.0,
                )),
      );
    } else {
      return Expanded(
        child: StatusIndicator(
          status: Status.warning,
          message: 'No matching playlist found',
        ),
      );
    }
  }
}
