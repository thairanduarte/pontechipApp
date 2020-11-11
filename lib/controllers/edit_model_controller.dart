import 'package:mobx/mobx.dart';
part 'edit_model_controller.g.dart';

class EditModelController = _EditModelControllerBase with _$EditModelController;

  @observable 
  bool isEditing = false;


  @action
  void setEditing(){
    isEditing = !isEditing;
  }

abstract class _EditModelControllerBase with Store {
  
  @observable 
  bool isEditing = false;


  @action
  void setEditing(value){
    isEditing = value;
  }

}