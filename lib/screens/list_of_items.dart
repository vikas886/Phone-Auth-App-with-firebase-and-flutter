import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_auth/db/db_operation.dart';
import 'package:flutter_phone_auth/model/item.dart';
import 'package:flutter_phone_auth/screens/single_screen_product.dart';
import 'package:intl/intl.dart';

class ListOfProducts extends StatefulWidget {
  ListOfProducts({Key key}) : super(key: key);

  @override
  _ListOfProductsState createState() => _ListOfProductsState();
}

class _ListOfProductsState extends State<ListOfProducts> {
  Query query = DbOperations.fetchItems();
  final NumberFormat numberFormat = new NumberFormat("#,##,###0.0#", "en_US");

  Size deviceSize;
  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text('List of All the Products'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FlatButton.icon(
                    onPressed: () {
                      // _displayBottomSheet(context);
                    },
                    icon: Icon(
                      Icons.sort,
                      color: Colors.white,
                      size: 30,
                    ),
                    label: Text(
                      'Sort',
                      style: TextStyle(color: Colors.white, letterSpacing: 2),
                    )),
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.grey,
                ),
                FlatButton.icon(
                    onPressed: () {
                      // _displayFilterScreen();
                    },
                    icon: Icon(
                      Icons.filter,
                      color: Colors.white,
                      size: 30,
                    ),
                    label: Text(
                      'Filter',
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2),
                    )),
              ],
            ),
            Divider(),
            Expanded(
                child: StreamBuilder(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Container(
                    child: Text(
                      'Some Error Occur',
                      style: TextStyle(fontSize: 24, color: Colors.red),
                    ),
                  );
                }
                //get data
                QuerySnapshot querySnapshot = snapshot.data;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: deviceSize.width / deviceSize.height),
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        querySnapshot.docs[index];
                    Map<String, dynamic> dataMap = documentSnapshot.data();
                    Item product = Item();
                    product.itemName = dataMap['name'];
                    product.itemPrice = dataMap['price'];
                    product.url = dataMap['imageUrl'];
                    product.itemDesc = dataMap['desc'];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleProductScreen(product: product,)));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                product.url[1],
                                height: deviceSize.height / 4,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product.itemName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                product.itemDesc,
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                  '\u{20B9} ${numberFormat.format(int.parse(product.itemPrice))}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: querySnapshot.size,
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
