import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  bool _obscureText = true;
  late FocusNode _focusNodePassWord;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _focusNodePassWord = FocusNode();
  }

  @override
  void dispose() {
    _focusNodePassWord.dispose();
    super.dispose();
  }

  void _onSubmitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Submitted !")));
      setState(() {
        _isLoading = true;
      });

      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Form Page",
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(label: Text("Email")),
                onFieldSubmitted: (value) => _focusNodePassWord.requestFocus(),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Field require!!";
                  }
                  return null;
                },
              ),
              TextFormField(
                focusNode: _focusNodePassWord,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  label: Text("Password"),
                  suffixIcon: IconButton(
                    onPressed:
                        () => {
                          setState(() {
                            _obscureText = !_obscureText;
                          }),
                        },
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                obscureText: _obscureText,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Field require!!";
                  }
                  return null;
                },
                onFieldSubmitted: (value) => {_onSubmitForm()},
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                child: ElevatedButton.icon(
                  onPressed: _onSubmitForm,
                  label: Text("Submit"),
                  icon:
                      _isLoading
                          ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.blue),
                              strokeWidth: 2,
                            ),
                          )
                          : Icon(Icons.send),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
