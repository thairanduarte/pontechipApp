// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserController on _UserControllerBase, Store {
  final _$isLoggedAtom = Atom(name: '_UserControllerBase.isLogged');

  @override
  bool get isLogged {
    _$isLoggedAtom.reportRead();
    return super.isLogged;
  }

  @override
  set isLogged(bool value) {
    _$isLoggedAtom.reportWrite(value, super.isLogged, () {
      super.isLogged = value;
    });
  }

  final _$userAtom = Atom(name: '_UserControllerBase.user');

  @override
  UserModel get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserModel value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$hasErrorAtom = Atom(name: '_UserControllerBase.hasError');

  @override
  bool get hasError {
    _$hasErrorAtom.reportRead();
    return super.hasError;
  }

  @override
  set hasError(bool value) {
    _$hasErrorAtom.reportWrite(value, super.hasError, () {
      super.hasError = value;
    });
  }

  final _$errorAtom = Atom(name: '_UserControllerBase.error');

  @override
  String get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  final _$loadingAtom = Atom(name: '_UserControllerBase.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$signInAsyncAction = AsyncAction('_UserControllerBase.signIn');

  @override
  Future<void> signIn({Function onFail, Function onSuccess}) {
    return _$signInAsyncAction
        .run(() => super.signIn(onFail: onFail, onSuccess: onSuccess));
  }

  final _$signInGoogleAsyncAction =
      AsyncAction('_UserControllerBase.signInGoogle');

  @override
  Future<void> signInGoogle(
      {Function onFail, Function onSuccess, User result}) {
    return _$signInGoogleAsyncAction.run(() => super
        .signInGoogle(onFail: onFail, onSuccess: onSuccess, result: result));
  }

  final _$signUpAsyncAction = AsyncAction('_UserControllerBase.signUp');

  @override
  Future<void> signUp(
      {Function onFail,
      Function onSuccess,
      Map<String, dynamic> userSignUpData}) {
    return _$signUpAsyncAction.run(() => super.signUp(
        onFail: onFail, onSuccess: onSuccess, userSignUpData: userSignUpData));
  }

  final _$loadCurrentUserAsyncAction =
      AsyncAction('_UserControllerBase.loadCurrentUser');

  @override
  Future<bool> loadCurrentUser({User firebaseUser}) {
    return _$loadCurrentUserAsyncAction
        .run(() => super.loadCurrentUser(firebaseUser: firebaseUser));
  }

  final _$loadCurrentUserVoidAsyncAction =
      AsyncAction('_UserControllerBase.loadCurrentUserVoid');

  @override
  Future<dynamic> loadCurrentUserVoid({User firebaseUser}) {
    return _$loadCurrentUserVoidAsyncAction
        .run(() => super.loadCurrentUserVoid(firebaseUser: firebaseUser));
  }

  final _$_UserControllerBaseActionController =
      ActionController(name: '_UserControllerBase');

  @override
  Future<void> signUpFromGoogle(
      User user, String city, String uf, Function onSucess, Function onFail) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.signUpFromGoogle');
    try {
      return super.signUpFromGoogle(user, city, uf, onSucess, onFail);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserLocation(dynamic document) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setUserLocation');
    try {
      return super.setUserLocation(document);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserEmail(String value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setUserEmail');
    try {
      return super.setUserEmail(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserPassword(String value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setUserPassword');
    try {
      return super.setUserPassword(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void signOut() {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.signOut');
    try {
      return super.signOut();
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLogged: ${isLogged},
user: ${user},
hasError: ${hasError},
error: ${error},
loading: ${loading}
    ''';
  }
}
