import 'package:flutter/cupertino.dart';

import '../app/user/data/remote/models/user_model.dart';
import 'auth_service.dart';

class UsersProviders extends ChangeNotifier{
  UserModel? _userModel;
  final AuthService _authService = AuthService();

  UserModel? get users => _userModel;

 Future<void> refreshUsers()async{
    UserModel user = await _authService.getUsersDetails();
    _userModel = user;
    notifyListeners();
  }

}