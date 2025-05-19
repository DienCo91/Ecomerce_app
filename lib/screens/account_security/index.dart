import 'package:flutter/material.dart';
import 'package:flutter_app/common/constants.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/screens/login_signup/index.dart';
import 'package:flutter_app/services/auth_service.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/header.dart';
import 'package:flutter_app/widgets/text_form_field_custome.dart';
import 'package:get/get.dart';

class AccountSecurity extends StatefulWidget {
  const AccountSecurity({super.key});

  @override
  State<AccountSecurity> createState() => _AccountSecurityState();
}

class _AccountSecurityState extends State<AccountSecurity> {
  final _formKey = GlobalKey<FormState>();
  final _controllerCurrentPassword = TextEditingController();
  final _controllerNewPassword = TextEditingController();
  final _controllerConfirmPassword = TextEditingController();

  final _focusCurrentPassword = FocusNode();
  final _focusNewPassword = FocusNode();
  final _focusConfirmPassword = FocusNode();

  bool _isLoading = false;
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
  }

  @override
  void dispose() {
    _controllerCurrentPassword.dispose();
    _controllerNewPassword.dispose();
    _controllerConfirmPassword.dispose();
    _focusCurrentPassword.dispose();
    _focusNewPassword.dispose();
    _focusConfirmPassword.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await AuthService().resetPassword(
        password: _controllerCurrentPassword.text,
        confirmPassword: _controllerConfirmPassword.text,
      );
      await _authController.clearUser();
    } catch (e) {
      print('Error resetting password: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(icon: Icons.lock, iconColor: Colors.blue, title: "Account Security"),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _PasswordField(
                    label: "Current Password",
                    controller: _controllerCurrentPassword,
                    focusNode: _focusCurrentPassword,
                    nextFocus: _focusNewPassword,
                  ),
                  _PasswordField(
                    label: "New Password",
                    controller: _controllerNewPassword,
                    focusNode: _focusNewPassword,
                    nextFocus: _focusConfirmPassword,
                  ),
                  _PasswordField(
                    label: "Confirm Password",
                    controller: _controllerConfirmPassword,
                    focusNode: _focusConfirmPassword,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter Confirm Password';
                      if (value != _controllerNewPassword.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _handleSave,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text("Reset password", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final String? Function(String)? validator;

  const _PasswordField({
    required this.label,
    required this.controller,
    required this.focusNode,
    this.nextFocus,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormFieldCustom(
        controllerInput: controller,
        focusNode: focusNode,
        label: label,
        type: FieldType.password,
        prefixIcon: const Icon(Icons.lock, color: Colors.blue),
        validator: validator ??
            (value) => value.isEmpty ? 'Please enter $label' : null,
        onFieldSubmitted: (_) {
          if (nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          } else {
            focusNode.unfocus();
          }
        },
      ),
    );
  }
}
