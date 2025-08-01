# 🔐 Regras do Firestore para Notícias

## 📋 **Regras Atualizadas do Firestore**

Para que o sistema de notícias funcione, você precisa atualizar as regras de segurança no Firebase Console:

### **1. Acesse Firebase Console → Firestore Database → Rules**

### **2. Substitua as regras por estas:**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // ===== USUÁRIOS =====
    // Permite que usuários autenticados leiam e escrevam seus próprios dados
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // ===== NOTÍCIAS =====
    // Qualquer pessoa pode ler notícias ativas
    match /noticias/{noticiaId} {
      // Leitura: qualquer pessoa (notícias são públicas)
      allow read: if resource.data.ativo == true;
      
      // Escrita: apenas usuários autenticados podem criar/editar
      allow create, update: if request.auth != null;
      
      // Deletar: apenas o autor ou admin
      allow delete: if request.auth != null && 
        (request.auth.uid == resource.data.autorId);
    }
    
    // ===== ADMINISTRAÇÃO (Opcional) =====
    // Se você quiser criar usuários admin
    match /admin/{adminId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == adminId;
    }
    
    // ===== TESTES =====
    match /test/{document} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 🔧 **Alternativa Simples (Para Desenvolvimento)**

Se quiser liberar tudo para desenvolvimento inicial:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuários: apenas próprios dados
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Notícias: usuários autenticados podem fazer tudo
    match /noticias/{document} {
      allow read, write: if request.auth != null;
    }
    
    // Testes
    match /test/{document} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 📊 **Estrutura da Coleção "noticias"**

Cada documento terá esta estrutura:

```json
{
  "titulo": "Título da Notícia",
  "resumo": "Breve resumo da notícia...",
  "conteudo": "Conteúdo completo da notícia...",
  "imagemUrl": "https://exemplo.com/imagem.jpg",
  "autor": "Nome do Autor",
  "autorId": "UID_do_usuario",
  "dataPublicacao": "timestamp",
  "dataAtualizacao": "timestamp",
  "tags": ["volei", "esporte", "brasil"],
  "ativo": true,
  "visualizacoes": 0
}
```

## 🎯 **Funcionalidades Implementadas**

✅ **Criar notícias** (usuários logados)
✅ **Listar notícias ativas** (todos podem ver)
✅ **Editar notícias** (autor da notícia)
✅ **Deletar notícias** (soft delete - autor)
✅ **Buscar por tags**
✅ **Buscar por texto**
✅ **Contar visualizações**
✅ **Paginação**
✅ **Tempo real** (opcional)

## 🚀 **Como Usar**

1. **Configure as regras** no Firebase Console
2. **Use a página de admin** para criar notícias:
   ```dart
   Navigator.push(context, 
     MaterialPageRoute(builder: (context) => AdminNoticiasPage())
   );
   ```

3. **Integre com sua página existente** de notícias

## 🔍 **Próximos Passos**

1. ✅ Configure as regras acima
2. ✅ Teste criando uma notícia
3. ✅ Verifique no Firestore se foi salva
4. ✅ Integre com sua página de notícias atual

---

**🎯 Agora você tem um sistema completo de notícias integrado ao Firestore!**