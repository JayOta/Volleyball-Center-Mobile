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
          Positioned(
            bottom: 80,
            child: SizedBox(
              width: 100,
              child: Text(
                "Login",
                style: TextStyle(color: Color(0xFF14276B), fontSize: 40),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 15,
          ),
          input('Email'),
          SizedBox(
            height: 18,
          ),
          input('Senha'),
          SizedBox(
            height: 18,
          ),
          SizedBox(
            width: 350,
            height: 50,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Color(0xFF14276B)),
              ),
              onPressed: () {},
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      )),
    );
  }

  SizedBox input(String placeholder) {
    return SizedBox(
      width: 350,
      child: TextField(
        decoration: InputDecoration(
          labelText: placeholder,
          labelStyle: TextStyle(color: Color(0xFF14276B)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(color: Color(0xFF14276B)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(color: Color(0xFF14276B)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(
              color: Color(0xFF14276B),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
