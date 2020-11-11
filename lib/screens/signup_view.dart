import 'package:brasil_fields/formatter/telefone_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:potenchip/controllers/signup_controller.dart';
import 'package:potenchip/controllers/user_controller.dart';
import 'package:potenchip/screens/admin_view.dart';
import 'package:potenchip/screens/searchmodel_view.dart';
import 'package:potenchip/shared/const.dart';
import 'package:potenchip/shared/customtextfield.dart';
import 'package:potenchip/shared/text.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

class SignUpView extends StatefulWidget {
  final UserController userController;
  SignUpView({Key key, this.userController}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  SignUpController signUpController = SignUpController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  Position _currentPosition;
  String _currentAddress;
  // ignore: non_constant_identifier_names
  Position geolocator = Position();

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
        signUpController.city = place.subAdministrativeArea;
        signUpController.uf = place.administrativeArea;
      }

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  _getCurrentLocation() async {
    geolocator =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
            .then((Position position) {
      setState(() {
        print("position");
        print(position);
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

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

  Future<User> _getUser() async {
    if (_currentUser != null) return _currentUser;
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User user = authResult.user;

      return user;
    } catch (error) {
      print("Erro de login");
      return null;
    }
  }

  void googleSignUp() async {
    setState(() {
      isLoading = true;
    });
    final User user = await _getUser();

    if (user == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Não foi possivel fazer o login, tente novamente"),
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)))));
    }
    //await getLocationWithNominatim();
    print(signUpController.city);
    print(signUpController.uf);

