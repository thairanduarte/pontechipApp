// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plate_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PlateController on _PlateControllerBase, Store {
  final _$plate_listAtom = Atom(name: '_PlateControllerBase.plate_list');

  @override
  ObservableList<String> get plate_list {
    _$plate_listAtom.reportRead();
    return super.plate_list;
  }

  @override
  set plate_list(ObservableList<String> value) {
    _$plate_listAtom.reportWrite(value, super.plate_list, () {
      super.plate_list = value;
    });
  }

  final _$documents_listAtom =
      Atom(name: '_PlateControllerBase.documents_list');

  @override
  ObservableList<PlateModel> get documents_list {
    _$documents_listAtom.reportRead();
    return super.documents_list;
  }

  @override
  set documents_list(ObservableList<PlateModel> value) {
    _$documents_listAtom.reportWrite(value, super.documents_list, () {
      super.documents_list = value;
    });
  }

  final _$selected_plateAtom =
      Atom(name: '_PlateControllerBase.selected_plate');

  @override
  String get selected_plate {
    _$selected_plateAtom.reportRead();
    return super.selected_plate;
  }

  @override
  set selected_plate(String value) {
    _$selected_plateAtom.reportWrite(value, super.selected_plate, () {
      super.selected_plate = value;
    });
  }

  final _$_PlateControllerBaseActionController =
      ActionController(name: '_PlateControllerBase');

  @override
  void setSelectedPlate(String value) {
    final _$actionInfo = _$_PlateControllerBaseActionController.startAction(
        name: '_PlateControllerBase.setSelectedPlate');
    try {
      return super.setSelectedPlate(value);
    } finally {
      _$_PlateControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getModelsFromSnapshot(List<dynamic> snapshot) {
    final _$actionInfo = _$_PlateControllerBaseActionController.startAction(
        name: '_PlateControllerBase.getModelsFromSnapshot');
    try {
      return super.getModelsFromSnapshot(snapshot);
    } finally {
      _$_PlateControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
plate_list: ${plate_list},
documents_list: ${documents_list},
selected_plate: ${selected_plate}
    ''';
  }
}
