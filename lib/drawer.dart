// import 'package:flutter/material.dart';
// import 'country.dart';
// import 'main.dart';
// import 'package:flutter/services.dart';
// class Drawer extends StatelessWidget {
//    Drawer({Key? key}) : super(key: key);
//   dynamic cName;
//   dynamic country;
//   dynamic category;
//   dynamic findNews;
//   int pageNum = 1;
//   bool isPageLoading = false;
//   late ScrollController controller;
//   int pageSize = 10;
//   bool isSwitched = true;
//   List<dynamic> news = [];
//   bool notFound = false;
//   List<int> data = [];
//   bool isLoading = false;
//   String baseApi = 'https://newsapi.org/v2/top-headlines?';
//   IconData iconDark = Icons.nights_stay;
//   IconData iconLight = Icons.wb_sunny;
//   IconData icon = Icons.numbers;
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: const EdgeInsets.symmetric(vertical: 32),
//         children: <Widget>[
//           DrawerHeader(
//             child: Column(
//               children: <Widget>[
//                 CircleAvatar(
//                   radius: 36,
//                   backgroundImage: NetworkImage(
//                       'https://media-exp1.licdn.com/dms/image/C4E03AQEUzuySJWLvrw/profile-displayphoto-shrink_800_800/0/1638700706814?e=2147483647&v=beta&t=4fS_HTAIS_d_42UYO2uyPb2togSOr_utvXa8bJUf1N0'),
//                 ),
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text("               Kshitiz Agarwal"),
//                         Text("kshitizagarwal2405@gmail.com"),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (country != null)
//                 Text('Country = $cName')
//               else
//                 Container(),
//               const SizedBox(height: 10),
//               if (category != null)
//                 Text('Category = $category')
//               else
//                 Container(),
//               const SizedBox(height: 20),
//             ],
//           ),
//           ListTile(
//             title: TextFormField(
//               decoration: const InputDecoration(hintText: 'Find Keyword'),
//               scrollPadding: const EdgeInsets.all(5),
//               onChanged: (String val) => setState(() => findNews = val),
//             ),
//             trailing: IconButton(
//               onPressed: () async => getNews(searchKey: findNews as String),
//               icon: const Icon(Icons.search,color: Colors.red,),
//             ),
//           ),
//           ExpansionTile(
//             leading: Icon(Icons.flag,color: Colors.red,),
//             title: const Text('Country'),
//             children: <Widget>[
//               for (int i = 0; i < listOfCountry.length; i++)
//                 DropDownList(
//                   call: () {
//                     country = listOfCountry[i]['code'];
//                     cName = listOfCountry[i]['name']!.toUpperCase();
//                     getNews();
//                   },
//                   name: listOfCountry[i]['name']!.toUpperCase(),
//                 ),
//             ],
//           ),
//           ExpansionTile(
//             leading: Icon(Icons.category,color: Colors.red,),
//             title: const Text('Category'),
//             children: [
//               for (int i = 0; i < listOfCategory.length; i++)
//                 DropDownList(
//                   call: () {
//                     category = listOfCategory[i]['code'];
//                     getNews();
//                   },
//                   name: listOfCategory[i]['name']!.toUpperCase(),
//                 )
//             ],
//           ),
//           ExpansionTile(
//             leading: Icon(Icons.data_exploration,color: Colors.red,),
//             title: const Text('Channel'),
//             children: [
//               for (int i = 0; i < listOfNewsChannel.length; i++)
//                 DropDownList(
//                   call: () =>
//                       getNews(channel: listOfNewsChannel[i]['code']),
//                   name: listOfNewsChannel[i]['name']!.toUpperCase(),
//                 ),
//             ],
//           ),
//           FloatingActionButton(onPressed: () => SystemNavigator.pop(),backgroundColor: Colors.red,child: const Icon(Icons.exit_to_app),),
//         ],
//       ),
//
//     );