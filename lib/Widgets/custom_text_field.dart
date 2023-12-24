import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final int maxLines;
  final TextEditingController controllerr;
  final bool obscuretype;
  final Icon icon;
  final TextInputType keyboardTypee;



  const CustomTextField({
    super.key,
    required this.hint,
    this.maxLines = 1,
    required this.controllerr,
    this.obscuretype = false,
    required this.icon, this.keyboardTypee = TextInputType.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
          ),
        ],
      ),
      width: 320,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: keyboardTypee,
        obscureText: obscuretype,
        controller: controllerr,
        decoration: InputDecoration(
            icon: icon, hintText: hint, border: InputBorder.none),
      ),
    );
  }
}
