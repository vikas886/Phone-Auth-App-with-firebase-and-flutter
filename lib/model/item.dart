class Item {
  String itemName;
  String itemDesc;
  List<dynamic> url;
  String sellerName;
  String itemPrice;
  Item({
    this.itemName,
    this.itemDesc,
    this.url,
    this.sellerName,
    this.itemPrice,
  });

  @override
  String toString() {
    return 'Item(itemName: $itemName, itemDesc: $itemDesc, url: $url, sellerName: $sellerName, itemPrice: $itemPrice)';
  }
}
