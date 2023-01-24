import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/constants/app_constants.dart';
import 'package:flutter_webapi_first_course/screens/commom/confirmation_dialog.dart';
import 'package:flutter_webapi_first_course/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final AuthService service = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(32),
        decoration:
            BoxDecoration(border: Border.all(width: 8), color: Colors.white),
        child: Form(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(
                    Icons.bookmark,
                    size: 64,
                    color: Colors.brown,
                  ),
                  const Text(
                    "Simple Journal",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text("por Alura",
                      style: TextStyle(fontStyle: FontStyle.italic)),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(thickness: 2),
                  ),
                  const Text("Entre ou Registre-se"),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      label: Text("E-mail"),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    controller: _passController,
                    decoration: const InputDecoration(label: Text("Senha")),
                    keyboardType: TextInputType.visiblePassword,
                    maxLength: 16,
                    obscureText: true,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await login(context);
                      },
                      child: const Text("Continuar")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    final String email = _emailController.text;
    final String password = _passController.text;

    try {
      service.login(email: email, password: password).then((isLogedIn) {
        if (isLogedIn) {
          Navigator.of(context).pushReplacementNamed(routeHomeScreen);
        }
      });
    } on UserNotFoundException {
      log("usuário não encontrado");
      showConfirmationDialog(
        context,
        content:
            "Não encontramos esse usuário.\nDeseja criar um novo usuário usando o e-mail $email e a senha inserida?",
        affirmativeOption: "Criar",
      ).then((value) async {
        if (value != null && value) {
          try {
            service
                .register(email: email, password: password)
                .then((isRegistered) {
              if (isRegistered) {
                Navigator.of(context).pushReplacementNamed(routeHomeScreen);
              }
            });
          } catch (e) {
            log("Erro de registro não esperado");
            log('$e');
          }
        }
      });
    } catch (e) {
      log("Erro de login não esperado");
      log('$e');
    }
  }
}
