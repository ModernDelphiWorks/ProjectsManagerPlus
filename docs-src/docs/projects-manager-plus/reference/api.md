---
displayed_sidebar: projectsManagerPlusSidebar
title: API — Reference
---

A "API" exposta neste contexto refere-se às interfaces da Open Tools API (OTA) e à arquitetura de Comandos (`ProjectsManagerPlus.Commands.pas`).

## Main inputs

| Item | Type | Description |
|------|------|-------------|
| `IOTAProject` | `Interface` | Objeto raiz do projeto (`.dproj`). Utilizado para inferir o `FileName` (caminho absoluto físico). |
| `IOTAProjectManager` | `Interface` | Objeto da IDE onde a extensão do menu (`TProjectPlusMenuNotifier`) é acoplada/desacoplada. |
| `FContext` | `IOTAProjectManagerMenu` | O nó ativo clicado. Pode ser um diretório ou arquivo virtual/físico no Project Manager. |

## Main outputs

| Item | Type | Description |
|------|------|-------------|
| `TNewUnitCommand` | `IProjectPlusCommand` | Executa a criação de uma unit base `*.pas` fisicamente na pasta e adiciona-a ao projeto. |
| `TNewFolderCommand` | `IProjectPlusCommand` | Cria um sub-diretório de forma física relativa ao projeto selecionado. |
| `TAddFoldersCommand` | `IProjectPlusCommand` | Invoca UI para seleção de uma pasta física contendo subdiretórios/arquivos para importação em lote (`ProjectsManagerPlus.FolderDialog.pas`). |

## Rules and contracts

- **Caminhos Físicos Absolutos:** A função utilitária de busca de caminhos (`_GetSelectedFolderPath` ou similar em `TBaseProjectCommand`) deve processar unicamente o `IOTAProject.FileName` como caminho raiz para o projeto, nunca `GetCurrentDir`.
- **Prevenção de A/V (Lifecycle):** Toda extensão que implementa `IOTAProjectMenuItemCreatorNotifier` (`TProjectPlusMenuNotifier`) **deve** ser removida formalmente através do método `RemoveMenuItemCreatorNotifier` do `BorlandIDEServices` na seção de `finalization`.
- **Sem Side Effects na UI:** O arquivo não deve forçar re-paint da IDE ou manipulação do VCL principal fora de caixas de diálogo explícitas (`TFolderDialog`). A adição à árvore de projetos é realizada delegando o comando via métodos da interface OTA.