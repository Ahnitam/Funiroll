import 'package:flutter/material.dart';

class CampoLogin extends StatelessWidget {
  final TextEditingController controller;
  final Color colorBorderField;
  final String label;
  final bool isSenha;
  final TextInputType textType;

  const CampoLogin(this.label, {Key? key, this.isSenha = false, this.textType = TextInputType.text, required this.colorBorderField, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borda = OutlineInputBorder(
      borderSide: BorderSide(
        color: colorBorderField,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(25),
    );
    return TextField(
      controller: controller,
      obscureText: isSenha,
      keyboardType: textType,
      decoration: InputDecoration(
        isDense: true,
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: "Bree Serif",
        ),
        enabledBorder: borda,
        focusedBorder: borda,
      ),
    );
  }
}
