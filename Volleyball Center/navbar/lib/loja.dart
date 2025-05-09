import 'package:flutter/material.dart';

class Loja extends StatefulWidget {
  const Loja({super.key});

  @override
  State<Loja> createState() => _LojaState();
}

class _LojaState extends State<Loja> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0,),
          Center(child: Text("Loja",
              style: TextStyle(color: Color(0xFF14276B), fontSize: 25)),),
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
