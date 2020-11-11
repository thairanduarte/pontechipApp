import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potenchip/controllers/search_controller.dart';
import 'package:potenchip/controllers/user_controller.dart';
import 'package:potenchip/models/vehicle_model.dart';
import 'package:potenchip/shared/custombutton.dart';
import 'package:potenchip/shared/customtextfield.dart';
import 'package:potenchip/shared/plate_formatter.dart';
import 'package:potenchip/shared/text.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:uuid/uuid.dart';


class VehicleAddView extends StatefulWidget {
  final UserController userController;
  VehicleAddView({Key key, this.userController}) : super(key: key);

  @override
  _VehicleAddViewState createState() => _VehicleAddViewState();
}

class _VehicleAddViewState extends State<VehicleAddView> {
  SearchController searchController = SearchController();
  PlateFormatter plateFormatter = PlateFormatter();
  VehicleModel newVehicle = VehicleModel();
  String valueModel = "";
  bool isColab = false;

  bool isLoading = false;
  var uuid = Uuid();

  Future<List<dynamic>> getCarList() async {
    QuerySnapshot qShot = await FirebaseFirestore.instance
        .collection("Cars")
        .where("brand", isEqualTo: searchController.brand.toUpperCase())
        .get();

    return qShot.docs.map((doc) => doc["name"]).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black,
        appBar: AppBar(),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Card(
                    elevation: 1,
                    color: Colors.transparent,
                    child: Container(
                        height: 80, child: Image.asset('assets/Potenchip.png')),
                  ),
                  SizedBox(height: 25),
                  CustomText('Adicionar veículo', 22),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.grey[800],
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius:BorderRadius.all(Radius.circular(30))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          padding: EdgeInsets.all(15),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              Text(
                                "Marca",
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal),
                                textAlign: TextAlign.center,
                              ),
                              SearchableDropdown.single(
                                readOnly: false,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                items: searchController.getBrandList(),
                                value: "",
                                hint: "Selecione uma Marca",
                                searchHint: "Selecione uma Marca",
                                displayClearIcon: false,
                                onChanged: (String value) {
                                  if (value != null) {
                                    newVehicle.brand = value.toUpperCase().trim();

                                  }
                                },
                                
                                isCaseSensitiveSearch: false,
                                isExpanded: true,
                                closeButton: "Fechar",
                                iconSize: 20,
                                disabledHint: true,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                           Text(
                                "Modelo",
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomEditTextField(
                                width: MediaQuery.of(context).size.width / 1.3,
                                hint: "Modelo",
                                textInputType: TextInputType.name,
                                inputFormatter: [],
                                prefix: Icon(
                                  Icons.car_repair,
                                  color: Colors.white,
                                ),
                                onChanged: (value) {
                                newVehicle.name = value.toUpperCase().trim();

                                },
                                onSubmitted: (value) {
                                  newVehicle.name = value.toUpperCase().trim();
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                         Text(
                                "Potencia Original",
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: CustomEditTextField(
                                  hint: "Potencia",
                                  textInputType: TextInputType.number,
                                  inputFormatter: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  prefix: Icon(
                                    Icons.car_repair,
                                    color: Colors.white,
                                  ),
                                  onChanged: (value) {
                                newVehicle.default_power = value.toUpperCase().trim();
                                  },
                                  onSubmitted: (value) {
                                newVehicle.default_power = value.toUpperCase().trim();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: CustomEditTextField(
                                  hint: "Torque",
                                  textInputType: TextInputType.number,
                                  inputFormatter: [FilteringTextInputFormatter.digitsOnly,],
                                  prefix: Icon(
                                    Icons.car_repair,
                                    color: Colors.white,
                                  ),
                                  onChanged: (value) {
                                newVehicle.default_torque = value.toUpperCase().trim();
                                  },
                                  onSubmitted: (value) {
                                newVehicle.default_torque = value.toUpperCase().trim();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Potencia Reprogramado",
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomText('Variação potencia', 18,
                                  fontStyle: FontStyle.normal),
                              SizedBox(
                                height: 10,
                              ),
                              CustomEditTextField(
                                width: MediaQuery.of(context).size.width / 1.3,
                                hint: "Potencia",
                                textInputType: TextInputType.number,
                                inputFormatter: [FilteringTextInputFormatter.digitsOnly,],
                                prefix: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                onChanged: (value) {
                                newVehicle.increase_power = value.toUpperCase().trim();
                                },
                                onSubmitted: (value) {
                                newVehicle.increase_power = value.toUpperCase().trim();
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomText('Variação Torque', 18,
                                  fontStyle: FontStyle.normal),
                              SizedBox(
                                height: 10,
                              ),
                              CustomEditTextField(
                                width: MediaQuery.of(context).size.width / 1.3,
                                hint: "Torque",
                                textInputType: TextInputType.number,
                                inputFormatter: [FilteringTextInputFormatter.digitsOnly,],
                                prefix: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                onChanged: (value) {
                                newVehicle.increase_torque = value.toUpperCase().trim();
                                },
                                onSubmitted: (value) {
                                newVehicle.increase_torque = value.toUpperCase().trim();
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomText('Valor', 19,
                                  fontStyle: FontStyle.normal),
                              SizedBox(
                                height: 10,
                              ),
                              CustomEditTextField(
                                width: MediaQuery.of(context).size.width / 1.3,
                                hint: "Valor",
                                textInputType: TextInputType.numberWithOptions(),
                                inputFormatter: [FilteringTextInputFormatter.digitsOnly,],
                                prefix: Icon(
                                  Icons.attach_money,
                                  color: Colors.white,
                                ),
                                onChanged: (value) {
                                newVehicle.final_price = value.toUpperCase().trim();
                                },
                                onSubmitted: (value) {
                                newVehicle.final_price = value.toUpperCase().trim();
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomText('Valor 12x', 19,
                                  fontStyle: FontStyle.normal),
                              SizedBox(
                                height: 10,
                              ),
                              CustomEditTextField(
                                width: MediaQuery.of(context).size.width / 1.3,
                                hint: "Valor 12x",
                                textInputType: TextInputType.numberWithOptions(),
                                inputFormatter: [FilteringTextInputFormatter.digitsOnly,],
                                prefix: Icon(
                                  Icons.money_off,
                                  color: Colors.white,
                                ),
                                onChanged: (value) {
                                newVehicle.total_price = value.toUpperCase().trim();
                                },
                                onSubmitted: (value) {
                                newVehicle.total_price = value.toUpperCase().trim();
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              isLoading
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.red,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.all(5),
                                      child: CustomButtonWidgetSave(
                                          text: "Salvar",
                                          height: 43,
                                          onPressed: () async {
                                            setState(() {
                                              isLoading = true;
                                            });

                                            newVehicle.carId = uuid.v1();
                                            newVehicle.tunning_power = (int.parse(newVehicle.default_power) + int.parse(newVehicle.increase_power)).toString();
                                            newVehicle.tunning_torque = (int.parse(newVehicle.default_torque) + int.parse(newVehicle.increase_torque)).toString();

                                            print(newVehicle.toDocument());
                                            await FirebaseFirestore.instance.collection("Cars").doc(newVehicle.carId).set(newVehicle.toDocument());

                                            await Future.delayed(
                                                Duration(seconds: 2));
                                            

                                            setState(() {
                                              isLoading = false;
                                            });

                                            Navigator.pop(context);
                                          },
                                          width: 150,
                                          context: context),
                                    ),
                              SizedBox(height: 40),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
