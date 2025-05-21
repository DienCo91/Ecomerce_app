import 'package:flutter/material.dart';
import 'package:flutter_app/common/constants.dart';
import 'package:flutter_app/screens/otp/index.dart';
import 'package:flutter_app/services/auth_service.dart';
import 'package:flutter_app/utils/assets_animation.dart';
import 'package:flutter_app/utils/showSnackBar.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/text_form_field_custome.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController _controllerInputEmail;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controllerInputEmail = TextEditingController();
    super.initState();
  }

  void handleSendMail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await AuthService().verify(email: _controllerInputEmail.text);
        Get.to(
          OTP(),
          arguments: {'email': _controllerInputEmail.text},
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 300),
        );
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Forgot Password',
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
                    controllerInput: _controllerInputEmail,
                    type: FieldType.email,
                    label: "Email",
                    prefixIcon: Icon(Icons.email, color: Colors.blue),
                    onFieldSubmitted: (_) => handleSendMail,
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: handleSendMail,
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
                      label: const Text("Send Email", style: TextStyle(color: Colors.white)),
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
