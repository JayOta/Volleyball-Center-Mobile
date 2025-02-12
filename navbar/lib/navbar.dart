import 'package:flutter/material.dart';
import 'package:navbar/login.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1366,
        height: 70,
        decoration: BoxDecoration(color: Color(0xFF14276b)),
        child: Center(
          // Centralizando o texto dentro do Container
          child: Row(
            children: [
              SizedBox(width: 20),
              Image.asset("images/logo.png", width: 80, height: 80),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [textCreator("Volleyball"), textCreator("Center")],
              ),
              SizedBox(width: 150),
              Image.asset(
                "images/bell.png",
                color: Colors.white,
                width: 44,
                height: 44,
              ),
            ],
          ),
        ),
      ),
    );
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

  Text textCreatorTitle(String text) {
    return Text(
      text,
      textDirection: TextDirection.ltr,
      style: TextStyle(fontSize: 13.5, color: Colors.blue.shade300),
    );
  }

  Text textCreator(String text) {
    return Text(
      text,
      textDirection: TextDirection.ltr,
      style: TextStyle(fontSize: 15, color: Colors.white),
    );
  }
}
