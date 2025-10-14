// ignore_for_file: use_full_hex_values_for_flutter_colors, avoid_unnecessary_containers, sized_box_for_whitespace, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/admin.dart';
import 'package:volleyball_center_mobile/login.dart';
import 'package:volleyball_center_mobile/loja.dart';
import 'package:volleyball_center_mobile/fundamentos.dart';
import 'package:volleyball_center_mobile/menuBar.dart';
import 'package:volleyball_center_mobile/navbar.dart';
import 'package:volleyball_center_mobile/noticias.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'perfil.dart';

// NOVO: Importando a página Admin e as constantes
import 'package:volleyball_center_mobile/utils/constants.dart'; // Certifique-se que este arquivo exista

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppWidget(title: 'Volleyball Center'),
    );
  }
}

class AppWidget extends StatefulWidget {
  final String title;

  const AppWidget({super.key, required this.title});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  int _selectedIndex = 2; // Página inicial padrão (Home)

  // --- Lógica de Verificação de Admin ---
  bool _isAdmin() {
    final currentUser = FirebaseAuth.instance.currentUser;
    // Retorna true se estiver logado E o UID corresponder ao UID Admin
    return currentUser != null && currentUser.uid == ADMIN_UID;
  }

  // NOVO: Widget do Botão Admin
  Widget _buildAdminButton(BuildContext context) {
    if (_isAdmin()) {
      return IconButton(
        icon: const Icon(Icons.admin_panel_settings,
            color: Colors.white, size: 28),
        tooltip: 'Acesso Admin',
        onPressed: () {
          // Navega para a tela de Administração
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Admin()),
          );
        },
      );
    }
    return const SizedBox.shrink(); // Não mostra nada se não for Admin
  }
  // ----------------------------------------

  // 🔥 FUNÇÃO DE NAVEGAÇÃO CENTRALIZADA
  void _onItemSelected(int index) {
    // Se for o ícone de Perfil (index 4)
    if (index == 4) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Usuário logado: troca o body para a tela Perfil
        setState(() {
          _selectedIndex = index;
        });
      } else {
        // Usuário não logado: navega para a tela de Login (push, não troca o body)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    } else {
      // Para outras páginas (0, 1, 2, 3), troca o body normalmente
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar é persistente
      appBar: AppBar(
        backgroundColor: const Color(0xFF14276b), // Cor azul (Cor da Navbar)
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png', // Ajuste para o caminho da sua logo
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: const Text(
                'Volleyball Center',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          _buildAdminButton(context), // Botão Admin condicional
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications_none, color: Colors.white),
          ),
        ],
      ),
      // Body muda conforme o item selecionado
      body: _buildBody(_selectedIndex),
      // bottomNavigationBar é persistente
      bottomNavigationBar: MenuBarFile(onItemSelected: _onItemSelected),
    );
  }

  // 🔥 _buildBody AGORA INCLUI A PÁGINA PERFIL (index 4)
  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return Fundamentos();
      case 1:
        return Noticias();
      case 2:
        return HomePage();
      case 3:
        return Loja();
      case 4:
        return const Perfil(); // Retorna o widget Perfil diretamente no body
      default:
        return Container();
    }
  }
}

// Exemplo de páginas (substitua pelas suas próprias páginas)
class HomePage extends StatefulWidget {
//... (Mantenha o código da HomePage, _HomePageState, mainCard, imageCarousel, etc. abaixo)
//...
//...
//...
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          TextButton(
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Noticias()));
            },
            child: Column(
              children: [
                mainCard(),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/images/jogo-2.jpg",
                        width: 165,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/images/jogo-3.jpg",
                        width: 165,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          const SizedBox(
            height: 80,
          ),
          // centerContainer(),
          Container(
            color: const Color(0xFF14276b),
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 53), // ajuste esse valor como quiser
                  child: SizedBox(
                    width: 300, // aumentei um pouco para caber melhor
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'Meias Nike ',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: 'por apenas ',
                            style: TextStyle(color: Colors.amber),
                          ),
                          TextSpan(
                            text: 'R\$60,00!!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                imageCarousel([
                  "assets/images/viseira-nike.png",
                  "assets/images/tenis.jpg",
                  "assets/images/meias.jpg",
                  "assets/images/meias-nike.png",
                ]),
              ],
            ),
          ),
          const SizedBox(
            height: 80,
          ),

          const Text(
            "Mais conteúdo em breve..",
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  Text textCreator(String text) {
    return Text(text,
        textDirection: TextDirection.ltr,
        style: TextStyle(
          fontSize: 20,
          color: Colors.blue.shade300,
        ));
  }

  Widget imageCarousel(List<String> urls) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.8,
            onPageChanged: (index, reason) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
          ),
          items: urls.map((imagePath) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.50),
                        blurRadius: 6,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: 400,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: urls.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () =>
                  {}, // você pode adicionar funcionalidade aqui se quiser
              child: Container(
                width: 10.0,
                height: 10.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentCarouselIndex == entry.key
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  TextButton buttonCreator(String text, BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Login()));
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          Colors.transparent,
        ),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        side: const WidgetStatePropertyAll(
            BorderSide(color: Colors.white, width: 1.8)),
      ),
      child: Text(
        text,
        textDirection: TextDirection.ltr,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }
}

Container centerContainer() {
  return Container(
    color: const Color(0xFF14276b),
    width: double.infinity,
    height: 300,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 200,
                child: Text(
                  'VENHA VER NOSSOS PRODUTOS!',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Wrap(
                children: [
                  Text(
                    'Meias Nike ',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  Text(
                    'por apenas ',
                    style: TextStyle(color: Color(0xffffcce00), fontSize: 17),
                  ),
                ],
              ),
              const Text(
                'RS60,00!!',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6))),
                    backgroundColor:
                        const WidgetStatePropertyAll(Color(0xffffcce00)),
                  ),
                  onPressed: () {},
                  child: const Text('Saiba mais')),
            ],
          ),
        ), //
        const Spacer(),
        Container(
          child: Image.asset(
            "assets/images/jogo-3.jpg",
            width: 280,
            height: 300,
            fit: BoxFit.cover,
          ),
        ),
      ],
    ),
  );
}

Column mainCard() {
  return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
    Container(
      width: 342,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Imagem com borderRadius
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/jogo-1.jpg',
              width: 342,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),

          // Overlay escuro com mesma borda
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 342,
              height: 220,
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // Texto por cima
          const Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Text(
              'Brasil bate Coreia do Sul e pega EUA na final do vôlei feminino!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                letterSpacing: 0.2,
                fontFamily: 'BebasNeue',
              ),
            ),
          ),
        ],
      ),
    ),
  ]);
}
