# Gerenciador de Planetas - APK Flutter  

Este repositório contém um aplicativo Flutter desenvolvido como parte de um projeto pessoal. O **Gerenciador de Planetas** permite cadastrar, visualizar, editar e excluir planetas, garantindo uma experiência fluida e intuitiva para os usuários.  

## Funcionalidades  

- **CRUD Completo**:  
  - Adicionar novos planetas com nome, distância do sol e tamanho.  
  - Editar informações dos planetas cadastrados.  
  - Excluir planetas (com confirmação antes da remoção).  
  - Restaurar planetas excluídos do histórico.  

- **Validação de Dados**:  
  - Distância e tamanho devem ser valores positivos.  
  - Nome do planeta deve ter no mínimo 3 caracteres.  

- **Design Moderno e Diferenciado**:  
  - Interface com cores em tons de lilás e roxo.  
  - Fonte elegante para os títulos (`Cinzel`).  
  - Layout otimizado para facilitar a usabilidade.  

- **Histórico de Exclusões**:  
  - Visualizar todos os planetas removidos.  
  - Opção de restaurar planetas apagados.  

- **Tela de Detalhes**:  
  - Visualizar todas as informações de um planeta específico, como:  
    - Nome.  
    - Apelido (se houver).  
    - Distância do Sol (em km).  
    - Tamanho (em km).  

- **Mensagens Personalizadas**:  
  - Notificações ao adicionar, editar, excluir ou restaurar um planeta.  

## Tecnologias Utilizadas  

- **Flutter**: Framework para desenvolvimento de aplicações multiplataforma.  
- **Dart**: Linguagem de programação usada com Flutter.  
- **SQLite**: Banco de dados local para persistência dos planetas cadastrados.  

## Estrutura do Projeto  

- `lib/main.dart`: Configuração principal do aplicativo, temas e navegação.  
- `lib/controle/controle_planeta.dart`: Gerencia a comunicação com o banco de dados.  
- `lib/modelo/planeta.dart`: Define a estrutura dos objetos planeta.  
- `lib/tela/tela_planeta.dart`: Tela de cadastro e edição de planetas.  
- `lib/tela/tela_historico.dart`: Tela que exibe o histórico de planetas removidos.  
- `lib/tela/tela_detalhes.dart`: Tela que exibe as informações completas de um planeta.  

---

Feito com 💜 por **Ana Júlia**, com criatividade e dedicação no aprendizado de Flutter. 🚀
