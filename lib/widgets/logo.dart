import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String titulo;

  const Logo({
    Key key,
    @required this.titulo,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: 170,
        child: Column(
          children: [
            Image.asset("assets/logoAltair.png"),
            Text(this.titulo, style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
