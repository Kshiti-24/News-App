import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/firstPage.dart';
import 'package:newsapp/secondPage.dart';
import 'articleNews.dart';
import 'constants.dart';
import 'country.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'firstPage.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';

void main() => runApp(MyApp());
bool counter = true;
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

void toggleDrawer() {
  if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
    _scaffoldKey.currentState?.openEndDrawer();
  } else {
    _scaffoldKey.currentState?.openDrawer();
  }
}

class DropDownList extends StatelessWidget {
  const DropDownList(
  {super.key, required this.name, required this.call, Icon? icon});

  final String name;
  final Function call;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(title: Text(name)),
      onTap: () => call(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
            () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SecondPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Image.asset('assets/images/logo.png'),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 90,
              ),
              Lottie.asset(
                'assets/images/logo.json',
                height: 250,
                width: 250,
              ),
              SizedBox(
                height: 180,
              ),
              Text(
                'Be the first to know the latest news and events',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Material(
                color: Colors.black,
                child: GestureDetector(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => MyApp()));
                      counter = false;
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.red,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(11.0),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class MyRoutes {
  static String firstRoute = "/first";
}

class _MyAppState extends State<MyApp> {
  dynamic cName;
  int hey = 0;
  String IsOpened = "No";
  dynamic country;
  dynamic category;
  String? findNews;
  int pageNum = 1;
  bool isPageLoading = false;
  late ScrollController controller;
  int pageSize = 10;
  List<dynamic> news = [];
  int j=0;
  bool notFound = false;
  bool isSwitched = true;
  List<int> data = [];
  bool isLoading = false;
  String baseApi = 'https://newsapi.org/v2/top-headlines?';
  IconData iconDark = Icons.nights_stay;
  IconData iconLight = Icons.wb_sunny;
  IconData icon = Icons.numbers;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Newsverse',
      theme: isSwitched
          ? ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.red,
      )
          : ThemeData(brightness: Brightness.dark, primaryColor: Colors.red),
      home: counter
          ? MyHomePage()
          : Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 32),
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: NetworkImage(
                          'https://media-exp1.licdn.com/dms/image/C4E03AQEUzuySJWLvrw/profile-displayphoto-shrink_800_800/0/1638700706814?e=2147483647&v=beta&t=4fS_HTAIS_d_42UYO2uyPb2togSOr_utvXa8bJUf1N0'),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("               Kshitiz Agarwal"),
                            Text("kshitizagarwal2405@gmail.com"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ExpansionTile(
                leading: Icon(
                  Icons.flag,
                  color: Colors.red,
                ),
                title: const Text('Country'),
                children: <Widget>[
                  for (int i = 0; i < listOfCountry.length; i++)
                    DropDownList(
                      call: () {
                        country = listOfCountry[i]['code'];
                        cName = listOfCountry[i]['name']!.toUpperCase();
                        getNews();
                      },
                      name: listOfCountry[i]['name']!.toUpperCase(),
                    ),
                ],
              ),
              ExpansionTile(
                leading: Icon(
                  Icons.category,
                  color: Colors.red,
                ),
                title: const Text('Category'),
                children: [
                  for (int i = 0; i < listOfCategory.length; i++)
                    DropDownList(
                      call: () {
                        category = listOfCategory[i]['code'];
                        getNews();
                      },
                      name: listOfCategory[i]['name']!.toUpperCase(),
                    )
                ],
              ),
              FloatingActionButton(
                onPressed: () => SystemNavigator.pop(),
                backgroundColor: Colors.red,
                child: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Newsverse',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 29.0),
          ),
          backgroundColor: Colors.red,
          actions: [
            IconButton(
              onPressed: () async {
                country = null;
                category = null;
                findNews = null;
                cName = null;
                getNews();
              },
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              icon: Icon(isSwitched ? iconDark : iconLight),
              onPressed: () {
                setState(() {
                  isSwitched = !isSwitched;
                });
              },
            ),
          ],
          // bottom: PreferredSize(
          //   preferredSize: Size.fromHeight(56),
          //   child: Padding(
          //     padding: EdgeInsets.all(10.0),
          //     child: TextField(
          //       onChanged: (String? val) {
          //         setState(() => findNews = val);
          //         print(findNews);
          //       },
          //       textAlign: TextAlign.center,
          //       decoration: InputDecoration(
          //         hintText: '     Search',
          //         suffixIcon: IconButton(
          //             onPressed: ()  =>
          //                   getNews(searchKey: findNews as String),
          //             icon: Icon(
          //               Icons.search,
          //               color: Colors.grey,
          //             )),
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(3),
          //           borderSide: BorderSide.none,
          //         ),
          //         contentPadding: EdgeInsets.zero,
          //         filled: true,
          //         fillColor: Theme.of(context).splashColor,
          //       ),
          //       textInputAction: TextInputAction.search,
          //     ),
          //   ),
          // ),
        ),
        body: notFound
            ? const Center(
          child: Text('Not Found', style: TextStyle(fontSize: 30)),
        )
            : RefreshIndicator(
          onRefresh: () async {
            country = null;
            category = null;
            findNews = null;
            cName = null;
            getNews();
          },
          child: FutureBuilder<NewsModel>(
              future: getNews(),
              // log()
              builder: (context, snapshot) {
                print(snapshot.connectionState);
                if (snapshot.hasData) {
                  if(j==1){
                  checkConnection();
                  j++;}
                    print('yes');
                    print(snapshot.data!.articles[0].source!.name);
                    return ListView.builder(
                      controller: controller,
                      itemBuilder:
                          (BuildContext context, int index) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(20),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (BuildContext
                                        context) =>
                                            ArticalNews(
                                              newsUrl: snapshot
                                                  .data!
                                                  .articles[index]
                                                  .url,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets
                                        .symmetric(
                                      vertical: 10,
                                      horizontal: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          30),
                                    ),
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            if (snapshot
                                                .data!
                                                .articles[
                                            index]
                                                .urlToImage ==
                                                null)
                                              Container()
                                            else
                                              ClipRRect(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    20),
                                                child:
                                                CachedNetworkImage(
                                                  placeholder: (BuildContext
                                                  context,
                                                      String
                                                      url) =>
                                                      Container(),
                                                  errorWidget: (BuildContext
                                                  context,
                                                      String
                                                      url,
                                                      error) =>
                                                  const SizedBox(),
                                                  imageUrl: snapshot
                                                      .data!
                                                      .articles[
                                                  index]
                                                      .urlToImage!,
                                                ),
                                              ),
                                            Positioned(
                                              top: 3,
                                              right: 3,
                                              child: Card(
                                                elevation: 0,
                                                color: Theme
                                                    .of(
                                                    context)
                                                    .primaryColor
                                                    .withOpacity(
                                                    0.8),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                    horizontal:
                                                    10,
                                                    vertical: 8,
                                                  ),
                                                  child: Text(
                                                    snapshot.data!
                                                        .articles[index].source!
                                                        .name!,
                                                    style: Theme
                                                        .of(
                                                        context)
                                                        .textTheme
                                                        .subtitle2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Text(
                                          snapshot.data!.articles[index].title,
                                          style: const TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (index ==
                                snapshot.data!.articles
                                    .length -
                                    1 &&
                                isLoading)
                              const Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.yellow,
                                ),
                              )
                            else
                              const SizedBox(),
                          ],
                        );
                      },
                      itemCount: snapshot.data!.articles.length,
                    );
                } else if (snapshot.hasError) {
                  checkConnection();
                  return Text('${snapshot.error}');
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),

