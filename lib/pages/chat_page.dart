import 'dart:io';

import 'package:chat_app/models/mensajes_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';

import 'package:chat_app/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  List<ChatMessage> _messages = [];
  bool _estaEscribiendo = false;

  @override
  void initState() {
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(this.chatService.usuarioDestino.uid);
    super.initState();
  }

  void _escucharMensaje(dynamic payload) {
    ChatMessage message = ChatMessage(
      uid: payload['de'],
      texto: payload['mensaje'],
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 300)),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  void _cargarHistorial(String usuarioID) async {
    List<Mensaje> chat = await this.chatService.getChat(usuarioID);
    // print(chat);

    final history = chat.map((mensaje) => ChatMessage(
          //IMPORTANTE QUE SEA ".DE"
          uid: mensaje.de,
          texto: mensaje.mensaje,
          animationController: AnimationController(
              vsync: this, duration: Duration(milliseconds: 0))
            ..forward(),
        ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioDestino = chatService.usuarioDestino;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(usuarioDestino.nombre.substring(0, 2),
                  style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text(
              usuarioDestino.nombre,
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) {
                  return _messages[i];
                },
              ),
            ),
            Divider(thickness: 1),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                decoration:
                    InputDecoration.collapsed(hintText: "Enviar mensaje"),
                focusNode: _focusNode, //controlar el foco
                controller: _textController, //gestionar el texto
                onSubmitted: _handleSubmit, //al darle "enter" o equivalente
                onChanged: (texto) {
                  setState(() {
                    if (texto.trim().length > 0) {
                      //está escribiendo
                      _estaEscribiendo = true;
                    } else {
                      _estaEscribiendo = false;
                    }
                  });
                },
              ),
            ),

            //Botón de enviar
            Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                child: Platform.isIOS //isa dart:io para ver la plataforma
                    ? CupertinoButton(
                        //si es IOS
                        child: Text("Enviar"),
                        onPressed: _estaEscribiendo
                            ? () => _handleSubmit(
                                  //evita que siempre se limpie el texto
                                  _textController.text.trim(),
                                )
                            : null,
                      )
                    : Container(
                        //si no es IOS
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        child: IconTheme(
                          data: IconThemeData(color: Colors.blue[400]),
                          child: IconButton(
                            highlightColor:
                                Colors.transparent, //quito efecto de material
                            splashColor:
                                Colors.transparent, //quito efecto de material
                            icon: Icon(Icons.send),
                            onPressed: _estaEscribiendo
                                ? () => _handleSubmit(
                                      //evita que siempre se limpie el texto
                                      _textController.text.trim(),
                                    )
                                : null,
                          ),
                        ),
                      ))
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    //evito poder dar enter sin texto
    if (texto.length == 0) return;
    //captura el value enviado por onSubbmitted
    _textController.clear(); //limpia el texto
    _focusNode.requestFocus(); //esto pide el foco para que no se cierre

    //crea un objeto tipo ChatMessage
    final newMessage = ChatMessage(
      uid: authService.usuario.uid,
      texto: texto,
      //paso el this gracias a mezclar State con TickerProviderStateMixin
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 150),
      ),
    );
    //lo añade al inicio de la lista de mensajes con .insert y la posición
    _messages.insert(0, newMessage);

    //ya tengo la aniamción, ahora DEBO LANZARLA
    newMessage.animationController.forward();
    setState(() {
      _estaEscribiendo = false; //desactiva el botón luego de enviar

      this.socketService.emit('mensaje-personal', {
        'de': this.authService.usuario.uid,
        'para': this.chatService.usuarioDestino.uid,
        'mensaje': texto
      });
    });
  }

  @override
  void dispose() {
    //TODO: off sel socket
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
