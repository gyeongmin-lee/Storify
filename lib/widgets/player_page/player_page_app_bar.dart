import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/widgets/_common/custom_flat_icon_button.dart';
import 'package:storify/widgets/_common/overlay_menu.dart';
import 'package:storify/widgets/home_page/home_page.dart';
import 'package:storify/widgets/more_info_menu_body/more_info_menu_body.dart';

class PlayerPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PlayerPageAppBar(
      {Key? key, required this.playlist, this.isOpenedFromDeepLink = false})
      : super(key: key);
  final Playlist? playlist;
  final bool isOpenedFromDeepLink;

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      title: Text(
        playlist?.name ?? '',
        style: TextStyles.appBarTitle.copyWith(letterSpacing: -2.0),
      ),
      leading: isOpenedFromDeepLink
          ? CustomFlatIconButton(
              icon: Icon(
                Icons.arrow_back,
                color: CustomColors.secondaryTextColor,
              ),
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  HomePage.routeName, (Route<dynamic> route) => false))
          : null,
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: CustomColors.secondaryTextColor,
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'MORE',
            style: TextStyles.smallButtonText,
          ),
          onPressed: () => OverlayMenu.show(context,
              menuBody: MoreInfoMenuBody(
                playlist: playlist,
              )),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
