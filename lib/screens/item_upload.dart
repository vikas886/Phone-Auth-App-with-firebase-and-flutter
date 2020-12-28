import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_auth/db/db_operation.dart';
import 'package:flutter_phone_auth/model/item.dart';
import 'package:flutter_phone_auth/model/person.dart';
import 'package:flutter_phone_auth/screens/items_details.dart';
import 'package:image_picker/image_picker.dart';

class UploadItem extends StatefulWidget {
  Person user;
  UploadItem(this.user);

  @override
  _UploadItemState createState() => _UploadItemState();
}

class _UploadItemState extends State<UploadItem> {
  File imageFile1, imageFile2, imageFile3, imageFile4;
  bool uploading = false;
  double val = 0;
  String itemUID = "";

  //open camera or gallery to pick the images
  _openCameraOrGallery(String param) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);
    if (param == '1') {
      imageFile1 = File(pickedFile.path);
      print("Image Path is $imageFile1");
    } else if (param == '2') {
      imageFile2 = File(pickedFile.path);
      print("Image Path is $imageFile2");
    } else if (param == '3') {
      imageFile3 = File(pickedFile.path);
      print("Image Path is $imageFile3");
    } else if (param == '4') {
      imageFile4 = File(pickedFile.path);
      print("Image Path is $imageFile4");
    }
    // print("Image Path is $imageFile1");
    setState(() {});
  }

  //Image Container to display the picked images
  imageContainer(
    dynamic opneCamOrGal,
    String params,
  ) {
    return InkWell(
      onTap: () async {
        await opneCamOrGal(params);
        setState(() {
          // print('fileeee: ${file}');
        });
      },
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.white,
          ),
          boxShadow: [
            BoxShadow(
              spreadRadius: 3,
              blurRadius: 10,
              color: Colors.white.withOpacity(.2),
              offset: Offset(0, 10),
            ),
          ],
          shape: BoxShape.rectangle,
          image: decorationImage(params),
        ),
      ),
    );
  }

  decorationImage(String param) {
    if (param == '1') {
      return DecorationImage(
        fit: BoxFit.cover,
        image: imageFile1 == null
            ? NetworkImage(
                'https://toppng.com/uploads/preview/file-upload-image-icon-115632290507ftgixivqp.png')
            : FileImage(imageFile1),
      );
    }
    if (param == '2') {
      return DecorationImage(
        fit: BoxFit.cover,
        image: imageFile2 == null
            ? NetworkImage(
                'https://toppng.com/uploads/preview/file-upload-image-icon-115632290507ftgixivqp.png')
            : FileImage(imageFile2),
      );
    }
    if (param == '3') {
      return DecorationImage(
        fit: BoxFit.cover,
        image: imageFile3 == null
            ? NetworkImage(
                'https://toppng.com/uploads/preview/file-upload-image-icon-115632290507ftgixivqp.png')
            : FileImage(imageFile3),
      );
    }
    if (param == '4') {
      return DecorationImage(
        fit: BoxFit.cover,
        image: imageFile4 == null
            ? NetworkImage(
                'https://toppng.com/uploads/preview/file-upload-image-icon-115632290507ftgixivqp.png')
            : FileImage(imageFile4),
      );
    }
  }

  TextField buildTextFormField(
      {String lable, String hint, dynamic controller}) {
    return TextField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        labelText: lable,
        hintText: hint,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: Colors.orange[800]),
          gapPadding: 10,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: Colors.orange[800]),
          gapPadding: 10,
        ),
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(horizontal: 45, vertical: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: Colors.orange[800]),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: Colors.orange[800]),
          gapPadding: 10,
        ),
      ),
      controller: controller,
    );
  }

  //Upload Images On firebase Storage
  String msg = '';
  String imagePath;
  String downloadURL;
  List<String> download = [];
  Future _uploadImage() {
    int i = 1;
    List<File> img12 = [imageFile1, imageFile2, imageFile3, imageFile4];
    print(img12);
    for (var img in img12) {
      setState(() {
        val = i / img12.length;
      });
      imagePath = "images/${DateTime.now()}.jpg";
      Reference ref = FirebaseStorage.instance.ref().child(imagePath);
      UploadTask uploadTask = ref.putFile(img);
      uploadTask.then((TaskSnapshot tasksnapshot) async {
        downloadURL = await tasksnapshot.ref.getDownloadURL();
        setState(() {
          msg = "File Uploaded $downloadURL";
          i++;
          download.add(downloadURL);
        });
      }).catchError((err) => setState(() {
            msg = "Error in Upload $err";
          }));
      if (uploadTask.snapshot.state == TaskState.success) {
        setState(() {
          msg = "File Uploaded ";
        });
      } else {
        msg = "File Not Uploaded....";
      }
    }
  }

  Item item = Item();
  //Save Items Details to firebase
  Future _saveRecord() async {
    // Product product = Product();
    // Item item=Item();
    item.itemName = _nameCtrl.text;
    item.itemDesc = _descCtrl.text;
    item.itemPrice = _priceCtrl.text;
    item.sellerName = _sellerCtrl.text;
    item.url = download;
    String result = await DbOperations.addItem(item);
    setState(() {
      itemUID = result;
    });
    print("Product DETAIL IS $item");
    print('price ${item.itemPrice}');
    print('price ${item.sellerName}');
  }

  //Text Controllers to access the text in the text field
  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _priceCtrl = TextEditingController();
  TextEditingController _descCtrl = TextEditingController();
  TextEditingController _sellerCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text(
          'Add New Item',
          style: TextStyle(letterSpacing: 2),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.orange[800],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Stack(children: [
          ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  imageContainer(_openCameraOrGallery, '1'),
                  imageContainer(_openCameraOrGallery, '2'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  imageContainer(_openCameraOrGallery, '3'),
                  imageContainer(_openCameraOrGallery, '4'),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                color: Colors.orange[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: Colors.black),
                ),
                onPressed: () {
                  // setState(() {
                  //   uploading=true;
                  // });
                  _uploadImage();
                  print(download);
                },
                child: Text(
                  'Upload items picture',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    wordSpacing: 2,
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  // height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.,
                  ),
                  child: Text(
                    'Add item Details',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        wordSpacing: 2),
                  )),
              SizedBox(
                height: 10,
              ),
              buildTextFormField(
                controller: _nameCtrl,
                hint: 'Enter Items Name',
                lable: 'Item Name',
              ),
              SizedBox(
                height: 10,
              ),
              buildTextFormField(
                controller: _sellerCtrl,
                hint: "Enter Seller's",
                lable: 'Seller Name',
              ),
              SizedBox(
                height: 10,
              ),
              buildTextFormField(
                controller: _descCtrl,
                hint: "Enter Item's Description",
                lable: 'Item Description',
              ),
              SizedBox(
                height: 10,
              ),
              buildTextFormField(
                controller: _priceCtrl,
                hint: "Enter Item's Price",
                lable: 'Item Name',
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: Colors.black),
                ),
                color: Colors.orange[800],
                onPressed: () {
                  _saveRecord().whenComplete(() => {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => ItemsDetails(
                                  product: item,
                                  user: widget.user,
                                )))
                      });
                },
                child: Text('UPLOAD ITEM',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      wordSpacing: 2,
                    )),
              ),
            ],
          ),
          uploading
              ? Center(
                  child: Column(
                    children: [
                      Container(child: Text('uploading...')),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ),
                )
              : Container(),
        ]),
      ),
    );
  }
}
