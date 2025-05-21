import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/screens/new_password/index.dart';
import 'package:flutter_app/services/auth_service.dart';
import 'package:flutter_app/utils/assets_animation.dart';
import 'package:flutter_app/utils/showSnackBar.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class OTP extends StatefulWidget {
  const OTP({super.key});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final _formKey = GlobalKey<FormState>();
  List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  bool isLoading = false;
  bool isError = false;
  String email = '';

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    email = args['email'];
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void handleSendMail() async {
    String otp = _controllers.map((c) => c.text).join();
    if (otp.length < 6) {
      return showSnackBar(message: "OTP length must be 6 digits", backgroundColor: Colors.red);
    }

    try {
      setState(() {
        isLoading = true;
      });

      await AuthService().sendOtp(email: email, code: otp);

      Get.to(
        NewPassword(),
        arguments: {'email': email, 'otp': otp},
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

  Widget buildOTPFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 45,
          height: 55,
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (KeyEvent event) {
              if (event.logicalKey == LogicalKeyboardKey.backspace &&
                  event is KeyDownEvent &&
                  _controllers[index].text.isEmpty) {
                if (index > 0) {
                  FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                  _controllers[index - 1].clear();
                }
              }
            },
            child: TextFormField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              decoration: InputDecoration(
                counterText: '',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),

              onChanged: (value) {
                if (value.isNotEmpty && index < 5) {
                  setState(() {
                    isError = false;
                  });
                  FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                }
              },
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'OTP',
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Lottie.asset(AssetsLottie.forgotPassword, width: 200, height: 200, fit: BoxFit.contain),
            SizedBox(height: 48),
            const Text(
              'Please check your email to receive the OTP code',
              style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  buildOTPFields(),
                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: handleSendMail,
                      icon:
                          isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                              : const Icon(Icons.send, color: Colors.white),
                      label: const Text("Confirm", style: TextStyle(color: Colors.white)),
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
