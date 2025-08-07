import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/navbar.dart';


class Admin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: const Navbar(),
      body: Center(
        child: Text('Tu chegou aqui, parça!'),
      ),
    );
  }
}

