import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_auth/db/db_operation.dart';
import 'package:flutter_phone_auth/model/person.dart';
import 'package:flutter_phone_auth/screens/login.dart';
import 'package:flutter_phone_auth/screens/sucess.dart';
import 'package:flutter_phone_auth/utils/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String msg = "";
  String imagePath; //take image path picked from imagepicker
  String downloadURL;//download url from firbase
  String uid;//user id
  Person user = Person();//person class object
  final _formkey = GlobalKey<FormState>();
  String gender = 'male';
  File imageFile;//take file path 

  //open Cemera or Gallery to pic image
  _openCameraOrGallery(String param) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);
    print("Image Path is $imageFile");
    setState(() {});
  }

  //upload profile pic to the firebase storage and return download link
  _uploadImage() {
    imagePath = "images/${DateTime.now()}.jpg";
    Reference ref = FirebaseStorage.instance.ref().child(imagePath);
    UploadTask uploadTask = ref.putFile(imageFile);
    uploadTask.then((TaskSnapshot tasksnapshot) async {
      downloadURL = await tasksnapshot.ref.getDownloadURL();
      setState(() {
        msg = "File Uploaded $downloadURL";
        print(msg);
      });
    }).catchError((err) => setState(() {
          msg = "Error in Upload $err";
          print(msg);
        }));
    if (uploadTask.snapshot.state == TaskState.success) {
      setState(() {
        msg = "File Uploaded ";
        print(msg);
      });
    } else {
      msg = "File Not Uploaded....";
      print(msg);
    }
  }

  String loc ;//store the current user loaction

  //getLocation of the user
  _getLocation() async {
    loc = await getLocation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white30,
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text('Profile Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false);
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Builder(
          builder: (context) => Form(
            key: _formkey,
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 4,
                              color: Colors.white,
                            ),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.white.withOpacity(.2),
                                offset: Offset(0, 10),
                              ),
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: imageFile == null
                                  ? NetworkImage(
                                      'https://clipground.com/images/person-icon-clipart-5.jpg')
                                  : FileImage(imageFile),
                            )),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                              color: Colors.green,
                            ),
                            child: IconButton(
                                icon: Icon(Icons.edit, color: Colors.white),
                                onPressed: () {
                                  _openCameraOrGallery('');
                                }),
                          )),
                    ],
                  ),
                ),
                Center(
                  child: RaisedButton(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(color: Colors.black),
                    ),
                    color: Colors.orange[800],
                    onPressed: () {
                      _uploadImage();
                    },
                    child: Text(
                      'Upload Profile Picture',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                buildTextFormField(
                  lable: 'Full Name',
                  hint: 'Enter Full Name',
                  error: 'Please Enter Full Name',
                  controller: nameController,
                ),
                SizedBox(
                  height: 20,
                ),
                buildTextFormField(
                  controller: dobController,
                  hint: 'DD/MM/YYYY',
                  lable: 'Date of Birth',
                  error: 'Please Enter DOB',
                ),
                SizedBox(
                  height: 20,
                ),
                buildTextFormField(
                  controller: emailController,
                  hint: 'example@gmail.com',
                  lable: 'E-mail',
                  error: 'Please Enter email id',
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 10),
                  child: Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                RadioListTile(
                  title: Text(
                    'MALE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  value: 'male',
                  activeColor: Colors.orange[800],
                  groupValue: gender,
                  onChanged: (val) {
                    setState(() {
                      gender = val;
                    });
                  },
                ),
                RadioListTile(
                  title: Text(
                    'FEMALE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  value: 'female',
                  groupValue: gender,
                  activeColor: Colors.orange[800],
                  onChanged: (val) {
                    setState(() {
                      gender = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                   loc!=null? '${loc}':'',
                   style: TextStyle(color: Colors.white,fontSize: 23,),
                  ),
                ),
                SizedBox(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(color: Colors.black),
                    ),
                    child: Text('Current Location',
                        style: TextStyle(letterSpacing: 2)),
                    onPressed: () {
                      _getLocation();
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(color: Colors.black),
                    ),
                    color: Colors.orange[800],
                    elevation: 0,
                    onPressed: () async {
                      final form = _formkey.currentState;
                      if (form.validate()) {
                        storeUser();
                        print('Person :${user.toString()}');
                        await _addPerson(user);
                        moveTonextScreen();
                      }
                    },
                    child: Text('Save',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //store user details to the user object 
  storeUser() {
    user.name = nameController.text;
    user.dob = dobController.text;
    user.email = emailController.text;
    user.uid = uid;
    user.picUrl = downloadURL == null
        ? 'https://clipground.com/images/person-icon-clipart-5.jpg'
        : downloadURL;
    user.location = loc;
    user.gender = gender;
    setState(() {});
  }

  //move to next screen--succes 
  moveTonextScreen() {
    Timer(
        Duration(seconds: 8),
        () => {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Success(user: user)))
            });
  }

  //Text form widget 
  TextFormField buildTextFormField(
      {String lable, String hint, String error, dynamic controller}) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
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
      validator: (value) {
        if (value.isEmpty) {
          return error;
        }
      },
      controller: controller,
    );
  }

  //Assigning contoller to the text fields 
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  //adding user to cloud firebase 
  Future<String> _addPerson(Person user) async {
    String str = await DbOperations.addPerson(user);
    print(str);
    // return str;
  }

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
  }
}
