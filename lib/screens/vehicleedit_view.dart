import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:potenchip/controllers/search_controller.dart';
import 'package:potenchip/controllers/user_controller.dart';
import 'package:potenchip/models/plate_model.dart';
import 'package:potenchip/screens/edit_model_view.dart';
import 'package:potenchip/screens/model_view.dart';
import 'package:potenchip/shared/custombutton.dart';
import 'package:potenchip/shared/customtextfield.dart';
import 'package:potenchip/shared/plate_formatter.dart';
import 'package:potenchip/shared/text.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

class VehicleEditView extends StatefulWidget {
  final UserController userController;
  VehicleEditView({Key key, this.userController}) : super(key: key);

  @override
  _VehicleEditViewState createState() => _VehicleEditViewState();
}

class _VehicleEditViewState extends State<VehicleEditView> {
  SearchController searchController = SearchController();
  PlateFormatter plateFormatter = PlateFormatter();
  String valueModel = "";
  String _platformVersion = 'Unknown';
  bool isColab = false;

  Future<List<dynamic>> getCarList() async {
    QuerySnapshot qShot = await FirebaseFirestore.instance
        .collection("Cars")
        .where("brand", isEqualTo: searchController.brand.toUpperCase())
        .get();

    return qShot.docs.map((doc) => doc["name"]).toList();
  }

  void setNewConsulta() async {
    if (searchController.isMercosul) {
      searchController.finalPlate = searchController.plateMercosulA +
          searchController.plateMercosulB +
          searchController.plateMercosulC +
          searchController.plateMercosulD;
    } else {
      searchController.finalPlate =
          searchController.plateA + searchController.plateB;
    }

    print(searchController.finalPlate);

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyy // kk:mm:ss');
    final String formatted = formatter.format(now);
    print(formatted);
    PlateModel plateDocument = PlateModel();
    plateDocument.date = formatted;
    plateDocument.user = widget.userController.user;
    plateDocument.vehicle = searchController.selectedCar;
    plateDocument.plate = searchController.finalPlate;
    print(plateDocument.toDocument());

    await FirebaseFirestore.instance
        .collection("Consultas")
        .doc()
        .set(plateDocument.toDocument());
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 0,
                          color: Colors.transparent,
                          child: Container(
                              height: 80,
                              child: Image.asset('assets/Potenchip.png')),
                        ),
                        SizedBox(height: 25),
                        CustomText('Editar veículo', 22),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 35, right: 35, top: 10),
                          child: Container(
                            color: Colors.transparent,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35))),
                              color: Colors.grey[850],
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, bottom: 12, top: 0),
                                  child:
                                      // Observer(builder: (_) {
                                      //   return

                                      ListView(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      CustomText(
                                          'Caracteristicas do veículo', 18),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width: 300,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Marca",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.normal),
                                                textAlign: TextAlign.center,
                                              ),
                                              SearchableDropdown.single(
                                                readOnly: false,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                items: searchController
                                                    .getBrandList(),
                                                value: "",
                                                hint: "Selecione uma Marca",
                                                searchHint:
                                                    "Selecione uma Marca",
                                                displayClearIcon: false,
                                                onChanged: (String value) {
                                                  if (value != null) {
                                                    searchController
                                                        .setBrand(value);

                                                    searchController.success =
                                                        false;
                                                  }
                                                },
                                                isCaseSensitiveSearch: false,
                                                isExpanded: true,
                                                closeButton: "Fechar",
                                                iconSize: 20,
                                                disabledHint: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      searchController.brand != "" ?
                                      StreamBuilder<dynamic>(
                                        stream: FirebaseFirestore.instance
                                            .collection("Cars")
                                            .where("brand",
                                                isEqualTo: searchController
                                                    .brand
                                                    .toUpperCase())
                                            .snapshots(),
                                        builder:
                                            (BuildContext context, snapshot) {
                                          if (snapshot.hasData) {
                                            searchController
                                                .getModelsFromSnapshot(
                                                    snapshot.data.docs);
                                            return SearchableDropdown.single(
                                              readOnly: false,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                              items: convertToMenuItemModels(
                                                  snapshot.data.docs),
                                              value: "",
                                              hint: "Selecione um Modelo",
                                              searchHint: "Selecione um Modelo",
                                              displayClearIcon: false,
                                              onChanged: (value) {
                                                print(value);
                                                if (value != null) {
                                                  searchController
                                                      .setModel(value);
                                                }

                                                // searchController.success =
                                                //     true;
                                              },
                                              isExpanded: true,
                                              //closeButton: "Fechar",
                                              iconSize: 20,
                                              disabledHint: true,
                                              isCaseSensitiveSearch: false,
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ):
                                      Container(),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      CustomButtonWidget(
                                          text: "Editar",
                                          height: 43,
                                          onPressed: () async {
                                     

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditModelView(
                                                        userController: widget
                                                            .userController,
                                                        vehicle:
                                                            searchController
                                                                .selectedCar,
                                                      )),
                                            );
                                          },
                                          context: context),
                                      SizedBox(
                                        height: 9,
                                      ),
                                    ],
                                  )
                                  //   ;
                                  // }),
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              
          );
  }
}
