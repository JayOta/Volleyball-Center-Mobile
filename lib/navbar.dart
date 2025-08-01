import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/main.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: preferredSize.height, // Usa a altura definida
      decoration: const BoxDecoration(color: Color(0xFF14276b)),
      child: Center(
        child: Row(
          children: [
            const SizedBox(width: 10),
            SizedBox(
              width: 100,
              height: 80,
              child: TextButton(
                style: ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => MyApp()));
                },
                child: Image.asset("images/logo.png", width: 50, height: 50),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [textCreator("Volleyball"), textCreator("Center")],
            ),
            const SizedBox(width: 175),
            Image.asset(
              "assets/images/bell.png",
              color: Colors.white,
              width: 44,
              height: 44,
            ),
          ],
        ),
      ),
    );
  }

  Text textCreator(String text) {
    return Text(
      text,
      textDirection: TextDirection.ltr,
      style: const TextStyle(fontSize: 15, color: Colors.white),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(70); // Define o tamanho da navbar
}
