# Coleção de Notícias - Firestore

Este documento explica como usar a coleção "noticias" no Cloud Firestore para o projeto Volleyball Center Mobile.

## Estrutura da Coleção

A coleção `noticias` armazena documentos com a seguinte estrutura:

```json
{
  "titulo": "Título da notícia",
  "conteudo": "Conteúdo completo da notícia...",
  "imagemUrl": "https://example.com/imagem.jpg",
  "autor": "Nome do autor",
  "dataPublicacao": "Timestamp",
  "dataAtualizacao": "Timestamp",
  "tags": ["tag1", "tag2", "tag3"],
  "ativo": true,
  "visualizacoes": 0
}
```

## Arquivos Criados

### 1. Modelo de Dados
- **`lib/models/noticia.dart`**: Classe que representa uma notícia

### 2. Serviço
- **`lib/services/noticias_service.dart`**: Serviço para gerenciar operações CRUD

### 3. Utilitários
- **`lib/utils/noticias_exemplo.dart`**: Dados de exemplo para popular a coleção
- **`lib/examples/criar_noticia_exemplo.dart`**: Exemplos de uso do serviço

### 4. Interface Atualizada
- **`lib/noticias.dart`**: Tela de notícias atualizada para usar dados do Firestore

## Como Usar

### 1. Inicialização

A coleção será automaticamente populada com dados de exemplo na primeira execução:

```dart
// Isso acontece automaticamente na tela de notícias
await NoticiasExemplo.popularSeVazia();
```

### 2. Criar uma Nova Notícia

```dart
import 'package:volleyball_center_mobile/models/noticia.dart';
import 'package:volleyball_center_mobile/services/noticias_service.dart';

final noticiasService = NoticiasService();

Noticia novaNoticia = Noticia(
  titulo: "Título da notícia",
  conteudo: "Conteúdo da notícia...",
  autor: "Nome do autor",
  dataPublicacao: DateTime.now(),
  tags: ["tag1", "tag2"],
);

String id = await noticiasService.criarNoticia(novaNoticia);
```

### 3. Buscar Notícias

```dart
// Buscar todas as notícias ativas
List<Noticia> noticias = await noticiasService.buscarTodasNoticias();

// Buscar por ID
Noticia? noticia = await noticiasService.buscarNoticiaPorId("id_da_noticia");

// Buscar por tag
List<Noticia> noticias = await noticiasService.buscarNoticiasPorTag("seleção");

// Buscar por autor
List<Noticia> noticias = await noticiasService.buscarNoticiasPorAutor("autor");

// Buscar mais visualizadas
List<Noticia> noticias = await noticiasService.buscarNoticiasMaisVisualizadas(limite: 10);

// Buscar recentes
List<Noticia> noticias = await noticiasService.buscarNoticiasRecentes(limite: 10);
```

### 4. Atualizar Notícia

```dart
Map<String, dynamic> updates = {
  'titulo': 'Novo título',
  'conteudo': 'Novo conteúdo',
  'tags': ['nova', 'tag'],
};

await noticiasService.atualizarNoticia("id_da_noticia", updates);
```

### 5. Deletar Notícia

```dart
// Soft delete (marca como inativa)
await noticiasService.deletarNoticia("id_da_noticia");

// Deletar permanentemente
await noticiasService.deletarNoticiaPermanentemente("id_da_noticia");
```

### 6. Incrementar Visualizações

```dart
await noticiasService.incrementarVisualizacoes("id_da_noticia");
```

### 7. Stream em Tempo Real

```dart
noticiasService.streamNoticias().listen(
  (noticias) {
    // Atualizar UI com as notícias em tempo real
    print('Notícias atualizadas: ${noticias.length}');
  },
);
```

## Regras de Segurança do Firestore

Certifique-se de que suas regras de segurança permitam as operações necessárias:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Regras para a coleção de notícias
    match /noticias/{noticiaId} {
      // Permitir leitura para todos
      allow read: if true;
      
      // Permitir escrita apenas para usuários autenticados
      allow write: if request.auth != null;
      
      // Ou para usuários com role específico
      // allow write: if request.auth != null && 
      //   get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

## Funcionalidades Implementadas

✅ **CRUD Completo**: Criar, ler, atualizar e deletar notícias
✅ **Busca Avançada**: Por tag, autor, mais visualizadas, recentes
✅ **Soft Delete**: Marcar notícias como inativas em vez de deletar
✅ **Contador de Visualizações**: Incrementar automaticamente
✅ **Stream em Tempo Real**: Atualizações automáticas
✅ **Dados de Exemplo**: População automática da coleção
✅ **Tratamento de Erros**: Mensagens de erro amigáveis
✅ **Interface Atualizada**: Tela de notícias usando dados do Firestore

## Próximos Passos

1. **Configurar Regras de Segurança**: Ajustar as regras do Firestore conforme necessário
2. **Implementar Upload de Imagens**: Integrar com Firebase Storage
3. **Sistema de Comentários**: Adicionar funcionalidade de comentários
4. **Notificações Push**: Enviar notificações para novas notícias
5. **Sistema de Likes**: Implementar curtidas nas notícias
6. **Busca por Texto**: Implementar busca por título e conteúdo

## Exemplo de Uso Completo

Veja o arquivo `lib/examples/criar_noticia_exemplo.dart` para exemplos completos de todas as operações disponíveis.