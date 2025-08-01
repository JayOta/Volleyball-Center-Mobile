# 👥 Como Visualizar Usuários Cadastrados

## 🎉 **Implementação Concluída!**

Agora os usuários são salvos **automaticamente** em dois lugares:

### 1. 🔐 **Firebase Authentication** (Já funcionando)
**Para ver os usuários cadastrados:**
1. Acesse: https://console.firebase.google.com/
2. Selecione: `volleyballcenter-57da3`
3. Menu lateral → **"Authentication"**
4. Aba **"Users"**
5. ✅ Aqui você vê: Email, UID, data de criação, último login

### 2. 🗄️ **Cloud Firestore** (Novo! Implementado agora)
**Para ver os dados completos dos usuários:**
1. Acesse: https://console.firebase.google.com/
2. Selecione: `volleyballcenter-57da3`
3. Menu lateral → **"Firestore Database"**
4. Se ainda não criou: clique **"Create database"**
   - Escolha **"Start in test mode"**
   - Selecione uma localização (ex: us-central1)
5. Após criar, você verá a coleção **"users"**
6. ✅ Cada documento contém:
   - `uid`: ID único do usuário
   - `name`: Nome do usuário
   - `email`: Email
   - `createdAt`: Data de criação
   - `updatedAt`: Última atualização
   - `isActive`: Se o usuário está ativo

## 🔧 **Configuração Necessária (Importante!)**

### **Habilitar Cloud Firestore:**
1. No Firebase Console, vá em **"Firestore Database"**
2. Se não existir, clique **"Create database"**
3. Escolha **"Start in test mode"** (para desenvolvimento)
4. Selecione uma localização próxima (ex: southamerica-east1)

### **Regras de Segurança Iniciais:**
O Firestore criará regras básicas. Para desenvolvimento, use:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permite leitura e escrita para usuários autenticados
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 📊 **Estrutura dos Dados no Firestore**

Cada usuário terá um documento como este:

```json
{
  "uid": "abc123...",
  "name": "João Silva",
  "email": "joao@email.com",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-01-15T10:30:00Z",
  "isActive": true
}
```

## 🚀 **Próximos Cadastros**

A partir de agora, quando alguém se cadastrar:
1. ✅ Usuário é criado no **Authentication**
2. ✅ Dados são salvos automaticamente no **Firestore**
3. ✅ Você pode ver ambos nos respectivos painéis

## 💡 **Vantagens do Firestore**

- **Consultas complexas**: Buscar por nome, data, etc.
- **Dados adicionais**: Pode adicionar telefone, endereço, preferências
- **Relacionamentos**: Pode ligar com outras coleções (pedidos, favoritos)
- **Tempo real**: Dados sincronizam automaticamente
- **Escalabilidade**: Suporta milhões de usuários

## 🔍 **Para Testar Agora**

1. Execute o app
2. Cadastre um novo usuário
3. Vá no Firebase Console:
   - **Authentication > Users**: Veja o usuário básico
   - **Firestore > users**: Veja os dados completos

## 📋 **Checklist**

- [x] Cloud Firestore dependency adicionada
- [x] FirestoreService criado
- [x] AuthService integrado com Firestore
- [x] Cadastro salva automaticamente no Firestore
- [x] Login verifica/cria perfil no Firestore
- [ ] Firestore Database criado no Console (você precisa fazer)
- [ ] Regras de segurança configuradas (opcional para desenvolvimento)

**Agora você tem controle total sobre os dados dos usuários!** 🎯