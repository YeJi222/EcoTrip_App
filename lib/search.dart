import 'package:ecotripapp/widget.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'cotroller.dart';

class DataModel {
  final String? title;
  final String? description;
  final String? location;
  final String? creator_name;

  DataModel({this.title, this.description, this.location, this.creator_name});

  List<DataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
      snapshot.data() as Map<String, dynamic>;

      return DataModel(
          title: dataMap['title'],
          description: dataMap['description'],
          location: dataMap['location'],
          creator_name: dataMap['creator_name']);
    }).toList();
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  int flag = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: FirestoreSearchScaffold(
          scaffoldBackgroundColor: Color(0xfff9fff8),
          appBarBackgroundColor: Colors.white,
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
                  const Icon(Icons.search),
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
                  searchBy: 'location',
                  initialBody: const Center(child: Text(
                      'Search Trip Plans :)',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 28,
                        fontFamily: 'jua',
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
                      return ListView(
                        children: [
                          GetBuilder<Controller>(
                              builder: (_) {
                                return SizedBox(
                                  width: 400,
                                  child: ListView(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.all(16.0),
                                      children: buildListCardsV(_.products, context, flag)),
                                );
                              }
                          ),
                        ],
                      );
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
              return ListView(
                children: [
                  GetBuilder<Controller>(
                      builder: (_) {
                        return SizedBox(
                          width: 400,
                          child: ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(16.0),
                              children: buildListCardsV(_.products, context, flag)),
                        );
                      }
                  ),
                ],
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    'No Search Results!',
                  ),
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