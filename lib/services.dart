// import 'main.dart';
// import 'package:http/http.dart';
// import 'dart:convert';
// class Services {
//   dynamic cName;
//   dynamic country;
//   dynamic category;
//   dynamic findNews;
//   int pageNum = 1;
//   bool isPageLoading = false;
//   int pageSize = 10;
//   bool isSwitched = true;
//   List<dynamic> news = [];
//   bool notFound = false;
//   List<int> data = [];
//   bool isLoading = false;
//   String baseApi = 'https://newsapi.org/v2/top-headlines?';
//
//   Future<void> getDataFromApi(String url) async {
//     final http.Response res = await http.get(Uri.parse(url));
//     if (res.statusCode == 200) {
//       if (jsonDecode(res.body)['totalResults'] == 0) {
//         notFound = !isLoading;
//         setState(() => isLoading = false);
//       } else {
//         if (isLoading) {
//           final newData = jsonDecode(res.body)['articles'] as List<dynamic>;
//           for (final e in newData) {
//             news.add(e);
//           }
//         } else {
//           news = jsonDecode(res.body)['articles'] as List<dynamic>;
//         }
//         setState(() {
//           notFound = false;
//           isLoading = false;
//         });
//       }
//     } else {
//       setState(() => notFound = true);
//     }
//   }
//
//   Future<void> getNews({
//     String? channel,
//     String? searchKey,
//     bool reload = false,
//   }) async {
//     setState(() => notFound = false);
//
//     if (!reload && !isLoading) {
//       toggleDrawer();
//     } else {
//       country = null;
//       category = null;
//     }
//     if (isLoading) {
//       pageNum++;
//     } else {
//       setState(() => news = []);
//       pageNum = 1;
//     }
//     baseApi = 'https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&';
//
//     baseApi += country == null ? 'country=in&' : 'country=$country&';
//     baseApi += category == null ? '' : 'category=$category&';
//     baseApi += 'apiKey=$apiKey';
//     if (channel != null) {
//       country = null;
//       category = null;
//       baseApi =
//       'https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&sources=$channel&apiKey=58b98b48d2c74d9c94dd5dc296ccf7b6';
//     }
//     if (searchKey != null) {
//       country = null;
//       category = null;
//       baseApi =
//       'https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&q=$searchKey&apiKey=58b98b48d2c74d9c94dd5dc296ccf7b6';
//     }
//     //print(baseApi);
//     getDataFromApi(baseApi);
//   }
// }