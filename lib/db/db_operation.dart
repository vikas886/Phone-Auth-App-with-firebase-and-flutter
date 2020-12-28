import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_phone_auth/model/item.dart';
import 'package:flutter_phone_auth/model/person.dart';

class DbOperations {
  static Future<String> addPerson(Person person) async {
    DocumentReference docRef;
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('person');
    Map<String, dynamic> map = {
      "name": person.name,
      "dob": person.dob,
      "email": person.email,
      "location": person.location,
      "gender": person.gender,
      "uid": person.uid,
      "picUrl": person.picUrl,
    };
    try {
      docRef = await collectionReference.add(map);
    } catch (e) {
      return "Error in Record Add $e";
    }
    return "Record added ${docRef.id}";
  }

  static Future<String> addItem(Item item) async {
    DocumentReference docRef;
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('items');
    Map<String, dynamic> map = {
      "name": item.itemName,
      "seller": item.sellerName,
      "price": item.itemPrice,
      "desc": item.itemDesc,
      "imageUrl": item.url,
    };
    try {
      docRef = await collectionReference.add(map);
    } catch (e) {
      return "Error in Record Add $e";
    }
    return "Record added ${docRef.id}";
  }

  static Query fetchItems() {
    Query query = FirebaseFirestore.instance.collection('items');
    String filterOrOrder = 'ascending';
    return query;
  }

 static checkLoggedIn() {
   return FirebaseFirestore.instance
        .collection('person')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .orderBy('timeStamp',descending:true )
        .get();
  }
}
