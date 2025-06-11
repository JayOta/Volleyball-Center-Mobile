import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/navbar.dart';

class Rodizios extends StatefulWidget {
  const Rodizios({super.key});

  @override
  State<Rodizios> createState() => _RodiziosState();
}

class _RodiziosState extends State<Rodizios> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text("Sistemas de rodízios",
                  style: TextStyle(color: Color(0xFF14276B), fontSize: 25)),
            ),
               container("Rodízio 6x0",
                "No Rodízio 6x0..."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/rod-6x0.jpg')),
            ),
                  container("Rodízio 6x0 com infiltração",
                "No Rodízio 6x0 com infiltraçao..."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/rod-6x0-infiltracao.jpg')),
            ),
                container("Rodízio 5x1",
                "No Rodízio 5x1..."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/rod-5x1.jpg')),
            ),
            container("Rodízio 4x2",
                "No Rodízio 4x2..."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/rod-4x2.jpg')),
            ),
               container("Rodízio 4x2 com líbero",
                "No Rodízio 4x2 com líbero..."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/rod-4x2-libero.jpg')),
            ),
                container("Rodízio 4x2 com infiltração",
                "No Rodízio 4x2 com infiltração..."),
            Center(
              child: Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('images/rod-4x2-infiltracao.jpg')),
            ),
          ]
      ),
    );
  }
  }
  
Column container(String titulo, String texto) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 16.0),
        child: Text(
          titulo,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Padding(
        padding: EdgeInsets.only(left: 16.0, right: 30.0),
        child: Text(
          texto,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14),
        ),
      ),
  
    ],
  );
}
