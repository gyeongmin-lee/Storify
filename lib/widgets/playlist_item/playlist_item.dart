import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/services/firebase_db.dart';
import 'package:storify/services/playlist_actions.dart';
import 'package:storify/services/spotify_auth.dart';

class PlayListItem extends StatefulWidget {
  const PlayListItem(
      {Key? key,
      required this.playlist,
      this.onPressed,
      this.titleText,
      this.subtitleText,
      this.trailing})
      : super(key: key);

  final Playlist playlist;
  final VoidCallback? onPressed;
  final String? titleText;
  final String? subtitleText;
  final Widget? trailing;

  @override
  _PlayListItemState createState() => _PlayListItemState();
}

class _PlayListItemState extends State<PlayListItem> {
  late FirebaseDB _firebaseDB;
  SlidableController? _slidableController;

  @override
  void initState() {
    super.initState();
    _firebaseDB = FirebaseDB();
    _slidableController = Slidable.of(context);
  }

  Future<void> _onOpenInSpotify() async {
    await PlaylistActions.openInSpotify(widget.playlist.externalUrl!);
  }

  Future<void> _onShareLink() async {
    await PlaylistActions.shareAsLink(widget.playlist);
  }

  Future<void> _onSavePlaylist(BuildContext context) async {
    final spotifyAuth = context.read<SpotifyAuth>();
    await PlaylistActions.savePlaylist(spotifyAuth.user!.id, widget.playlist);
  }

  Future<void> _onUnsavePlaylist(BuildContext context) async {
    final spotifyAuth = context.read<SpotifyAuth>();
    await PlaylistActions.unsavePlaylist(
        spotifyAuth.user!.id, widget.playlist.id);
  }

  void _onLongPress(BuildContext context) {
    // TODO Implement
    _slidableController?.openEndActionPane();
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<SpotifyAuth>().user!.id;
    final playlistImageUrl = widget.playlist.playlistImageUrl;

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          CustomSlidableAction(
            child: Column(children: [
              Opacity(
                  opacity: 0.75,
                  child: Image.asset('images/spotify_white.png', width: 24.0)),
              Text('OPEN IN\nSPOTIFY'),
            ]),
            backgroundColor: Colors.white.withOpacity(0.05),
            foregroundColor: CustomColors.primaryTextColor,
            padding: const EdgeInsets.only(bottom: 4.0),
            onPressed: (_) => _onOpenInSpotify(),
          ),
          SlidableAction(
            padding: const EdgeInsets.only(bottom: 4.0),
            icon: Icons.link,
            label: 'SHARE LINK',
            backgroundColor: Colors.white.withOpacity(0.05),
            foregroundColor: CustomColors.primaryTextColor,
            onPressed: (_) => _onShareLink(),
          ),
          StreamBuilder<bool>(
            stream: _firebaseDB.isPlaylistSavedStream(
                userId: userId, playlistId: widget.playlist.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }
              if (snapshot.hasData) {
                final isPlaylistSaved = snapshot.data!;
                return SlidableAction(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  icon:
                      isPlaylistSaved ? Icons.bookmark : Icons.bookmark_border,
                  label: isPlaylistSaved ? 'UNSAVE' : 'SAVE',
                  backgroundColor: Colors.white.withOpacity(0.05),
                  foregroundColor: CustomColors.primaryTextColor,
                  onPressed: isPlaylistSaved
                      ? (_) => _onUnsavePlaylist(context)
                      : (_) => _onSavePlaylist(context),
                );
              } else {
                return SlidableAction(
                  onPressed: (BuildContext context) => null,
                  icon: Icons.bookmark_border,
                  padding: const EdgeInsets.only(bottom: 4.0),
                  label: 'SAVE',
                  backgroundColor: Colors.white.withOpacity(0.05),
                  foregroundColor: Colors.white24,
                );
              }
            },
          )
        ],
        openThreshold: 0.25,
      ),
      child: Builder(
        builder: (context) => ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: playlistImageUrl != null
                ? CachedNetworkImageProvider(playlistImageUrl)
                : null,
            backgroundColor: Colors.black,
          ),
          title: Text(widget.titleText ?? widget.playlist.name!,
              style: TextStyles.primary.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              )),
          subtitle: Text(
              widget.subtitleText ?? '${widget.playlist.numOfTracks} TRACKS',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w300,
                color: Colors.white30,
              )),
          onTap: widget.onPressed,
          onLongPress: () => _onLongPress(context),
          trailing: widget.trailing,
        ),
      ),
    );
  }
}
