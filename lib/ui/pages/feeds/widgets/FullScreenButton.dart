import 'package:overlay_dialog/overlay_dialog.dart';

import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/widgets/players/BetterPlayerFullScreen.dart';
import 'package:dtube_togo/ui/widgets/players/YTPlayerFullScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FullScreenButton extends StatelessWidget {
  FullScreenButton(
      {Key? key,
      required this.videoUrl,
      required this.videoSource,
      this.bgColor,
      required this.iconSize})
      : super(key: key);

  final String videoUrl;
  final String videoSource;
  Color? bgColor;
  double iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: iconSize,
        // style: ButtonStyle(
        //     backgroundColor:
        //         MaterialStateProperty.all(Colors.transparent)),
        onPressed: () {
          // pushDynamicScreen(
          //   context,
          //   screen: videoSource == "youtube"
          //       ? YoutubePlayerFullScreenPage(
          //           link: videoUrl,
          //         )
          //       : ["ipfs", "sia"].contains(videoSource)
          //           ? BetterPlayerFullScreenPage(
          //               link: videoUrl,
          //             )
          //           : Text("no player detected"),
          //   withNavBar: false, // OPTIONAL VALUE. True by default.
          //   // pageTransitionAnimation: PageTransitionAnimation.cupertino,
          // );
          DialogHelper().show(
              context,
              DialogWidget.custom(
                child: videoSource == "youtube"
                    ? YoutubePlayerFullScreenPage(
                        link: videoUrl,
                      )
                    : ["ipfs", "sia"].contains(videoSource)
                        ? BetterPlayerFullScreenPage(
                            link: videoUrl,
                          )
                        : Text("no player detected"),
              ));
        },
        icon: ShadowedIcon(
          icon: FontAwesomeIcons.expand,
          color: Colors.white,
          shadowColor: Colors.black,
          size: iconSize,
        ));
  }
}