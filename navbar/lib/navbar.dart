import 'package:flutter/material.dart';
import 'package:navbar/login.dart';
import 'package:navbar/navigationBar.dart';

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
        height: 60,
        color: Color.fromARGB(255, 248, 202, 1),
        child: Center(
          // Centralizando o texto dentro do Container
          child: Row(
            children: [
              SizedBox(width: 5),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NavigationBarFile()));
                  },
                  style: ButtonStyle(),
                  child: Image.asset("images/menu.png", width: 30, height: 40)),
              SizedBox(width: 10),
              Image.asset("images/logo-volei.png", width: 44, height: 44),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [textCreator("Volleyball"), textCreator("Center")],
              ),
              SizedBox(width: 120),
              buttonCreator("Login", context)
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
      style: TextStyle(fontSize: 13.5, color: Colors.blue.shade300),
    );
  }
}
