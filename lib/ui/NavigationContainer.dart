import 'dart:async';

import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_togo/bloc/notification/notification_bloc_full.dart';
import 'package:dtube_togo/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';

import 'package:dtube_togo/bloc/user/user_bloc_full.dart';

import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/pages/feeds/FeedList.dart';

import 'package:dtube_togo/ui/pages/notifications/Notifications.dart';
import 'package:dtube_togo/ui/pages/settings/Settings.dart';
import 'package:dtube_togo/ui/pages/upload/uploaderTabContainer.dart';
import 'package:dtube_togo/ui/pages/user/User.dart';
import 'package:dtube_togo/ui/pages/wallet/WalletTabContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class NavigationContainer extends StatefulWidget {
  NavigationContainer({Key? key}) : super(key: key);

  @override
  _NavigationContainerState createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  int bottomSelectedIndex = 0;
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: new FaIcon(
            FontAwesomeIcons.addressBook,
            color: Colors.white,
          ),
          title: 'Feed'),
      PersistentBottomNavBarItem(
        icon: new FaIcon(
          FontAwesomeIcons.newspaper,
          color: Colors.white,
        ),
        title: 'New',
      ),
      PersistentBottomNavBarItem(
          icon: new FaIcon(
            FontAwesomeIcons.idBadge,
            color: Colors.white,
          ),
          title: 'Profile'),
      PersistentBottomNavBarItem(
        icon: new FaIcon(
          FontAwesomeIcons.burn,
          color: Colors.white,
        ),
        title: 'Hot',
      ),
      // TODO: combine hot + trending ?
      PersistentBottomNavBarItem(
        icon: new FaIcon(
          FontAwesomeIcons.chartLine,
          color: Colors.white,
        ),
        title: 'Trending',
      ),
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  List<Widget> _buildScreens() {
    return [
      BlocProvider<FeedBloc>(
        create: (context) => FeedBloc(repository: FeedRepositoryImpl())
          ..add(FetchFeedEvent(feedType: "MyFeed")),
        child:
            FeedList(feedType: 'MyFeed', bigThumbnail: true, showAuthor: false),
      ),
      BlocProvider<FeedBloc>(
        create: (context) => FeedBloc(repository: FeedRepositoryImpl())
          ..add(FetchFeedEvent(feedType: "NewFeed")),
        child: FeedList(
          feedType: 'NewFeed',
          bigThumbnail: true,
          showAuthor: false,
        ),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider<UserBloc>(
            create: (BuildContext context) =>
                UserBloc(repository: UserRepositoryImpl()),
          ),
          BlocProvider<TransactionBloc>(
            create: (BuildContext context) =>
                TransactionBloc(repository: TransactionRepositoryImpl()),
          ),
        ],
        child: UserPage(
          ownUserpage: true,
        ),
      ),
      BlocProvider<FeedBloc>(
        create: (context) => FeedBloc(repository: FeedRepositoryImpl())
          ..add(FetchFeedEvent(feedType: "HotFeed")),
        child: FeedList(
            feedType: 'HotFeed', bigThumbnail: true, showAuthor: false),
      ),
      BlocProvider<FeedBloc>(
        create: (context) => FeedBloc(repository: FeedRepositoryImpl())
          ..add(FetchFeedEvent(feedType: "TrendingFeed")),
        child: FeedList(
            feedType: 'TrendingFeed', bigThumbnail: true, showAuthor: false),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        elevation: 8,
        toolbarHeight: 60,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: CircleAvatar(
                    backgroundColor: globalRed,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return UploaderMainPage();
                            },
                          ),
                        );
                      },
                      child: new FaIcon(
                        FontAwesomeIcons.cloudUploadAlt,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              BalanceOverview(),
              DTubeLogo(size: 60),
              Container(
                width: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          backgroundColor: globalBlue,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return BlocProvider<NotificationBloc>(
                                    create: (context) => NotificationBloc(
                                        repository:
                                            NotificationRepositoryImpl()),
                                    child: Notifications());
                              }));
                            },
                            child: new FaIcon(
                              FontAwesomeIcons.bell,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: globalBlue,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return BlocProvider<NotificationBloc>(
                                    create: (context) => NotificationBloc(
                                        repository:
                                            NotificationRepositoryImpl()),
                                    child: WalletMainPage());
                              }));
                            },
                            child: new FaIcon(
                              FontAwesomeIcons.wallet,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: globalBlue,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return BlocProvider<SettingsBloc>(
                                    create: (context) => SettingsBloc(),
                                    child: SettingsPage());
                              }));
                            },
                            child: new FaIcon(
                              FontAwesomeIcons.cog,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: globalBGColor, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(25.0),
          colorBehindNavBar: globalBGColor,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.easeOut,
          duration: Duration(milliseconds: 200),
        ),
        // onItemSelected: (index) {
        //   setState(() {
        //     bottomSelectedIndex =
        //         index; // NOTE: THIS IS CRITICAL!! Don't miss it!
        //     _controller.index = index;
        //   });
        // },

        navBarStyle: NavBarStyle.style14,
      ),
    );
  }
}

class BalanceOverview extends StatefulWidget {
  const BalanceOverview({
    Key? key,
  }) : super(key: key);

  @override
  _BalanceOverviewState createState() => _BalanceOverviewState();
}

class _BalanceOverviewState extends State<BalanceOverview> {
  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(FetchDTCVPEvent()); // statements;
    const oneSec = const Duration(seconds: 240);
    new Timer.periodic(oneSec, (Timer t) {
      _userBloc.add(FetchDTCVPEvent());
    });
    // Do something
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      bloc: _userBloc,
      builder: (context, state) {
        if (state is UserInitialState) {
          return SizedBox(width: 0, height: 12);
        } else if (state is UserDTCVPLoadingState) {
          return SizedBox(width: 0, height: 12);
        } else if (state is UserDTCVPLoadedState) {
          double _dtcBalanceK = state.dtcBalance / 100000;
          double _vpBalanceK = state.vtBalance["v"]! / 1000;
          try {
            return Column(
                //mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  Text(
                    (_dtcBalanceK >= 1000 ? _dtcBalanceK / 1000 : _dtcBalanceK)
                            .toStringAsFixed(1) +
                        (_dtcBalanceK >= 1000 ? 'M' : 'K') +
                        "DTC",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(width: 4),
                  Text(
                    (_vpBalanceK >= 1000 ? _vpBalanceK / 1000 : _vpBalanceK)
                            .toStringAsFixed(1) +
                        (_vpBalanceK >= 1000 ? 'M' : 'K') +
                        "VP",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ]);
          } catch (e) {
            return FaIcon(FontAwesomeIcons.times);
          }
        } else if (state is UserErrorState) {
          return FaIcon(FontAwesomeIcons.times);
        } else {
          return FaIcon(FontAwesomeIcons.times);
        }
      },
    );
  }
}
