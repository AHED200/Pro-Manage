import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_management/Helper/constant.dart';

class AppBarContainer extends StatelessWidget {
  final double height;
  final double width;
  final String? text;
  final String? date;
  final String? cost;
  final Color? color;

  AppBarContainer(
      {required this.height,
      required this.width,
      this.text,
      this.date,
      this.cost,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color == null ? Color(0xFF633BE5) : color,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(36),
              bottomLeft: Radius.circular(36)),
        ),
        child: text != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        text.toString(),
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Date: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                              TextSpan(
                                  text: date,
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'The cost: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                              TextSpan(
                                  text: double.parse(cost.toString())<=0
                                      ? 'none'
                                      : '\$' + cost.toString(),
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            : null);
  }
}
