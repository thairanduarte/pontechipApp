// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_admin_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserAdminController on _UserAdminControllerBase, Store {
  final _$usersListAtom = Atom(name: '_UserAdminControllerBase.usersList');

  @override
  ObservableList<UserModel> get usersList {
    _$usersListAtom.reportRead();
    return super.usersList;
  }

  @override
  set usersList(ObservableList<UserModel> value) {
    _$usersListAtom.reportWrite(value, super.usersList, () {
      super.usersList = value;
    });
  }

  final _$_UserAdminControllerBaseActionController =
      ActionController(name: '_UserAdminControllerBase');

  @override
  void getUsersFromSnapshot(List<dynamic> snapshot) {
    final _$actionInfo = _$_UserAdminControllerBaseActionController.startAction(
        name: '_UserAdminControllerBase.getUsersFromSnapshot');
    try {
      return super.getUsersFromSnapshot(snapshot);
    } finally {
      _$_UserAdminControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
usersList: ${usersList}
    ''';
  }
}
