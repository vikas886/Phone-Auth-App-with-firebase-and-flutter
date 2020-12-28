import 'package:flutter/material.dart';
import 'package:flutter_phone_auth/model/item.dart';
import 'package:intl/intl.dart';
import 'package:carousel_pro/carousel_pro.dart';

class SingleProductScreen extends StatefulWidget {
  // SingleProductScreen({Key key}) : super(key: key);
  Item product;
  SingleProductScreen({this.product});

  @override
  _SingleProductScreenState createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  final NumberFormat numberFormat = new NumberFormat("#,##,###0.0#", "en_US");
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text(''),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                height: deviceSize.height / 2,
                color: Colors.white,
                child: Carousel(
                  dotSize: 5.0,
                  dotBgColor: Colors.transparent,
                  animationDuration: Duration(seconds: 1),
                  autoplay: false,
                  borderRadius: true,
                  onImageTap: (int currentSliderNumber) {
                    print("Current slider number $currentSliderNumber");
                  },
                  images: widget.product.url != null &&
                          widget.product.url.length > 0
                      ? widget.product.url
                          .map((currentAd) => NetworkImage(currentAd))
                          .toList()
                      : [
                          NetworkImage(
                              'https://media3.giphy.com/media/3oEjI6SIIHBdRxXI40/giphy.gif'),
                        ],
                ),
              ),
              Positioned(
                top: 10,
                left: deviceSize.width / 1.17,
                child: Column(
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.blueGrey,
                              size: 35,
                            ),
                            onPressed: () {})),
                    SizedBox(
                      height: 5,
                    ),
                    CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: IconButton(
                            icon: Icon(
                              Icons.share,
                              size: 34,
                              color: Colors.blueGrey,
                            ),
                            onPressed: () {})),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.itemName,
                  style: TextStyle(
                      fontSize: 22,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.product.itemDesc,
                  style: TextStyle(fontSize: 17, letterSpacing: 2),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '\u{20B9} ${numberFormat.format(int.parse(widget.product.itemPrice))}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '\u{20B9} ${numberFormat.format(int.parse("400"))}',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '50% off',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 21,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent[700],
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        "4.3 *",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                          '${numberFormat.format(int.parse("1545187"))} ratings',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
              child: SizedBox(
            height: deviceSize.height / 15.5,
            child: RaisedButton(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              color: Colors.white,
              onPressed: () {},
              child: Text(
                'ADD TO CART',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          )),
          Expanded(
              child: SizedBox(
            height: deviceSize.height / 15.5,
            child: RaisedButton(
              color: Colors.orange[800],
              onPressed: () {},
              child: Text('BUY NOW',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
          )),
        ],
      ),
    );
  }
}
