---
displayed_sidebar: projectsManagerPlusSidebar
title: Runtime Flow
---

## Main sequence

1. **Ide Initialization (`Register`):** 
   - A unit `ProjectsManagerPlus.Register` no seu método `Register` instala a extensão na IDE criando uma instância de `TProjectPlusMenuNotifier` que escuta por solicitações do Project Manager.
2. **Context Click (`Menu.pas`):** 
   - O desenvolvedor clica com o botão direito num arquivo/pasta no Project Manager.
   - O Notifier dispara, e adiciona os itens do menu (ex. "New Folder...", "New Unit...") passando os nós e contextos do projeto.
3. **Command Invocation (`Commands.pas`):** 
   - Ao selecionar um item, o método `Execute` de `IOTAProjectManagerMenu` instanciará um `IProjectPlusCommand`.
   - O comando então resolve o diretório absoluto por intermédio da interface `IOTAProject.FileName` para evitar vazamentos de contexto.
4. **Processing & Feedback (`Services.pas`):** 
   - O `TBaseProjectCommand` em uso (`TNewFolderCommand` ou `TNewUnitCommand`) utiliza o `TFileService` para criar a pasta física no SO.
   - O arquivo criado é adicionado à árvore do `IOTAProject` chamando o método adequado de `IOTAProject` da API da IDE.
5. **Unload (`Finalization`):** 
   - Ao fechar o projeto ou fechar a IDE Delphi, a cláusula `finalization` de `ProjectsManagerPlus.Register` limpa corretamente o Notifier da lista da IDE para prevenir *Access Violations*.

## Error points

- **Virtual node inference:** Se o menu for invocado num nó "virtual" do Project Manager, o projeto usará `ExtractFilePath(IOTAProject.FileName)` como raiz física em vez do nome do nó, prevenindo que diretórios como "VirtualDir" existam em lugares errados.
- **Dangling references:** Caso os ponteiros das classes da OTA não fossem limpos antes do fechamento da IDE (antigo bug), os processos poderiam causar vazamentos de memória (Access Violations). Isso está agora contido no ciclo de vida em `finalization`.