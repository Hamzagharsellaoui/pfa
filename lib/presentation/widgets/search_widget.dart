import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? helperText;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? counterText;
  final InputBorder border;

  const SearchWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.helperText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.counterText,
    this.border = const OutlineInputBorder(), required InputDecoration decoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(

    );
  }
   }