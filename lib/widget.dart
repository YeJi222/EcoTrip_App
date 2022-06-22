import 'package:flutter/material.dart';

class Product {
  const Product(
      {required this.name,
        required this.description,
        required this.imageURL,

      });

  final String name;
  final String description;
  final String imageURL;
}

// List Horizon
List<Card> buildListCardsH(List<Product> products, BuildContext context) {
  if (products.isEmpty) {
    return const <Card>[];
  }

  return products.map((product) {
    return Card(
        color: Colors.transparent,
        elevation: 0.0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => DetailPage(product),
            //   ),
            // );
          },
          child: SizedBox(
            width: 300,
            height: 370,
            child: Stack(
              children: [
                Positioned(
                    child: SizedBox(
                      width: 270,
                      height: 350,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Image.network(
                          product.imageURL,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                ),
                Positioned(
                    top: 220,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 25),),
                          const SizedBox(height: 10,),
                          Text(product.description, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 17),),
                          // const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("?????", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 25),),
                              const SizedBox(width: 100,),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.bookmark_added_outlined, color: Colors.white,size: 28,)
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                ),
                Positioned(
                  right: 50,
                    top: 30,
                    child: Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xff6dc62f),
                        borderRadius: BorderRadius.all(
                          Radius.circular(11),
                        ),
                      ),
                      child: Row(
                        children: const [
                          SizedBox(width: 12,),
                          Icon(Icons.star,color: Colors.white,size: 16,),
                          Text("4.8", style: TextStyle(color: Colors.white, fontSize: 12),),
                        ],
                      )
                    ),
                )
              ],
            ),
          ),
        ));
  }).toList();
}

// List Vertical
List<Card> buildListCardsV(List<Product> products, BuildContext context) {
  if (products.isEmpty) {
    return const <Card>[];
  }

  return products.map((product) {
    return Card(
        color: Colors.transparent,
        elevation: 0.0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => DetailPage(product),
            //   ),
            // );
          },
          child: Container(
            width: 300,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(11),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: Image.network(product.imageURL, fit: BoxFit.cover,),
                  )
                ],
              ),
            )
          ),
        ));
  }).toList();
}