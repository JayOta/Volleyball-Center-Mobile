// lib/services/storage_service.dart (ATUALIZADO)

import 'package:firebase_storage/firebase_storage.dart';
// Importa o XFile, que é a classe de arquivo do image_picker
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Função ATUALIZADA para aceitar XFile (compatível com web)
  Future<String> uploadNewsImage(XFile imageFile, String newsId) async {
    // 1. Cria a referência no Storage
    final String path =
        'news_images/$newsId/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final Reference ref = _storage.ref().child(path);

    // 2. Lê os bytes do arquivo (funciona na web e nativo)
    final bytes = await imageFile.readAsBytes();

    // 3. Faz o upload do arquivo usando putData (upload de bytes)
    final UploadTask uploadTask = ref.putData(bytes);

    // 4. Aguarda a conclusão e retorna a URL
    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // Função para deletar a imagem associada, usada ao excluir uma notícia
  Future<void> deleteImage(String? imageUrl) async {
    if (imageUrl == null || imageUrl.isEmpty) {
      return;
    }

    try {
      // Cria a referência a partir da URL
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      // Ignoramos erros como "Object not found"
      print("Erro ao deletar imagem do Storage: $e");
    }
  }
}
