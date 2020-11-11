import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:potenchip/controllers/plate_controller.dart';
import 'package:potenchip/controllers/user_controller.dart';
import 'package:potenchip/controllers/users_admin_controller.dart';
import 'package:potenchip/shared/text.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:fialogs/fialogs.dart';

class UsersView extends StatefulWidget {
  final UserController userController;

  const UsersView({Key key, this.userController}) : super(key: key);
  @override
  _UsersViewState createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  PlateController plateController = PlateController();
  UserAdminController userAdminController = UserAdminController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:       CustomText("Usuários Cadastrados", 18,),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: 15,
              ),
        
              StreamBuilder<dynamic>(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      //plateController.getModelsFromSnapshot(snapshot.data.docs);
                      userAdminController
                          .getUsersFromSnapshot(snapshot.data.docs);

                      print(snapshot.data.docs[0]["name"]);
                      print(userAdminController.usersList.length);

                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: userAdminController.usersList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      CustomText(
                                          "${userAdminController.usersList[index].name}",
                                          18),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      CustomText(
                                          "${userAdminController.usersList[index].email}",
                                          18),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      userAdminController
                                                  .usersList[index].city !=
                                              ""
                                          ? Container(
                                              child: CustomText(
                                                  "${userAdminController.usersList[index].city}, ${userAdminController.usersList[index].uf} ",
                                                  18))
                                          : Container(),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      userAdminController
                                                  .usersList[index].phone !=
                                              ""
                                          ? Container(
                                              child: CustomText(
                                                  "${userAdminController.usersList[index].phone}",
                                                  18))
                                          : Container(),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Column(
                                            children: [
                                              CustomText("Administrador", 18),
                                              Switch(
                                                  value: userAdminController
                                                      .usersList[index].isAdmin,
                                                  onChanged: (value) async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("Users")
                                                        .doc(userAdminController
                                                            .usersList[index]
                                                            .id)
                                                        .update(
                                                            {"isAdmin": value});
                                                  }),
                                            ],
                                          ),
                                          Expanded(
                                            child: Container(),
                                          ),
                                          Column(
                                            children: [
                                              CustomText("Colaborador", 18),
                                              Switch(
                                                  value: userAdminController
                                                      .usersList[index].isColab,
                                                  onChanged: (value) async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("Users")
                                                        .doc(userAdminController
                                                            .usersList[index]
                                                            .id)
                                                        .update(
                                                            {"isColab": value});
                                                  })
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      userAdminController
                                                            .usersList[index]
                                                            .isColab?
                                      Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  child: CustomText(
                                                      "Variador de preço", 18)),
                                              Expanded(
                                                child: Container(),
                                              ),
                                              Container(
                                                  child: CustomText(
                                                      "${userAdminController.usersList[index].priceChange}",
                                                      18)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: Colors.red[500],
                                                ),
                                                onPressed: () async {
                                                  singleInputDialog(
                                                    context,
                                                    "Adicionar Variador de Preço",
                                                    DialogTextField(
                                                        textAlign: TextAlign.center,
                                                        obscureText: false,
                                                        textInputType:
                                                            TextInputType.text,
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
                                                      userAdminController
                                                          .usersList[index]
                                                          .priceChange = double.parse(value.trim());
                                                          
                                                      print(userAdminController
                                                          .usersList[index]
                                                          .priceChange);
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("Users")
                                                          .doc(userAdminController
                                                              .usersList[index].id)
                                                          .update(
                                                              userAdminController
                                                                  .usersList[index]
                                                                  .toDocument());
                                                    },
                                                    hideNeutralButton: false,
                                                    closeOnBackPress: true,
                                                  );

                                             
                                                },
                                              )
                                            ],
                                          ),
                                          ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: userAdminController
                                            .usersList[index]
                                            .workingCities
                                            .length,
                                        itemBuilder: (context, index2) {
                                          return Container(
                                            child: Row(
                                              children: [
                                                CustomText(
                                                    userAdminController
                                                        .usersList[index]
                                                        .workingCities[index2],
                                                    15),
                                                Expanded(
                                                  child: Container(),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red[500],
                                                  ),
                                                  onPressed: () async {
                                                    userAdminController
                                                        .usersList[index]
                                                        .workingCities
                                                        .remove(
                                                            userAdminController
                                                                    .usersList[
                                                                        index]
                                                                    .workingCities[
                                                                index2]);
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("Users")
                                                        .doc(userAdminController
                                                            .usersList[index]
                                                            .id)
                                                        .update(
                                                            userAdminController
                                                                .usersList[
                                                                    index]
                                                                .toDocument());
                                                    setState(() {});
                                                  },
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          singleInputDialog(
                                            context,
                                            "Adicionar Cidade",
                                            DialogTextField(
                                                textAlign: TextAlign.center,
                                                obscureText: false,
                                                textInputType:
                                                    TextInputType.text,
                                                validator: (value) {
                                                  if (value.isEmpty)
                                                    return "Required!";
                                                  return null;
                                                },
                                                onEditingComplete:
                                                    (value) async {
                                                  print(value);
                                                }),
                                            positiveButtonText: "Adicionar",
                                            positiveButtonAction:
                                                (value) async {
                                              print(value);
                                              userAdminController
                                                  .usersList[index]
                                                  .workingCities
                                                  .add(value.toString().trim());
                                              print(userAdminController
                                                  .usersList[index]
                                                  .workingCities);
                                              await FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .doc(userAdminController
                                                      .usersList[index].id)
                                                  .update(userAdminController
                                                      .usersList[index]
                                                      .toDocument());
                                            },
                                            hideNeutralButton: false,
                                            closeOnBackPress: true,
                                          );
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Center(
                                          child: CustomText(
                                              "+ Adicionar Cidades", 16),
                                        ),
                                      )
                                        ],
                                      ):Container(),
                                      
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
        ));
  }
}
