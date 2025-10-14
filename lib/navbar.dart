// navbar.dart - VERSÃO FINAL CORRIGIDA

import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/main.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    // A flag 'automaticallyImplyLeading' do Scaffold/AppBar controla a seta de voltar.
    // O AppBar padrão adiciona o botão de voltar se a página puder voltar (canPop).
    // Ao usar um widget customizado, o controle é mais manual.

    return AppBar(
      // Usamos o AppBar padrão e apenas customizamos o 'title' e 'actions'.
      // Isso permite que o Flutter adicione o botão de voltar automaticamente
      // (a seta) se a tela não for a raiz.
      automaticallyImplyLeading:
          true, // Padrão: mostra a seta se não for a primeira tela

      // Cor de fundo
      backgroundColor: const Color(0xFF14276b),

      // Remove a sombra para ficar mais flat (opcional, mas comum)
      elevation: 0,

      // Define a altura para a que você queria
      toolbarHeight: preferredSize.height,

      // 1. Title: Contém a logo e o texto "Volleyball Center"
      title: Row(
        mainAxisSize: MainAxisSize.min, // Ocupa apenas o espaço necessário
        children: [
          // Logo (Ajustado o tamanho para se adequar ao AppBar)
          SizedBox(
            width: 50,
            height: 50,
            child: TextButton(
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                padding: WidgetStateProperty.all(EdgeInsets.zero),
              ),
              onPressed: () {
                // Navega para a tela principal (MyApp), limpando a pilha.
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MyApp()),
                  (Route<dynamic> route) => false,
                );
              },
              child: SvgPicture.asset(
                "SvgPicture/logo.svg",
                width: 40,
                height: 40,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Texto "Volleyball Center"
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [textCreator("Volleyball"), textCreator("Center")],
          ),
        ],
      ),

      // 2. Actions: Contém o sino (e futuros ícones à direita)
      actions: [
        Image.asset(
          "assets/images/bell.png",
          color: Colors.white,
          width: 30, // Reduzido o tamanho para não causar overflow
          height: 30,
        ),
        const SizedBox(width: 10), // Padding à direita
      ],

      // 3. Leading (Botão de Voltar): O Flutter cuida disso!
      // Se 'automaticallyImplyLeading: true', o botão de voltar (seta)
      // será inserido automaticamente à esquerda do 'title'.
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
      const Size.fromHeight(70); // Mantém o tamanho da navbar
}
