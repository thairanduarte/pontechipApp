import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:potenchip/controllers/edit_model_controller.dart';
import 'package:potenchip/controllers/user_controller.dart';
import 'package:potenchip/models/vehicle_model.dart';
import 'package:potenchip/shared/custombutton.dart';
import 'package:potenchip/shared/customtextfield.dart';
import 'package:potenchip/shared/text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'dart:async';

class EditModelView extends StatefulWidget {
  final UserController userController;
  final VehicleModel vehicle;

  EditModelView({Key key, this.userController, this.vehicle}) : super(key: key);

  @override
  _EditModelViewState createState() => _EditModelViewState();
}

class _EditModelViewState extends State<EditModelView> {
  final Email email = Email(
    body: 'MensagemEnviada',
    subject: 'Teste',
    recipients: ['thairanld@hotmail.com'],
    cc: ['thairanld@hotmail.com'],
    bcc: ['thairanld@icloud.com'],
    //attachmentPaths: ['/path/to/attachment.zip'],
    isHTML: false,
  );

  String _platformVersion = 'Unknown';
  String carName = "";
  String stockPower = "";
  String stockTorque = "";

  String remapPower = "";
  String remapTorque = "";
  String remapValue = "";
  String remapTotalValue = "";
  bool isLoading = false;
  @override
  void initState() {
    carName = widget.vehicle.name;
    stockPower = widget.vehicle.default_power;
    stockTorque = widget.vehicle.default_torque;
    remapPower = widget.vehicle.increase_power;
    remapTorque = widget.vehicle.increase_torque;
    remapValue = widget.vehicle.final_price;
    remapTotalValue = widget.vehicle.total_price;
    super.initState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterOpenWhatsapp.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  EditModelController editController = EditModelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Center(
            child: Text(
          "Editar Veículo",
          textAlign: TextAlign.center,
        )),
        actions: [
          // isLoading?
          // Observer(builder: (_) {
          //   return Container(
          //     height: 45,
          //     width: 80,
          //     child: Center(
          //       child: Switch(
          //         value: editController.isEditing,
          //         onChanged: (value) {
          //           editController.setEditing(value);
          //         },
          //         activeTrackColor: Colors.lightGreenAccent,
          //         activeColor: Colors.green,
          //       ),
          //     ),
          //   );
          // }):Container(),
        ],
        automaticallyImplyLeading: isLoading? false:true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  height: 175,
                  padding: EdgeInsets.all(12),
              child:
               Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText('$carName\nPotencia OEM', 20,
                            fontStyle: FontStyle.normal),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          CustomText(
                                              "${widget.vehicle.default_power} cv",
                                              18),
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () async {
                                              singleInputDialog(
                                                context,
                                                "Adicionar potencia nominal",
                                                DialogTextField(
                                                    textAlign: TextAlign.center,
                                                    obscureText: false,
                                                    textInputType:
                                                        TextInputType.number,
                                                    validator: (value) {
                                                      if (value.isEmpty)
                                                        return "Required!";
                                                      return null;
                                                    },
                                                    onEditingComplete:
                                                        (value) async {
                                                      print(value);
                                                    }),
                                                positiveButtonText: "Alterar",
                                                positiveButtonAction:
                                                    (value) async {
                                                  print(value);
                                                  widget.vehicle.default_power =
                                                      value.toString().trim();
                                                  print(widget.vehicle
                                                      .toDocument());
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Cars")
                                                      .doc(widget.vehicle.carId)
                                                      .update(widget.vehicle
                                                          .toDocument());

                                                  setState(() {
                                                    isLoading = true;
                                                  });

                                                  await Future.delayed(
                                                      Duration(seconds: 2));

                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                },
                                                hideNeutralButton: false,
                                                closeOnBackPress: true,
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Expanded(child: Container()),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          CustomText("${widget.vehicle.default_torque} Kgfm", 18),
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () async {
                                              singleInputDialog(
                                                context,
                                                "Adicionar torque nominal",
                                                DialogTextField(
                                                    textAlign: TextAlign.center,
                                                    obscureText: false,
                                                    textInputType:
                                                        TextInputType.number,
                                                    validator: (value) {
                                                      if (value.isEmpty)
                                                        return "Required!";
                                                      return null;
                                                    },
                                                    onEditingComplete:
                                                        (value) async {
                                                      print(value);
                                                    }),
                                                positiveButtonText: "Alterar",
                                                positiveButtonAction:
                                                    (value) async {
                                                  print(value);
                                                  widget.vehicle.default_torque =
                                                      value.toString().trim();
                                                  print(widget.vehicle
                                                      .toDocument());
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Cars")
                                                      .doc(widget.vehicle.carId)
                                                      .update(widget.vehicle
                                                          .toDocument());

                                                  setState(() {
                                                    isLoading = true;
                                                  });

                                                  await Future.delayed(
                                                      Duration(seconds: 2));

                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                },
                                                hideNeutralButton: false,
                                                closeOnBackPress: true,
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            
                        SizedBox(
                          height: 12,
                        ),
                      ],
                    )),
              SizedBox(
                height: 20,
              ),
              Observer(builder: (_) {
                return Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    height: 500,
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText("REPROGRAMAÇÃO", 22),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CustomText('Potencia', 18,
                                            fontStyle: FontStyle.normal),
                                      ),
                                     Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  CustomText(
                                                      " ${widget.vehicle.increase_power} cv", 18),
                                                  IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () async {
                                              singleInputDialog(
                                                context,
                                                "Diferença de potencia após reprogramação",
                                                DialogTextField(
                                                    textAlign: TextAlign.center,
                                                    obscureText: false,
                                                    textInputType:
                                                        TextInputType.number,
                                                    validator: (value) {
                                                      if (value.isEmpty)
                                                        return "Required!";
                                                      return null;
                                                    },
                                                    onEditingComplete:
                                                        (value) async {
                                                      print(value);
                                                    }),
                                                positiveButtonText: "Alterar",
                                                positiveButtonAction:
                                                    (value) async {
                                                  print(value);
                                                  widget.vehicle.increase_power =
                                                      value.toString().trim();
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Cars")
                                                      .doc(widget.vehicle.carId)
                                                      .update(widget.vehicle
                                                          .toDocument());

                                                  setState(() {
                                                    isLoading = true;
                                                  });

                                                  await Future.delayed(
                                                      Duration(seconds: 2));

                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                },
                                                hideNeutralButton: false,
                                                closeOnBackPress: true,
                                              );
                                            },
                                          )
                                                ],
                                              ),
                                            ),
                                    
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CustomText('Torque', 19,
                                            fontStyle: FontStyle.normal),
                                      ),
                                      Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  CustomText(
                                                      " ${widget.vehicle.increase_torque} Kgfm", 18),

                                                  IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () async {
                                              singleInputDialog(
                                                context,
                                                "Diferença de torque após reprogramação",
                                                DialogTextField(
                                                    textAlign: TextAlign.center,
                                                    obscureText: false,
                                                    textInputType:
                                                        TextInputType.number,
                                                    validator: (value) {
                                                      if (value.isEmpty)
                                                        return "Required!";
                                                      return null;
                                                    },
                                                    onEditingComplete:
                                                        (value) async {
                                                      print(value);
                                                    }),
                                                positiveButtonText: "Alterar",
                                                positiveButtonAction:
                                                    (value) async {
                                                  print(value);
                                                  widget.vehicle.increase_torque =
                                                      value.toString().trim();
                                          
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Cars")
                                                      .doc(widget.vehicle.carId)
                                                      .update(widget.vehicle
                                                          .toDocument());

                                                  setState(() {
                                                    isLoading = true;
                                                  });

                                                  await Future.delayed(
                                                      Duration(seconds: 2));

                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                },
                                                hideNeutralButton: false,
                                                closeOnBackPress: true,
                                              );
                                            },
                                          )
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CustomText('Valor', 19,
                                            fontStyle: FontStyle.normal),
                                      ),
                                     Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  CustomText(
                                                      " R\$: ${widget.vehicle.final_price.toString()}",
                                                      18),
                                                  IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () async {
                                              singleInputDialog(
                                                context,
                                                "Alterar Valor Final",
                                                DialogTextField(
                                                    textAlign: TextAlign.center,
                                                    obscureText: false,
                                                    textInputType:
                                                        TextInputType.number,
                                                    validator: (value) {
                                                      if (value.isEmpty)
                                                        return "Required!";
                                                      return null;
                                                    },
                                                    onEditingComplete:
                                                        (value) async {
                                                      print(value);
                                                    }),
                                                positiveButtonText: "Alterar",
                                                positiveButtonAction:
                                                    (value) async {
                                                  print(value);
                                                  widget.vehicle.final_price =
                                                      value.toString().trim().replaceAll(".","");
                                            
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Cars")
                                                      .doc(widget.vehicle.carId)
                                                      .update(widget.vehicle
                                                          .toDocument());

                                                  setState(() {
                                                    isLoading = true;
                                                  });

                                                  await Future.delayed(
                                                      Duration(seconds: 2));

                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                },
                                                hideNeutralButton: false,
                                                closeOnBackPress: true,
                                              );
                                            },
                                          )
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CustomText('Valor 12x', 19,
                                            fontStyle: FontStyle.normal),
                                      ),
                                      Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CustomText(
                                                  " R\$: ${(double.parse(widget.vehicle.final_price.toString())/10).toString()}", 18),
                                            ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  editController.isEditing
                                      ? isLoading
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                child:
                                                    CircularProgressIndicator(
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
                                                    //widget.vehicle.tunning_power = (int.parse(widget.vehicle.default_power.toString()) + int.parse(widget.vehicle.increase_power.toString())).toString();
                                                    //widget.vehicle.tunning_power = (int.parse(widget.vehicle.default_torque.toString()) + int.parse(widget.vehicle.increase_torque.toString())).toString();
                                                    print(widget.vehicle
                                                        .toDocument());
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("Cars")
                                                        .doc(widget
                                                            .vehicle.carId)
                                                        .update(widget.vehicle
                                                            .toDocument());

                                                    setState(() {
                                                      isLoading = true;
                                                    });

                                                    await Future.delayed(
                                                        Duration(seconds: 2));

                                                    setState(() {
                                                      isLoading = false;
                                                    });

                                                    Navigator.pop(context);
                                                  },
                                                  width: 150,
                                                  context: context),
                                            )
                                      : Container(
                                          padding: EdgeInsets.all(5),
                                          child: CustomButtonWidgetSave(
                                              text: "Remover",
                                              height: 43,
                                              onPressed: () async {
                                                //widget.vehicle.tunning_power = (int.parse(widget.vehicle.default_power.toString()) + int.parse(widget.vehicle.increase_power.toString())).toString();
                                                //widget.vehicle.tunning_power = (int.parse(widget.vehicle.default_torque.toString()) + int.parse(widget.vehicle.increase_torque.toString())).toString();
                                                print(widget.vehicle
                                                    .toDocument());
                                                await FirebaseFirestore.instance
                                                    .collection("Cars")
                                                    .doc(widget.vehicle.carId)
                                                    .delete();

                                                setState(() {
                                                  isLoading = true;
                                                });

                                                await Future.delayed(
                                                    Duration(seconds: 2));

                                                setState(() {
                                                  isLoading = false;
                                                });

                                                Navigator.pop(context);
                                              },
                                              width: 150,
                                              context: context),
                                        )
                                ]),
                          ],
                        ),
                      ],
                    ));
              })
            ],
          ),
        ),
      ),
    );
  }
}
