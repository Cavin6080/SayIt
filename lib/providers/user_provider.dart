import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sayit/models/usermodel.dart';
import 'package:sayit/resources/auth_methods.dart';

class UserProvider extends ChangeNotifier {
  Users? _user;
  Users? get getuser => _user;
  
    

  final AuthMethods _authMethods = AuthMethods();

  Future<void> refreshUser() async {
    Users user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
