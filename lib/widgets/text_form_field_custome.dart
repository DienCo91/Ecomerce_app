import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/common/constants.dart';

class _NoLeadingZeroInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty || newValue.text.startsWith(RegExp(r'[1-9]'))) {
      return newValue;
    }

    if (newValue.text == '0') {
      return newValue;
    }

    String newText = newValue.text.replaceFirst(RegExp(r'^0+'), '');
    return TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: newText.length));
  }
}

class TextFormFieldCustom extends StatefulWidget {
  const TextFormFieldCustom({
    super.key,
    required TextEditingController controllerInput,
    FocusNode? focusNode,
    FieldType? type = FieldType.text,
    required String label,
    Widget? prefixIcon,
    void Function(String)? onFieldSubmitted,
    bool? isNumber = false,
    String? initValue,
    this.validator,
    this.maxLines = 1,
    this.isBlockFirstZero,
  }) : _controllerInput = controllerInput,
       _focusNode = focusNode,
       _type = type,
       _label = label,
       _prefixIcon = prefixIcon,
       _onFieldSubmitted = onFieldSubmitted,
       _isNumber = isNumber,
       _initValue = initValue;

  final TextEditingController _controllerInput;
  final FocusNode? _focusNode;
  final FieldType? _type;
  final String _label;
  final Widget? _prefixIcon;
  final void Function(String)? _onFieldSubmitted;
  final bool? _isNumber;
  final String? _initValue;
  final String? Function(String)? validator;
  final int? maxLines;
  final bool? isBlockFirstZero;

  @override
  State<TextFormFieldCustom> createState() => _TextFormFieldCustomState();
}

class _TextFormFieldCustomState extends State<TextFormFieldCustom> {
  bool _isShowPassword = false;

  String? handleValidator(value) {
    if (widget.validator != null) {
      return widget.validator!(value);
    }
    if (value == null || value.isEmpty) {
      return '${widget._label} required !';
    } else if (!emailRegex.hasMatch(value) && widget._type == FieldType.email) {
      return 'Email invalid';
    }
    return null;
  }

  void handleShowPassword() {
    setState(() {
      _isShowPassword = !_isShowPassword;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget._initValue != null && widget._controllerInput.text.isEmpty) {
      widget._controllerInput.text = widget._initValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget._focusNode,
      controller: widget._controllerInput,
      style: TextStyle(fontSize: 18),
      obscureText: !_isShowPassword && widget._type == FieldType.password,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        label: Text(widget._label),
        floatingLabelStyle: TextStyle(color: Colors.blue, fontSize: 18),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 1)),
        prefixIcon: widget._prefixIcon,
        suffixIcon:
            widget._type == FieldType.password
                ? IconButton(
                  onPressed: handleShowPassword,
                  icon: Icon(_isShowPassword ? Icons.visibility_off : Icons.visibility),
                )
                : null,
      ),
      onFieldSubmitted: widget?._onFieldSubmitted,
      validator: handleValidator,
      keyboardType: widget._isNumber == true ? TextInputType.number : null,
      maxLines: widget.maxLines,
      inputFormatters: widget.isBlockFirstZero == true ? [_NoLeadingZeroInputFormatter()] : null,
    );
  }
}
