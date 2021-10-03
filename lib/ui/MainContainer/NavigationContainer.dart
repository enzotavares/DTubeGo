import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/moments/MomentsTabContainer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/notification/notification_bloc_full.dart';

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';

import 'package:dtube_go/bloc/user/user_bloc_full.dart';

import 'package:dtube_go/style/dtubeLoading.dart';
import 'package:dtube_go/style/styledCustomWidgets.dart';
import 'package:dtube_go/ui/MainContainer/BalanceOverview.dart';
import 'package:dtube_go/ui/MainContainer/MenuButton.dart';
import 'package:dtube_go/ui/pages/Explore/ExploreTabContainer.dart';

import 'package:dtube_go/ui/pages/feeds/FeedTabContainer.dart';
import 'package:dtube_go/ui/pages/notifications/NotificationButton.dart';

import 'package:dtube_go/ui/pages/upload/uploaderTabContainer.dart';
import 'package:dtube_go/ui/pages/user/User.dart';

import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/ui/widgets/system/customSnackbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavigationContainer extends StatefulWidget {
  NavigationContainer({Key? key}) : super(key: key);

  @override
  _NavigationContainerState createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  late List<Widget> _screens;

  int bottomSelectedIndex = 0;
  int _currentIndex = 0;

  // list of navigation buttons
  List<BottomNavigationBarItem> navBarItems = [
    BottomNavigationBarItem(
      label: '',
      icon: Center(
        child: new ShadowedIcon(
          icon: FontAwesomeIcons.alignJustify,
          color: Colors.white,
          shadowColor: Colors.black,
          size: globalIconSizeMedium,
        ),
      ),
    ),
    BottomNavigationBarItem(
      label: '',
      icon: Center(
        child: new ShadowedIcon(
          icon: FontAwesomeIcons.globeAfrica,
          color: Colors.white,
          shadowColor: Colors.black,
          size: globalIconSizeMedium,
        ),
      ),
    ),
    BottomNavigationBarItem(
      label: '',
      icon: Center(
        child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
          if (state is TransactionPreprocessingState) {
            if (state.txType == 13 || state.txType == 4) {
              return DTubeLogoPulseRotating(size: 10.w);
            }
          }
          return Center(
            child: new ShadowedIcon(
              icon: FontAwesomeIcons.plus,
              color: Colors.white,
              shadowColor: Colors.black,
              size: globalIconSizeMedium,
            ),
          );
        }),
      ),
    ),
    BottomNavigationBarItem(
      label: '',
      icon: Center(
        child: new ShadowedIcon(
          icon: FontAwesomeIcons.eye,
          color: Colors.white,
          shadowColor: Colors.black,
          size: globalIconSizeMedium,
        ),
      ),
    ),
    BottomNavigationBarItem(
      label: '',
      icon: CircleAvatar(
        backgroundColor: Colors.white,
        radius: globalIconSizeMedium * 0.6,
        child: AccountAvatarBase(
            username: "you",
            avatarSize: globalIconSizeMedium,
            showVerified: false,
            showName: false,
            width: globalIconSizeMedium),
      ),
    ),
  ];

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void uploaderCallback() {
    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    // list of all available screens
    _screens = [
      BlocProvider(
        create: (context) => FeedBloc(repository: FeedRepositoryImpl()),
        child: FeedMainPage(),
      ),
      BlocProvider(
        create: (context) => FeedBloc(repository: FeedRepositoryImpl()),
        child: ExploreMainPage(),
      ),
      UploaderMainPage(
        callback: uploaderCallback,
        key: UniqueKey(),
      ),
      MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) =>
                    FeedBloc(repository: FeedRepositoryImpl())),
            BlocProvider(
                create: (context) =>
                    UserBloc(repository: UserRepositoryImpl())),
          ],
          child: MomentsPage(
              play: _currentIndex ==
                  3)), // start auto play the first moment if this is the current visible screen
      BlocProvider(
        create: (context) => UserBloc(repository: UserRepositoryImpl()),
        child: UserPage(
          ownUserpage: true,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Color(0x00ffffff),
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
        title: Align(
          alignment: Alignment.topRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                  child: BalanceOverviewBase(),
                  onTap: () {
                    BlocProvider.of<UserBloc>(context).add(FetchDTCVPEvent());
                  }),
              BlocProvider<NotificationBloc>(
                create: (context) =>
                    NotificationBloc(repository: NotificationRepositoryImpl()),
                child: NotificationButton(iconSize: globalIconSizeMedium),
              ),
              buildMainMenuSpeedDial(context)
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 10.h,
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.0),
                  Colors.black,
                ],
                stops: [
                  0.0,
                  1.0
                ])),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: navBarItems,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              if (index == 2) {
                // if the user navigated to the uploader screen
                // reset uploader page
                _screens.removeAt(2);
                _screens.insert(
                    2,
                    new UploaderMainPage(
                      callback: uploaderCallback,
                      key: UniqueKey(),
                    ));
              }
              // if the user navigated to the moments page
              if (index == 3) {
                // reset moments page and set play = true

                _screens.removeAt(3);

                _screens.insert(
                  3,
                  new MultiBlocProvider(
                      providers: [
                        BlocProvider(
                            create: (context) =>
                                FeedBloc(repository: FeedRepositoryImpl())),
                      ],
                      child: MomentsPage(
                        key: UniqueKey(),
                        play: true,
                      )),
                  //  index = index;
                );
              } else {
                // if the user navigated to any other screen than the moments page
                // reset moments page and set play = false
                _screens.removeAt(3);

                _screens.insert(
                    3,
                    MomentsPage(
                      key: UniqueKey(),
                      play: false,
                    ));
              }
              // if there is a current background upload > show snachbar and do not navigate to the screen
              if (BlocProvider.of<TransactionBloc>(context).state
                      is TransactionPreprocessingState &&
                  index == 2) {
                showCustomFlushbarOnError(
                    "please wait until upload is finished", context);
              } else {
                _currentIndex = index;
              }
            });
          },
        ),
      ),
      body:
          // show global snack bar to notify the user about transactions
          BlocListener<TransactionBloc, TransactionState>(
              bloc: BlocProvider.of<TransactionBloc>(context),
              listener: (context, state) {
                if (state is TransactionSent) {
                  showCustomFlushbarOnSuccess(state, context);
                }
                if (state is TransactionError) {
                  showCustomFlushbarOnError(state.message, context);
                }
              },
              child:
                  // show all pages as indexedStack to keep the state of every screen
                  IndexedStack(
                children: _screens,
                index: _currentIndex,
              )),
    );
  }
}
