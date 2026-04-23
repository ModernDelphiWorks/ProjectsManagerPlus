# Roadmap — ProjectsManagerPlus

> Extensão para IDE do Delphi que eleva o nível da gestão massiva de arquivos baseados em diretórios.

**Last updated:** 2026-04-23

---

## Phases

### Phase 1 — Estabilidade Core e OTA Lifecycle

**Goal:** Tornar a extensão à prova de balas em qualquer versão Delphi XE+, focando na resolução de caminhos (Path) e gerenciamento de vazamento de memória com os Menus.
**Target:** Sprint 1

- [ ] Consertar inferência de paths em Grupos de Projetos (Project Groups)
- [ ] Refatorar limpeza dos Notifiers para evitar Memory Leaks no fechamento da IDE

---

### Phase 2 — Limpeza e Filtros (DX)

**Goal:** Melhorar a experiência do desenvolvedor (DX) removendo poluição visual e expandindo os casos de uso.
**Target:** Sprint 2

- [ ] Feature: Deleção automática de Dummy Units ao criar o primeiro arquivo real numa pasta
- [ ] Feature: Permitir adicionar outras extensões (ex: .sql, .ini) ao invés de apenas `.pas`

---

### Phase 3 — Inteligência de Código (Namespace)

**Goal:** Gerar ganho real de tempo ao desenvolvedor pré-escrevendo o namespace da unidade baseado em sua estrutura de pastas física.
**Target:** Sprint 3

- [ ] Feature: Auto-mapping e preenchimento de Namespace no template da Nova Unit

---

## Backlog

Items identified but not yet prioritized:

- Feature: Renomeação rápida de pastas em sincronia com o `.dproj` e refactoring.

---

## Sprint log

Each sprint documented by `/sprint` is recorded here.
`/sprint` ticks the corresponding item when closing a round.
