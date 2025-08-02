# 🔐 Regras do Firestore - Coleção de Notícias

## 🚨 **IMPORTANTE: Configure as Regras do Firestore**

Para que a coleção de notícias funcione corretamente, você precisa configurar as regras de segurança do Firestore.

## 🛠️ **CONFIGURAÇÃO PASSO A PASSO:**

### **1. Acesse o Firebase Console**

1. Vá para: https://console.firebase.google.com/
2. Selecione seu projeto: **`volleyballcenter-57da3`**
3. No menu lateral, clique em **"Firestore Database"**
4. Clique na aba **"Rules"** (Regras)

### **2. Substitua as Regras Atuais**

**APAGUE tudo que está lá e cole estas regras atualizadas:**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permite que usuários autenticados leiam e escrevam seus próprios dados
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Regras para a coleção de notícias
    match /noticias/{noticiaId} {
      // Permitir leitura para todos (público)
      allow read: if true;
      
      // Permitir escrita apenas para usuários autenticados
      allow create, update, delete: if request.auth != null;
    }

    // Permite operações de teste para usuários autenticados
    match /test/{document} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### **3. Regras Mais Restritivas (Recomendadas para Produção)**

Se você quiser mais segurança, use estas regras:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permite que usuários autenticados leiam e escrevam seus próprios dados
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Regras para a coleção de notícias
    match /noticias/{noticiaId} {
      // Permitir leitura para todos (público)
      allow read: if true;
      
      // Permitir escrita apenas para administradores
      allow create, update, delete: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }

    // Permite operações de teste para usuários autenticados
    match /test/{document} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### **4. Regras para Desenvolvimento (Temporárias)**

Se você quiser liberar tudo temporariamente para testes:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // ⚠️ APENAS PARA DESENVOLVIMENTO - REMOVA ANTES DE PRODUÇÃO
    allow read, write: if request.auth != null;
  }
}
```

## 📋 **O que cada regra faz:**

### **Regra para Notícias:**

- ✅ **Leitura pública**: Qualquer pessoa pode ler as notícias
- ✅ **Escrita autenticada**: Apenas usuários logados podem criar/editar/deletar
- ✅ **Segurança**: Protege contra acesso não autorizado

### **Regra Restritiva (Produção):**

- ✅ **Leitura pública**: Qualquer pessoa pode ler as notícias
- ✅ **Escrita administrativa**: Apenas usuários com role 'admin' podem modificar
- ✅ **Máxima segurança**: Controle total sobre quem pode modificar

## 🧪 **Teste Após Configurar:**

1. **Configure as regras** seguindo os passos acima
2. **Aguarde 1-2 minutos** para propagar
3. **Execute o app** e vá para a tela de notícias
4. **Verifique se as notícias carregam** corretamente

## 🔍 **Como Verificar se Funcionou:**

Após configurar as regras, você deve ver nos logs:

```
✅ Iniciando população da coleção de notícias com dados de exemplo...
✅ Notícia criada com sucesso: [título] (ID: [id])
✅ População da coleção de notícias concluída!
✅ [X] notícias encontradas
```

Em vez de:

```
❌ Erro de permissão: Missing or insufficient permissions
❌ Erro ao carregar notícias: [erro de permissão]
```

## 📱 **Funcionalidades que Funcionarão:**

Com as regras configuradas, você poderá:

- ✅ **Ler notícias** (público)
- ✅ **Criar notícias** (usuários autenticados)
- ✅ **Atualizar notícias** (usuários autenticados)
- ✅ **Deletar notícias** (usuários autenticados)
- ✅ **Buscar por tag** (público)
- ✅ **Buscar por autor** (público)
- ✅ **Contar visualizações** (usuários autenticados)

## 🆘 **Se Ainda Der Erro:**

1. **Aguarde 2-3 minutos** após publicar as regras
2. **Refaça o login** no app
3. **Tente acessar** a tela de notícias
4. **Verifique os logs** no console do Flutter
5. **Me envie os logs** que aparecem

## 🎯 **Próximos Passos:**

1. ✅ **Configure as regras** (acima)
2. ✅ **Teste a tela de notícias**
3. ✅ **Verifique no Console** se os dados foram salvos em Firestore > Data
4. ✅ **Teste criar uma nova notícia** usando o exemplo

---

**🎯 A configuração das regras resolve todos os problemas de permission-denied para a coleção de notícias!**