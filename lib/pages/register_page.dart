import 'package:chat_app/helpers/mostrar_alerta.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/services/auth_service.dart';

import 'package:chat_app/widgets/custom_input.dart';
import 'labels.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:chat_app/widgets/boton_azul.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0XffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 1.1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(titulo: "Registro"),
                  _Form(),
                  Labels(
                    ruta: "login",
                    titulo: "¿si tienes cuenta?",
                    subtitulo: "Ingresa ahora",
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
  final nameController = TextEditingController();
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
            icon: Icons.perm_identity,
            placeholder: "Nombre",
            keyboardType: TextInputType.text,
            textController: nameController,
          ),
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
            text: "Registrar",
            onPressed: authService.autenticando
                ? null
                : () async {
                    print(nameController.text);
                    print(emailController.text);
                    print(passwordController.text);
                    final registroOk = await authService.register(
                      nameController.text.trim(),
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );

                    if (registroOk == true) {
                      //Conectar socket server
                      Navigator.pushReplacementNamed(context, "usuarios");
                    } else {
                      mostrarAlerta(context, "Registro incorrecto", registroOk);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
