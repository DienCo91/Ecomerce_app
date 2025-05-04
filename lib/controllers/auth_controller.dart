import 'package:flutter_app/models/auth.dart';
import 'package:flutter_app/models/login_response.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var user = Rxn<LoginResponse>();

  void setUser(LoginResponse authData) {
    user.value = authData;
  }

  void clearUser() {
    user.value = null;
  }

  void setUserDetail(Auth authData) {
    user.value = LoginResponse(success: user.value!.success, token: user.value!.token, user: authData);
  }
}
