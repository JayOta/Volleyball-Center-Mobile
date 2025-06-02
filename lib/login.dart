import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:volleyball_center_mobile/main.dart';
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
            Text(
              "Login",
              style: TextStyle(color: Color(0xFF14276B), fontSize: 40),
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
                  backgroundColor:
                  WidgetStatePropertyAll(Color(0xFF14276B)),
                ),
                onPressed: () {},
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                linha(Colors.black),
                SizedBox(width: 5),
                Text('Ou fazer login com'),
                SizedBox(width: 5),
                linha(Colors.black),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                loginIcon(AssetImage('assets/images/google.png'), 'Google', context),
                SizedBox(width: 20),
                loginIcon(AssetImage('assets/images/facebook.png'), 'Face', context),
              ],
            ),
            SizedBox(height: 40),
            Column(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Esqueceu a senha?',
                    style: TextStyle(color: Color(0xFFFCCE00)),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Não fez login ainda?',
                      style: TextStyle(color: Color(0xFF14276B)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Cadastro()),
                        );
                      },
                      child: Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: Color(0xFF14276B),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF14276B),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Text(
                  'Volleyball Center',
                  style: TextStyle(color: Color(0xFF14276B), fontSize: 35),
                ),
              ],
            )
          ],
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

  Future<void> loginGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = userCredential.user;
      final String? idToken = await user?.getIdToken();

      if (idToken != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      }
    } catch (e) {
      print("Erro no login com Google: $e");
    }
  }

  Container linha(Color cor) {
    return Container(
      width: 100,
      height: 1,
      color: cor,
    );
  }

  Container loginIcon(AssetImage image, String name, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[100],

      ),
      child: TextButton(
        onPressed: () {
          if (name == "Google") {
            loginGoogle(context);
          }
        },
        child: Image(image: image, width: 40, height: 40,),
      ),
    );
  }
}
