import 'package:flutter/material.dart';
import 'package:flutter_app/common/constants.dart';
import 'package:flutter_app/screens/login_signup/widgets/text_form_field_custome.dart';
import 'package:flutter_app/utils/assets_animation.dart';
import 'package:flutter_app/utils/assets_image.dart';
import 'package:lottie/lottie.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _controllerInputEmail = TextEditingController();
  final _controllerInputFirstName = TextEditingController();
  final _controllerInputLastName = TextEditingController();
  final _controllerInputPassword = TextEditingController();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _controllerInputEmail.dispose();
    _controllerInputFirstName.dispose();
    _controllerInputLastName.dispose();
    _controllerInputPassword.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void handleGoLogin() {
      final controller = DefaultTabController.of(context);
      if (controller != null) {
        controller.animateTo(0);
      }
    }

    void handleSignUp() {}

    return SingleChildScrollView(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 100,
          ),
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
                child: Image(
                  image: AssetsImages.imageBar,
                  fit: BoxFit.cover,
                  height: 600,
                ),
              ),
              Column(
                children: [
                  Lottie.asset(
                    AssetsLottie.login,
                    width: 280,
                    height: 280,
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
                            onFieldSubmitted:
                                (value) => _firstNameFocus.requestFocus(),
                            type: FieldType.email,
                            label: "Email",
                            prefixIcon: Icon(Icons.email),
                          ),
                          SizedBox(height: 20),
                          TextFormFieldCustom(
                            controllerInput: _controllerInputFirstName,
                            type: FieldType.text,
                            label: "First Name",
                            prefixIcon: Icon(Icons.person),
                            focusNode: _firstNameFocus,
                            onFieldSubmitted:
                                (value) => _lastNameFocus.requestFocus(),
                          ),
                          SizedBox(height: 20),
                          TextFormFieldCustom(
                            controllerInput: _controllerInputLastName,
                            type: FieldType.text,
                            label: "Last Name",
                            prefixIcon: Icon(Icons.person),
                            focusNode: _lastNameFocus,
                            onFieldSubmitted:
                                (value) => _passwordFocus.requestFocus(),
                          ),
                          SizedBox(height: 20),
                          TextFormFieldCustom(
                            controllerInput: _controllerInputPassword,
                            type: FieldType.password,
                            label: "Password",
                            prefixIcon: Icon(Icons.password),
                            focusNode: _passwordFocus,
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 32),
                            child: ElevatedButton.icon(
                              onPressed: handleSignUp,

                              label: Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll<Color>(
                                  Colors.blue,
                                ),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              //TODO: Loading when login
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
                              Text("Already have an account ?"),
                              TextButton(
                                onPressed: handleGoLogin,
                                child: Text(
                                  "Log in",
                                  style: TextStyle(color: Colors.blue),
                                ),
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
      ),
    );
  }
}
