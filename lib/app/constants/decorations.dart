import 'package:flutter/material.dart';
import 'package:i_have_todo/app/constants/them_data.dart';

InputDecoration kInputDecoration({
  String? hintText,
  Widget? suffixIcon,
  Widget? prefixIcon,
  double fontSize = 16,
}) =>
    InputDecoration(
      border: const UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      // filled: true,
      fillColor: kWhiteColor,
      hintText: hintText,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      hintStyle: const TextStyle(
        color: kGreyColor,
        fontWeight: FontWeight.w900,
        fontSize: 16,
      ),
    );
