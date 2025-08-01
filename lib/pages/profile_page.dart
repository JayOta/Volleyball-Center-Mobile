import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volleyball_center_mobile/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      print('ProfilePage: Carregando dados do usuário...'); // Debug log

      if (_authService.currentUser == null) {
        print('ProfilePage: Usuário não está logado'); // Debug log
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Tenta pegar dados do Firestore, mas não quebra se não conseguir
      try {
        final profile = await _authService.getUserProfile();
        print('ProfilePage: Dados do Firestore: $profile'); // Debug log

        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
      } catch (e) {
        print(
            'ProfilePage: Erro ao carregar Firestore (não é crítico): $e'); // Debug log

        // Mesmo se der erro no Firestore, continua sem os dados
        setState(() {
          _userProfile = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('ProfilePage: Erro geral ao carregar dados: $e'); // Debug log

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pegar usuário atual do Authentication
    final User? currentUser = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: const Color(0xFF14276B),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card do usuário
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dados do Authentication:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF14276B),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow('UID:', currentUser?.uid ?? 'N/A'),
                          _buildInfoRow('Email:', currentUser?.email ?? 'N/A'),
                          _buildInfoRow('Display Name:',
                              currentUser?.displayName ?? 'N/A'),
                          _buildInfoRow(
                              'Email Verificado:',
                              currentUser?.emailVerified == true
                                  ? 'Sim'
                                  : 'Não'),
                          _buildInfoRow(
                              'Criado em:',
                              currentUser?.metadata.creationTime?.toString() ??
                                  'N/A'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Card dos dados do Firestore
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dados do Firestore:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF14276B),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (_userProfile != null) ...[
                            _buildInfoRow(
                                'Nome:', _userProfile!['name'] ?? 'N/A'),
                            _buildInfoRow(
                                'Email:', _userProfile!['email'] ?? 'N/A'),
                            _buildInfoRow(
                                'UID:', _userProfile!['uid'] ?? 'N/A'),
                            _buildInfoRow(
                                'Ativo:',
                                _userProfile!['isActive'] == true
                                    ? 'Sim'
                                    : 'Não'),
                            _buildInfoRow(
                                'Criado em:',
                                _userProfile!['createdAt']
                                        ?.toDate()
                                        ?.toString() ??
                                    'N/A'),
                            _buildInfoRow(
                                'Atualizado em:',
                                _userProfile!['updatedAt']
                                        ?.toDate()
                                        ?.toString() ??
                                    'N/A'),
                          ] else ...[
                            const Text('Nenhum dado encontrado no Firestore'),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Exemplos de uso dos dados
                  Card(
                    elevation: 4,
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Exemplos de Uso:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF14276B),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Exemplo 1: Saudação
                          _buildExampleCard(
                            'Saudação Personalizada:',
                            'Bem-vindo, ${_userProfile?['name'] ?? currentUser?.displayName ?? 'Usuário'}!',
                            Icons.waving_hand,
                          ),

                          // Exemplo 2: Status da conta
                          _buildExampleCard(
                            'Status da Conta:',
                            'Conta ${currentUser?.emailVerified == true ? 'verificada' : 'não verificada'}',
                            currentUser?.emailVerified == true
                                ? Icons.verified
                                : Icons.warning,
                          ),

                          // Exemplo 3: Tempo de uso
                          _buildExampleCard(
                            'Membro desde:',
                            _formatDate(currentUser?.metadata.creationTime),
                            Icons.calendar_today,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Botão de logout
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () async {
                        await _authService.signOut();
                        if (mounted) {
                          Navigator.of(context).pushReplacementNamed('/login');
                        }
                      },
                      child: const Text(
                        'Fazer Logout',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(String title, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF14276B), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Data não disponível';
    return '${date.day}/${date.month}/${date.year}';
  }
}
