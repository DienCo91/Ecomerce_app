import 'package:flutter/material.dart';
import 'package:flutter_app/common/constants.dart';
import 'package:flutter_app/screens/login_signup/index.dart';
import 'package:flutter_app/services/auth_service.dart';
import 'package:flutter_app/utils/assets_animation.dart';
import 'package:flutter_app/utils/showSnackBar.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/text_form_field_custome.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  late TextEditingController _controllerInputPassword;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String otp = '';

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    email = args['email'];
    otp = args['otp'];
    _controllerInputPassword = TextEditingController();
  }

  @override
  void dispose() {
    _controllerInputPassword.dispose();
    super.dispose();
  }

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        await AuthService().changePasswordOtp(email: email, password: _controllerInputPassword.text);
        showSnackBar(message: "Change Passsword Successfully");
        Get.offAll(LoginAndSignUp());
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'New Password',
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              AssetsLottie.forgotPassword,
              width: 200,
              height: 200,
              fit: BoxFit.contain,
              repeat: true,
              animate: true,
            ),
            SizedBox(height: 48),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormFieldCustom(
                    controllerInput: _controllerInputPassword,
                    type: FieldType.password,
                    label: "New Password",
                    prefixIcon: Icon(Icons.password, color: Colors.blue),
                    onFieldSubmitted: (_) => handleSubmit,
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: handleSubmit,
                      icon:
                          isLoading
                              ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                              : const Icon(Icons.send, color: Colors.white),
                      label: const Text("Change password", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLoading ? Colors.grey : Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
