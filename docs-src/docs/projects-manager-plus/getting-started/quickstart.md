---
displayed_sidebar: projectsManagerPlusSidebar
title: Quickstart
---

## Prerequisites

- Delphi IDE (compatível com as versões mais recentes a partir do XE+).
- Open Tools API (OTA).

## Instalação

Abra o pacote `ProjectsManagerPlus.dpk` ou `ProjectsManagerPlus.dproj` diretamente no Delphi e clique em **Install**.

## Como utilizar

A extensão injeta comandos diretamente no menu de contexto do seu Project Manager. 

Para utilizar a ferramenta, basta seguir este fluxo mínimo:

1. Abra um projeto (ex: `MeuProjeto.dproj`).
2. Clique com o botão direito no projeto ou em uma sub-pasta dentro da árvore no **Project Manager**.
3. O menu estendido do `ProjectsManagerPlus` estará disponível, permitindo:
   - Criar uma nova "New Unit...".
   - Criar uma "New Folder...".
   - Adicionar ou remover units em lote.

A extensão determinará automaticamente a pasta física em disco relativa ao item em que você clicou, independentemente do `Current Directory` ativo na IDE.

## Next steps

- [Architecture](../architecture/overview.md)
- [API Reference](../reference/api.md)