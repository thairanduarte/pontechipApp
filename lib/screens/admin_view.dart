import 'package:flutter/material.dart';
import 'package:potenchip/controllers/user_controller.dart';
import 'package:potenchip/screens/add_vehicle.dart';
import 'package:potenchip/screens/login_view.dart';
import 'package:potenchip/screens/plates_view.dart';
import 'package:potenchip/screens/searchmodel_view.dart';
import 'package:potenchip/screens/searchmodeladmin_view.dart';
import 'package:potenchip/screens/users_view.dart';
import 'package:potenchip/screens/vehicleedit_view.dart';
import 'package:potenchip/shared/text.dart';

class AdminView extends StatefulWidget {
  final UserController userController;

  const AdminView({Key key, this.userController}) : super(key: key);
  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  String userName;
  @override
  void initState() {
    widget.userController.loadCurrentUser();
    userName = widget.userController.user.name; // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              SizedBox(
                height: 30,
              ),
              Container(
                height: 150,
                padding: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                        'Bem Vindo,\n ${widget.userController.user.name}', 28),
                    Expanded(child: Container()),
                    Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Container(
                          height: 100,
                          child: Image.asset('assets/Potenchip.png')),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomText('Menu', 22),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SearchModelViewAdmin(
                                            userController:
                                                widget.userController,
                                          )),
                                );
                              },
                              leading: Icon(
                                Icons.search,
                                size: 35,
                              ),
                              title: CustomText('Orçamento', 20,
                                  align: TextAlign.start),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlatesView(
                                            userController:
                                                widget.userController,
                                          )),
                                );
                              },
                              leading: Icon(
                                Icons.search,
                                size: 35,
                              ),
                              title: CustomText('Consultar Placa', 20,
                                  align: TextAlign.start),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VehicleEditView(
                                            userController:
                                                widget.userController,
                                          )),
                                );
                              },
                              leading: Icon(
                                Icons.car_repair,
                                size: 35,
                              ),
                              title: CustomText('Editar Veículo', 20,
                                  align: TextAlign.start),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VehicleAddView(
                                            userController:
                                                widget.userController,
                                          )),
                                );
                              },
                              leading: Icon(
                                Icons.car_rental,
                                size: 35,
                              ),
                              title: CustomText('Inserir Veículo', 20,
                                  align: TextAlign.start),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UsersView(
                                            userController:
                                                widget.userController,
                                          )),
                                );
                              },
                              leading: Icon(
                                Icons.people,
                                size: 35,
                              ),
                              title: CustomText('Usuários', 20,
                                  align: TextAlign.start),
                            ),
                          ]),
                    )),
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
                                      userController: widget.userController,
                                    )),
                          );
                        },
                        child: CustomText("SAIR", 18, align: TextAlign.end)),
                  ],
                ),
              )
            ])));
  }
}
