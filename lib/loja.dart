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
      body: SingleChildScrollView( 
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0),
          Center(
            child: Text(
              "Catálago de produtos",
              style: TextStyle(color: Color(0xFF14276B), fontSize: 25),
            ),
          ),
          
          SizedBox(height: 20.0),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,  
              crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              imageAlign('assets/images/bola.jpg', 'assets/images/manguito.jpg'),
               SizedBox(height: 30,),
               imageAlign('assets/images/tenis.jpg', 'assets/images/joelheira.jpg'),
                SizedBox(height: 30,),
               ],
          ),
          ), 
        ],
      ),
      ),
    );
  }
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
  Row imageAlign(String imagem, String imagem2) {
    return Row(
      children: [
        Image.asset(imagem, width: 160, height: 160,),
        SizedBox(width: 60,),
        Image.asset(imagem2, width: 160, height: 160,),
      ],
    );
  }
  