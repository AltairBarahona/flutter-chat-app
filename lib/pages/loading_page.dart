import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  //me servirá como un preloading para cosas como JWT, etc
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('LoadingPage'),
      ),
    );
  }
}
