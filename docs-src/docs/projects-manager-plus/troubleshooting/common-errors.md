---
displayed_sidebar: projectsManagerPlusSidebar
title: Common Errors
---

## Access Violation (A/V) ao fechar o Delphi ou desinstalar o pacote

- **Symptom:** Uma janela de erro "Access Violation" ou o travamento geral da IDE ao encerrar o Delphi, fechar o projeto ativo ou desinstalar o `ProjectsManagerPlus.dpk`.
- **Likely cause:** O `IOTAProjectMenuItemCreatorNotifier` foi injetado via registro, mas a rotina de descarregamento (seção `finalization`) não removeu o Notifier do `BorlandIDEServices`. A IDE tenta limpar a memória referenciando um ponteiro já destruído (Memory Leak / Dangling Reference). Este era um erro comum antes da versão `v0.1.1`.
- **Action:** Atualizar para a última versão da extensão onde a limpeza via `RemoveMenuItemCreatorNotifier` na cláusula `finalization` é assegurada.

## Criação de arquivo ou pasta no diretório errado (ex. pasta `bin` da IDE)

- **Symptom:** Ao clicar para criar "New Unit" num subdiretório do projeto, o arquivo é salvo em `C:\Program Files (x86)\Embarcadero\Studio\...\bin` ou no diretório do primeiro projeto que foi aberto.
- **Likely cause:** A lógica de caminho estava usando `GetCurrentDir` para compor o diretório raiz em vez de referenciar as propriedades do projeto selecionado no evento de menu.
- **Action:** Atualize a extensão. O `TBaseProjectCommand._GetSelectedFolderPath` não usa mais variáveis de ambiente ou diretórios globais; agora infere o caminho físico exclusivamente através de `IOTAProject.FileName` do nó ativado no Project Manager.