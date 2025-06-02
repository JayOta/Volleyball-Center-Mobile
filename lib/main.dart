import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/fundamentos.dart';
import 'package:volleyball_center_mobile/login.dart';
import 'package:volleyball_center_mobile/loja.dart';
import 'package:volleyball_center_mobile/menuBar.dart';
import 'package:volleyball_center_mobile/navbar.dart';
import 'package:volleyball_center_mobile/noticias.dart';
//import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();  Inicializa o Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppWidget(title: 'Volleyball Center'), // Ajuste aqui
    );
  }
}

class AppWidget extends StatefulWidget {
  final String title;

  const AppWidget({super.key, required this.title});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  int _currentIndex = 2; // Página inicial padrão

  final List<Widget> _pages = [
    Fundamentos(),
    Noticias(),
    HomePage(),
    Loja(),
    Login(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      body: Center(
        child: _pages[_currentIndex],
      ), // Exibe a página selecionada
      bottomNavigationBar: MenuBarFile(onItemSelected: _onItemSelected),
    );
  }
}

// Exemplo de páginas (substitua pelas suas próprias páginas)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          color: Color(0xFFFFCCE00),
          width: double.infinity,
          height: 100,
        ), // Barra amarela
        SizedBox(
          height: 20,
        ),
        Container(
          width: 330,
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 2,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Imagem com borderRadius
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'images/jogo-3.jpg',
                  width: 330,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),

              // Overlay escuro com mesma borda
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 330,
                  height: 220,
                  color: Colors.black.withOpacity(0.3),
                ),
              ),

              // Texto por cima
              Positioned(
                bottom: 30,
                left: 10,
                right: 10,
                child: Text(
                  'Brasil bate Coreia do Sul e pega EUA na final do vôlei feminino!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'BebasNeue',
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  Text textCreator(String text) {
    return Text(text,
        textDirection: TextDirection.ltr,
        style: TextStyle(
          fontSize: 20,
          color: Colors.blue.shade300,
        ));
  }

  TextButton buttonCreator(String text, BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Login()));
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          Colors.transparent,
        ),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        side:
        WidgetStatePropertyAll(BorderSide(color: Colors.white, width: 1.8)),
      ),
      child: Text(
        text,
        textDirection: TextDirection.ltr,
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }
}
