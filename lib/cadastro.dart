import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/main.dart';

class Cadastro extends StatelessWidget {
  const Cadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Cadastro",
                style: TextStyle(color: Color(0xFF14276B), fontSize: 40),
              ),
              SizedBox(height: 30),
              input('Usuário'),
              SizedBox(height: 18),
              input('Email'),
              SizedBox(height: 18),
              input('Senha'),
              SizedBox(height: 18),
              SizedBox(
                width: 350,
                height: 50,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xFF14276B)),
                  ),
                  onPressed: () {
                    // Aqui você pode adicionar a lógica de cadastro com Firebase ou outro backend
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  },
                  child: Text(
                    "Cadastrar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Volta para o login
                },
                child: Text(
                  'Já tem uma conta? Fazer login',
                  style: TextStyle(
                    color: Color(0xFF14276B),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF14276B),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Text(
                'Volleyball Center',
                style: TextStyle(color: Color(0xFF14276B), fontSize: 35),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox input(String placeholder) {
    return SizedBox(
      width: 350,
      child: TextField(
        obscureText: placeholder == 'Senha',
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
            borderSide: BorderSide(color: Color(0xFF14276B), width: 2),
          ),
        ),
      ),
    );
  }
}
