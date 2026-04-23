---
displayed_sidebar: projectsManagerPlusSidebar
title: Overview
---

## Context

A arquitetura do **ProjectsManagerPlus** segue um padrão modular com responsabilidades claras, focando em interações de baixo risco e sem efeitos colaterais (side-effects) com a IDE do Delphi através da Open Tools API (OTA).

## Main components

- **`ProjectsManagerPlus.Register.pas`**: Ponto de entrada (Entrypoint). Registra o Notifier (`IOTAProjectMenuItemCreatorNotifier`) no Project Manager Menu da IDE na seção `initialization` e assegura a liberação explícita de memória em `finalization`.
- **`ProjectsManagerPlus.Menu.pas`**: Atua como dispatcher da interface dos menus (`IOTAProjectManagerMenu`). Com base no evento ou verbo do clique, instancia o comando apropriado passando referências necessárias (como o path físico e projeto atrelado).
- **`ProjectsManagerPlus.Commands.pas`**: Lógica de negócio isolada. Possui a base `TBaseProjectCommand` e implementações de uso (`TNewUnitCommand`, `TNewFolderCommand`, `TAddFoldersCommand`, etc.). Resolve os caminhos usando puramente as informações de arquivo do projeto (`IOTAProject.FileName`).
- **`ProjectsManagerPlus.Services.pas`**: Oferece o utilitário estático `TFileService` responsável pelas abstrações de disco físico (manipulação de pastas e criação de arquivos base).
- **`ProjectsManagerPlus.FolderDialog.pas`**: Lida com a UI customizada exibida para o desenvolvedor durante certas seleções de diretório, com a funcionalidade de recursão de subpastas.
- **`ProjectsManagerPlus.DebugLogHelper.pas`**: Utilitário de debug (`TDebugLog`). Usado para gravar registros de timestamp, thread ID, e status usando `OutputDebugString` (podem ser lidos com utilitários como DbgView).

## Extensibility

A arquitetura de `IProjectPlusCommand` e sua classe base `TBaseProjectCommand` em `ProjectsManagerPlus.Commands.pas` permitem que novos comandos e ações de menu sejam criados criando apenas uma nova subclasse. O registro e invocação em `ProjectsManagerPlus.Menu.pas` pode mapear as extensões.