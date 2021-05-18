import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String texto;
  /*Si es el mismo mío significa que yo envíe el mensaje
  si no, significa que es de otra persona.
  Me sirve para hacer esa diferenciación y establecer también color */
  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    Key key,
    @required this.uid,
    @required this.texto,
    @required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      //animación de Fade cuando se crea
      opacity: animationController,
      child: SizeTransition(
        //animación de expansión hacia arriba
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: this.uid == "123" ? _myMessage() : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(
          bottom: 5,
          left: 30,
          right: 10,
        ),
        child: Text(
          this.texto,
          style: TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
            color: Color(0xff4D9EF6), borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(
          bottom: 5,
          left: 10,
          right: 30,
        ),
        child: Text(
          this.texto,
          style: TextStyle(color: Colors.black87),
        ),
        decoration: BoxDecoration(
            color: Color(0xffE4E5E8), borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
