import 'package:mobx/mobx.dart';
import 'package:potenchip/models/user_model.dart';
part 'users_admin_controller.g.dart';

class UserAdminController = _UserAdminControllerBase with _$UserAdminController;

abstract class _UserAdminControllerBase with Store {
  
  @observable
  ObservableList<UserModel> usersList = ObservableList<UserModel>();

  @action 
  void getUsersFromSnapshot(List<dynamic> snapshot){
    usersList = new ObservableList<UserModel>();
      snapshot.forEach((element) { 
        UserModel userAux = UserModel();
        userAux.fromDocument(element);
        usersList.add(userAux);
      });
  }
}