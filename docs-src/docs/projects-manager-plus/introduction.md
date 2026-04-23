---
displayed_sidebar: projectsManagerPlusSidebar
title: Introduction
---

O Delphi Project Manager padrão muitas vezes se mostra limitante para gerenciar pastas físicas e criar novas units dentro de subdiretórios específicos do projeto. Atualmente, os desenvolvedores enfrentam instabilidades devido à obtenção de diretórios via `GetCurrentDir`, gerando confusão quando há múltiplos projetos no mesmo Project Group.

O **ProjectsManagerPlus** resolve esses problemas ao interagir com a Open Tools API (OTA) do Delphi. Ele introduz comandos nos menus de contexto que extraem o caminho de diretório diretamente a partir da hierarquia do `IOTAProject` do projeto selecionado, permitindo criar units, novas pastas ou adicionar/remover arquivos em lote diretamente no disco físico, de maneira segura.

## Key concepts

- **IOTAProject:** Interface da Open Tools API que representa um projeto Delphi aberto. É a fonte primária e confiável para extrair o caminho do arquivo (`FileName`) do projeto.
- **IOTAProjectManagerMenu:** Interface que permite registrar e manipular menus de contexto dentro da aba Project Manager.
- **Virtual vs Physical Nodes:** O Project Manager pode exibir nós (nodes) que representam agrupamentos virtuais de arquivos, e nós que correspondem a diretórios físicos. A extensão mapeia as ações e cria os arquivos garantindo caminhos absolutos corretos.

## Target audience

Desenvolvedores Delphi (XE+) que utilizam a IDE e desejam uma gestão melhor e mais produtiva de arquivos e pastas através do Project Manager.

## Why use it

- Resolve falhas na extração do diretório ativo, não dependendo do frágil `GetCurrentDir`.
- Permite a criação imediata de pastas físicas e units onde realmente deveriam estar no disco, alinhando a IDE à estrutura do SO.
- Evita vazamento de memória (Memory Leak) da variável `GMenuNotifier` e limpa adequadamente os recursos de UI no fechamento ou desinstalação.