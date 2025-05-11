import 'package:flutter_app/models/auth.dart';
import 'package:flutter_app/models/login_response.dart';
import 'package:flutter_app/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  var user = Rxn<LoginResponse>();
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    restoreSession();
  }

  Future<void> restoreSession() async {
    if (_storage.hasData('user')) {
      final userData = Map<String, dynamic>.from(_storage.read('user'));
      final loginResponse = LoginResponse.fromJson(userData);
      final token = loginResponse.token;

      try {
        final currentUser = await AuthService().fetchCurrentUser(token);
        user.value = LoginResponse(success: loginResponse.success, token: loginResponse.token, user: currentUser);
      } catch (e) {
        print("Error get user ======= $e");
        clearUser();
      }
    }
  }

  void setUser(LoginResponse authData) {
    user.value = authData;
    _storage.write('user', authData.toJson());
  }

  void clearUser() {
    user.value = null;
    _storage.remove('user');
  }

  void setUserDetail(Auth authData) {
    user.value = LoginResponse(success: user.value!.success, token: user.value!.token, user: authData);
    _storage.write('user', user.value!.toJson());
  }
}
