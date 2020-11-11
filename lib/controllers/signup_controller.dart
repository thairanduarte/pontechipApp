import 'package:mobx/mobx.dart';
part 'signup_controller.g.dart';

class SignUpController = _SignUpControllerBase with _$SignUpController;

abstract class _SignUpControllerBase with Store {

  @observable 
  bool isEmailValid = false;

  @observable 
  bool isPasswordValid = false;

  @observable
  bool arePasswordsEqual = false;

  @observable 
  String email = "";

  @observable 
  String password= "";

  @observable 
  String confirmPassword = "";

  @observable 
  String name = "";

  @observable
  String phone = "";

  @observable 
  String city = "";

  @observable 
  String uf = "";

  @observable 
  bool enablePasswordView = false;

  @observable
  bool enableConfirmPasswordView = false;

  @action
  void setEnablePasswordView(){
    enablePasswordView = !enablePasswordView;
  }

  @action
  void setEnableConfirmPasswordView(){
    enableConfirmPasswordView = !enableConfirmPasswordView;
  }

  @action 
  void setName(value){
    name = value.toString().trim();
  }

  @action 
  void setPhone(value){
    phone = value.toString().trim();
  }

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
    validateEqualPassword();
  }

  void setConfirmPassword(value){
    confirmPassword=value.toString().trim();
    validatePassword();
    validateEqualPassword();
  }

  @action
  void validatePassword(){{
    if(password.length < 6){
      isPasswordValid = false;
    }else{
      isPasswordValid = true;
    }
  }}

  @action
  void validateEqualPassword(){
    if(password == confirmPassword){
      arePasswordsEqual = true;
    }else{
      arePasswordsEqual = false;
    }
  }

  @action 
  Map<String,dynamic> toMap(){
    return {
      "name":name,
      "phone":phone,
      "email":email,
      "city":city,
      "uf":uf
    };
  }




  
  
}