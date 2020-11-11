import 'dart:wasm';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:potenchip/models/vehicle_model.dart';
import 'package:potenchip/shared/text.dart';
part 'search_controller.g.dart';

class SearchController = _SearchControllerBase with _$SearchController;

abstract class _SearchControllerBase with Store {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<String> brand_list = [
    "FIAT",
    "LAND ROVER",
    "ASTON MARTIN",
    "AUDI",
    "KIA",
    "MERCEDES BENZ",
    "CITROEN",
    "VOLKSWAGEN",
    "PORSCHE",
    "CHEVROLET",
    "VOLVO",
    "JAGUAR",
    "BMW",
    "HONDA",
    "FORD",
    "PEUGEOT",
    "FERRARI",
    "MITSUBISHI",
    "NISSAN",
    "RENAULT",
    "DODGE",
    "CADILLAC",
    "SUBARU",
    "HYUNDAI",
    "TOYOTA",
    "LEXUS",
    "BMW MOTOS",
    "CHRYSLER",
    "SUZUKI",
    "JEEP",
    "BENTLEY",
    "MINI",
    "MAHINDRA",
    "MASERATI",
    "TAC",
    "LAMBORGHINI",
    "SMART",
    "TROLLER",
    "BUGATTI"
  ];

  @observable 
  bool success = false;

  @observable 
  bool isMercosul = false;

  @observable
  ObservableList<String> model_list = ObservableList<String>();

  @observable
  ObservableList<VehicleModel> car_list = ObservableList<VehicleModel>();

  @observable
  double priceChange;


  @observable
  String model = "";

  @observable
  String brand = "";

  @observable 
  VehicleModel selectedCar = VehicleModel();

  @observable 
  String plateA = "";

  @observable 
  String plateB = "";

  @observable 
  String plateMercosulA = "";

  @observable 
  String plateMercosulB= "";

  @observable 
  String plateMercosulC = "";

  @observable 
  String plateMercosulD = "";

  @observable
  String finalPlateMercosul = "";

  @observable 
  String finalPlate = "";


  @action 
  void setMercosul(bool value){
    isMercosul = value;
  }


  @action 
  void setBrand(value){
    print(value);
    brand = value;
    model_list.clear();
    print(brand);
  }

  @action 
  void setModel(value){
    model = value;
    car_list.forEach((element) {
      if(element.name.toUpperCase() == model.toUpperCase()){
          selectedCar = element;
      }
    });
  }

  @action
  void setPlateA(String value){
      plateA = value.toUpperCase();
  }
  @action
  void setPlateB(String value){
      plateB = value.toUpperCase();
  }

  @action
  void setPlateMercosulA(String value){
      plateMercosulA = value.toUpperCase();
  }

  @action
  void setPlateMercosulB(String value){
      plateMercosulB = value.toUpperCase();
  }

  @action
  void setPlateMercosulC(String value){
      plateMercosulC = value.toUpperCase();
  }

  @action
  void setPlateMercosulD(String value){
      plateMercosulD = value.toUpperCase();
  }

  @action
  Future getPriceChanger(String city, String uf) async{
    String location = city+","+uf;
    print(location);
   QuerySnapshot snapshots = await FirebaseFirestore.instance.collection("Users").where("workingCities",arrayContains:location).get();
   if(snapshots.docs!=null){
     print(snapshots.docs[0]["priceChange"]);
     priceChange = snapshots.docs[0]["priceChange"];
     selectedCar.priceChange = priceChange;
   }

  }



  @action 
  void getModelsFromSnapshot(List<dynamic> snapshot){
    car_list = ObservableList<VehicleModel>();
    snapshot.forEach((element) {
       VehicleModel car = VehicleModel();
        car.fromDocument(element);
        car_list.add(car);
    });
  } 

  @action
  List<DropdownMenuItem<String>> getBrandList() {
    return convertToMenuItem(brand_list);
  }





}
