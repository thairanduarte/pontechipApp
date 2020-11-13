import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:potenchip/controllers/login_controller.dart';
import 'package:potenchip/controllers/user_controller.dart';
import 'package:potenchip/screens/admin_view.dart';
import 'package:potenchip/screens/searchmodel_view.dart';
import 'package:potenchip/screens/signup_view.dart';
import 'package:potenchip/shared/custombutton.dart';
import 'package:potenchip/shared/customtextfield.dart';
import 'package:potenchip/shared/text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class LoginView extends StatefulWidget {
  final UserController userController;
  final bool connection;
  LoginView({Key key, this.userController, this.connection}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginController loginController = LoginController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Map _pickedLocation;
  var _pickedLocationText;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  Position _currentPosition;
  String _currentAddress;
  // ignore: non_constant_identifier_names
  Position geolocator = Position();
  final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));

  User _currentUser;
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    });
  }

  _getAddressFromLatLng() async {
    LocationPermission permission = await checkPermission();
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[1];
      placemarks.forEach((element) {
        print(element.locality);
      });

      if (place != null) {
        //signUpController.city = place.subAdministrativeArea;
        //signUpController.uf = place.administrativeArea;
      }

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  Future<User> _getUser() async {
    if (_currentUser != null) return _currentUser;
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signOut();
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User user = authResult.user;
      print("achei user");

      return user;
    } catch (error) {
      print("Erro de login");
      User user = null;

      return user;
    }
  }

  void googleSignUp() async {
    setState(() {
      isLoading = true;
    });
    print("cheguei no get user");
    final User user = await _getUser();
    print("passei get user");
    print(user);
    if (user == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Não foi possivel fazer o login, tente novamente"),
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)))));
    }
    widget.userController.signInGoogle(
        result: user,
        onSuccess: () {
          setState(() {
            widget.userController.isLogged = true;
          });

          if (widget.userController.user.name != null) {
            !widget.userController.user.isAdmin
                ? print("entrei admin")
                : print("entrei nao admin");

            !widget.userController.user.isAdmin
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchModelView(
                              userController: widget.userController,
                            )),
                  )
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminView(
                              userController: widget.userController,
                            )),
                  );
          }
        },
        onFail: () {
          print("Falhar");
          //fail
        });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // !widget.userController.user.isAdmin
    //     ? Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => SearchModelView(
    //                   userController: widget.userController,
    //                 )),
    //       )
    //     : Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => AdminView(
    //                   userController: widget.userController,
    //                 )),
    //       );

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      key: scaffoldKey,
      body: Builder(builder: (BuildContext context) {
         
        return 
        
        Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Container(
                      height: 100, child: Image.asset('assets/Potenchip.png')),
                ),
                SizedBox(height: 25),
                CustomText('Entre ou Cadastre-se', 22),
                Padding(
                  padding: EdgeInsets.only(left: 35, right: 35, top: 10),
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(35))),
                      color: Colors.grey[850],
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 15, right: 15, bottom: 12, top: 0),
                          child: Observer(builder: (_) {
                            return ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                SizedBox(height: 10),
                                CustomText('Entrar', 22),
                                SizedBox(
                                  height: 18,
                                ),
                                CustomLoginTextField(
                                  hint: "Email",
                                  textInputType: TextInputType.emailAddress,
                                  inputFormatter: [],
                                  prefix: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  onChanged: (value) {
                                    loginController.setEmail(value);
                                  },
                                  onSubmitted: (value) {
                                    loginController.setPassword(value);
                                  },
                                  enabled: !widget.userController.loading,
                                ),
                                loginController.isEmailValid
                                    ? SizedBox(
                                        height: 10,
                                      )
                                    : Column(
                                        children: [
                                          SizedBox(height: 5),
                                          loginController.email == ""
                                              ? Container(
                                                  height: 2,
                                                  width: 1,
                                                )
                                              : Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        height: 1,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Entre com um e-mail válido",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),

                                CustomLoginTextField(
                                  hint: "Senha",
                                  obscure: true,
                                  inputFormatter: [],
                                  prefix: Icon(Icons.lock, color: Colors.white),
                                  onChanged: (value) {
                                    loginController.setPassword(value);
                                  },
                                  onSubmitted: (value) {
                                    loginController.setPassword(value);
                                  },
                                  enabled: !widget.userController.loading,
                                ),

                                // Text(
                                //   "Entre com uma senha válida",
                                //   style: TextStyle(
                                //       color: Colors.white, fontStyle: FontStyle.italic),
                                //   textAlign: TextAlign.right,
                                // ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          "Esqueci minha senha",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                  ],
                                ),
                                loginController.isEmailValid &&
                                        loginController.isPasswordValid
                                    ? !widget.userController.loading
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                top: 25),
                                            child: Container(
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Colors.red[900],
                                                        Colors.black26
                                                      ],
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(25)),
                                                ),
                                                child: RaisedButton(
                                                  elevation: 3,
                                                  splashColor: Colors.green,
                                                  color: Colors.transparent,
                                                  onPressed: loginController
                                                          .isEmailValid
                                                      ? () {
                                                          widget.userController
                                                              .setUserEmail(
                                                                  loginController
                                                                      .email);
                                                          widget.userController
                                                              .setUserPassword(
                                                                  loginController
                                                                      .password);
                                                          widget.userController
                                                              .signIn(
                                                                  onFail: (e) {
                                                                    print("falha");
                                                            print(e);
                                                            scaffoldKey
                                                                .currentState
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                  "Falha ao entrar: $e"),
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ));
                                                          }, onSuccess: () {
                                                            !widget.userController
                                                                    .user.isAdmin
                                                                ? Navigator
                                                                    .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            SearchModelView(
                                                                              userController: widget.userController,
                                                                            )),
                                                                  )
                                                                : Navigator
                                                                    .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            AdminView(
                                                                              userController: widget.userController,
                                                                            )),
                                                                  );
                                                          });
                                                        }
                                                      : null,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                25)),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Entrar",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                          fontStyle:
                                                              FontStyle.normal),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                )),
                                          )
                                        : Column(
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                backgroundColor: Colors.red,
                                              ))
                                            ],
                                          )
                                    : Container(),
                                if (!widget.userController.loading)
                                  Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              height: 35,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: Center(
                                                  child: Text(
                                                "Ou",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          isLoading
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    child:
                                                        CircularProgressIndicator(
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  ),
                                                )
                                              : IconButton(
                                                  // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                                  icon: FaIcon(
                                                    FontAwesomeIcons.google,
                                                    size: 25,
                                                    color: Colors.red[500],
                                                  ),
                                                  onPressed: () async {
                                                    googleSignUp();
                                                    await Future.delayed(
                                                        Duration(seconds: 2));
                                                  }),
                                        ],
                                      ),
                                    ],
                                  ),
                              ],
                            );
                          })),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                CustomTextSmall("Não possui conta ainda?", 13,
                    decoration: TextDecoration.none),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpView(
                                  userController: widget.userController,
                                )),
                      );
                    },
                    child: CustomText("REGISTRE-SE", 15,
                        fontStyle: FontStyle.normal, color: Colors.red[400]))
              ],
            ),
          ),
        );
      }),
    );
  }
}
