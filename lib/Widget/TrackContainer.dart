import 'package:flutter/material.dart';

class TrackContainer extends StatelessWidget {
  final int count;
  final String text;
  final Color color;
  final IconData icon;

  TrackContainer(
      {required this.text, required this.count, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      padding: EdgeInsets.all(8),
      width: 110,
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 30,),
              Text(
                count.toString(),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              )
            ],
          )
        ],
      ),
    );
  }
}
