import 'package:flutter/material.dart';
import 'navbar.dart';

class Cadastro extends StatelessWidget {
  const Cadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Positioned(
              bottom: 100,
              left: 20,
              child: SizedBox(
                width: 140,
                height: 35,
                child: Text(
                  "Cadastro",
                  style: TextStyle(color: Color(0xFF14276B), fontSize: 30),
                ),
              ),
            ),
            SizedBox(height: 50),
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
                onPressed: () {},
                child: Text(
                  "Cadastrar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
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

  Container linha(Color cor) {
    return Container(
      width: 100,
      height: 1,
      color: cor,
    );
  }

  Container loginIcon(AssetImage image) {
    return Container(
        width: 65,
        height: 35,
        decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(221, 70, 70, 70),
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(5)),
        child: TextButton(
          onPressed: () {},
          child: Image(
            image: image,
          ),
        ));
  }
}