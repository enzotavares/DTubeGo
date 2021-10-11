// list of global static application configurations

class AppConfig {
  // feed url schemes
  static String myFeedUrlFirst = "/feed/##USERNAME";
  static String myFeedUrlMore = "/feed/##USERNAME/##AUTHOR/##LINK";
  static String myFeedUrlFiltered =
      "/feed/##USERNAME/filter:limit=500##FILTERSTRING";
  static String newFeedUrlFirst = "/new";
  static String newFeedUrlMore = "/new/##AUTHOR/##LINK";
  static String newFeedUrlFiltered = "/new/filter:limit=500##FILTERSTRING";
  static String hotFeedUrlFirst = "/hot";
  static String hotFeedUrlMore = "/hot/##AUTHOR/##LINK";
  static String trendingFeedUrlFirst = "/trending";
  static String trendingFeedUrlMore = "/trending/##AUTHOR/##LINK";
  static String accountFeedUrlFirst = "/blog/##USERNAME";
  static String accountFeedUrlMore = "/blog/##USERNAME/##AUTHORNAME/##LINK";
  static String notificationFeedUrl = "/notifications/##USERNAME";

  // rewards and history url schemes
  static String rewardsUrl = "/votes/##REWARDSTATE/##USERNAME/0";
  static String accountHistoryFeedUrl = "/history/##USERNAME/##FROMBLOC";
  static String accountHistoryFeedUrlFromBlock = "/history/##USERNAME/##BLOCK";

  // detail url schemes
  static String postDataUrl = "/content/##AUTHOR/##LINK";
  static String accountDataUrl = "/account/##USERNAME";

  // search url schemes
  static String searchAccountsUrl =
      "https://search.d.tube/avalon.accounts/_search?q=name:*##SEARCHSTRING*&size=50&sort=balance:desc";
  static String searchPostsUrl =
      "https://search.d.tube/avalon.contents/_search?default_operator=OR&q=json.title:*##SEARCHSTRING*+author:*##SEARCHSTRING*+json.desc:*##SEARCHSTRING*&size=50&sort=ts:desc";

  // other avalon url schemes
  static String sendTransactionUrl = "/transactWaitConfirm";
  static String avalonConfig = "/config";

// storage providers and upload endpoints
  static String ipfsVideoUrl = "https://ipfs.d.tube/ipfs/";
  static String siaVideoUrl = "https://siasky.net/";
  static String ipfsUploadUrl = "https://ipfs.d.tube/ipfs/";
  static List<String> btfsUploadEndpoints = [
    "https://1.btfsu.d.tube",
    "https://2.btfsu.d.tube",
    "https://3.btfsu.d.tube",
    "https://4.btfsu.d.tube"
  ];

  static String ipfsSnapUrl = 'https://snap1.d.tube/ipfs/';
  static String ipfsSnapUploadUrl = 'https://snap1.d.tube';

// verified url schemes
  static String originalDtuberListUrl = "https://dtube.fso.ovh/oc/creators";
  static String originalDtuberCheckUrl =
      "https://dtube.fso.ovh/oc/creator/##USERNAME";

// hivesigner config
  static String hiveSignerCallbackUrlScheme = 'dtubego';
  static String hiveSignerRedirectUrlHTMLEncoded =
      hiveSignerCallbackUrlScheme + '%3A%2F%2Foauth2redirect';
  static String hiveSignerAccessTokenUrl =
      'https://hivesigner.com/oauth2/authorize?client_id=dtubemobile&redirect_uri=${hiveSignerRedirectUrlHTMLEncoded}&scope=vote,comment';

  static String hiveSignerBroadcastAddress =
      'https://hivesigner.com/api/broadcast';

// node discovery & api node configs
  static Duration nodeDescoveryTimeout = Duration(seconds: 2);

  static bool useDevNodes =
      false; //activate for new features which has not been integrated

  static List<String> apiNodesDev = [
    // development nodes for new features
    'https://dtube.club/mainnetapi',
    'https://avalon.tibfox.com'
  ];

  static List<String> apiNodes = [
    // common api nodes
    'https://avalon.tibfox.com',
    // 'https://avalon.d.tube',
    'https://dtube.club/mainnetapi',
    // 'https://avalon.oneloved.tube',
    'https://dtube.fso.ovh'
  ];

  static int minFreeSpaceRecordVideoInMB =
      50; // min free space to enable the user to record video in app

// urls for login screen
  static String signUpUrl = "https://signup.d.tube";
  static String readmoreUrl = "https://token.d.tube";

  // activate/deactivate first user journey
  static bool faqStartup = false; // show on first startup
  static bool faqVisible = false; // make the FAQ videos visible

  // global settings -> tags: those are the possible tags
  static List<String> possibleExploreTags = [
    "dtube",
    "dtubeGo",
    // outside

    "travel",
    "gardening",
    "nature",
    "animals",

    // knowhow
    "howto",
    "tutorial",
    "DIY",
    "cooking",
    // tech
    "tech",
    "blockchain",
    "crypto",
    // news
    "news",
    "politics",
    // entertainment
    "entertainment",
    "funny",
    "gaming",
    "dailyvlog",
    "vlog",
    // art
    "art",
    "painting",
    "music",
    "dance",
    // lifestyle
    "fashion",
    "lifestyle",
    "health",
    "sports",
    "skate",
    // others
    "psychology",
    "horology",
    // communities
    "skatehive",
    "cleanplanet",
    "onelovedtube"
  ];
}
