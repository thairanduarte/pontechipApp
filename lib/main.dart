import 'package:flutter/material.dart';
import 'package:potenchip/controllers/user_controller.dart';
import 'package:potenchip/screens/admin_view.dart';
import 'package:potenchip/screens/login_view.dart';
import 'package:potenchip/screens/searchmodel_view.dart';
import 'package:potenchip/screens/loading_view.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Potenchip',
        theme: ThemeData.dark(),
        home: FutureBuilder(
            // Initialize FlutterFire:
            future: _initialization,
            builder: (context, snapshot){
              // Check for errors
              if (snapshot.hasError) {
                return Container(
                  child: Center(
                    child: Text("Something wrong"),
                  ),
                );
              }

              // Once complete, show your application
              if (snapshot.connectionState == ConnectionState.done) {
                UserController userController = UserController();

                return FutureBuilder(
                    future: userController.loadCurrentUserVoid(),
                    builder: (context, snapshot2) {
                      if (!snapshot2.hasError) {
                        if (snapshot2.connectionState == ConnectionState.done) {
                          if (userController.user.name != null)  {
                            print("user nao nulo");
                           print(userController.user.isAdmin);
                            if (userController.user.isAdmin) {
                              
                              return AdminView(userController: userController);
                            } else {
                              if (userController.user.isColab) {
                                return SearchModelView(
                                    userController: userController);
                              } else {
                                return SearchModelView(
                                    userController: userController);
                              }
                            }
                          } else {
                            print("user nulo");
                            return LoginView(userController: userController,connection: true,);
                          }
                        } else {
                          return LoginView(userController: userController,connection: false,);
                        }
                      } else {

                        return LoginView(userController: userController,connection: false,);
                      }
                    });

                //return AdminView(userController: userController);
              }

              // Otherwise, show something whilst waiting for initialization to complete
              return LoadingView();
            },
          ),
        );
  }
}

// QUANDO O CLIENTE FAZER A CONSULTA ELE GERA UM DOCUMENT NA COLLECTION CONSULTAS, A CONSULTA VAI TER UMA CLASSE
// COM DADOS DO CLIENTE, DADOS DA CONSULTA,
// QUANDO FOR BUSCAR AS CONSULTA, VERIFICAR POR PLACA,

// CADA USUARIO VAI TER UM IS ADMIN, IS COLAB PRA SEPARAR ADMINISTRADOR DE COLABORADOR E CLIENTE
// CADA USUARIO VAI TER UM COLAB DE PREÇO POR REGIAO E O USUARIO VAI TER O PREÇO DO COLAB DA REGIAO

// import 'dart:math' show cos, sqrt, asin;

// void main() {
// double calculateDistance(lat1, lon1, lat2, lon2){
// var p = 0.017453292519943295;
// var c = cos;
// var a = 0.5 - c((lat2 - lat1) * p)/2 +
// c(lat1 * p) * c(lat2 * p) *
// (1 - c((lon2 - lon1) * p))/2;
// return 12742 * asin(sqrt(a));
// }

// double totalDistance = calculateDistance(26.196435, 78.197535,26.197195, 78.196408);

// print(totalDistance);
// }
// FORMULA PRA CALCULAR DISTANCIAS E VER O MAIS PERTO

// COEF TB DE DISTANCIA QUE É ACEITA PRA NÃO DIRECIONAR O CONTATO DA MATRIZ
//POR LISTA DE CIDADES OS DEALERS
