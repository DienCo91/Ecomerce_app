import 'package:flutter/material.dart';
import 'package:flutter_app/utils/assets_image.dart';
import 'package:flutter_app/common/constants.dart';

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
  bool _isShowPassword = false;

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

  void handleShowPassword() {
    setState(() {
      _isShowPassword = !_isShowPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 48, bottom: 48),
            child: Image(image: AssetsImages.logoApp, width: 120, height: 120),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _controllerInputEmail,
                  style: TextStyle(fontSize: 20),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    label: Text("Email"),
                    floatingLabelStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                  onFieldSubmitted:
                      (value) => _focusNodePassword.requestFocus(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email required !';
                    } else if (!emailRegex.hasMatch(value)) {
                      return 'Email invalid';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 26),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  focusNode: _focusNodePassword,
                  controller: _controllerInputPassword,
                  style: TextStyle(fontSize: 20),
                  obscureText: !_isShowPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password required !';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    label: Text("Password"),
                    floatingLabelStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                    ),
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: IconButton(
                      onPressed: handleShowPassword,
                      icon: Icon(
                        _isShowPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 32),
                  child: ElevatedButton.icon(
                    onPressed: () {},

                    label: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        Colors.blue,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
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
                Container(
                  margin: EdgeInsets.only(top: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 24,
                    children: [
                      Container(
                        width: 120,
                        height: 2,
                        color: const Color.fromARGB(80, 158, 158, 158),
                      ),
                      Text(
                        "OR",
                        style: TextStyle(
                          color: Color.fromARGB(168, 0, 0, 0),
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        width: 120,
                        height: 2,
                        color: const Color.fromARGB(80, 158, 158, 158),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 32, bottom: 16),
                  child: OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        Colors.white,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      side: WidgetStatePropertyAll<BorderSide>(
                        BorderSide(
                          color: Color.fromARGB(86, 63, 63, 63),
                          width: 1,
                        ),
                      ),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Image(
                          image: AssetsImages.iconGoogle,
                          width: 20,
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            "Login with Google",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
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
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
