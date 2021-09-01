import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/services/auth_service.dart';

import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/usuarios_page.dart';

class LoadingPage extends StatelessWidget {
  //me servirá como un preloading para cosas como JWT, etc
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: chechLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Text("Loading page"),
          );
        },
      ),
    );
  }

//usaré instancia del provider para leer el AuthService
  Future chechLoginState(BuildContext context) async {
    /*listen en flase porque estoy dentro de una promesa que no redibuja nada */
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      socketService.connect();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => UsuariosPage(),
          transitionDuration: Duration(milliseconds: 0),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginPage(),
          transitionDuration: Duration(milliseconds: 0),
        ),
      );
    }
  }
}
