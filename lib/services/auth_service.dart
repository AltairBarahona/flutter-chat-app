import 'dart:convert';
import 'package:chat_app/models/usuario.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/login_response.dart';

class AuthService with ChangeNotifier {
  Usuario usuario;
  bool _autenticando = false;

  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;

  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  //Getters del token de forma estática para no instancear el AuthService
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.delete(key: 'token');
  }

  //Debo tener la información del usuario conectado cuando necesite conocer eso

  Future<bool> login(String email, String password) async {
    //para llamar al notifierListeners
    this.autenticando = true;

    final data = {'email': email, 'password': password};

    final apiUrl = Uri.parse('${Environment.apiUrl}/login');

    final resp = await http.post(
      apiUrl,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    // print(resp.body);
    //Para desbloquear el botóncuando se realizó la autenticación
    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      //TODO: guardar token en lugar seguro
      await this._guardarToken(loginResponse.token);

      //Todo salió bien
      return true;
    } else {
      //Listado con el error o como se desee

      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    this.autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password,
    };

    final apiUrl = Uri.parse('${Environment.apiUrl}/login/new');

    final resp = await http.post(
      apiUrl,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    // print(resp.body);
    //Para desbloquear el botóncuando se realizó la autenticación
    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._guardarToken(loginResponse.token);

      //Todo salió bien
      return true;
    } else {
      //Listado con el error o como se desee
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    // print(token);
    final apiUrl = Uri.parse('${Environment.apiUrl}/login/renew');

    final resp = await http.get(
      apiUrl,
      headers: {'Content-Type': 'application/json', 'x-token': token},
    );

    // print(resp.body);

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._guardarToken(loginResponse.token);

      //Todo salió bien
      return true;
    } else {
      this.logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
