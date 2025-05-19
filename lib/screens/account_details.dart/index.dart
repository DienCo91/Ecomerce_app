





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

class _AccountDetailsState extends State<AccountDetails> with _AccountFields {
  final _formKey = GlobalKey<FormState>();
  final _focusMap = <String, FocusNode>{
    'lastName': FocusNode(),
    'phone': FocusNode(),
  };

  final _controllerMap = <String, TextEditingController>{
    'firstName': TextEditingController(),
    'lastName': TextEditingController(),
    'phone': TextEditingController(),
  };

  bool _isLoading = false;

  @override
  void dispose() {
    _controllerMap.values.forEach((c) => c.dispose());
    _focusMap.values.forEach((f) => f.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final user = Get.find<AuthController>().user.value?.user;
    if (user != null) {
      _controllerMap['firstName']?.text = user.firstName;
      _controllerMap['lastName']?.text = user.lastName;
      _controllerMap['phone']?.text = user.phoneNumber ?? '';
    }
  }

  Future<void> _update(AuthController c) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final user = c.user.value!.user;
    final updated = user.copyWith(
      firstName: _controllerMap['firstName']?.text,
      lastName: _controllerMap['lastName']?.text,
      phoneNumber: _controllerMap['phone']?.text.orNullIfEmpty(),
    );

    try {
      final response = await AuthService().updateUser(updated);
      c.setUserDetail(response);
      _controllerMap['firstName']?.text = response.firstName;
      _controllerMap['lastName']?.text = response.lastName;
      _controllerMap['phone']?.text = response.phoneNumber ?? '';
      showSnackBar(message: "Update Account Success !");
    } catch (e) {
      debugPrint("Update error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final user = auth.user.value?.user;

    return AppScaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow(user),
            const SizedBox(height: 16),
            _userInfoTile(user),
            const SizedBox(height: 12),
            Divider(color: Colors.grey[300]),
            _buildForm(),
            const SizedBox(height: 24),
            _buildSaveButton(auth),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: _buildFields(),
      ),
    );
  }

  List<Widget> _buildFields() {
    return [
      _field("First Name", "firstName", Icons.person, next: _focusMap['lastName']),
      _field("Last Name", "lastName", Icons.person, focus: _focusMap['lastName'], next: _focusMap['phone']),
      _field("Phone Number", "phone", Icons.phone_android, isNumber: true, focus: _focusMap['phone']),
    ];
  }

  Widget _field(String label, String key, IconData icon, {FocusNode? focus, FocusNode? next, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormFieldCustom(
        controllerInput: _controllerMap[key]!,
        label: label,
        type: FieldType.text,
        prefixIcon: Icon(icon, color: Colors.blue),
        isNumber: isNumber,
        focusNode: focus,
        onFieldSubmitted: (_) =>
            next != null ? FocusScope.of(context).requestFocus(next) : FocusScope.of(context).unfocus(),
      ),
    );
  }

  Widget _buildHeaderRow(Auth user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Header(icon: Icons.person, iconColor: Colors.blue, title: "Account Details"),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 226, 226, 226),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(user.role.replaceAll("ROLE", "").toLowerCase(), style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }

  Widget _userInfoTile(Auth? user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          children: [
            const TextSpan(text: "Email: ", style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: user?.email ?? "Chưa có email"),
          ],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildSaveButton(AuthController c) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: !_isLoading ? () => _update(c) : null,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text("Save Changes", style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

mixin _AccountFields {
  String? orNullIfEmpty(String? s) => (s == null || s.trim().isEmpty) ? null : s;
}

extension CopyAuth on Auth {
  Auth copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? id,
    String? role,
    String? phoneNumber,
  }) {
    return Auth(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      id: id ?? this.id,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
