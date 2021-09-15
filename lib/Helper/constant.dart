import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constant{
  static const Color purple=Color(0xDA633BE5);
  static const BoxDecoration purpleDecoration=BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35)),
      boxShadow: [
        BoxShadow(
            color: Colors.white10,
            blurRadius: 20,
            offset: Offset(0, 1))
      ],
      gradient: LinearGradient(
        colors: [Color(0xD2001049), Constant.purple],
        end: Alignment.topCenter,
        begin: Alignment.bottomCenter,
      ));

  static const TextStyle style=TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );
}