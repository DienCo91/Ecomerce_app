import 'package:flutter/material.dart';
import 'package:flutter_app/common/constants.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
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
  final FocusNode _focusCurrentPassword = FocusNode();
  final FocusNode _focusNewPassword = FocusNode();
  final FocusNode _focusConfirmPassword = FocusNode();
  bool _isLoading = false;

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

  void _handleSave(AuthController authController) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await AuthService().resetPassword(
          confirmPassword: _controllerConfirmPassword.text,
          password: _controllerCurrentPassword.text,
        );
        await authController.clearUser();
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormFieldCustom(
        controllerInput: controller,
        focusNode: focusNode,
        label: label,
        type: FieldType.password,
        prefixIcon: Icon(Icons.lock, color: Colors.blue),
        validator: (String value) {
          if (value.isEmpty) return 'Please enter $label';
          if (label == "Confirm Password" && value != _controllerNewPassword.text) {
            return 'Passwords do not match';
          }
          return null;
        },
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

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

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
                  _buildPasswordField(
                    label: "Current Password",
                    controller: _controllerCurrentPassword,
                    focusNode: _focusCurrentPassword,
                    nextFocus: _focusNewPassword,
                  ),
                  _buildPasswordField(
                    label: "New Password",
                    controller: _controllerNewPassword,
                    focusNode: _focusNewPassword,
                    nextFocus: _focusConfirmPassword,
                  ),
                  _buildPasswordField(
                    label: "Confirm Password",
                    controller: _controllerConfirmPassword,
                    focusNode: _focusConfirmPassword,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: !_isLoading ? () => _handleSave(authController) : null,
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
