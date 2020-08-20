import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/services/firebase_db.dart';
import 'package:storify/services/playlist_actions.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:storify/widgets/_common/custom_image_provider.dart';
import 'package:provider/provider.dart';

class PlayListItem extends StatefulWidget {
  const PlayListItem(
      {Key key,
      @required this.playlist,
      this.onPressed,
      this.titleText,
      this.subtitleText,
      this.trailing})
      : super(key: key);

  final Playlist playlist;
  final VoidCallback onPressed;
  final String titleText;
  final String subtitleText;
  final Widget trailing;

  @override
  _PlayListItemState createState() => _PlayListItemState();
}

class _PlayListItemState extends State<PlayListItem> {
  FirebaseDB _firebaseDB;
  SlidableController _slidableController;

  @override
  void initState() {
    super.initState();
    _firebaseDB = FirebaseDB();
    _slidableController = SlidableController();
  }

  Future<void> _onOpenInSpotify() async {
    await PlaylistActions.openInSpotify(widget.playlist.externalUrl);
  }

  Future<void> _onShareLink() async {
    await PlaylistActions.shareAsLink(widget.playlist);
  }

  Future<void> _onSavePlaylist(BuildContext context) async {
    final spotifyAuth = context.read<SpotifyAuth>();
    await PlaylistActions.savePlaylist(spotifyAuth.user.id, widget.playlist);
  }

  Future<void> _onUnsavePlaylist(BuildContext context) async {
    final spotifyAuth = context.read<SpotifyAuth>();
    await PlaylistActions.unsavePlaylist(
        spotifyAuth.user.id, widget.playlist.id);
  }

  void _onLongPress(BuildContext context) {
    if (_slidableController?.activeState == null)
      Slidable.of(context)?.open(actionType: SlideActionType.secondary);
    else
      Slidable.of(context)?.close();
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<SpotifyAuth>().user.id;
    return Slidable(
      controller: _slidableController,
      actionPane: SlidableScrollActionPane(),
      showAllActionsThreshold: 0.25,
      actionExtentRatio: 0.22,
      secondaryActions: [
        IconSlideAction(
          caption: 'OPEN IN\nSPOTIFY',
          color: Colors.white.withOpacity(0.05),
          foregroundColor: CustomColors.primaryTextColor,
          iconWidget: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Opacity(
                opacity: 0.75,
                child: Image.asset('images/spotify_white.png', width: 24.0)),
          ),
          onTap: _onOpenInSpotify,
        ),
        IconSlideAction(
          iconWidget: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Icon(
              Icons.link,
              color: CustomColors.primaryTextColor,
            ),
          ),
          caption: 'SHARE LINK',
          color: Colors.white.withOpacity(0.05),
          foregroundColor: CustomColors.primaryTextColor,
          onTap: _onShareLink,
        ),
        StreamBuilder<bool>(
          stream: _firebaseDB.isPlaylistSavedStream(
              userId: userId, playlistId: widget.playlist.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            if (snapshot.hasData) {
              final isPlaylistSaved = snapshot.data;
              return IconSlideAction(
                iconWidget: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Icon(
                    isPlaylistSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: CustomColors.primaryTextColor,
                  ),
                ),
                caption: isPlaylistSaved ? 'UNSAVE' : 'SAVE',
                color: Colors.white.withOpacity(0.05),
                foregroundColor: CustomColors.primaryTextColor,
                onTap: isPlaylistSaved
                    ? () => _onUnsavePlaylist(context)
                    : () => _onSavePlaylist(context),
              );
            } else {
              return IconSlideAction(
                iconWidget: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Icon(
                    Icons.bookmark_border,
                    color: Colors.white24,
                  ),
                ),
                caption: 'SAVE',
                color: Colors.white.withOpacity(0.05),
                foregroundColor: Colors.white24,
              );
            }
          },
        )
      ],
      child: Builder(
        builder: (context) => ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: CustomImageProvider.cachedImage(
                widget.playlist.playlistImageUrl),
            backgroundColor: Colors.transparent,
          ),
          title: Text(widget.titleText ?? widget.playlist.name,
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
