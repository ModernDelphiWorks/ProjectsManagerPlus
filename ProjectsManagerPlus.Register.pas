unit ProjectsManagerPlus.Register;

interface

uses
  ToolsAPI,
  Winapi.Windows,
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  Vcl.Menus,
  Vcl.Dialogs,
  ProjectsManagerPlus.Menu,
  ProjectsManagerPlus.Commands,
  ProjectsManagerPlus.Types;

type
{$IF CompilerVersion < 21.0} // Delphi < 2010
  TProjectPlusMenuNotifier = class(TNotifierObject, INTAProjectMenuCreatorNotifier)
  public
    { INTAProjectMenuCreatorNotifier }
    function AddMenu(const Ident: string): TMenuItem;
    function CanHandle(const Ident: string): Boolean;
  end;
{$ELSE} // Delphi 2010+ including RAD Studio 12
  TProjectPlusMenuNotifier = class(TNotifierObject, IOTAProjectMenuItemCreatorNotifier)
  public
    { IOTAProjectMenuItemCreatorNotifier }
    procedure AddMenu(const Project: IOTAProject; const IdentList: TStrings;
      const ProjectManagerMenuList: IInterfaceList; IsMultiSelect: Boolean);
    function CanHandle(const Ident: string): Boolean;
  end;

  // Menu item class for Delphi 2010+
  TProjectPlusMenuItem = class(TNotifierObject, IOTALocalMenu, IOTAProjectManagerMenu)
  private
    FCaption: string;
    FName: string;
    FVerb: string;
    FParent: string;
    FPosition: Integer;
    FProject: IOTAProject;
  public
    constructor Create(const ACaption, AName, AVerb, AParent: string; APosition: Integer; AProject: IOTAProject);
    // IOTALocalMenu methods
    function GetCaption: string;
    function GetChecked: Boolean;
    function GetEnabled: Boolean;
    function GetHelpContext: Integer;
    function GetName: string;
    function GetParent: string;
    function GetPosition: Integer;
    function GetVerb: string;
    procedure SetCaption(const Value: string);
    procedure SetChecked(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetHelpContext(Value: Integer);
    procedure SetName(const Value: string);
    procedure SetParent(const Value: string);
    procedure SetPosition(Value: Integer);
    procedure SetVerb(const Value: string);
    // IOTAProjectManagerMenu methods
    function GetIsMultiSelectable: Boolean;
    procedure SetIsMultiSelectable(Value: Boolean);
    procedure Execute(const MenuContextList: IInterfaceList); overload;
    function PreExecute(const MenuContextList: IInterfaceList): Boolean;
    function PostExecute(const MenuContextList: IInterfaceList): Boolean;
  end;
{$ENDIF}

procedure Register;

implementation

var
  MenuNotifier: TProjectPlusMenuNotifier;
  NotifierIndex: Integer = -1;

const
  sFileContainer = 'FileContainer';
  sProjectContainer = 'ProjectContainer';
  sProjectGroupContainer = 'ProjectGroupContainer';
  sDirectoryContainer = 'DirectoryContainer';
  sBaseContainer = 'BaseContainer';

{ TProjectPlusMenuNotifier }

{$IF CompilerVersion < 21.0} // Delphi < 2010
function TProjectPlusMenuNotifier.AddMenu(const Ident: string): TMenuItem;
begin
  OutputDebugString(PChar('TProjectPlusMenuNotifier.AddMenu called with Ident: ' + Ident));

  Result := nil;

  if not CanHandle(Ident) then
  begin
    OutputDebugString(PChar('CanHandle returned False for Ident: ' + Ident));
    Exit;
  end;

  OutputDebugString(PChar('Creating menu for Ident: ' + Ident));

  // Create a simple test menu item
  Result := TMenuItem.Create(nil);
  Result.Caption := 'Add Folder (ProjectPlus)';
  // Don't assign OnClick for now, just test if menu appears
  
  OutputDebugString(PChar('Menu created successfully for Ident: ' + Ident));
end;
{$ELSE} // Delphi 2010+

procedure TProjectPlusMenuNotifier.AddMenu(const Project: IOTAProject;
  const IdentList: TStrings; const ProjectManagerMenuList: IInterfaceList;
  IsMultiSelect: Boolean);
var
  LFor: Integer;
begin
  OutputDebugString(PChar('TProjectPlusMenuNotifier.AddMenu called'));

  if not Assigned(IdentList) or (IdentList.Count = 0) then
    Exit;

  OutputDebugString(PChar('ProjectsManagerPlus: AddMenu - IdentList.Count: ' + IntToStr(IdentList.Count)));

  // Implementação baseada na documentação do Delphi IDE Open Tools API
  // Verifica se o contexto é sProjectContainer (projeto)
  for LFor := 0 to IdentList.Count - 1 do
  begin
    if sProjectContainer = IdentList[LFor] then
    begin
      // Para projetos: apenas Add Folder
      ProjectManagerMenuList.Add(TProjectPlusMenuItem.Create(
        'Add Folder...', 'AddFolder', 'AddFolders', '', High(Integer), Project));
      OutputDebugString(PChar('ProjectsManagerPlus: Menu Add Folder criado para projeto'));
    end
    else if sDirectoryContainer = IdentList[LFor] then
    begin
      // Para pastas: Add Unit, Add Folder, Remove Folder
      ProjectManagerMenuList.Add(TProjectPlusMenuItem.Create(
        'New Unit...', 'NewUnit', 'NewUnit', '', 100, Project));
      ProjectManagerMenuList.Add(TProjectPlusMenuItem.Create(
        'New Folder...', 'NewFolder', 'NewFolder', '', 101, Project));
      ProjectManagerMenuList.Add(TProjectPlusMenuItem.Create(
        'Add Folder...', 'AddFolder', 'AddFolders', '', 102, Project));
      ProjectManagerMenuList.Add(TProjectPlusMenuItem.Create(
        'Remove Folder', 'RemoveFolder', 'RemoveUnitsFromFolder', '', 103, Project));
      OutputDebugString(PChar('ProjectsManagerPlus: Menus criados para pasta'));
    end;
  end;
end;
{$ENDIF}

function TProjectPlusMenuNotifier.CanHandle(const Ident: string): Boolean;
begin
  OutputDebugString(PChar('TProjectPlusMenuNotifier.CanHandle called with Ident: ' + Ident));
  
  // Apenas para projetos e pastas - simples e direto
  Result := (Ident = sProjectContainer) or (Ident = sDirectoryContainer);
  
  OutputDebugString(PChar('CanHandle result: ' + BoolToStr(Result, True) + ' for Ident: ' + Ident));
end;

{$IF CompilerVersion >= 21.0} // Delphi 2010+
{ TProjectPlusMenuItem }

constructor TProjectPlusMenuItem.Create(const ACaption, AName, AVerb, AParent: string; APosition: Integer; AProject: IOTAProject);
begin
  inherited Create;
  FCaption := ACaption;
  FName := AName;
  FVerb := AVerb;
  FParent := AParent;
  FPosition := APosition;
  FProject := AProject;
end;

// IOTALocalMenu methods
function TProjectPlusMenuItem.GetCaption: string;
begin
  Result := FCaption;
end;

function TProjectPlusMenuItem.GetChecked: Boolean;
begin
  Result := False;
end;

function TProjectPlusMenuItem.GetEnabled: Boolean;
begin
  Result := True;
end;

function TProjectPlusMenuItem.GetHelpContext: Integer;
begin
  Result := 0;
end;

function TProjectPlusMenuItem.GetName: string;
begin
  Result := FName;
end;

function TProjectPlusMenuItem.GetParent: string;
begin
  Result := FParent;
end;

function TProjectPlusMenuItem.GetPosition: Integer;
begin
  Result := FPosition;
end;

function TProjectPlusMenuItem.GetVerb: string;
begin
  Result := FVerb;
end;

procedure TProjectPlusMenuItem.SetCaption(const Value: string);
begin
  // Do nothing - static menu
end;

procedure TProjectPlusMenuItem.SetChecked(Value: Boolean);
begin
  // Do nothing - static menu
end;

procedure TProjectPlusMenuItem.SetEnabled(Value: Boolean);
begin
  // Do nothing - static menu
end;

procedure TProjectPlusMenuItem.SetHelpContext(Value: Integer);
begin
  // Do nothing - static menu
end;

procedure TProjectPlusMenuItem.SetName(const Value: string);
begin
  // Do nothing - static menu
end;

procedure TProjectPlusMenuItem.SetParent(const Value: string);
begin
  // Do nothing - static menu
end;

procedure TProjectPlusMenuItem.SetPosition(Value: Integer);
begin
  FPosition := Value;
end;

procedure TProjectPlusMenuItem.SetVerb(const Value: string);
begin
  // Do nothing - static menu
end;

// IOTAProjectManagerMenu methods
function TProjectPlusMenuItem.GetIsMultiSelectable: Boolean;
begin
  Result := False;
end;

procedure TProjectPlusMenuItem.SetIsMultiSelectable(Value: Boolean);
begin
  // Do nothing - static menu
end;

procedure TProjectPlusMenuItem.Execute(const MenuContextList: IInterfaceList);
var
  LCommand: IProjectPlusCommand;
  LSelectedPath: string;
  LProjectPath: string;
  LContext: IOTAProjectMenuContext;
  LFor: Integer;
  LCorrectProject: IOTAProject;
  LProjectGroup: IOTAProjectGroup;
  LProjectIndex: Integer;
  LCurrentProject: IOTAProject;
begin
  OutputDebugString(PChar('TProjectPlusMenuItem.Execute called with verb: ' + FVerb));

  try
    // Get menu context
    LSelectedPath := '';
    LProjectPath := '';
    LCorrectProject := nil;

    if Assigned(MenuContextList) and (MenuContextList.Count > 0) then
    begin
      for LFor := 0 to MenuContextList.Count - 1 do
      begin
        if Supports(MenuContextList[LFor], IOTAProjectMenuContext, LContext) then
        begin
          LSelectedPath := LContext.Ident;
          Break;
        end;
      end;
    end;
    
    OutputDebugString(PChar('Selected path: ' + LSelectedPath));
    
    // Find the correct project that contains the selected path
    if (LSelectedPath <> '') and Assigned(BorlandIDEServices) then
    begin
      LProjectGroup := (BorlandIDEServices as IOTAModuleServices).MainProjectGroup;
      if Assigned(LProjectGroup) then
      begin
        for LProjectIndex := 0 to LProjectGroup.ProjectCount - 1 do
        begin
          LCurrentProject := LProjectGroup.Projects[LProjectIndex];
          if Assigned(LCurrentProject) then
          begin
            LProjectPath := ExtractFilePath(LCurrentProject.FileName);
            OutputDebugString(PChar('Checking project: ' + LCurrentProject.FileName));
            OutputDebugString(PChar('Project path: ' + LProjectPath));
            
            // Check if selected path starts with this project's path
            if (LProjectPath <> '') and (Pos(UpperCase(LProjectPath), UpperCase(LSelectedPath)) = 1) then
            begin
              LCorrectProject := LCurrentProject;
              OutputDebugString(PChar('Found correct project: ' + LCurrentProject.FileName));
              Break;
            end;
          end;
        end;
      end;
    end;
    
    // If no correct project found, use the original FProject as fallback
    if not Assigned(LCorrectProject) then
    begin
      LCorrectProject := FProject;
      if Assigned(FProject) then
      begin
        LProjectPath := ExtractFilePath(FProject.FileName);
        OutputDebugString(PChar('Using fallback project: ' + FProject.FileName));
      end;
    end;
    
    OutputDebugString(PChar('Final selected path: ' + LSelectedPath));
    OutputDebugString(PChar('Final project path: ' + LProjectPath));
    
    // Handle menu actions directly - no parent menu needed
    
    // Handle parent menu - no action needed, just display submenu
    if FVerb = 'AddMenu' then
    begin
      OutputDebugString(PChar('Parent Add menu clicked - showing submenu'));
      Exit; // Parent menu doesn't execute any command
    end;
    
    // Create command based on verb
    case IndexText(FVerb, ['NewUnit', 'NewFolder', 'AddFolders', 'RemoveUnitsFromFolder']) of
      0: // NewUnit
      begin
        LCommand := TNewUnitCommand.Create(LCorrectProject, LSelectedPath, LProjectPath);
        OutputDebugString(PChar('Created TNewUnitCommand'));
      end;
      1: // NewFolder
      begin
        LCommand := TNewFolderCommand.Create(LCorrectProject, LSelectedPath, LProjectPath);
        OutputDebugString(PChar('Created TNewFolderCommand'));
      end;
      2: // AddFolders
      begin
        LCommand := TAddFoldersCommand.Create(LCorrectProject, LSelectedPath, LProjectPath);
        OutputDebugString(PChar('Created TAddFoldersCommand'));
      end;
      3: // RemoveUnitsFromFolder
      begin
        LCommand := TRemoveUnitsFromFolderCommand.Create(LCorrectProject, LSelectedPath, LProjectPath);
        OutputDebugString(PChar('Created TRemoveUnitsFromFolderCommand with correct project'));
      end;
    else
      OutputDebugString(PChar('Unknown verb: ' + FVerb));
      MessageDlg('Unknown command: ' + FVerb, mtError, [mbOK], 0);
      Exit;
    end;
    
    // Execute command
    if Assigned(LCommand) then
    begin
      OutputDebugString(PChar('Executing command: ' + LCommand.GetName));
      LCommand.Execute;
    end;
    
  except
    on E: Exception do
    begin
      OutputDebugString(PChar('Error in Execute: ' + E.Message));
      MessageDlg('Error executing command: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TProjectPlusMenuItem.PreExecute(const MenuContextList: IInterfaceList): Boolean;
begin
  Result := True;
end;

function TProjectPlusMenuItem.PostExecute(const MenuContextList: IInterfaceList): Boolean;
begin
  Result := False;
end;
{$ENDIF}

procedure Register;
begin
  OutputDebugString(PChar('ProjectsManagerPlus: Register procedure called'));
  
  if not Assigned(BorlandIDEServices) then
  begin
    OutputDebugString(PChar('ProjectsManagerPlus: BorlandIDEServices is not assigned'));
    Exit;
  end;
  
  OutputDebugString(PChar('ProjectsManagerPlus: BorlandIDEServices is assigned'));
  
  // Avoid double registration
  if Assigned(MenuNotifier) then
  begin
    OutputDebugString(PChar('ProjectsManagerPlus: MenuNotifier already exists, skipping registration'));
    Exit;
  end;
  
  MenuNotifier := TProjectPlusMenuNotifier.Create;
  
{$IF CompilerVersion < 21.0} // Delphi < 2010
  try
    NotifierIndex := (BorlandIDEServices as IOTAProjectManager).AddMenuCreatorNotifier(MenuNotifier);
    OutputDebugString(PChar('ProjectsManagerPlus: Menu creator notifier added (Delphi < 2010) - Index: ' + IntToStr(NotifierIndex)));
  except
    on E: Exception do
    begin
      OutputDebugString(PChar('ProjectsManagerPlus: Error adding menu creator notifier: ' + E.Message));
      FreeAndNil(MenuNotifier);
    end;
  end;
{$ELSE} // Delphi 2010+ including RAD Studio 12
  try
    NotifierIndex := (BorlandIDEServices as IOTAProjectManager).AddMenuItemCreatorNotifier(MenuNotifier);
    OutputDebugString(PChar('ProjectsManagerPlus: Menu item creator notifier added (Delphi 2010+) - Index: ' + IntToStr(NotifierIndex)));
  except
    on E: Exception do
    begin
      OutputDebugString(PChar('ProjectsManagerPlus: Error adding menu item creator notifier: ' + E.Message));
      FreeAndNil(MenuNotifier);
    end;
  end;
{$ENDIF}
  
  if NotifierIndex >= 0 then
    OutputDebugString(PChar('ProjectsManagerPlus: Registration completed successfully'))
  else
    OutputDebugString(PChar('ProjectsManagerPlus: Registration failed - invalid notifier index'));
end;

procedure Finalize;
begin
  OutputDebugString(PChar('ProjectsManagerPlus: Finalize procedure called'));
  
  if Assigned(MenuNotifier) and (NotifierIndex >= 0) then
  begin
    try
{$IF CompilerVersion < 21.0} // Delphi < 2010
      (BorlandIDEServices as IOTAProjectManager).RemoveMenuCreatorNotifier(NotifierIndex);
      OutputDebugString(PChar('ProjectsManagerPlus: Menu creator notifier removed (Delphi < 2010)'));
{$ELSE} // Delphi 2010+
      (BorlandIDEServices as IOTAProjectManager).RemoveMenuItemCreatorNotifier(NotifierIndex);
      OutputDebugString(PChar('ProjectsManagerPlus: Menu item creator notifier removed (Delphi 2010+)'));
{$ENDIF}
    except
      on E: Exception do
        OutputDebugString(PChar('ProjectsManagerPlus: Error removing notifier: ' + E.Message));
    end;
    
    MenuNotifier := nil;
    NotifierIndex := -1;
  end;
  
  OutputDebugString(PChar('ProjectsManagerPlus: Finalization completed'));
end;

initialization
  Register;

finalization
  Finalize;

end.

