import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:potenchip/controllers/search_controller.dart';
import 'package:potenchip/controllers/user_controller.dart';
import 'package:potenchip/models/plate_model.dart';
import 'package:potenchip/screens/login_view.dart';
import 'package:potenchip/screens/model_view.dart';
import 'package:potenchip/shared/custombutton.dart';
import 'package:potenchip/shared/customtextfield.dart';
import 'package:potenchip/shared/plate_formatter.dart';
import 'package:potenchip/shared/text.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

class SearchModelView extends StatefulWidget {
  final UserController userController;
  SearchModelView({Key key, this.userController}) : super(key: key);

  @override
  _SearchModelViewState createState() => _SearchModelViewState();
}

class _SearchModelViewState extends State<SearchModelView> {
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

  bool success = false;
  Future<void> delayed() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      success = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.userController.user.isColab ||
            widget.userController.user.isAdmin
        ? widget.userController.user.isAdmin
            ? Scaffold(
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
                        CustomText('Orçamento Admin', 22),
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
                                      searchController.brand != ""
                                          ? StreamBuilder<dynamic>(
                                              stream: FirebaseFirestore.instance
                                                  .collection("Cars")
                                                  .where("brand",
                                                      isEqualTo:
                                                          searchController.brand
                                                              .toUpperCase())
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  snapshot) {
                                                if (snapshot.hasData) {
                                                  searchController
                                                      .getModelsFromSnapshot(
                                                          snapshot.data.docs);
                                                  return SearchableDropdown
                                                      .single(
                                                    readOnly: false,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    items:
                                                        convertToMenuItemModels(
                                                            snapshot.data.docs),
                                                    value: "",
                                                    hint: "Selecione um Modelo",
                                                    searchHint:
                                                        "Selecione um Modelo",
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
                                                    isCaseSensitiveSearch:
                                                        false,
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              },
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      CustomButtonWidget(
                                          text: "Orçamento",
                                          height: 43,
                                          onPressed: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ModelView(
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
              )
            :

            //COLABORADOR
            Scaffold(
                resizeToAvoidBottomPadding: true,
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.black,
                body: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Card(
                          elevation: 0,
                          color: Colors.transparent,
                          child: Container(
                              height: 100,
                              child: Image.asset('assets/Potenchip.png')),
                        ),
                        SizedBox(height: 25),
                        CustomText('Orçamento Colaborador', 22),
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
                                      CustomText(
                                          'Caracteristicas do veículo', 18),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      CustomLoginTextField(
                                        hint: "Nome do Cliente",
                                        textInputType: TextInputType.name,
                                        inputFormatter: [],
                                        prefix: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                        onChanged: (value) {
                                          //signUpController.setName(value);
                                        },
                                        onSubmitted: (value) {
                                          //signUpController.setName(value);
                                        },
                                      ),
                                      SizedBox(
                                        height: 13,
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
                                                onChanged:
                                                    (String value) async {
                                                  if (value != null) {
                                                    searchController
                                                        .setBrand(value);
                                                    searchController
                                                        .setModel("");
                                                    searchController.success =
                                                        false;
                                                  }
                                                  setState(() {
                                                    success = false;
                                                  });
                                                  await delayed();
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
                                      searchController.brand != ""
                                          ? success
                                              ? StreamBuilder<dynamic>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection("Cars")
                                                      .where("brand",
                                                          isEqualTo:
                                                              searchController
                                                                  .brand
                                                                  .toUpperCase())
                                                      .snapshots(),
                                                  builder:
                                                      (BuildContext context,
                                                          snapshot) {
                                                    if (snapshot.hasData) {
                                                      searchController
                                                          .getModelsFromSnapshot(
                                                              snapshot
                                                                  .data.docs);
                                                      return SearchableDropdown
                                                          .single(
                                                        readOnly: false,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        items:
                                                            convertToMenuItemModels(
                                                                snapshot
                                                                    .data.docs),
                                                        value: "",
                                                        hint:
                                                            "Selecione um Modelo",
                                                        searchHint:
                                                            "Selecione um Modelo",
                                                        displayClearIcon: false,
                                                        onChanged: (value) {
                                                          print(value);
                                                          if (value != null) {
                                                            searchController
                                                                .setModel(
                                                                    value);
                                                          }

                                                          // searchController.success =
                                                          //     true;
                                                        },
                                                        isExpanded: true,
                                                        //closeButton: "Fechar",
                                                        iconSize: 20,
                                                        disabledHint: true,
                                                        isCaseSensitiveSearch:
                                                            false,
                                                      );
                                                    } else {
                                                      return Container();
                                                    }
                                                  },
                                                )
                                              : Container(
                                                  height: 50,
                                                  width: 50,
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator()))
                                          : Container(),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Observer(builder: (_) {
                                        return searchController.model != ""
                                            ? Row(
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                    child: Text(
                                                      "Mercosul",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  )),
                                                  Container(
                                                    height: 45,
                                                    width: 80,
                                                    child: Center(
                                                      child: Switch(
                                                        value: searchController
                                                            .isMercosul,
                                                        onChanged: (value) {
                                                          searchController
                                                              .setMercosul(
                                                                  value);
                                                          searchController
                                                              .finalPlate = "";
                                                          searchController
                                                              .finalPlateMercosul = "";
                                                        },
                                                        activeTrackColor: Colors
                                                            .lightGreenAccent,
                                                        activeColor:
                                                            Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container();
                                      }),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Observer(builder: (_) {
                                        return searchController.model != ""
                                            ? searchController.isMercosul
                                                ?
                                                //IS MERCOSUL
                                                //32387
                                                //cc 264784
                                                //cnpj 76321074/0001-91
                                                Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            CustomPlateTextField(
                                                          hint: "ABC",
                                                          height: 70,
                                                          prefix: null,
                                                          textInputType:
                                                              TextInputType
                                                                  .name,
                                                          inputFormatter: <
                                                              TextInputFormatter>[
                                                            FilteringTextInputFormatter(
                                                                RegExp(
                                                                    "[a-zA-Z]"),
                                                                allow: true),
                                                            UpperCaseTextFormatter(),
                                                            LengthLimitingTextInputFormatter(
                                                                3),
                                                          ],
                                                          onChanged: (value) {
                                                            print(value);
                                                            if (value != null) {
                                                              print("value");
                                                              searchController
                                                                  .setPlateMercosulA(
                                                                      value
                                                                          .toUpperCase());
                                                            }
                                                          },
                                                          onSubmitted: (value) {
                                                            if (value != null) {
                                                              searchController
                                                                  .setPlateMercosulA(
                                                                      value
                                                                          .toUpperCase());
                                                            }
                                                          },
                                                          enabled: true,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Container(
                                                        width: 50,
                                                        child:
                                                            CustomPlateTextField(
                                                          hint: "0",
                                                          height: 70,
                                                          prefix: null,
                                                          textInputType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatter: <
                                                              TextInputFormatter>[
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
                                                            UpperCaseTextFormatter(),
                                                            LengthLimitingTextInputFormatter(
                                                                1),
                                                          ],
                                                          onChanged: (value) {
                                                            if (value != null) {
                                                              searchController
                                                                  .setPlateMercosulB(
                                                                      value
                                                                          .toUpperCase());
                                                            }
                                                          },
                                                          onSubmitted: (value) {
                                                            if (value != null) {
                                                              searchController
                                                                  .setPlateMercosulB(
                                                                      value
                                                                          .toUpperCase());
                                                            }
                                                          },
                                                          enabled: true,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Container(
                                                        width: 50,
                                                        child:
                                                            CustomPlateTextField(
                                                          hint: "A",
                                                          height: 70,
                                                          prefix: null,
                                                          textInputType:
                                                              TextInputType
                                                                  .name,
                                                          inputFormatter: <
                                                              TextInputFormatter>[
                                                            FilteringTextInputFormatter(
                                                                RegExp(
                                                                    "[a-zA-Z]"),
                                                                allow: true),
                                                            UpperCaseTextFormatter(),
                                                            LengthLimitingTextInputFormatter(
                                                                1),
                                                          ],
                                                          onChanged: (value) {
                                                            if (value != null) {
                                                              searchController
                                                                  .setPlateMercosulC(
                                                                      value
                                                                          .toUpperCase());
                                                            }
                                                          },
                                                          onSubmitted: (value) {
                                                            if (value != null) {
                                                              searchController
                                                                  .setPlateMercosulC(
                                                                      value
                                                                          .toUpperCase());
                                                            }
                                                          },
                                                          enabled: true,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child:
                                                            CustomPlateTextField(
                                                          hint: "00",
                                                          height: 70,
                                                          prefix: null,
                                                          textInputType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatter: <
                                                              TextInputFormatter>[
                                                            LengthLimitingTextInputFormatter(
                                                                2),
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
                                                            FilteringTextInputFormatter
                                                                .singleLineFormatter,
                                                          ],
                                                          onChanged: (value) {
                                                            searchController
                                                                .setPlateMercosulD(
                                                                    value);
                                                          },
                                                          onSubmitted: (value) {
                                                            searchController
                                                                .setPlateMercosulD(
                                                                    value);
                                                          },
                                                          enabled: true,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                :
                                                //IS NOT MERCOSUL
                                                Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            CustomPlateTextField(
                                                          hint: "ABC",
                                                          height: 70,
                                                          prefix: null,
                                                          textInputType:
                                                              TextInputType
                                                                  .name,
                                                          inputFormatter: <
                                                              TextInputFormatter>[
                                                            FilteringTextInputFormatter(
                                                                RegExp(
                                                                    "[a-zA-Z]"),
                                                                allow: true),
                                                            UpperCaseTextFormatter(),
                                                            LengthLimitingTextInputFormatter(
                                                                3),
                                                          ],
                                                          onChanged: (value) {
                                                            print(value);
                                                            if (value != null) {
                                                              searchController
                                                                  .setPlateA(value
                                                                      .toUpperCase());
                                                            }
                                                          },
                                                          onSubmitted: (value) {
                                                            print(value);
                                                            if (value != null) {
                                                              searchController
                                                                  .setPlateA(value
                                                                      .toUpperCase());
                                                            }
                                                          },
                                                          enabled: true,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child:
                                                            CustomPlateTextField(
                                                          hint: "0000",
                                                          height: 70,
                                                          prefix: null,
                                                          textInputType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatter: <
                                                              TextInputFormatter>[
                                                            LengthLimitingTextInputFormatter(
                                                                4),
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
                                                            FilteringTextInputFormatter
                                                                .singleLineFormatter,
                                                          ],
                                                          onChanged: (value) {
                                                            searchController
                                                                .setPlateB(
                                                                    value);
                                                          },
                                                          onSubmitted: (value) {
                                                            searchController
                                                                .setPlateB(
                                                                    value);
                                                          },
                                                          enabled: true,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                            : Container();
                                      }),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      CustomButtonWidget(
                                          text: "Orçamento",
                                          height: 43,
                                          onPressed: () async {
                                            // print(widget.userController.user.city);
                                            // print(widget.userController.user.uf);

                                            if (searchController.isMercosul) {
                                              searchController
                                                      .finalPlateMercosul =
                                                  searchController
                                                          .plateMercosulA +
                                                      searchController
                                                          .plateMercosulB +
                                                      searchController
                                                          .plateMercosulC +
                                                      searchController
                                                          .plateMercosulD;
                                            } else {
                                              searchController.finalPlate =
                                                  searchController.plateA +
                                                      searchController.plateB;
                                            }

                                            print(searchController.finalPlate);
                                            print(searchController
                                                .finalPlateMercosul);


                                             print(widget
                                                  .userController.user.city);
                                              print(widget
                                                  .userController.user.uf);
                                              if (widget.userController.user
                                                      .isColab !=
                                                  null) {
                                                if (!widget.userController.user
                                                        .isColab &&
                                                    !widget.userController.user
                                                        .isColab)
                                                  await searchController.getPriceChanger(
                                                      widget.userController.user
                                                          .city,
                                                      widget.userController.user
                                                          .uf);
                                              }
                                              setNewConsulta();

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ModelView(
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
                          height: 5,
                        ),
                        CustomTextSmall("Seu carro não esta na lista?", 13,
                            decoration: TextDecoration.none),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                            onTap: () {
                              FlutterOpenWhatsapp.sendSingleMessage(
                                  "5547991031014",
                                  "Olá me chamo NOME DO CLIENTE, sou de CIDADE,ESTADO e tenho interesse de agendar os serviço informações sobre a Reprogramação para o veículo (NOME) no valor de (VALOR)");
                              print(('Running on: $_platformVersion\n'));
                            },
                            child: CustomText("Clique aqui", 15,
                                fontStyle: FontStyle.normal,
                                color: Colors.red[400])),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    widget.userController.signOut();
                                    Navigator.pop(context);
                                  },
                                  child: CustomText("SAIR", 18,
                                      align: TextAlign.end)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )

        // CLIENTE NORMAL
        : Scaffold(
            resizeToAvoidBottomPadding: true,
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.black,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Container(
                          height: 100,
                          child: Image.asset('assets/Potenchip.png')),
                    ),
                    SizedBox(height: 25),
                    CustomText('Orçamento', 22),
                    Padding(
                      padding: EdgeInsets.only(left: 35, right: 35, top: 10),
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
                                  CustomText('Caracteristicas do veículo', 18),
                                  SizedBox(
                                    height: 25,
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
                                                fontStyle: FontStyle.normal),
                                            textAlign: TextAlign.center,
                                          ),
                                          SearchableDropdown.single(
                                            readOnly: false,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            items:
                                                searchController.getBrandList(),
                                            value: "",
                                            hint: "Selecione uma Marca",
                                            searchHint: "Selecione uma Marca",
                                            displayClearIcon: false,
                                            onChanged: (String value) async {
                                              if (value != null) {
                                                searchController
                                                    .setBrand(value);
                                                searchController.setModel("");
                                                searchController.success =
                                                    false;
                                              }
                                              setState(() {
                                                success = false;
                                              });
                                              await delayed();
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
                                  searchController.brand != ""
                                      ? success
                                          ? StreamBuilder<dynamic>(
                                              stream: FirebaseFirestore.instance
                                                  .collection("Cars")
                                                  .where("brand",
                                                      isEqualTo:
                                                          searchController.brand
                                                              .toUpperCase())
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  snapshot) {
                                                if (snapshot.hasData) {
                                                  searchController
                                                      .getModelsFromSnapshot(
                                                          snapshot.data.docs);
                                                  return SearchableDropdown
                                                      .single(
                                                    readOnly: false,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    items:
                                                        convertToMenuItemModels(
                                                            snapshot.data.docs),
                                                    value: "",
                                                    hint: "Selecione um Modelo",
                                                    searchHint:
                                                        "Selecione um Modelo",
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
                                                    isCaseSensitiveSearch:
                                                        false,
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              },
                                            )
                                          : Container(
                                              height: 50,
                                              width: 50,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()))
                                      : Container(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Observer(builder: (_) {
                                    return searchController.model != ""
                                        ? Row(
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                child: Text(
                                                  "Mercosul",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              )),
                                              Container(
                                                height: 45,
                                                width: 80,
                                                child: Center(
                                                  child: Switch(
                                                    value: searchController
                                                        .isMercosul,
                                                    onChanged: (value) {
                                                      searchController
                                                          .setMercosul(value);
                                                      searchController
                                                          .finalPlate = "";
                                                      searchController
                                                          .finalPlateMercosul = "";

                                                      searchController
                                                          .setPlateB("");
                                                      searchController
                                                          .setPlateA("");
                                                      searchController
                                                          .setPlateMercosulA(
                                                              "");
                                                      searchController
                                                          .setPlateMercosulB(
                                                              "");
                                                      searchController
                                                          .setPlateMercosulC(
                                                              "");
                                                      searchController
                                                          .setPlateMercosulD(
                                                              "");

                                                      setState(() {});
                                                    },
                                                    activeTrackColor:
                                                        Colors.lightGreenAccent,
                                                    activeColor: Colors.green,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container();
                                  }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Observer(builder: (_) {
                                    return searchController.model != ""
                                        ? searchController.isMercosul
                                            ?
                                            //IS MERCOSUL
                                            //32387
                                            //cc 264784
                                            //cnpj 76321074/0001-91
                                            Row(
                                                children: [
                                                  Expanded(
                                                    child:
                                                        CustomPlateMercosulTextField(
                                                      hint: "ABC",
                                                      height: 70,
                                                      prefix: null,
                                                      textInputType:
                                                          TextInputType.name,
                                                      inputFormatter: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter(
                                                            RegExp("[a-zA-Z]"),
                                                            allow: true),
                                                        UpperCaseTextFormatter(),
                                                        LengthLimitingTextInputFormatter(
                                                            3),
                                                      ],
                                                      onChanged: (value) {
                                                        print(value);
                                                        if (value != null) {
                                                          searchController
                                                              .setPlateMercosulA(
                                                                  value
                                                                      .toUpperCase());
                                                        }
                                                        setState(() {});
                                                      },
                                                      onSubmitted: (value) {
                                                        if (value != null) {
                                                          searchController
                                                              .setPlateMercosulA(
                                                                  value
                                                                      .toUpperCase());
                                                        }
                                                        setState(() {});
                                                      },
                                                      enabled: true,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    width: 50,
                                                    child:
                                                        CustomPlateMercosulTextField(
                                                      hint: "0",
                                                      height: 70,
                                                      prefix: null,
                                                      textInputType:
                                                          TextInputType.number,
                                                      inputFormatter: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        UpperCaseTextFormatter(),
                                                        LengthLimitingTextInputFormatter(
                                                            1),
                                                      ],
                                                      onChanged: (value) {
                                                        if (value != null) {
                                                          searchController
                                                              .setPlateMercosulB(
                                                                  value
                                                                      .toUpperCase());
                                                        }
                                                        setState(() {});
                                                      },
                                                      onSubmitted: (value) {
                                                        if (value != null) {
                                                          searchController
                                                              .setPlateMercosulB(
                                                                  value
                                                                      .toUpperCase());
                                                        }
                                                        setState(() {});
                                                      },
                                                      enabled: true,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    width: 50,
                                                    child:
                                                        CustomPlateMercosulTextField(
                                                      hint: "A",
                                                      height: 70,
                                                      prefix: null,
                                                      textInputType:
                                                          TextInputType.name,
                                                      inputFormatter: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter(
                                                            RegExp("[a-zA-Z]"),
                                                            allow: true),
                                                        UpperCaseTextFormatter(),
                                                        LengthLimitingTextInputFormatter(
                                                            1),
                                                      ],
                                                      onChanged: (value) {
                                                        if (value != null) {
                                                          searchController
                                                              .setPlateMercosulC(
                                                                  value
                                                                      .toUpperCase());
                                                        }
                                                        setState(() {});
                                                      },
                                                      onSubmitted: (value) {
                                                        if (value != null) {
                                                          searchController
                                                              .setPlateMercosulC(
                                                                  value
                                                                      .toUpperCase());
                                                        }
                                                        setState(() {});
                                                      },
                                                      enabled: true,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child:
                                                        CustomPlateMercosulTextField(
                                                      hint: "00",
                                                      height: 70,
                                                      prefix: null,
                                                      textInputType:
                                                          TextInputType.number,
                                                      inputFormatter: <
                                                          TextInputFormatter>[
                                                        LengthLimitingTextInputFormatter(
                                                            2),
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        FilteringTextInputFormatter
                                                            .singleLineFormatter,
                                                      ],
                                                      onChanged: (value) {
                                                        searchController
                                                            .setPlateMercosulD(
                                                                value);
                                                        setState(() {});
                                                      },
                                                      onSubmitted: (value) {
                                                        searchController
                                                            .setPlateMercosulD(
                                                                value);
                                                        setState(() {});
                                                      },
                                                      enabled: true,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            :
                                            //IS NOT MERCOSUL
                                            Row(
                                                children: [
                                                  Expanded(
                                                    child: CustomPlateTextField(
                                                      hint: "ABC",
                                                      height: 70,
                                                      prefix: null,
                                                      textInputType:
                                                          TextInputType.name,
                                                      inputFormatter: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter(
                                                            RegExp("[a-zA-Z]"),
                                                            allow: true),
                                                        UpperCaseTextFormatter(),
                                                        LengthLimitingTextInputFormatter(
                                                            3),
                                                      ],
                                                      onChanged: (value) {
                                                        //plateA.text = value;

                                                        print(value);
                                                        if (value != null) {
                                                          searchController
                                                              .setPlateA(value
                                                                  .toUpperCase());
                                                        }
                                                        setState(() {});
                                                      },
                                                      onSubmitted: (value) {
                                                        print(value);
                                                        if (value != null) {
                                                          searchController
                                                              .setPlateA(value
                                                                  .toUpperCase());
                                                        }
                                                        setState(() {});
                                                      },
                                                      enabled: true,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: CustomPlateTextField(
                                                      hint: "0000",
                                                      height: 70,
                                                      prefix: null,
                                                      textInputType:
                                                          TextInputType.number,
                                                      inputFormatter: <
                                                          TextInputFormatter>[
                                                        LengthLimitingTextInputFormatter(
                                                            4),
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        FilteringTextInputFormatter
                                                            .singleLineFormatter,
                                                      ],
                                                      onChanged: (value) {
                                                        searchController
                                                            .setPlateB(value);
                                                        setState(() {});
                                                      },
                                                      onSubmitted: (value) {
                                                        searchController
                                                            .setPlateB(value);
                                                        setState(() {});
                                                      },
                                                      enabled: true,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              )
                                        : Container();
                                  }),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    child: (searchController.plateMercosulA !=
                                                    "" &&
                                                searchController
                                                        .plateMercosulB !=
                                                    "" &&
                                                searchController
                                                        .plateMercosulC !=
                                                    "" &&
                                                searchController
                                                        .plateMercosulD !=
                                                    "") ||
                                            (searchController.plateA != "" &&
                                                searchController.plateB != "")
                                        ? CustomButtonWidget(
                                            text: "Orçamento",
                                            height: 43,
                                            onPressed: () async {
                                              print(widget
                                                  .userController.user.city);
                                              print(widget
                                                  .userController.user.uf);
                                              if (widget.userController.user
                                                      .isColab !=
                                                  null) {
                                                if (!widget.userController.user
                                                        .isColab &&
                                                    !widget.userController.user
                                                        .isColab)
                                                  await searchController.getPriceChanger(
                                                      widget.userController.user
                                                          .city,
                                                      widget.userController.user
                                                          .uf);
                                              }
                                              setNewConsulta();

                                              if (searchController
                                                      .selectedCar !=
                                                  null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ModelView(
                                                            userController: widget
                                                                .userController,
                                                            vehicle:
                                                                searchController
                                                                    .selectedCar,
                                                          )),
                                                );
                                              }
                                            },
                                            context: context)
                                        : Container(),
                                  ),
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
                      height: 5,
                    ),
                    CustomTextSmall("Seu carro não esta na lista?", 13,
                        decoration: TextDecoration.none),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                        onTap: () {
                          FlutterOpenWhatsapp.sendSingleMessage("5547991031014",
                              "Olá me chamo NOME DO CLIENTE, sou de CIDADE,ESTADO e tenho interesse de agendar os serviço informações sobre a Reprogramação para o veículo (NOME) no valor de (VALOR)");
                          print(('Running on: $_platformVersion\n'));
                        },
                        child: CustomText("Clique aqui", 15,
                            fontStyle: FontStyle.normal,
                            color: Colors.red[400])),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                              onTap: () {
                                widget.userController.signOut();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginView(
                                            userController:
                                                widget.userController,
                                          )),
                                );
                              },
                              child:
                                  CustomText("SAIR", 18, align: TextAlign.end)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
