import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9fff8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 10,
            ),
            Image.asset(
              'img/leaf.png',
              height: 35,
            ),
            const SizedBox(
              width: 8,
            ),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText('EcoTrip'),
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
                onTap: () {
                  print("Tap Event");
                },
              ),
            ),
          ],
        ),
        leadingWidth: 250,
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none_outlined,
                color: Colors.black,
                size: 28,
              ),
          ),
          SizedBox(width: 10,),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 626,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              children: [
                ListTile(
                  leading: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  title: Text('planA'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  title: Text('planB'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  title: Text('planC'),
                ),
              ]
              // children:
              //     _buildListCards(context.read<FirebaseAuthMethods>().likeProducts),
            ),
          ),
        ],
      ),
    );
  }

  // List<Card> _buildListCards(List<Product> items) {
  //   if (items.isEmpty) {
  //     print("No List");
  //     return const <Card>[];
  //   }
  //
  //   return items.map((item) {
  //     return Card(
  //       color: Colors.transparent,
  //       elevation: 0,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           SizedBox(
  //             width: 400,
  //             height: 170,
  //             child: Stack(
  //               clipBehavior: Clip.none,
  //               children: <Widget>[
  //                 Positioned(
  //                   left: 7.7,
  //                   child: SizedBox(
  //                     width: 140,
  //                     height: 140,
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.circular(15.0),
  //                       child: Image.network(
  //                         item.imageURL,
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Positioned(
  //                   bottom: 20,
  //                   left: 140,
  //                   child: Container(
  //                     width: 200,
  //                     height: 120,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: const BorderRadius.only(
  //                         topRight: Radius.circular(5),
  //                         bottomRight: Radius.circular(5),
  //                       ),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.grey.withOpacity(0.3),
  //                           spreadRadius: 2,
  //                           blurRadius: 10,
  //                           offset: const Offset(
  //                               10, 6), // changes position of shadow
  //                         ),
  //                       ],
  //                     ),
  //                     child: Column(
  //                       // mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Padding(
  //                           padding: const EdgeInsets.only(top: 10, left: 20),
  //                           child: Text(
  //                             item.name.toString(),
  //                             style: const TextStyle(
  //                                 fontSize: 16, fontWeight: FontWeight.bold),
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.only(left: 15),
  //                           child: Row(
  //                             children: [
  //                               Container(
  //                                 padding: const EdgeInsets.only(
  //                                     left: 10, right: 10),
  //                                 decoration: BoxDecoration(
  //                                   gradient: const LinearGradient(
  //                                     begin: Alignment.topRight,
  //                                     end: Alignment.bottomLeft,
  //                                     colors: [
  //                                       Color.fromRGBO(129, 70, 224, 1),
  //                                       Color.fromRGBO(52, 12, 111, 1),
  //                                     ],
  //                                   ),
  //                                   borderRadius: const BorderRadius.all(
  //                                     Radius.circular(11),
  //                                   ),
  //                                   boxShadow: [
  //                                     BoxShadow(
  //                                       color: Colors.grey.withOpacity(0.3),
  //                                       spreadRadius: 2,
  //                                       blurRadius: 10,
  //                                       offset: const Offset(10,
  //                                           6), // changes position of shadow
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 child: Text(
  //                                   '233',
  //                                   // item.price.toString() + " ETH",
  //                                   style: const TextStyle(
  //                                       color: Colors.white,
  //                                       fontSize: 14,
  //                                       fontWeight: FontWeight.w400),
  //                                 ),
  //                               ),
  //                               const SizedBox(
  //                                 width: 10,
  //                                 height: 30,
  //                               ),
  //                               Container(
  //                                 padding: const EdgeInsets.only( right: 10),
  //                                 decoration: BoxDecoration(
  //                                   color:
  //                                       const Color.fromRGBO(241, 241, 241, 1),
  //                                   borderRadius: const BorderRadius.all(
  //                                     Radius.circular(11),
  //                                   ),
  //                                   boxShadow: [
  //                                     BoxShadow(
  //                                       color: Colors.grey.withOpacity(0.3),
  //                                       spreadRadius: 2,
  //                                       blurRadius: 10,
  //                                       offset: const Offset(10,
  //                                           6), // changes position of shadow
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 child: Row(
  //                                   children: [
  //                                     const SizedBox(
  //                                       width: 20,
  //                                       height: 20,
  //                                       child: ClipOval(),
  //                                     ),
  //                                     Text(
  //                                       'name',
  //                                       // item.creator_name.toString(),
  //                                       style: const TextStyle(
  //                                         fontSize: 10,
  //                                         fontWeight: FontWeight.w500,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.only(top: 5, left: 130),
  //                           child: ClipOval(
  //                             child: Container(
  //                               color: const Color.fromRGBO(229, 229, 229, 1),
  //                               child: IconButton(
  //                                 onPressed: () async {
  //                                   await FirebaseFirestore.instance
  //                                       .collection('users')
  //                                       .where('uid',
  //                                           isEqualTo: FirebaseAuth
  //                                               .instance.currentUser?.uid)
  //                                       .get()
  //                                       .then((snapshot) {
  //                                     snapshot.docs[0].reference
  //                                         .collection('like')
  //                                         .where('imgURL',
  //                                             isEqualTo: item.imageURL)
  //                                         .get()
  //                                         .then((snapshot) {
  //                                       for (final document
  //                                           in snapshot.docs) {
  //                                         document.reference.delete();
  //                                       }
  //                                     });
  //                                   });
  //                                   // appState.likeProducts.remove(item);
  //                                   setState(() {
  //                                     build(context);
  //                                   });
  //                                   const snackBar = SnackBar(
  //                                     content: Text('Delete product!'),
  //                                   );
  //                                   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //                                 },
  //                                 color: const Color.fromRGBO(249, 105, 0, 1),
  //                                 icon: const Icon(Icons.delete_outlined),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     );
  //   }).toList();
  // }
}
