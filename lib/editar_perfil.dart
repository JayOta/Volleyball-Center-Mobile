import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/services/auth_service.dart';

class EditarPerfil extends StatefulWidget {
  final String nomeAtual;
  final String emailAtual;

  const EditarPerfil({
    super.key,
    required this.nomeAtual,
    required this.emailAtual,
  });

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  final AuthService _authService = AuthService();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.nomeAtual);
    _emailController = TextEditingController(text: widget.emailAtual);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _salvarAlteracoes() async {
    setState(() => _loading = true);

    try {
      final novoNome = _nomeController.text.trim();
      final novoEmail = _emailController.text.trim();

      // 🔹 Atualiza o nome no Auth e Firestore
      if (novoNome.isNotEmpty && novoNome != widget.nomeAtual) {
        await _authService.updateDisplayName(novoNome);
      }

      // 🔹 Atualiza o email no Firestore (não dá para mudar diretamente no Auth sem reautenticação)
      if (novoEmail.isNotEmpty && novoEmail != widget.emailAtual) {
        await _authService.updateUserProfile({"email": novoEmail});
      }

      // 🔹 Retorna os dados atualizados para o perfil.dart
      if (mounted) {
        Navigator.pop(context, {"nome": novoNome, "email": novoEmail});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar: $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Perfil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 50),

            // Campo Nome no estilo de botão
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person, color: Colors.black, size: 28),
              label: SizedBox(
                width: 200,
                child: TextField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Digite seu nome",
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Campo Email no estilo de botão
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.email, color: Colors.black, size: 28),
              label: SizedBox(
                width: 200,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Digite seu email",
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Botão Salvar
            ElevatedButton.icon(
              onPressed: _loading ? null : _salvarAlteracoes,
              icon: const Icon(Icons.save, color: Colors.black, size: 28),
              label: _loading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text(
                      "Salvar",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 150, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
