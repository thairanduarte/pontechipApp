import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserModel {
  String id;
  String name;
  String phone;
  String email;
  String password;
  String uf;
  String city;
  bool isAdmin;
  bool isColab;
  List<dynamic> workingCities;
  double priceChange;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc("Users/$id");

  Future<void> saveData() async {
    firestoreRef.set(toDocument());
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "id": id,
      "uf": uf,
      "city": city,
      "isAdmin": isAdmin as bool,
      "isColab": isColab as bool,
      "workingCities": workingCities,
      "priceChange": priceChange
    };
  }

  String getUserLocation() {
    if (uf != null && city != null) {
      return "${uf},${city}";
    }
    if (uf != null && city != null) {
      return "${uf},${city}";
    }
  }

  void fromMap(Map<dynamic, dynamic> map) {
    this.id = map["id"] as String;
    this.name = map["name"] as String;
    this.email = map["email"] as String;
    this.phone = map["phone"] as String;
    this.uf = map["uf"] as String;
    this.city = map["city"] as String;
    this.isAdmin = map["isAdmin"] as bool;
    this.isColab = map["isColab"] as bool;
    this.workingCities = map["workingCities"] as List<dynamic>;
    this.priceChange = map["priceChange"] as double;
  }

  void fromDocument(DocumentSnapshot document) {
    
    if (document.data() != null) {
      this.id = document.data()["id"] as String;
      this.name = document.data()["name"] as String;
      this.phone = document.data()["phone"] as String;
      this.email = document.data()["email"] as String;
      if (document.data()["uf"] != null) {
        this.uf = document.data()["uf"] as String;
      } else {
        this.uf = "";
      }
      if (document.data()["city"] != null) {
        this.city = document.data()["city"] as String;
      } else {
        this.city = "";
      }
      this.isAdmin = document.data()["isAdmin"] as bool;
      this.isColab = document.data()["isColab"] as bool;
      this.workingCities = document.data()["workingCities"] as List<dynamic>;
      this.priceChange = document.data()["priceChange"] as double;
    }
  }
}
