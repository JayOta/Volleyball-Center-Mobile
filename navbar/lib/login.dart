import 'package:flutter/material.dart';
import 'package:navbar/main.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Login Page",
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
          SizedBox(
            height: 15,
          ),
          TextButton(
              style:
                  TextButton.styleFrom(backgroundColor: Colors.blue.shade500),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MyApp()));
              },
              child: Text(
                "Voltar",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ))
        ],
      )),
    );
  }
}
