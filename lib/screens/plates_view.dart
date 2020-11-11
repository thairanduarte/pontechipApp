import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:potenchip/controllers/plate_controller.dart';
import 'package:potenchip/controllers/user_controller.dart';
import 'package:potenchip/shared/text.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class PlatesView extends StatefulWidget {
  final UserController userController;

  const PlatesView({Key key, this.userController}) : super(key: key);
  @override
  _PlatesViewState createState() => _PlatesViewState();
}

class _PlatesViewState extends State<PlatesView> {
  PlateController plateController = PlateController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 40,
              ),
              CustomText('Selecione a placa do veículo\n se existente', 22),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Placa",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontStyle: FontStyle.normal),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              StreamBuilder<dynamic>(
                stream: FirebaseFirestore.instance
                    .collection("Consultas")
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    plateController.getModelsFromSnapshot(snapshot.data.docs);

                    return SearchableDropdown.single(
                      readOnly: false,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      items: convertToMenuItem(plateController.plate_list),
                      value: "",
                      hint: "Selecione uma placa",
                      searchHint: "Selecione uma placa",
                      displayClearIcon: false,
                      onChanged: (value) {
                        plateController.setSelectedPlate(value);
                        setState(() {});
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
              ),
              SizedBox(
                height: 15,
              ),
              plateController.selected_plate != null
                  ? Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          height: 90,
                          child: Column(
                            children: [
                              CustomText(
                                  'PLACA ${plateController.selected_plate.toUpperCase()}',
                                  22),
                              CustomText('Consultas Realizadas:', 22),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: plateController.documents_list.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (plateController
                                        .documents_list[index].plate ==
                                    plateController.selected_plate) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                          color: plateController
                                                  .documents_list[index]
                                                  .user
                                                  .isColab
                                              ? Colors.red[500]
                                              : Colors.green[500]),
                                      height: 100,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CustomText(
                                                '${plateController.documents_list[index].plate}',
                                                16),
                                            CustomText(
                                                '${plateController.documents_list[index].date}',
                                                16),
                                            CustomText(
                                                '${plateController.documents_list[index].user.name}',
                                                16),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ),
                      ],
                    )
                  : CustomText('Selecione uma placa', 16),
            ],
          ),
        ));
  }
}
