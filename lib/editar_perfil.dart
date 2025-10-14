import 'package:flutter/material.dart';
import 'package:volleyball_center_mobile/menuBar.dart';
import 'package:volleyball_center_mobile/navbar.dart';
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
  final int _selectedIndex = 4;

  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _novaSenhaController;

  final AuthService _authService = AuthService();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.nomeAtual);
    _emailController = TextEditingController(text: widget.emailAtual);
    _novaSenhaController = TextEditingController();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _novaSenhaController.dispose();
    super.dispose();
  }

  // NOVO MÉTODO 1: Diálogo para pedir a senha atual para reautenticação
  Future<String?> _showReauthDialog() async {
    final TextEditingController senhaController = TextEditingController();

    // Limpa a tela de loading antes de mostrar o diálogo
    if (_loading && mounted) setState(() => _loading = false);

    return showDialog<String>(
      context: context,
      barrierDismissible: false, // Força o usuário a interagir
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmação de Segurança'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                    'Sua sessão expirou. Por favor, digite sua senha atual para confirmar a alteração.'),
                const SizedBox(height: 20),
                TextField(
                  controller: senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha Atual',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop(null); // Retorna null
              },
            ),
            ElevatedButton(
              child: const Text('Confirmar'),
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(senhaController.text); // Retorna a senha digitada
              },
            ),
          ],
        );
      },
    ).then((result) {
      senhaController.dispose();
      // Liga o loading novamente ao retornar para a função principal
      if (mounted) setState(() => _loading = true);
      return result;
    });
  }

  // MÉTODO ATUALIZADO: Lógica de salvar com reautenticação
  Future<void> _salvarAlteracoes() async {
    if (_loading) return;
    setState(() => _loading = true);

    final novoNome = _nomeController.text.trim();
    final novoEmail = _emailController.text.trim();
    final novaSenha = _novaSenhaController.text;

    // Variável para rastrear se uma alteração sensível (que requer reautenticação) ocorreu
    bool requiresSensitiveChange =
        (novaSenha.isNotEmpty || novoEmail != widget.emailAtual);
    bool reauthNeeded = false;

    try {
      // 1. Tenta salvar as alterações (bloco interno)
      try {
        // Atualizar Nome (Não precisa de reautenticação)
        if (novoNome.isNotEmpty && novoNome != widget.nomeAtual) {
          await _authService.updateUserName(novoNome);
        }

        // 2. Atualizar Email
        if (novoEmail.isNotEmpty && novoEmail != widget.emailAtual) {
          await _authService.updateUserEmail(novoEmail);
        }

        // 3. Atualizar Senha
        if (novaSenha.isNotEmpty) {
          if (novaSenha.length < 6) {
            throw 'A nova senha deve ter pelo menos 6 caracteres.';
          }
          await _authService.updatePassword(novaSenha);
        }
      } on Exception catch (e) {
        // Captura o erro 'requires-recent-login'
        if (requiresSensitiveChange &&
            e.toString().contains('requires-recent-login')) {
          reauthNeeded = true;
        } else {
          // Relança outros erros (senha fraca, email inválido, etc.)
          rethrow;
        }
      }

      // 4. Se a reautenticação for necessária, mostra o diálogo
      if (reauthNeeded) {
        final currentPassword = await _showReauthDialog();

        if (currentPassword != null && currentPassword.isNotEmpty) {
          // Tenta reautenticar (usando o método que adicionamos no AuthService)
          await _authService.reauthenticateUser(currentPassword);

          // Se a reautenticação foi bem-sucedida, tenta a operação original novamente
          // Usamos 'return' para evitar que o código de sucesso/finally seja executado duas vezes
          return _salvarAlteracoes();
        } else {
          throw 'Reautenticação cancelada. As alterações não foram salvas.';
        }
      }

      // 5. Se chegou aqui sem erro nem reautenticação, é sucesso!
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Perfil atualizado com sucesso!")));
        Navigator.pop(context, {"nome": novoNome, "email": novoEmail});
      }
    } catch (e) {
      // Tratamento de erro final (para erros de autenticação, senha fraca, etc.)
      String errorMessage;
      if (e is String) {
        errorMessage = e;
      } else if (e.toString().contains(']')) {
        errorMessage = e.toString().split(']')[1].trim();
      } else {
        errorMessage = 'Erro desconhecido: ${e.toString()}';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao salvar: $errorMessage")),
        );
      }
    } finally {
      // O 'finally' garante que o loading seja desligado, a menos que estejamos
      // no meio de uma tentativa de reautenticação (que chamará _salvarAlteracoes novamente).
      if (mounted) {
        _novaSenhaController.clear();
        setState(() => _loading = false);
      }
    }
  }

  void _onItemSelected(int index) {
    if (index != 4) {
      Navigator.pop(context);
    }
  }

  // ... (buildProfileField e bodyContent permanecem inalterados)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      bottomNavigationBar: MenuBarFile(onItemSelected: _onItemSelected),
      body: bodyContent(context),
    );
  }

  // Novo Widget Auxiliar para simplificar a criação dos campos
  Widget buildProfileField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.black, size: 28),
      label: SizedBox(
        width: 200,
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
          ),
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget bodyContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Editar Perfil",
              style: TextStyle(
                fontSize: 28,
                color: Color(0xFF14276b),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Imagem de perfil
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

            const SizedBox(height: 30),

            // 🔹 Campo Nome
            buildProfileField(
              controller: _nomeController,
              icon: Icons.person,
              hintText: "Nome de Usuário",
            ),

            const SizedBox(height: 20),

            // 🔹 Campo Email
            buildProfileField(
              controller: _emailController,
              icon: Icons.email,
              hintText: "Email",
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 40),

            // Título para Alterar Senha
            const Text(
              "Mudar Senha (Opcional)",
              style: TextStyle(
                fontSize: 22,
                color: Color(0xFF14276b),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // ⚠️ Campo Nova Senha
            buildProfileField(
              controller: _novaSenhaController,
              icon: Icons.lock,
              hintText: "Nova Senha",
              isPassword: true,
            ),

            const SizedBox(height: 40),

            // 🔹 Botão Salvar
            ElevatedButton.icon(
              onPressed: _loading ? null : _salvarAlteracoes,
              icon: _loading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2,
                      ))
                  : const Icon(Icons.save, color: Colors.black, size: 28),
              label: _loading
                  ? const Text("Salvando...",
                      style: TextStyle(color: Colors.black, fontSize: 20))
                  : const Text(
                      "Salvar",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffffcce00),
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
