import 'package:flutter/material.dart';

class ContainerButton extends StatelessWidget {
  final IconData icon;

  ContainerButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Icon(
          icon,
          size: 30,
          color:
          Theme.of(context).scaffoldBackgroundColor,
        ),
        decoration: BoxDecoration(
          color: Color(0xFF9BC1F3),
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.only(left: 8),
        padding: EdgeInsets.symmetric(
            vertical: 9, horizontal: 9),
      ),
    );
  }}
