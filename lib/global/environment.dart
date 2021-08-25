//clase solo con métodos estáticos

import 'dart:io';

class Environment {
  //Platform del paquete dart:io NO DEL HTML
  //Servicios REST
  static String apiUrl = Platform.isAndroid
      ? 'http://10.0.2.2:3000/api'
      : 'http://localhost:3000/api';

  //Servidor de sockets solo con la referencia al puerto
  static String socketUrl =
      Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';
}
