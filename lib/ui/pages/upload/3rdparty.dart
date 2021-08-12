import 'package:dtube_togo/bloc/hivesigner/hivesigner_bloc_full.dart';
import 'package:dtube_togo/bloc/settings/settings_bloc.dart';
import 'package:dtube_togo/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_togo/bloc/thirdpartyloader/thirdpartyloader_bloc_full.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/ui/pages/upload/uploadForm.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;

class Wizard3rdParty extends StatefulWidget {
  const Wizard3rdParty({
    Key? key,
  }) : super(key: key);

  @override
  _Wizard3rdPartyState createState() => _Wizard3rdPartyState();
}

class _Wizard3rdPartyState extends State<Wizard3rdParty> {
  TextEditingController _foreignUrlController = new TextEditingController();
  late SettingsBloc _settingsBloc;
  late UserBloc _userBloc;
  late HivesignerBloc _hivesignerBloc;
  late ThirdPartyMetadataBloc _thirdPartyBloc;

  UploadData _uploadData = UploadData(
      link: "",
      title: "",
      description: "",
      tag: "",
      vpPercent: 0.0,
      vpBalance: 0,
      burnDtc: 0,
      dtcBalance: 0,
      duration: "",
      thumbnailLocation: "",
      localThumbnail: true,
      videoLocation: "",
      localVideoFile: true,
      originalContent: false,
      nSFWContent: false,
      unlistVideo: false,
      videoSourceHash: "",
      video240pHash: "",
      video480pHash: "",
      videoSpriteHash: "",
      thumbnail640Hash: "",
      thumbnail210Hash: "",
      isEditing: false,
      isPromoted: false,
      parentAuthor: "",
      parentPermlink: "",
      uploaded: false,
      crossPostToHive: false);

  @override
  void initState() {
    super.initState();
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _settingsBloc.add(FetchSettingsEvent());
    _thirdPartyBloc = BlocProvider.of<ThirdPartyMetadataBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(FetchDTCVPEvent());
    _hivesignerBloc = BlocProvider.of<HivesignerBloc>(context);

    loadHiveSignerAccessToken();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadHiveSignerAccessToken() async {
    String _accessToken = await sec.getHiveSignerAccessToken();
    _uploadData.crossPostToHive = _accessToken != '';
  }

  void childCallback(UploadData ud) {
    setState(() {
      _uploadData = ud;
      BlocProvider.of<TransactionBloc>(context)
          .add(SendCommentEvent(_uploadData));
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("1. Video", style: TextStyle(fontSize: 18)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 150,
                child: TextField(
                  decoration: new InputDecoration(
                      labelText:
                          "youtube url"), // TODO: support more foreign systems
                  controller: _foreignUrlController,
                ),
              ),
              InputChip(
                  label: BlocBuilder<ThirdPartyMetadataBloc,
                          ThirdPartyMetadataState>(
                      bloc: _thirdPartyBloc,
                      builder: (context, state) {
                        if (state is ThirdPartyMetadataInitialState) {
                          return Text("load data");
                        } else if (state is ThirdPartyMetadataLoadedState) {
                          return Text("reload data");
                        } else if (state is ThirdPartyMetadataErrorState) {
                          print(state.message);
                          return Text("error data");
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                  onPressed: () async {
                    _thirdPartyBloc.add(LoadThirdPartyMetadataEvent(
                        _foreignUrlController.value.text));
                  }),
            ],
          ),
          BlocBuilder<ThirdPartyMetadataBloc, ThirdPartyMetadataState>(
            bloc: _thirdPartyBloc,
            builder: (context, state) {
              if (state is ThirdPartyMetadataLoadedState) {
                _uploadData = UploadData(
                    link: "",
                    title: state.metadata.title,
                    description: state.metadata.description,
                    tag: "",
                    vpPercent: 0.0,
                    vpBalance: 0,
                    burnDtc: 0,
                    dtcBalance: 0,
                    duration: state.metadata.duration.inSeconds.toString(),
                    thumbnailLocation: state.metadata.thumbUrl,
                    localThumbnail: false,
                    videoLocation: state.metadata.sId,
                    localVideoFile: false,
                    originalContent: false,
                    nSFWContent: false,
                    unlistVideo: false,
                    videoSourceHash: "",
                    video240pHash: "",
                    video480pHash: "",
                    videoSpriteHash: "",
                    thumbnail640Hash: "",
                    thumbnail210Hash: "",
                    isEditing: false,
                    isPromoted: false,
                    parentAuthor: "",
                    parentPermlink: "",
                    uploaded: false,
                    crossPostToHive: _uploadData.crossPostToHive);
                return UploadForm(
                  uploadData: _uploadData,
                  callback: childCallback,
                );
              } else {
                return SizedBox(height: 0);
              }
            },
          )
        ],
      ),
    );
  }
}
