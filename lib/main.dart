// ignore_for_file: use_full_hex_values_for_flutter_colors, avoid_unnecessary_containers, sized_box_for_whitespace, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/admin.dart';
import 'package:volleyball_center_mobile/login.dart';
import 'package:volleyball_center_mobile/loja.dart';
import 'package:volleyball_center_mobile/fundamentos.dart';
import 'package:volleyball_center_mobile/menuBar.dart';
import 'package:volleyball_center_mobile/noticias.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:volleyball_center_mobile/services/firestore_service.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'perfil.dart';
import 'package:url_launcher/link.dart';
// Renamed to avoid conflict with the standard dart:io Link class if imported

// 🔥 Importações necessárias para o Firebase
import 'package:volleyball_center_mobile/models/news.dart'; // Garanta que este modelo existe
import 'package:cloud_firestore/cloud_firestore.dart';

// Importando a página Admin e as constantes
import 'package:volleyball_center_mobile/utils/constants.dart'; // Onde ADMIN_UID está definido

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

  // Widget do Botão Admin
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

  // FUNÇÃO DE NAVEGAÇÃO CENTRALIZADA
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
            const Expanded(
              child: Text(
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

  // _buildBody INCLUI A PÁGINA PERFIL (index 4)
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
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentCarouselIndex = 0;

  final FirestoreService _firestoreService = FirestoreService();

  // Future para Produtos em Destaque
  late Future<List<Map<String, dynamic>>> _featuredProductsFuture;

  // Future para Notícias
  late Future<List<News>> _newsFuture;

  @override
  void initState() {
    super.initState();
    // 2. Chame o método na instância
    _newsFuture = _fetchNews();
    _featuredProductsFuture =
        _firestoreService.getFeaturedProducts(4); // ✅ CORREÇÃO 2
  }

  // Função para buscar e converter as notícias (limitando a 9)
  Future<List<News>> _fetchNews() async {
    try {
      final List<Map<String, dynamic>> newsDataList =
          await _firestoreService.getAllNews();
      final List<Map<String, dynamic>> topNine = newsDataList.take(9).toList();
      return topNine.map((data) => News.fromMap(data)).toList();
    } catch (e) {
      print("Erro ao carregar notícias na HomePage: $e");
      return []; // Retorna lista vazia em caso de erro
    }
  }

  // Função auxiliar para formatar o timestamp
  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 30),

          // FutureBuilder para exibir as notícias dinamicamente
          FutureBuilder<List<News>>(
            future: _newsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(50.0),
                  child: CircularProgressIndicator(),
                ));
              } else if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(50.0),
                  child: Text('Nenhuma notícia recente encontrada.',
                      style: TextStyle(color: Colors.grey)),
                ));
              }

              final newsList = snapshot.data!;

              if (newsList.isEmpty) {
                return const SizedBox.shrink();
              }

              final News mainNews = newsList[0];
              final List<News> extraNews = newsList.skip(3).toList();

              return Column(
                children: [
                  TextButton(
                    style: ButtonStyle(
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      // Leva para a página Notícias
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Noticias()));
                    },
                    child: Column(
                      children: [
                        _buildMainCard(mainNews), // Card Principal (índice 0)
                        const SizedBox(height: 10),
                        // Cards Menores (índices 1 e 2, se existirem)
                        if (newsList.length > 1)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Notícia 2 (índice 1)
                              _buildSmallNewsCard(newsList[1]),
                              const SizedBox(width: 16),
                              // Notícia 3 (índice 2) - Só exibe se houver
                              if (newsList.length > 2)
                                _buildSmallNewsCard(newsList[2]),
                            ],
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // FutureBuilder para carregar o carrossel de produtos
                  FutureBuilder<List<Map<String, dynamic>>>(
                      future: _featuredProductsFuture,
                      builder: (context, productSnapshot) {
                        if (productSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            color: const Color(0xFF14276b),
                            height: 400,
                            child: const Center(
                              child: CircularProgressIndicator(
                                  color: Color(0xFFFFCC00)), // Amarelo
                            ),
                          );
                        }
                        if (productSnapshot.hasError ||
                            !productSnapshot.hasData ||
                            productSnapshot.data!.isEmpty) {
                          // Se houver erro ou produtos vazios, exibe mensagem
                          return Container(
                            color: const Color(0xFF14276b),
                            height: 400,
                            child: const Center(
                              child: Text(
                                'Nenhum produto em destaque no momento.',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          );
                        }

                        // Passa a lista de produtos para o carrossel
                        return _buildProductCarouselSection(
                            context, productSnapshot.data!);
                      }),

                  const SizedBox(height: 80),

                  // Área para as 6 notícias extras
                  if (extraNews.isNotEmpty)
                    _buildExtraNewsGrid(context, extraNews),

                  const SizedBox(height: 10),

                  Center(
                    child: Link(
                      uri: Uri.parse(
                          'https://volleyballcenter.infinityfreeapp.com/'),
                      builder: (BuildContext context,
                          Future<void> Function()? followLink) {
                        return ElevatedButton(
                          onPressed: followLink,
                          child: const Text(
                            'Visite nosso site!',
                            style: TextStyle(color: Color(0xFF14276b)),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ]),
      ),
    );
  }

  // Widget para o Card Principal (dinâmico)
  Widget _buildMainCard(News news) {
    final Widget imageWidget =
        news.imageUrl != null && news.imageUrl!.isNotEmpty
            ? Image.network(
                news.imageUrl!,
                width: 342,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/jogo-1.jpg', // Fallback
                  width: 342,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset(
                'assets/images/jogo-1.jpg', // Fallback padrão
                width: 342,
                height: 220,
                fit: BoxFit.cover,
              );

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
              child: imageWidget,
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

            // Texto dinâmico por cima
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Text(
                news.title, // Título dinâmico
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  letterSpacing: 0.2,
                  fontFamily: 'BebasNeue',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  // Widget que contém a imagem do card pequeno (reutilizável)
  Widget _buildSmallNewsCardImage(News news) {
    final Widget imageWidget =
        news.imageUrl != null && news.imageUrl!.isNotEmpty
            ? Image.network(
                news.imageUrl!,
                width: 165,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/jogo-2.jpg', // Fallback
                  width: 165,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset(
                'assets/images/jogo-2.jpg', // Fallback padrão
                width: 165,
                height: 100,
                fit: BoxFit.cover,
              );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageWidget,
    );
  }

  // Widget para os Cards Menores (topo da tela)
  Widget _buildSmallNewsCard(News news) {
    return Column(
      children: [
        // Imagem
        _buildSmallNewsCardImage(news),
        // Título
        Container(
          width: 165,
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            news.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // Widget para construir a grade de 6 notícias
  Widget _buildExtraNewsGrid(BuildContext context, List<News> newsList) {
    if (newsList.isEmpty) return const SizedBox.shrink();

    // Limitamos a 6 cards
    final topSix = newsList.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            "Outros Destaques",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF14276b)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          // Usamos Wrap para quebrar a linha automaticamente, simulando uma Grid
          child: Wrap(
            spacing: 10, // Espaçamento horizontal
            runSpacing: 10, // Espaçamento vertical
            alignment: WrapAlignment.center,
            children: topSix.map((news) {
              return _buildSmallNewsCardWrapper(context, news);
            }).toList(),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // Widget auxiliar para envolver o card pequeno extra, tornando-o clicável e formatado
  Widget _buildSmallNewsCardWrapper(BuildContext context, News news) {
    // Largura fixa que simula duas colunas em dispositivos móveis (165 pixels)
    const double cardWidth = 165;

    return SizedBox(
      width: cardWidth,
      child: TextButton(
        onPressed: () {
          // Ação de clique: levar para a página de notícias (Noticias)
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Noticias()));
        },
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          overlayColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem
            _buildSmallNewsCardImage(news),
            const SizedBox(height: 4),
            // Título
            Text(
              news.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            // Data
            Text(
              _formatTimestamp(news.createdAt),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Widget que engloba a seção de carrossel de produtos
  Widget _buildProductCarouselSection(
      BuildContext context, List<Map<String, dynamic>> products) {
    return Container(
      color: const Color(0xFF14276b), // Cor Azul Marinho
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 40, bottom: 20),
            child: Text(
              'OFERTAS DA SEMANA!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Carrossel de Produtos
          _imageCarousel(context, products),

          // Botão Chamar para Loja
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: TextButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6))),
                  backgroundColor:
                      const WidgetStatePropertyAll(Color(0xffffcce00)),
                ),
                onPressed: () {
                  // Navega para a tela da Loja
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Loja()));
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: Text(
                    'VER TODOS OS PRODUTOS',
                    style: TextStyle(
                        color: Color(0xFF14276b),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ATUALIZADO: Widget de Carrossel de Imagens (agora recebe produtos do Firebase)
  Widget _imageCarousel(
      BuildContext context, List<Map<String, dynamic>> products) {
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
          // Mapeia os dados do produto para os itens do carrossel
          items: products.map((product) {
            return Builder(
              builder: (BuildContext context) {
                // Torna o card clicável
                return GestureDetector(
                  onTap: () {
                    // Navega para a Loja ao clicar no card
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Loja()));
                  },
                  child: Container(
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
                      // Exibe a imagem do banco (NetworkImage) ou fallback
                      child: product['image_url'] != null
                          ? Image.network(
                              product['image_url'],
                              fit: BoxFit.cover,
                              width: 400,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/images/meias-nike.png', // Fallback (Você pode usar um asset genérico)
                                fit: BoxFit.cover,
                                width: 400,
                              ),
                            )
                          : Image.asset(
                              'assets/images/meias-nike.png', // Fallback padrão
                              fit: BoxFit.cover,
                              width: 400,
                            ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        // Indicadores do Carrossel (Dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: products.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () =>
                  {}, // Mantido como um ponto visual, sem ação de clique aqui
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

  // Removido: textCreator
  // Removido: buttonCreator (pois o botão foi incorporado ao _buildProductCarouselSection)
}
// Removido: centerContainer (foi substituído pelo _buildProductCarouselSection)
