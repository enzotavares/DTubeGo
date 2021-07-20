import 'package:cached_network_image/cached_network_image.dart';

import 'package:dtube_togo/bloc/user/user_bloc_full.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';

class AccountAvatarBase extends StatelessWidget {
  const AccountAvatarBase({Key? key, required this.username}) : super(key: key);
  final String username;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(repository: UserRepositoryImpl()),
      child: AccountAvatar(
        username: username,
      ),
    );
  }
}

class AccountAvatar extends StatefulWidget {
  const AccountAvatar({Key? key, required this.username}) : super(key: key);
  final username;

  @override
  _AccountAvatarState createState() => _AccountAvatarState();
}

class _AccountAvatarState extends State<AccountAvatar> {
  late UserBloc _userBlocAvatar;
  @override
  void initState() {
    super.initState();
    _userBlocAvatar = BlocProvider.of<UserBloc>(context);
    _userBlocAvatar.add(FetchAccountDataEvent(widget.username));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      bloc: _userBlocAvatar,
      builder: (context, state) {
        if (state is UserLoadingState) {
          return CircularProgressIndicator();
        } else if (state is UserLoadedState &&
            state.user.jsonString != null &&
            state.user.jsonString?.profile != null &&
            state.user.jsonString?.profile?.avatar != "" &&
            state.user.name == widget.username) {
          try {
            return CachedNetworkImage(
                imageUrl: state.user.jsonString!.profile!.avatar!
                    .replaceAll("http:", "https:"),
                imageBuilder: (context, imageProvider) => Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                placeholder: (context, url) => AvatarLoadingPlaceholder());
          } catch (e) {
            return AvatarErrorPlaceholder();
          }
        } else if (state is UserErrorState) {
          return AvatarErrorPlaceholder();
        } else {
          return AvatarErrorPlaceholder();
        }
      },
    );
  }
}

class AvatarErrorPlaceholder extends StatelessWidget {
  const AvatarErrorPlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: Image.asset('assets/images/Flag_of_None.svg.png').image,
            fit: BoxFit.cover),
      ),
    );
  }
}

class AvatarLoadingPlaceholder extends StatelessWidget {
  const AvatarLoadingPlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: Image.asset('assets/images/appicon.png').image,
            fit: BoxFit.cover),
      ),
    );
  }
}