        floatingActionButton: Builder(
          builder: (context) => FabCircularMenu(
            alignment: Alignment.bottomRight,
            ringColor: Colors.red.withOpacity(0.0),
            ringDiameter: 360.0,
            ringWidth: 60.0,
            fabSize: 60.0,
            fabElevation: 8.0,
            fabColor: Colors.black,
            fabOpenIcon: Image.asset('assets/images/logo1.png'),
            fabCloseIcon: Icon(Icons.close, color: Colors.red),
            fabMargin: const EdgeInsets.all(20.0),
            animationDuration: const Duration(milliseconds: 800),
            animationCurve: Curves.easeInOutCirc,
            onDisplayChange: (isOpen) {
              if (isOpen) {
                setState(() {
                  IsOpened = "Yes";
                });
              } else {
                setState(() {
                  IsOpened = "No";
                });
              }
            },
            children: [
              SizedBox(
                height: 500,
                width: 500,
              ),
              FloatingActionButton(
                mini: true,
                backgroundColor: Colors.black,
                heroTag: "Home",
                child: Icon(
                  Icons.home,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    hey = hey + 1;
                  });
                },
              ),
              SizedBox(
                height: 500,
                width: 500,
              ),
              FloatingActionButton(
                backgroundColor: Colors.black,
                mini: true,
                heroTag: "Live TV",
                child: Icon(
                  Icons.video_call,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    hey = hey + 2;
                  });
                },
              ),
              SizedBox(
                height: 500,
                width: 500,
              ),
              FloatingActionButton(
                backgroundColor: Colors.black,
                mini: true,
                heroTag: "Profile",
                child: Icon(
                  Icons.account_circle,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    hey = hey - 1;
                  });
                },
              ),
              SizedBox(
                height: 500,
                width: 500,
              ),
              FloatingActionButton(
                backgroundColor: Colors.black,
                mini: true,
                heroTag: "Setting",
                child: Icon(
                  Icons.settings,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    hey = hey - 2;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      routes: {
        MyRoutes.firstRoute: (context) => MyHomePage(),
      },
    );
  }

  checkConnection() async{
    var connection =await Connectivity().checkConnectivity();
    if(connection==ConnectivityResult.none){
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Alert Dialog Box"),
          content: const Text('Please turn on your internet connection'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Container(
                color: Colors.red,
                padding: const EdgeInsets.all(14),
                child: const Text("okay",style: TextStyle(color: Colors.black),),
              ),
            ),
          ],
        ),
      );
    }
    else {
        return showDialog(
          context: context,
          builder: (ctx) =>
              AlertDialog(
                title: const Text("Alert Dialog Box"),
                content: const Text('Connected'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Container(
                      color: Colors.red,
                      padding: const EdgeInsets.all(14),
                      child: const Text(
                        "okay", style: TextStyle(color: Colors.black),),
                    ),
                  ),
                ],
              ),
        );
    }
  }

  Future<NewsModel> getDataFromApi(String url) async {
    final http.Response res = await http.get(Uri.parse(url));
    print(res.statusCode);
    if (res.statusCode == 200) {
      // if (jsonDecode(res.body)['totalResults'] == 0) {
      //   notFound = !isLoading;
      //   setState(() => isLoading = false);
      // } else {
      //   if (isLoading) {
      //     final newData = jsonDecode(res.body)['articles'] as List<dynamic>;
      //     for (final e in newData) {
      //       news.add(e);
      //     }
      //   } else {
      //     news = jsonDecode(res.body)['articles'] as List<dynamic>;
      //   }
      //     setState(() {
      //       notFound = false;
      //       isLoading = false;
      //     });
      //   }
      //   log(res.body.toString());
      return newsModelFromJson(res.body);
    } else {
      // setState(() => notFound = true);
      throw Exception('Not Found');
    }
  }

  Future<NewsModel> getNews({
    String? channel,
    String? searchKey,
    bool reload = false,
  }) async {
    setState(() => notFound = false);
    if (isLoading) {
      pageNum++;
    } else {
      setState(() => news = []);
      pageNum = 1;
    }
    baseApi = 'https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&';

    baseApi += country == null ? 'country=in&' : 'country=$country&';
    baseApi += category == null ? '' : 'category=$category&';
    baseApi += 'apiKey=$apiKey';
    print(searchKey);
    if (searchKey != null) {
      country = null;
      category = null;
      baseApi =
      'https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&q=$searchKey&apiKey=9bb7bf6152d147ad8ba14cd0e7452f2f';
    }
    print(searchKey);
    return getDataFromApi(baseApi);
  }





  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    getNews();
    super.initState();
  }

  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      setState(() => isLoading = true);
      getNews();
    }
  }
}
