import 'package:bloc/bloc.dart';
import 'package:dtube_togo/bloc/feed/feed_state.dart';
import 'package:dtube_togo/bloc/feed/feed_event.dart';
import 'package:dtube_togo/bloc/feed/feed_response_model.dart';
import 'package:dtube_togo/bloc/feed/feed_repository.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedRepository repository;
  bool isFetching = false;

  FeedBloc({required this.repository}) : super(FeedInitialState());

  // @override

  // FeedState get initialState => FeedInitialState();

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    String _avalonApiNode = await sec.getNode();
    String? _applicationUser = await sec.getUsername();
    if (event is FetchFeedEvent) {
      yield FeedLoadingState();
      try {
        List<FeedItem> feed = [];
        switch (event.feedType) {
          case 'MyFeed':
            {
              feed = await repository.getMyFeed(_avalonApiNode,
                  _applicationUser, event.fromAuthor, event.fromLink);
            }
            break;
          case 'HotFeed':
            {
              feed = await repository.getHotFeed(_avalonApiNode,
                  event.fromAuthor, event.fromLink, _applicationUser);
            }
            break;
          case 'TrendingFeed':
            {
              feed = await repository.getTrendingFeed(
                  _avalonApiNode,
                  event.fromAuthor,
                  event.fromLink,
                  _applicationUser); // statements;
            }
            break;
          case 'NewFeed':
            {
              feed = await repository.getNewFeed(
                  _avalonApiNode,
                  event.fromAuthor,
                  event.fromLink,
                  _applicationUser); // statements;
            }
            break;
        }

        yield FeedLoadedState(feed: feed);
      } catch (e) {
        yield FeedErrorState(message: e.toString());
      }
    }

    if (event is FetchUserFeedEvent) {
      yield FeedLoadingState();
      try {
        List<FeedItem> feed = await repository.getUserFeed(_avalonApiNode,
            event.username, event.fromAuthor, event.fromLink, _applicationUser);
        yield FeedLoadedState(feed: feed);
      } catch (e) {
        print(e.toString());
        yield FeedErrorState(message: e.toString());
      }
    }
  }
}
