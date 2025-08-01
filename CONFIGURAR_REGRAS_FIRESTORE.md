# 🔐 Como Configurar Regras do Firestore

## 🚨 **ERRO: Permission Denied - SOLUÇÃO AQUI!**

O erro que você está vendo é causado pelas **regras de segurança do Firestore** que estão bloqueando a escrita de dados.

## 🛠️ **SOLUÇÃO PASSO A PASSO:**

### **1. Acesse o Firebase Console**
1. Vá para: https://console.firebase.google.com/
2. Selecione seu projeto: **`volleyballcenter-57da3`**
3. No menu lateral, clique em **"Firestore Database"**
4. Clique na aba **"Rules"** (Regras)

### **2. Substitua as Regras Atuais**

**APAGUE tudo que está lá e cole esta regra:**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permite que usuários autenticados leiam e escrevam seus próprios dados
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Permite operações de teste para usuários autenticados
    match /test/{document} {
      allow read, write: if request.auth != null;
    }
    
    // Permite leitura pública de algumas coleções (se necessário)
    // match /public/{document} {
    //   allow read: if true;
    // }
  }
}
```

### **3. Publique as Regras**
1. Clique no botão **"Publish"** (Publicar)
2. Aguarde a confirmação

## 🔄 **Alternativa para Desenvolvimento (Temporária)**

**Se você quiser liberar tudo temporariamente para testes:**

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

### **Regra Recomendada (Segura):**
- ✅ Usuários só podem ler/escrever seus próprios dados
- ✅ Verifica se o usuário está autenticado
- ✅ Verifica se o UID do documento = UID do usuário

### **Regra de Desenvolvimento (Menos Segura):**
- ✅ Qualquer usuário autenticado pode ler/escrever qualquer documento
- ⚠️ Menos segura, mas útil para desenvolvimento

## 🧪 **Teste Após Configurar:**

1. **Configure as regras** seguindo os passos acima
2. **Aguarde 1-2 minutos** para propagar
3. **Teste o cadastro** novamente
4. **Verifique os logs** para ver se funcionou

## 🔍 **Como Verificar se Funcionou:**

Após configurar as regras, você deve ver nos logs:
```
✅ Perfil do usuário criado com sucesso no Firestore
✅ Perfil do usuário atualizado com sucesso
```

Em vez de:
```
❌ Erro de permissão: Missing or insufficient permissions
```

## 📱 **Próximos Passos:**

1. ✅ **Configure as regras** (acima)
2. ✅ **Teste o cadastro** novamente
3. ✅ **Verifique no Console** se os dados foram salvos em Firestore > Data

## 🆘 **Se Ainda Der Erro:**

1. **Aguarde 2-3 minutos** após publicar as regras
2. **Refaça o login** no app
3. **Tente cadastrar** um usuário novo
4. **Me envie os logs** que aparecem no console

---

**🎯 A configuração das regras resolve 99% dos problemas de permission-denied!**