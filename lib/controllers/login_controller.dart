import 'package:mobx/mobx.dart';
part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {

  @observable 
  bool isEmailValid = false;

  @observable 
  bool isPasswordValid = false;

  @observable 
  String email = "";

  @observable 
  String password= "";

  @observable 
  String city = "";

  @observable 
  String uf = "";
  
  @action 
  void setCity(value){
    city = value.toString().trim();
  }

   @action 
  void setUf(value){
    uf = value.toString().trim();
  }


  @action 
  void validateEmail() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    isEmailValid = (!regex.hasMatch(email)) ? false : true;
  }

  @action 
  void setEmail(value){
    email = value.toString().trim();
    validateEmail();
  }

  @action 
  void setPassword(value){
    password=value.toString().trim();
    validatePassword();
  }

  @action validatePassword(){{
    if(password.length < 6){
      isPasswordValid = false;
    }else{
      isPasswordValid = true;
    }
  }}

  


}