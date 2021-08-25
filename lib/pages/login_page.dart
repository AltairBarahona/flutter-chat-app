import 'package:chat_app/widgets/boton_azul.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';

import 'labels.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/helpers/mostrar_alerta.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0XffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(titulo: "Messenger"),
                  _Form(),
                  Labels(
                    ruta: "register",
                    titulo: "¿No tienes cuenta?",
                    subtitulo: "Crear una ahora",
                  ),
                  Text(
                    "Términos y condiciones",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: "Correo",
            keyboardType: TextInputType.emailAddress,
            textController: emailController,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: "Password",
            textController: passwordController,
            isPassword: true,
          ),
          BotonAzul(
            text: "Ingresar",
            onPressed: authService.autenticando
                ? null
                : () async {
                    //quita el foco de donde esté o cierra el teclado
                    FocusScope.of(context).unfocus();

                    //Guardo el return en una variable
                    final loginOk = await authService.login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );

                    if (loginOk) {
                      //TODO: Conectar a nuestro socket server
                      //TODO: Navegar a otra pantalla, sockets, etc
                      Navigator.pushReplacementNamed(context, "usuarios");
                    } else {
                      mostrarAlerta(context, "Login incorrecto",
                          "Revise sus credenciales nuevamente");
                    }
                  },
          ),
        ],
      ),
    );
  }
}
