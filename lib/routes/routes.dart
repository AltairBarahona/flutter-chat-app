import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/loading_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/pages/usuarios_page.dart';
import 'package:flutter/cupertino.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  //function buildcontext muy importante para evitar error, puedo ver qué necesitaba colcoando el ratón sobre
  "usuarios": (_) => UsuariosPage(), //no uso el context en ninguna
  "chat": (_) => ChatPage(),
  "login": (_) => LoginPage(),
  "register": (_) => RegisterPage(),
  "loading": (_) => LoadingPage(),
};
