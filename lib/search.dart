import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  final String? title;
  final String? developer;
  final String? framework;
  final String? tool;

  DataModel({this.title, this.developer, this.framework, this.tool});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold
  List<DataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
      snapshot.data() as Map<String, dynamic>;

      return DataModel(
          title: dataMap['title'],
          developer: dataMap['description'],
          framework: dataMap['location'],
          tool: dataMap['creator_name']);
    }).toList();
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: FirestoreSearchScaffold(
          appBarBackgroundColor: Color(0xfff9fff8),
          searchBackgroundColor: Colors.white,
          firestoreCollectionName: 'products',
          showSearchIcon: true,
          backButtonColor: Colors.green,
          appBarTitleColor: Colors.green,
          searchBy: 'title',
          scaffoldBody: Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 40.0,
                    height: 90,
                  ),
                  Icon(Icons.search),
                  Expanded(
                      child: FirestoreSearchBar(
                        searchBackgroundColor: Colors.black12,
                        tag: 'test',
                      )
                  ),
                  const SizedBox(
                    width: 40.0,
                  ),
                ],
              ),
              Expanded(
                child: FirestoreSearchResults.builder(
                  tag: 'test',
                  firestoreCollectionName: 'products',
                  searchBy: 'title',
                  initialBody: const Center(child: Text(
                      'Search Trip Plans :)',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  dataListFromSnapshot: DataModel().dataListFromSnapshot,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<DataModel>? dataList = snapshot.data;
                      if (dataList!.isEmpty) {
                        return const Center(
                          child: Text('No Search Results!'),
                        );
                      }
                      return ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            final DataModel data = dataList[index];

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${data.title}',
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, left: 8.0, right: 8.0),
                                  child: Text('${data.tool}',
                                      style: Theme.of(context).textTheme.bodyText1),
                                )
                              ],
                            );
                          });
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text('No Results Returned'),
                        );
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              )
            ],
          ),
          dataListFromSnapshot: DataModel().dataListFromSnapshot,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<DataModel>? dataList = snapshot.data;
              if (dataList!.isEmpty) {
                return const Center(
                  child: Text('No Search Results!'),
                );
              }
              return ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    final DataModel data = dataList[index];

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${data.title}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 8.0, right: 8.0),
                          child: Text('${data.tool}',
                              style: Theme.of(context).textTheme.bodyText1),
                        )
                      ],
                    );
                  });
            }

            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text('No Search Results!'),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
      ),
    );
  }
}