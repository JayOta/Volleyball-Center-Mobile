import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Navbaradmin extends StatelessWidget implements PreferredSizeWidget {
  const Navbaradmin({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
  width: double.infinity,
  height: preferredSize.height,
  color: Colors.black, // fundo preto só pra teste
  child: Center(
    child: SvgPicture.asset(
      'assets/SvgPicture/logo.svg',
      width: 150,
      height: 150,
      fit: BoxFit.contain,
    ),
  ),
);
  }

  @override
  Size get preferredSize => const Size.fromHeight(230); // altura da navbar
}


