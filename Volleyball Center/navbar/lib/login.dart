import 'package:flutter/material.dart';
import 'cadastro.dart';

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
            bottom: 100,
            left: 10,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Text(
                "Login",
                style: TextStyle(color: Color(0xFF14276B), fontSize: 40),
              ),
            ),
          ),
          SizedBox(height: 30),
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
                "Login",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                linha(Colors.black),
                SizedBox(
                  width: 5,
                ),
                Text('Ou fazer login com'),
                SizedBox(
                  width: 5,
                ),
                linha(Colors.black),
              ],
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                loginIcon(AssetImage('images/google.png')),
                SizedBox(width: 40),
                loginIcon(AssetImage('images/facebook.png')),
                SizedBox(width: 40),
                loginIcon(AssetImage('images/twitter.png')),
              ],
            ),
          ),
          SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Esqueceu a senha?',
                    style: TextStyle(
                      color: Color(0xFFFCCE00),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Não fez login ainda?',
                        style: TextStyle(color: Color(0xFF14276B))),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Cadastro()),
                        );
                      },
                      child: Text(
                        'Cadastre-se',
                        style: TextStyle(
                            color: Color(0xFF14276B),
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFF14276B)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 80),
                Positioned(
                  child: SizedBox(
                    width: 270,
                    height: 50,
                    child: Text(
                      'Volleyball Center',
                      style: TextStyle(color: Color(0xFF14276B), fontSize: 35),
                    ),
                  ),
                ),
              ],
            ),
          )
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
              width: 0.5,
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
