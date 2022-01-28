import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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

  static Widget waitingScreen() {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Color(0xFF1D1E2A),
        ),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: Shimmer.fromColors(
                    enabled: true,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 48.0,
                              height: 48.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: 10,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 10,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: 40.0,
                                    height: 10,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      itemCount: 6,
                    ),
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade700,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}