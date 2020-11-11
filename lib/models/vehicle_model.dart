import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleModel{
  String carId;
  String brand;
  String name;
  String default_power;
  String default_torque;
  String final_price;
  String total_price;
  String increase_power;
  String increase_torque;
  String tunning_power;
  String tunning_torque;
  double priceChange;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc("Cars/$carId");

  Future<void> saveData() async {
    firestoreRef.set(toDocument());
  }

  Map<String, dynamic> toDocument() {
    return {
      "carId": this.carId,
      "brand": this.brand,
      "name": this.name,
      "default_power": this.default_power,
      "default_torque": this.default_torque,
      "final_price": this.final_price,
      "total_price": this.total_price,
      "increase_power": this.increase_power,
      "increase_torque": this.increase_torque,
      "tunning_power": this.tunning_power,
      "tunning_torque": this.tunning_torque
    };
  }
  void fromMap(Map<String, dynamic> document) {
    if (document != null) {
      this.carId = document["carId"] as String;
      this.brand = document["brand"] as String;
      this.name = document["name"] as String;
      this.default_power = document["default_power"] as String;
      this.default_torque = document["default_torque"] as String;
      this.final_price = document["final_price"] as String;
      this.total_price = document["total_price"] as String;
      this.increase_power = document["increase_power"] as String;
      this.increase_torque = document["increase_torque"] as String;
      this.tunning_power = document["tunning_power"] as String;
      this.tunning_torque = document["tunning_torque"] as String;
    }
  }

  void fromDocument(QueryDocumentSnapshot document) {
    if (document != null) {
      this.carId = document.data()["carId"] as String;
      this.brand = document.data()["brand"] as String;
      this.name = document.data()["name"] as String;
      this.default_power = document.data()["default_power"] as String;
      this.default_torque = document.data()["default_torque"] as String;
      this.final_price = document.data()["final_price"] as String;
      this.total_price = document.data()["total_price"] as String;
      this.increase_power = document.data()["increase_power"] as String;
      this.increase_torque = document.data()["increase_torque"] as String;
      this.tunning_power = document.data()["tunning_power"] as String;
      this.tunning_torque = document.data()["tunning_torque"] as String;
    }
  }
}
