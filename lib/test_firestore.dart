import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TestFirestore extends StatefulWidget {
  const TestFirestore({super.key});

  @override
  State<TestFirestore> createState() => _TestFirestoreState();
}

class _TestFirestoreState extends State<TestFirestore> {
  String _status = 'Testando...';
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _runTests();
  }

  void _addLog(String message) {
    setState(() {
      _logs.add(message);
    });
    print(message);
  }

  Future<void> _runTests() async {
    try {
      _addLog('=== INICIANDO TESTES ===');
      
      // Teste 1: Verificar Firebase Auth
      _addLog('1. Testando Firebase Auth...');
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        _addLog('✅ Usuário logado: ${currentUser.email}');
        _addLog('✅ UID: ${currentUser.uid}');
      } else {
        _addLog('❌ Nenhum usuário logado');
        setState(() {
          _status = 'Erro: Usuário não logado';
        });
        return;
      }
      
      // Teste 2: Verificar Firestore Connection
      _addLog('2. Testando conexão Firestore...');
      final firestore = FirebaseFirestore.instance;
      
      // Teste 3: Tentar ler dados do usuário
      _addLog('3. Tentando ler dados do usuário...');
      try {
        final doc = await firestore.collection('users').doc(currentUser.uid).get();
        
        if (doc.exists) {
          final data = doc.data();
          _addLog('✅ Documento existe no Firestore');
          _addLog('✅ Dados: $data');
        } else {
          _addLog('⚠️ Documento não existe no Firestore');
          _addLog('ℹ️ Isso é normal se o usuário ainda não foi salvo');
        }
      } catch (e) {
        _addLog('❌ Erro ao ler Firestore: $e');
      }
      
      // Teste 4: Tentar criar um documento de teste
      _addLog('4. Testando escrita no Firestore...');
      try {
        await firestore.collection('test').doc('teste').set({
          'timestamp': FieldValue.serverTimestamp(),
          'message': 'Teste de conexão',
        });
        _addLog('✅ Escrita no Firestore funcionando');
        
        // Limpeza: deletar documento de teste
        await firestore.collection('test').doc('teste').delete();
        _addLog('✅ Limpeza concluída');
        
      } catch (e) {
        _addLog('❌ Erro ao escrever no Firestore: $e');
      }
      
      _addLog('=== TESTES CONCLUÍDOS ===');
      setState(() {
        _status = 'Testes concluídos - veja os logs';
      });
      
    } catch (e) {
      _addLog('❌ Erro geral nos testes: $e');
      setState(() {
        _status = 'Erro nos testes';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste Firestore'),
        backgroundColor: const Color(0xFF14276B),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                'Status: $_status',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Logs dos Testes:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    final log = _logs[index];
                    Color textColor = Colors.black;
                    
                    if (log.startsWith('✅')) {
                      textColor = Colors.green.shade700;
                    } else if (log.startsWith('❌')) {
                      textColor = Colors.red.shade700;
                    } else if (log.startsWith('⚠️')) {
                      textColor = Colors.orange.shade700;
                    } else if (log.startsWith('===')) {
                      textColor = Colors.blue.shade700;
                    }
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        log,
                        style: TextStyle(
                          color: textColor,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _logs.clear();
                    _status = 'Testando...';
                  });
                  _runTests();
                },
                child: const Text('Executar Testes Novamente'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}