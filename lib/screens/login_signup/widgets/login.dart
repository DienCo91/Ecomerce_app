import 'package:flutter/material.dart';
import 'package:flutter_app/common/constants.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/models/login_request.dart';
import 'package:flutter_app/screens/home/index.dart';
import 'package:flutter_app/widgets/text_form_field_custome.dart';
import 'package:flutter_app/services/auth_service.dart';
import 'package:flutter_app/utils/assets_animation.dart';
import 'package:flutter_app/utils/assets_image.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerInputEmail;
  late TextEditingController _controllerInputPassword;
  late FocusNode _focusNodePassword;
  bool _isLoadingBtn = false;
  final AuthController auth = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _controllerInputEmail = TextEditingController();
    _controllerInputPassword = TextEditingController();
    _focusNodePassword = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerInputEmail.dispose();
    _controllerInputPassword.dispose();
    _focusNodePassword.dispose();
  }

  void handleGoSignUp() {
    final controller = DefaultTabController.of(context);
    if (controller != null) {
      controller.animateTo(1);
    }
  }

  void handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoadingBtn = true;
      });
      try {
        final data = await AuthService().loginUser(
          LoginRequest(email: _controllerInputEmail.text, password: _controllerInputPassword.text),
        );
        print(data);
        auth.setUser(data);
        Get.offAll(Home());
      } catch (e) {
        print("Error ${e}");
      } finally {
        setState(() {
          _isLoadingBtn = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 100),
        child: Stack(
          children: [
            Positioned(
              bottom: 500,
              left: -10,
              right: 0,
              child: Image(image: AssetsImages.imageBar2, fit: BoxFit.cover),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image(image: AssetsImages.imageBar, fit: BoxFit.cover, height: 600),
            ),
            Column(
              children: [
                Lottie.asset(
                  AssetsLottie.login,
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                  repeat: true,
                  animate: true,
                ),
                Container(
                  padding: EdgeInsets.only(left: 32, right: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormFieldCustom(
                          controllerInput: _controllerInputEmail,
                          onFieldSubmitted: (value) => _focusNodePassword.requestFocus(),
                          type: FieldType.email,
                          label: "Email",
                          prefixIcon: Icon(Icons.email),
                        ),
                        SizedBox(height: 20),
                        TextFormFieldCustom(
                          controllerInput: _controllerInputPassword,
                          type: FieldType.password,
                          label: "Password",
                          prefixIcon: Icon(Icons.password),
                          focusNode: _focusNodePassword,
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 32),
                          child: ElevatedButton.icon(
                            onPressed: handleLogin,
                            label: Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                              child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(_isLoadingBtn ? Colors.grey : Colors.blue),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                              ),
                            ),
                            icon:
                                _isLoadingBtn
                                    ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(Colors.white),
                                      ),
                                    )
                                    : null,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 24,
                            children: [
                              Container(width: 120, height: 2, color: const Color.fromARGB(80, 158, 158, 158)),
                              Text("OR", style: TextStyle(color: Color.fromARGB(168, 0, 0, 0), fontSize: 14)),
                              Container(width: 120, height: 2, color: const Color.fromARGB(80, 158, 158, 158)),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 24, bottom: 16),
                          child: OutlinedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                              ),
                              side: WidgetStatePropertyAll<BorderSide>(
                                BorderSide(color: Color.fromARGB(86, 63, 63, 63), width: 1),
                              ),
                            ),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10,
                              children: [
                                Image(image: AssetsImages.iconGoogle, width: 20, height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text(
                                    "Login with Google",
                                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                            // icon: SizedBox(
                            //   width: 20,
                            //   height: 20,z
                            //   child: CircularProgressIndicator(
                            //     strokeWidth: 2,
                            //     valueColor: AlwaysStoppedAnimation(Colors.grey),
                            //   ),
                            // ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account ?"),
                            TextButton(
                              onPressed: handleGoSignUp,
                              child: Text("Sign Up", style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
