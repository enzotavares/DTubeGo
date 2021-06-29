import 'package:dtube_togo/utils/SecureStorage.dart' as sec;
import 'package:bloc/bloc.dart';
import 'package:dtube_togo/bloc/user/user_event.dart';
import 'package:dtube_togo/bloc/user/user_state.dart';
import 'package:dtube_togo/bloc/user/user_response_model.dart';
import 'package:dtube_togo/bloc/user/user_repository.dart';
import 'package:dtube_togo/utils/discoverAPINode.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserRepository repository;

  UserBloc({required this.repository}) : super(UserInitialState());

  @override
  // TODO: implement initialState
  UserState get initialState => UserInitialState();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    String _avalonApiNode = await discoverAPINode();
    String? _applicationUser = await sec.getUsername();
    if (event is FetchAccountDataEvent) {
      yield UserLoadingState();
      try {
        User user = await repository.getAccountData(
            _avalonApiNode, event.username, _applicationUser!);
        yield UserLoadedState(user: user);
      } catch (e) {
        yield UserErrorState(message: e.toString());
      }
    }
    if (event is FetchMyAccountDataEvent) {
      yield UserLoadingState();
      try {
        User user = await repository.getAccountData(
            _avalonApiNode, _applicationUser!, _applicationUser);

        yield UserLoadedState(user: user);
      } catch (e) {
        yield UserErrorState(message: e.toString());
      }
    }

    if (event is FetchDTCVPEvent) {
      yield UserDTCVPLoadingState();
      try {
        Map<String, int> vtBalance = await repository.getVP(
            _avalonApiNode, _applicationUser!, _applicationUser);
        int dtcBalance = await repository.getDTC(
            _avalonApiNode, _applicationUser, _applicationUser);

        yield UserDTCVPLoadedState(
            dtcBalance: dtcBalance, vtBalance: vtBalance);
      } catch (e) {
        yield UserErrorState(message: e.toString());
      }
    }
  }
}
