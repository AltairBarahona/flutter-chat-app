import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final IconData icon; //es el ícono que recibiremos
  final String placeholder; //texto que aparecerá como ayuda
  final TextEditingController
      textController; //me permite obtener el valor de la caja de texto actual
  final TextInputType keyboardType; //para modificar el tipo del teclado
  final bool isPassword;

  const CustomInput({
    Key key,
    @required this.icon,
    @required this.placeholder,
    @required this.textController,
    this.keyboardType =
        TextInputType.text, //el teclado aparecerá con vista por defecto
    this.isPassword = false, //solo si lo construyo con true será tipo password
  }) : super(
            key:
                key); //podríamos dejar el key por si ocupamos la referencia a este mismo

  @override
  Widget build(BuildContext context) {
    return Container(
      //impedir que el texto se pegue mucho al borde
      padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: <BoxShadow>[
            //es bueno definir el tipado
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 5),
              blurRadius: 5,
            )
          ]),
      child: TextField(
        obscureText: this.isPassword,
        controller: this.textController,
        autocorrect: false, //no autocompletar
        keyboardType: this.keyboardType, //ver la arroba cuando entro
        decoration: InputDecoration(
          prefixIcon: Icon(this.icon),
          focusedBorder: InputBorder.none, //quita la linea inferior resaltada
          border: InputBorder.none, //quita la linea inferior no resaltada
          hintText: this.placeholder, //texto de ayuda visible
        ),
      ),
    );
  }
}
