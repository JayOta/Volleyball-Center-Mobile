// Importe a classe AuthService
import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/main.dart';
import 'package:volleyball_center_mobile/editar_perfil.dart';
import 'package:volleyball_center_mobile/utils/user_utils.dart';
import 'package:volleyball_center_mobile/services/auth_service.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final AuthService _authService = AuthService();

  String nome = "Carregando...";
  String email = "carregando@email.com";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final profile = await UserUtils.getUserProfile();
    if (profile != null && mounted) {
      setState(() {
        nome = profile["name"] ?? UserUtils.getUserDisplayName();
        email = profile["email"] ?? UserUtils.getUserEmail();
      });
    }
  }

  // 🔥 REMOVIDA LÓGICA DE NAVEGAÇÃO INTERNA

  @override
  Widget build(BuildContext context) {
    // 🔥 RETORNA APENAS O CONTEÚDO, SEM SCAFFOLD
    return bodyContent(context);
  }

  Widget bodyContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Conteúdo do Perfil (reintroduzido)
          const SizedBox(height: 80),
          Center(
            child: SizedBox(
              width: 150,
              height: 150,
              child: Image.asset(
                "assets/images/perfil.png",
                fit: BoxFit.fill,
                color: const Color(0xFF14276b),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            nome,
            style: const TextStyle(fontSize: 22, color: Colors.black87),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFF14276B).withOpacity(0.6),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              email,
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          const SizedBox(height: 40),

          // Container dos botões principais
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF14276b),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                // Botão Editar
                ElevatedButton.icon(
                  onPressed: () async {
                    final resultado = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarPerfil(
                          nomeAtual: nome,
                          emailAtual: email,
                        ),
                      ),
                    );
                    if (resultado != null && mounted) {
                      setState(() {
                        nome = resultado["nome"];
                        email = resultado["email"];
                      });
                    }
                  },
                  icon: const Icon(Icons.edit, color: Colors.black, size: 28),
                  label: const Text(
                    "Editar",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 150, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Botão Configurações
                ElevatedButton.icon(
                  onPressed: () {},
                  icon:
                      const Icon(Icons.settings, color: Colors.black, size: 28),
                  label: const Text(
                    "Configurações",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 110, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Botão Carrinho
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_cart,
                      color: Colors.black, size: 28),
                  label: const Text(
                    "Carrinho de compras",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          // Botão Logout (Com a função de logout)
          ElevatedButton.icon(
            onPressed: () async {
              try {
                // Chama o método de logout
                await _authService.signOut();
                print("Logout realizado com sucesso!");

                // Redireciona para o MyApp/AppWidget (e limpa o histórico)
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MyApp()),
                    (Route<dynamic> route) => false,
                  );
                }
              } catch (e) {
                print("Erro ao fazer logout: $e");
                // Opcional: Mostrar um SnackBar de erro
              }
            },
            icon: const Icon(Icons.logout, color: Colors.black),
            label: const Text(
              "Logout",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 219, 58, 46),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 40), // Adiciona um espaço extra no final
        ],
      ),
    );
  }
}
