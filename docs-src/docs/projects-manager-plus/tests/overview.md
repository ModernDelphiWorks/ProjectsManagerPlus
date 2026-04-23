---
displayed_sidebar: projectsManagerPlusSidebar
title: Tests
---

## Strategy

- Unit: Testes de unidade focados em validar serviços (ex: `TFileService`) e lógicas de caminhos sem acoplamento à interface da IDE.
- Black-box (Manual): Operações de Menu/Notifier que requerem injeção direta na IDE. Utilizam logs em destrutores (`TDebugLog.Log`) para acompanhar ciclo de vida.

## How to run

Para rodar a suíte de testes de unidade:
- Abra o projeto principal no Delphi ou invoque a suíte de testes de linha de comando (ex: DUnitX via MSBuild) associada ao arquivo de teste `Tests/TestFileServiceCreateFile.pas`.

```bash
# Exemplo genérico de build e execução de testes DUnitX
msbuild /t:Build /p:Config=Debug /p:Platform=Win32 ProjectTest.dproj
```

## Expected coverage

O foco primário da cobertura recai na utilidade isolada (`ProjectsManagerPlus.Services.pas`), assegurando que lógicas puras de manipulação de string de path e I/O funcionem corretamente. Componentes OTA (`ProjectsManagerPlus.Register.pas`) têm dependência forte do `BorlandIDEServices` e não são fáceis de testar unicamente via mock.