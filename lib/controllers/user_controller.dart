import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:potenchip/models/user_model.dart';
import 'package:potenchip/shared/firebase_erros.dart';
part 'user_controller.g.dart';

class UserController = _UserControllerBase with _$UserController;

abstract class _UserControllerBase with Store {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @observable
  bool isLogged = false;

  @observable
  UserModel user = UserModel();

  @observable
  bool hasError = false;

  @observable
  String error = "";

  @observable
  bool loading = false;

  @action
  Future<void> signIn({Function onFail, Function onSuccess}) async {
    setLoading(true);
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      hasError = false;
      error = "";
      //print("logei");

      await loadCurrentUser(firebaseUser: result.user);
      isLogged = true;
      onSuccess();
    } on PlatformException catch (e) {
      hasError = true;
      error = getErrorString(e.code);

      onFail(getErrorString(e.code));
    }
    setLoading(false);
  }


    @action
  Future<void> signInGoogle({Function onFail, Function onSuccess, User result}) async {
    setLoading(true);
    try {
      print("antes do result signin");
      await loadCurrentUser(firebaseUser: result);
      print("passei o signin");
      onSuccess();
    } on PlatformException catch (e) {
      hasError = true;
      error = getErrorString(e.code);

      onFail(getErrorString(e.code));
    }
    setLoading(false);
  }

  @action
  Future<void> signUp(
      {Function onFail,
      Function onSuccess,
      Map<String, dynamic> userSignUpData}) async {
    setLoading(true);
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      print('cheguei');
     
      print("cheguei aqui");
      user.fromMap(userSignUpData);
      user.isAdmin = false;
      user.isColab = false;
      user.priceChange = 0;
      user.id = result.user.uid;
      user.workingCities = List<String>();

      user.saveData();
      onSuccess();
      isLogged = true;
    } catch (e) {
      onFail(getErrorString(e.code));
    }
    setLoading(false);
  }
  @action
  Future<void> signUpFromGoogle(
      User user, String city, String uf, Function onSucess, Function onFail){



    setLoading(true);

    if(user==null){

    }else{
      print(user.metadata);
      print(user.email);
      print(user.phoneNumber);
      print(user.providerData);
      print(user.tenantId);
      print(user.uid);
      print(user.displayName);
    }
      this.user.name = user.displayName;
      this.user.phone = user.phoneNumber;
      this.user.email = user.email;
      this.user.city = city;
      this.user.uf=uf;
      this.user.isAdmin = false;
      this.user.isColab = false;
      this.user.priceChange = 0;
      this.user.id = user.uid;
      this.user.workingCities = List<String>();

      this.user.saveData();
      onSucess();

    setLoading(false);
  }

  @action
  void setUserLocation(document) {
    print(document);
    print("STATE");
    print(document["state"]);
    print("DESC");
    print(document["desc"]);

    user.uf = document["state"];
    user.city = document["desc"];

  }

  @action
  void setUserEmail(String value) {
    user.email = value.trim();
    //print(user.email);
  }

  @action
  void setUserPassword(String value) {
    user.password = value.toString().trim();
  }

  @action
  void setLoading(bool value) {
    loading = value;
  }

  @action
  Future<bool> loadCurrentUser({User firebaseUser}) async {
    final User currentUser = firebaseUser ?? auth.currentUser;
    Future.delayed(Duration(seconds: 5));
    if (currentUser != null) {
      isLogged = true;

      final DocumentSnapshot docUser =
          await firestore.collection("Users").doc(currentUser.uid).get();
      this.user.fromDocument(docUser);
      return true;
    } else {
      isLogged = false;
      return false;
    }
  }

  @action
  Future loadCurrentUserVoid({User firebaseUser}) async {
    final User currentUser = firebaseUser ?? auth.currentUser;
    Future.delayed(Duration(seconds: 10));
    
    if (currentUser != null) {
      print("com user");
      print(currentUser.uid);

      isLogged = true;

      final DocumentSnapshot docUser =
          await firestore.collection("Users").doc(currentUser.uid).get();
      print(docUser.data());
      this.user.fromDocument(docUser);

    } else {
      print("sem user");
      isLogged = false;
    }
  }

  @action
  void signOut() {
    auth.signOut();
    user = new UserModel();
    isLogged = false;
  }
}
