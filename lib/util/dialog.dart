import 'package:flutter/material.dart';

void showSuccessDialog(BuildContext context,String title,String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
            },
          ),
        ],
      );
    },
  );
}