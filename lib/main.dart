import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'articleNews.dart';
import 'constants.dart';
import 'country.dart';

void main() => runApp(const MyApp());

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  dynamic cName;
  dynamic country;
  dynamic category;
  dynamic findNews;
  int pageNum = 1;
  bool isPageLoading = false;
  late ScrollController controller;
  int pageSize = 10;
  bool isSwitched = true;
  List<dynamic> news = [];
  bool notFound = false;
  List<int> data = [];
  bool isLoading = false;
  String baseApi = 'https://newsapi.org/v2/top-headlines?';
  IconData iconDark = Icons.nights_stay;
  IconData iconLight = Icons.wb_sunny;
  IconData icon = Icons.numbers;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter News',
      theme: isSwitched
          ? ThemeData(
              brightness: Brightness.light,
            )
          : ThemeData(
              brightness: Brightness.dark,
            ),
      home: Scaffold(
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
                            Text("Kshitiz Agarwal"),
                            Text("kshitizagarwal2405@gmail.com"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (country != null)
                    Text('Country = $cName')
                  else
                    Container(),
                  const SizedBox(height: 10),
                  if (category != null)
                    Text('Category = $category')
                  else
                    Container(),
                  const SizedBox(height: 20),
                ],
              ),
              ListTile(
                title: TextFormField(
                  decoration: const InputDecoration(hintText: 'Find Keyword'),
                  scrollPadding: const EdgeInsets.all(5),
                  onChanged: (String val) => setState(() => findNews = val),
                ),
                trailing: IconButton(
                  onPressed: () async => getNews(searchKey: findNews as String),
                  icon: const Icon(Icons.search),
                ),
              ),
              ExpansionTile(
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
              ExpansionTile(
                title: const Text('Channel'),
                children: [
                  for (int i = 0; i < listOfNewsChannel.length; i++)
                    DropDownList(
                      call: () =>
                          getNews(channel: listOfNewsChannel[i]['code']),
                      name: listOfNewsChannel[i]['name']!.toUpperCase(),
                    ),
                ],
              ),
              //ListTile(title: Text("Exit"), onTap: () => exit(0)),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text('News'),
          actions: [
            IconButton(
              onPressed: () {
                country = null;
                category = null;
                findNews = null;
                cName = null;
                getNews(reload: true);
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
        ),
        body: notFound
            ? const Center(
                child: Text('Not Found', style: TextStyle(fontSize: 30)),
              )
            : news.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.yellow,
                    ),
                  )
                : ListView.builder(
                    controller: controller,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (BuildContext context) =>
                                          ArticalNews(
                                        newsUrl: news[index]['url'] as String,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          if (news[index]['urlToImage'] == null)
                                            Container()
                                          else
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: CachedNetworkImage(
                                                placeholder:
                                                    (BuildContext context,
                                                            String url) =>
                                                        Container(),
                                                errorWidget:
                                                    (BuildContext context,
                                                            String url,
                                                            error) =>
                                                        const SizedBox(),
                                                imageUrl: news[index]
                                                    ['urlToImage'] as String,
                                              ),
                                            ),
                                          Positioned(
                                            bottom: 8,
                                            right: 8,
                                            child: Card(
                                              elevation: 0,
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.8),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 8,
                                                ),
                                                child: Text(
                                                  "${news[index]['source']['name']}",
                                                  style: Theme.of(context)
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
                                        "${news[index]['title']}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (index == news.length - 1 && isLoading)
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
                    itemCount: news.length,
                  ),
      ),
    );
  }

  Future<void> getDataFromApi(String url) async {
    final http.Response res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      if (jsonDecode(res.body)['totalResults'] == 0) {
        notFound = !isLoading;
        setState(() => isLoading = false);
      } else {
        if (isLoading) {
          final newData = jsonDecode(res.body)['articles'] as List<dynamic>;
          for (final e in newData) {
            news.add(e);
          }
        } else {
          news = jsonDecode(res.body)['articles'] as List<dynamic>;
        }
        setState(() {
          notFound = false;
          isLoading = false;
        });
      }
    } else {
      setState(() => notFound = true);
    }
  }

  Future<void> getNews({
    String? channel,
    String? searchKey,
    bool reload = false,
  }) async {
    setState(() => notFound = false);

    if (!reload && !isLoading) {
      toggleDrawer();
    } else {
      country = null;
      category = null;
    }
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
    if (channel != null) {
      country = null;
      category = null;
      baseApi =
          'https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&sources=$channel&apiKey=58b98b48d2c74d9c94dd5dc296ccf7b6';
    }
    if (searchKey != null) {
      country = null;
      category = null;
      baseApi =
          'https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&q=$searchKey&apiKey=58b98b48d2c74d9c94dd5dc296ccf7b6';
    }
    //print(baseApi);
    getDataFromApi(baseApi);
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
