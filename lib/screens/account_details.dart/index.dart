import 'package:flutter/material.dart';
import 'package:flutter_app/common/constants.dart';
import 'package:flutter_app/controllers/auth_controller.dart';
import 'package:flutter_app/models/auth.dart';
import 'package:flutter_app/services/auth_service.dart';
import 'package:flutter_app/utils/showSnackBar.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/header.dart';
import 'package:flutter_app/widgets/text_form_field_custome.dart';
import 'package:get/get.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  final _formKey = GlobalKey<FormState>();
  final _controllerFirstName = TextEditingController();
  final _controllerLastName = TextEditingController();
  final _controllerPhone = TextEditingController();
  final _focusLastName = FocusNode();
  final _focusPhone = FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    _controllerFirstName.dispose();
    _controllerLastName.dispose();
    _controllerPhone.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final user = Get.find<AuthController>().user.value?.user;
    if (user != null) {
      _controllerFirstName.text = user.firstName;
      _controllerLastName.text = user.lastName;
      _controllerPhone.text = user.phoneNumber ?? '';
    }
  }

  void _handleSave(AuthController authController) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Auth user = authController.user.value!.user;
      Auth newUser = Auth(
        email: user.email,
        firstName: _controllerFirstName.text,
        lastName: _controllerLastName.text,
        id: user.id,
        role: user.role,
        phoneNumber: _controllerPhone.text.isEmpty ? null : _controllerPhone.text,
      );

      try {
        final response = await AuthService().updateUser(newUser);
        authController.setUserDetail(response);

        _controllerFirstName.text = response.firstName;
        _controllerLastName.text = response.lastName;
        _controllerPhone.text = response.phoneNumber!;
        showSnackBar(message: "Update Account Success !");
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildUserInfoHeader(AuthController authController) {
    final user = authController.user.value?.user;
    return Row(
      children: [
        Text(user?.email ?? "", style: TextStyle(fontSize: 16)),
        const SizedBox(width: 24),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 226, 226, 226),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(user?.role.replaceAll("ROLE", "").toLowerCase() ?? "", style: TextStyle(fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    FocusNode? focusNode,
    FocusNode? nextFocus,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormFieldCustom(
        controllerInput: controller,
        label: label,
        type: FieldType.text,
        prefixIcon: Icon(icon, color: Colors.blue),
        isNumber: isNumber,
        focusNode: focusNode,
        onFieldSubmitted: (_) {
          if (nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          } else {
            FocusScope.of(context).unfocus();
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
            const Header(icon: Icons.person, iconColor: Colors.blue, title: "Account Details"),
            const SizedBox(height: 16),
            _buildUserInfoHeader(authController),
            const SizedBox(height: 12),
            Divider(color: Colors.grey[300], thickness: 1),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    label: "First Name",
                    controller: _controllerFirstName,
                    icon: Icons.person,
                    nextFocus: _focusLastName,
                    focusNode: null,
                  ),
                  _buildTextField(
                    label: "Last Name",
                    controller: _controllerLastName,
                    icon: Icons.person,
                    focusNode: _focusLastName,
                    nextFocus: _focusPhone,
                  ),
                  _buildTextField(
                    label: "Phone Number",
                    controller: _controllerPhone,
                    icon: Icons.phone_android_rounded,
                    isNumber: true,
                    focusNode: _focusPhone,
                    nextFocus: null,
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
                label: const Text("Save Changes", style: TextStyle(color: Colors.white)),
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
