import 'package:flutter/material.dart';

class Noticias extends StatefulWidget {
  const Noticias({super.key});

  @override
  State<Noticias> createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("Notícias"),
          )
        ],
      ),
    );
  }

  Text textCreator(String text) {
    return Text(
      text,
      textDirection: TextDirection.ltr,
      style: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
    );
  }
}
