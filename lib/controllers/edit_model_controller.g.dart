// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_model_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$EditModelController on _EditModelControllerBase, Store {
  final _$isEditingAtom = Atom(name: '_EditModelControllerBase.isEditing');

  @override
  bool get isEditing {
    _$isEditingAtom.reportRead();
    return super.isEditing;
  }

  @override
  set isEditing(bool value) {
    _$isEditingAtom.reportWrite(value, super.isEditing, () {
      super.isEditing = value;
    });
  }

  final _$_EditModelControllerBaseActionController =
      ActionController(name: '_EditModelControllerBase');

  @override
  void setEditing(dynamic value) {
    final _$actionInfo = _$_EditModelControllerBaseActionController.startAction(
        name: '_EditModelControllerBase.setEditing');
    try {
      return super.setEditing(value);
    } finally {
      _$_EditModelControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isEditing: ${isEditing}
    ''';
  }
}
