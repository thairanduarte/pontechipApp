import 'package:potenchip/models/user_model.dart';
import 'package:potenchip/models/vehicle_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlateModel {
  String plate;
  VehicleModel vehicle; 
  UserModel user;
  String carOwner;
  String date;

  void fromDocument(DocumentSnapshot document) {
    user = UserModel();
    vehicle = VehicleModel();
    if (document != null) {
    
      user.fromMap(document.data()["user"]);
      vehicle.fromMap(document.data()["vehicle"]);
      this.date = document.data()["data"];
      this.plate = document.data()["plate"];
      this.carOwner = document.data()["carOwner"];
    }
  }

  bool checkCarOwner(){
    if(user.name.toString().toUpperCase() == carOwner.toUpperCase()){
      return true;
    }else{
      return false;
    }
  }

  Map<String, dynamic> toDocument() {
    return {
      "user": user.toDocument(),
      "data": date,
      "vehicle":vehicle.toDocument(),
      "plate":plate,
      "carOwner":carOwner
    };
  }
}
