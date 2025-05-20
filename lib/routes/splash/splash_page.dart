import 'dart:async';

import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2600), () {
      Navigator.of(context).pushReplacementNamed('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/images/hackathon_logo.jpg',
          fit: BoxFit.contain,
          gaplessPlayback: true,
          width: MediaQuery.of(context).size.width / 3,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Created by ',
                style: TextStyle(color: Colors.white, fontSize: 12.0),
              ),
              Text(
                'Aniket (@anipy1)',
                style: TextStyle(color: Colors.greenAccent, fontSize: 12.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
