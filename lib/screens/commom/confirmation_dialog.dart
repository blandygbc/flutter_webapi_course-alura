import 'package:flutter/material.dart';

Future<dynamic> showConfirmationDialog(
  BuildContext context, {
  String title = "Atenção!",
  String content = "Deseja realmente continuar?",
  String affirmativeOption = "Confirmar",
  bool haveCancel = true,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (haveCancel)
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancelar')),
          TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                affirmativeOption.toUpperCase(),
                style: const TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      );
    },
  );
}
