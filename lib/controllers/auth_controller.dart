import 'package:flutter_app/models/login_response.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var user = Rxn<LoginResponse>();

  void setUser(LoginResponse authData) {
    user.value = authData;
  }

  void clearUser(LoginResponse authData) {
    user.value = null;
  }
}
