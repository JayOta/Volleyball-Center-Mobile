import 'package:flutter/material.dart';

class Fundamentos extends StatefulWidget {
  const Fundamentos({super.key});

  @override
  State<Fundamentos> createState() => _FundamentosState();
}

class _FundamentosState extends State<Fundamentos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text("Origem do vôlei",
                  style: TextStyle(color: Color(0xFF14276B), fontSize: 25)),
            ),
            SizedBox(height: 20.0,),
            Center(
            child: Text("William George Morgan, professor e diretor de Educação Física na Associação Cristã de Moços (ACM), idealizou um jogo em que as probabilidades dos participantes se machucarem, em detrimento de contato físico, fossem baixas. Outro fator importante - e pensado nos jogadores mais velhos - era que o esporte não fosse fisicamente tão exigente."),
           
            ),
          ]
        ),
      ),
    );
  }
  }