    widget.userController
        .signUpFromGoogle(user, signUpController.city, signUpController.uf, () {
      setState(() {
        widget.userController.isLogged = true;
      });
      if (widget.userController.isLogged) {
        Navigator.pop(context);

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
      isLoading = false;
    }, () {
      widget.userController.isLogged = false;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
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
                            Text(
                              "Cadastrar",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: FONTFAMILY,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            CustomLoginTextField(
                              hint: "Nome",
                              textInputType: TextInputType.name,
                              inputFormatter: [],
                              prefix: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              onChanged: (value) {
                                signUpController.setName(value);
                              },
                              onSubmitted: (value) {
                                signUpController.setName(value);
                              },
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            CustomLoginTextField(
                              hint: "Telefone",
                              textInputType: TextInputType.name,
                              inputFormatter: [
                                FilteringTextInputFormatter.digitsOnly,
                                TelefoneInputFormatter()
                              ],
                              prefix: Icon(Icons.phone, color: Colors.white),
                              onChanged: (value) {
                                signUpController.setPhone(value);
                              },
                              onSubmitted: (value) {
                                signUpController.setPhone(value);
                              },
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            CustomLoginTextField(
                              hint: "Email",
                              textInputType: TextInputType.name,
                              inputFormatter: [],
                              prefix: Icon(Icons.email, color: Colors.white),
                              onChanged: (value) {
                                signUpController.setEmail(value);
                              },
                              onSubmitted: (value) {
                                signUpController.setEmail(value);
                              },
                            ),
                            signUpController.isEmailValid
                                ? SizedBox(
                                    height: 0,
                                  )
                                : Column(
                                    children: [
                                      signUpController.email == ""
                                          ? Container(
                                              height: 2,
                                              width: 1,
                                            )
                                          : Row(
                                              children: [
                                                Expanded(
                                                  child: Container(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    "Entre com um e-mail válido",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontStyle:
                                                            FontStyle.normal),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ],
                                            ),
                                      SizedBox(
                                        height: 0,
                                      ),
                                    ],
                                  ),
                            SizedBox(
                              height: 13,
                            ),
                            Observer(builder: (_) {
                              return CustomLoginTextField(
                                hint: "Senha",
                                obscure: !signUpController.enablePasswordView,
                                inputFormatter: [],
                                prefix: Icon(Icons.lock, color: Colors.white),
                                suffix: !signUpController.enablePasswordView
                                    ? GestureDetector(
                                        onTap: () {
                                          signUpController
                                              .setEnablePasswordView();
                                        },
                                        child: Icon(Icons.visibility_off))
                                    : GestureDetector(
                                        onTap: () {
                                          signUpController
                                              .setEnablePasswordView();
                                        },
                                        child: Icon(Icons.visibility)),
                                onChanged: (value) {
                                  signUpController.setPassword(value);
                                },
                                onSubmitted: (value) {
                                  signUpController.setPassword(value);
                                },
                              );
                            }),
                            signUpController.isPasswordValid
                                ? SizedBox(
                                    height: 0,
                                  )
                                : Column(
                                    children: [
                                      signUpController.password == ""
                                          ? Container(
                                              height: 0,
                                              width: 1,
                                            )
                                          : Row(
                                              children: [
                                                Expanded(
                                                  child: Container(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    "A senha deve conter 6 caracteres ou mais",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontStyle:
                                                            FontStyle.normal),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ],
                                            ),
                                      SizedBox(
                                        height: 0,
                                      ),
                                    ],
                                  ),
                            SizedBox(
                              height: 13,
                            ),
                            CustomLoginTextField(
                              hint: "Repetir senha",
                              obscure:
                                  !signUpController.enableConfirmPasswordView,
                              inputFormatter: [],
                              prefix: Icon(Icons.lock, color: Colors.white),
                              suffix:
                                  !signUpController.enableConfirmPasswordView
                                      ? GestureDetector(
                                          onTap: () {
                                            signUpController
                                                .setEnableConfirmPasswordView();
                                          },
                                          child: Icon(Icons.visibility_off))
                                      : GestureDetector(
                                          onTap: () {
                                            signUpController
                                                .setEnableConfirmPasswordView();
                                          },
                                          child: Icon(Icons.visibility)),
                              onChanged: (value) {
                                signUpController.setConfirmPassword(value);
                              },
                              onSubmitted: (value) {
                                signUpController.setConfirmPassword(value);
                              },
                            ),
                            signUpController.arePasswordsEqual
                                ? SizedBox(
                                    height: 0,
                                  )
                                : Column(
                                    children: [
                                      signUpController.confirmPassword == ""
                                          ? Container(
                                              height: 2,
                                              width: 1,
                                            )
                                          : Row(
                                              children: [
                                                Expanded(
                                                  child: Container(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    "As senhas não coincidem",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontStyle:
                                                            FontStyle.normal),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ],
                                            ),
                                      SizedBox(
                                        height: 13,
                                      ),
                                    ],
                                  ),
                            !widget.userController.loading
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        top: 10),
                                    child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.red[900],
                                                Colors.black26
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          // border: Border.all(
                                          //   width:1,
                                          //   color:Colors.black26,
                                          // )
                                        ),
                                        child: RaisedButton(
                                          elevation: 3,
                                          splashColor: Colors.red,
                                          color: Colors.transparent,
                                          onPressed: signUpController
                                                      .isEmailValid &&
                                                  signUpController
                                                      .arePasswordsEqual &&
                                                  signUpController.name != "" &&
                                                  signUpController.phone != ""
                                              ? () async {
                                                  //await getLocationWithNominatim();

                                                  //widget.userController.setUserLocation(_pickedLocation);
                                                  print("ADDRESS");

                                                  //print(_pickedLocation["address"]["state"]);
                                                  //signUpController.setCity(_pickedLocation["address"]["town"]);
                                                  //signUpController.setUf(_pickedLocation["address"]["state"]);

                                                  widget.userController
                                                      .setUserEmail(
                                                          signUpController
                                                              .email);
                                                  widget.userController
                                                      .setUserPassword(
                                                          signUpController
                                                              .password);

                                                  widget.userController.signUp(
                                                    userSignUpData:
                                                        signUpController
                                                            .toMap(),
                                                    onFail: (e) {
                                                      print(e);
                                                      scaffoldKey.currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            "Falha ao cadastrar: $e"),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ));
                                                    },
                                                    onSuccess: () {
                                                      scaffoldKey.currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                        duration: Duration(
                                                            seconds: 3),
                                                        content: Text(
                                                            "Bem vindo(a) ${widget.userController.user.name}!"),
                                                        backgroundColor:
                                                            Colors.green,
                                                        onVisible: () {
                                                          Navigator.pop(
                                                              context);

                                                          !widget.userController
                                                                  .user.isAdmin
                                                              ? Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              SearchModelView(
                                                                                userController: widget.userController,
                                                                              )),
                                                                )
                                                              : Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              AdminView(
                                                                                userController: widget.userController,
                                                                              )),
                                                                );
                                                        },
                                                      ));
                                                    },
                                                  );
                                                }
                                              : null,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Cadastrar",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.normal),
                                              textAlign: TextAlign.center,
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
                                          child: CircularProgressIndicator(
                                        backgroundColor: Colors.red,
                                      ))
                                    ],
                                  ),
                            SizedBox(
                              height: 9,
                            ),
                            CustomText("Ou", 14.5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                    : IconButton(
                                        // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                        icon: FaIcon(
                                          FontAwesomeIcons.google,
                                          size: 25,
                                          color: Colors.red[500],
                                        ),
                                        onPressed: () async {
                                          await _getCurrentLocation();
                                          googleSignUp();
                                          print(widget
                                              .userController.user.isAdmin);
                                          print(widget
                                              .userController.user.isColab);
                                          setState(() {});
                                        }),
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
            CustomTextSmall("Já possui uma conta?", 13,
                decoration: TextDecoration.none),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CustomText("LOGIN", 15,
                    fontStyle: FontStyle.normal, color: Colors.red[400]))
          ],
        ),
      ),
    );
  }
}
