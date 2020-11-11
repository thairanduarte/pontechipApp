import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child:Container(
                height: 100, child: Image.asset('assets/Potenchip.png')),
        ),
      ),
    );
  }
}
