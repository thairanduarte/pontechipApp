import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:potenchip/controllers/user_controller.dart';
import 'package:potenchip/models/vehicle_model.dart';
import 'package:potenchip/shared/custombutton.dart';
import 'package:potenchip/shared/text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'dart:async';

class ModelViewAdmin extends StatefulWidget {
  final UserController userController;
  final VehicleModel vehicle;

  ModelViewAdmin({Key key, this.userController, this.vehicle}) : super(key: key);

  @override
  _ModelViewAdminState createState() => _ModelViewAdminState();
}

class _ModelViewAdminState extends State<ModelViewAdmin> {


  String _platformVersion = 'Unknown';
  String carName = "";
  String stockPower = "";
  String stockTorque = "";

  String remapPower = "";
  String remapTorque = "";
  String remapValue = "";
  String remapTotalValue = "";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          ),
      body: Center(
        heightFactor: 1,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
                    height: 150,
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText('$carName', 20, fontStyle: FontStyle.normal),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            CustomText('Potencia Original', 18,
                                fontStyle: FontStyle.normal),
                            Expanded(child: Container()),
                            CustomText("${stockPower}cv  ", 18),
                            CustomText("/  ${stockTorque}Kgfm", 18),
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
                Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    height: 320
                    ,
                    padding: EdgeInsets.all(12),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText("REPROGRAMAÇÃO", 22),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          CustomText('Potencia', 19,
                                              fontStyle: FontStyle.normal),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5,
                                          ),
                                          CustomText('~+${remapPower}cv', 18,
                                              fontStyle: FontStyle.normal),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          CustomText('Torque', 19,
                                              fontStyle: FontStyle.normal),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5,
                                          ),
                                          CustomText('~+${remapTorque}cv', 18,
                                              fontStyle: FontStyle.normal),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          CustomText('Investimento', 19,
                                              fontStyle: FontStyle.normal),
                                          SizedBox(width: 50),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  CustomText('Avista ', 18,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  widget.vehicle.priceChange !=
                                                          null
                                                      ? widget.vehicle
                                                                  .priceChange !=
                                                              0
                                                          ? CustomText(
                                                              'R\$:${(double.parse(remapValue) * widget.vehicle.priceChange).toString()}',
                                                              18,
                                                              fontStyle: FontStyle
                                                                  .normal)
                                                          : CustomText(
                                                              'R\$:${remapValue.toString()}',
                                                              18,
                                                              fontStyle: FontStyle
                                                                  .normal)
                                                      : CustomText(
                                                          'R\$:${remapValue.toString()}',
                                                          18,
                                                          fontStyle:
                                                              FontStyle.normal)
                                                ],
                                              ),
                                              CustomText('ou ', 18,
                                                  fontStyle: FontStyle.normal),
                                              Row(
                                                children: [
                                                  CustomText('12x ', 18,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  widget.vehicle.priceChange !=
                                                          null
                                                      ? widget.vehicle
                                                                  .priceChange !=
                                                              0
                                                          ? CustomText(
                                                              'R\$:${((((double.parse(remapValue) * widget.vehicle.priceChange)) / 10)).toString()}',
                                                              18,
                                                              fontStyle: FontStyle
                                                                  .normal)
                                                          : CustomText(
                                                              'R\$:${(double.parse(remapValue) / 10).toString().split(".")[0]}',
                                                              18,
                                                              fontStyle: FontStyle
                                                                  .normal)
                                                      : CustomText(
                                                          'R\$:${(double.parse(remapValue) / 10).toString().split(".")[0]}',
                                                          18,
                                                          fontStyle:
                                                              FontStyle.normal),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      //CustomText("+ ~${remapPower} cv", 18),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      //CustomText("+ ~${remapTorque} Kgfm", 18),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //CustomText("À vista R\$ ${remapValue}", 18)
                                    ]),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              //CustomText("Ou Avista", 18),
                              //Expanded(child: Container()),
                              //CustomText("Ou ${remapValue}", 18),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          
                        ],
                      ),
                    )),
         
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
