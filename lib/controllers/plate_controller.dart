import 'package:mobx/mobx.dart';
import 'package:potenchip/models/plate_model.dart';
part 'plate_controller.g.dart';

class PlateController = _PlateControllerBase with _$PlateController;

abstract class _PlateControllerBase with Store {

  @observable
  ObservableList<String> plate_list = ObservableList<String>();

  @observable 
  ObservableList<PlateModel> documents_list;

  @observable 
  String selected_plate;

  @action
  void setSelectedPlate(String value){
    selected_plate = value;
  }

  @action 
  void getModelsFromSnapshot(List<dynamic> snapshot){
    documents_list = ObservableList<PlateModel>();
    snapshot.forEach((element) {
      if(element!=null){
        PlateModel plate = PlateModel();
        plate.fromDocument(element);
        documents_list.add(plate);
        if(!plate_list.contains(element.data()["plate"])){
          plate_list.add(element.data()["plate"] as String);
        }
      }

    });

  } 
}