import 'package:flutter/material.dart';
import 'package:navbar/menuBar.dart';

class Fundamentos extends StatefulWidget {
  const Fundamentos({super.key});

  @override
  State<Fundamentos> createState() => _FundamentosState();
}

class _FundamentosState extends State<Fundamentos> {
  @override
  Widget build(BuildContext context) {
    return Text('Oi');
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
