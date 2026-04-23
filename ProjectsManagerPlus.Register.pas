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
  ProjectsManagerPlus.Types,
  ProjectsManagerPlus.DebugLogHelper;

type
  TProjectPlusMenuNotifier = class(TNotifierObject, IOTAProjectMenuItemCreatorNotifier)
  public
    { IOTAProjectMenuItemCreatorNotifier }
    procedure AddMenu(const AProject: IOTAProject; const AIdentList: TStrings;
      const AProjectManagerMenuList: IInterfaceList; AIsMultiSelect: Boolean);
    function CanHandle(const AIdent: string): Boolean;
  end;

  TProjectPlusMenuItem = class(TNotifierObject, IOTALocalMenu, IOTAProjectManagerMenu)
  private
    FCaption: string;
    FName: string;
    FVerb: string;
    FParent: string;
    FPosition: Integer;
    FProject: IOTAProject;
    function _GetSelectedPath(const AMenuContextList: IInterfaceList): string;
    function _FindCorrectProject(const ASelectedPath: string; out AProjectPath: string): IOTAProject;
    function _CreateCommand(const AVerb, ASelectedPath, AProjectPath: string; const AProject: IOTAProject): IProjectPlusCommand;
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
    procedure SetCaption(const AValue: string);
    procedure SetChecked(AValue: Boolean);
    procedure SetEnabled(AValue: Boolean);
    procedure SetHelpContext(AValue: Integer);
    procedure SetName(const AValue: string);
    procedure SetParent(const AValue: string);
    procedure SetPosition(AValue: Integer);
    procedure SetVerb(const AValue: string);
    // IOTAProjectManagerMenu methods
    function GetIsMultiSelectable: Boolean;
    procedure SetIsMultiSelectable(AValue: Boolean);
    procedure Execute(const AMenuContextList: IInterfaceList); overload;
    function PreExecute(const AMenuContextList: IInterfaceList): Boolean;
    function PostExecute(const AMenuContextList: IInterfaceList): Boolean;
  end;

procedure Register;

implementation

var
  GMenuNotifier: TProjectPlusMenuNotifier;
  GNotifierIndex: Integer = -1;

const
  CFileContainer = 'FileContainer';
  CProjectContainer = 'ProjectContainer';
  CProjectGroupContainer = 'ProjectGroupContainer';
  CDirectoryContainer = 'DirectoryContainer';
  CBaseContainer = 'BaseContainer';

{ TProjectPlusMenuNotifier }

procedure TProjectPlusMenuNotifier.AddMenu(const AProject: IOTAProject;
  const AIdentList: TStrings; const AProjectManagerMenuList: IInterfaceList;
  AIsMultiSelect: Boolean);
var
  LFor: Integer;
begin
  TDebugLog.Log('TProjectPlusMenuNotifier.AddMenu called');

  if not Assigned(AIdentList) or (AIdentList.Count = 0) then
    Exit;

  TDebugLog.Log('ProjectsManagerPlus: AddMenu - AIdentList.Count: ' + IntToStr(AIdentList.Count));

  for LFor := 0 to AIdentList.Count - 1 do
  begin
    if CProjectContainer = AIdentList[LFor] then
    begin
      AProjectManagerMenuList.Add(TProjectPlusMenuItem.Create(
        'Add Folder...', 'AddFolder', 'AddFolders', '', High(Integer), AProject));
      TDebugLog.Log('ProjectsManagerPlus: Menu Add Folder criado para projeto');
    end
    else if CDirectoryContainer = AIdentList[LFor] then
    begin
      AProjectManagerMenuList.Add(TProjectPlusMenuItem.Create(
        'New Unit...', 'NewUnit', 'NewUnit', '', 100, AProject));
      AProjectManagerMenuList.Add(TProjectPlusMenuItem.Create(
        'New Folder...', 'NewFolder', 'NewFolder', '', 101, AProject));
      AProjectManagerMenuList.Add(TProjectPlusMenuItem.Create(
        'Add Folder...', 'AddFolder', 'AddFolders', '', 102, AProject));
      AProjectManagerMenuList.Add(TProjectPlusMenuItem.Create(
        'Remove Folder', 'RemoveFolder', 'RemoveUnitsFromFolder', '', 103, AProject));
      TDebugLog.Log('ProjectsManagerPlus: Menus criados para pasta');
    end;
  end;
end;

function TProjectPlusMenuNotifier.CanHandle(const AIdent: string): Boolean;
begin
  TDebugLog.Log('TProjectPlusMenuNotifier.CanHandle called with Ident: ' + AIdent);

  Result := (AIdent = CProjectContainer) or (AIdent = CDirectoryContainer);

  TDebugLog.Log('CanHandle result: ' + BoolToStr(Result, True) + ' for Ident: ' + AIdent);
end;

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

procedure TProjectPlusMenuItem.SetCaption(const AValue: string);
begin
  // Do nothing - static menu
end;

procedure TProjectPlusMenuItem.SetChecked(AValue: Boolean);
begin
  // Do nothing - static menu
end;

procedure TProjectPlusMenuItem.SetEnabled(AValue: Boolean);
begin
  // Do nothing - static menu
end;

procedure TProjectPlusMenuItem.SetHelpContext(AValue: Integer);
begin
  // Do nothing - static menu
end;

procedure TProjectPlusMenuItem.SetName(const AValue: string);
begin
  // Do nothing - static menu
end;

procedure TProjectPlusMenuItem.SetParent(const AValue: string);
begin
  // Do nothing - static menu
end;

procedure TProjectPlusMenuItem.SetPosition(AValue: Integer);
begin
  FPosition := AValue;
end;

procedure TProjectPlusMenuItem.SetVerb(const AValue: string);
begin
  // Do nothing - static menu
end;

// IOTAProjectManagerMenu methods
function TProjectPlusMenuItem.GetIsMultiSelectable: Boolean;
begin
  Result := False;
end;

procedure TProjectPlusMenuItem.SetIsMultiSelectable(AValue: Boolean);
begin
  // Do nothing - static menu
end;

function TProjectPlusMenuItem._GetSelectedPath(const AMenuContextList: IInterfaceList): string;
var
  LContext: IOTAProjectMenuContext;
  LFor: Integer;
begin
  Result := '';
  if not Assigned(AMenuContextList) or (AMenuContextList.Count = 0) then
    Exit;

  for LFor := 0 to AMenuContextList.Count - 1 do
  begin
    if Supports(AMenuContextList[LFor], IOTAProjectMenuContext, LContext) then
    begin
      Result := LContext.Ident;
      Break;
    end;
  end;
end;

function TProjectPlusMenuItem._FindCorrectProject(const ASelectedPath: string; out AProjectPath: string): IOTAProject;
var
  LProjectGroup: IOTAProjectGroup;
  LProjectIndex: Integer;
  LCurrentProject: IOTAProject;
  LPath: string;
begin
  Result := nil;
  AProjectPath := '';

  if (ASelectedPath = '') or not Assigned(BorlandIDEServices) then
    Exit;

  LProjectGroup := (BorlandIDEServices as IOTAModuleServices).MainProjectGroup;
  if not Assigned(LProjectGroup) then
    Exit;

  for LProjectIndex := 0 to LProjectGroup.ProjectCount - 1 do
  begin
    LCurrentProject := LProjectGroup.Projects[LProjectIndex];
    if not Assigned(LCurrentProject) then
      Continue;

    LPath := ExtractFilePath(LCurrentProject.FileName);
    TDebugLog.Log('Checking project: ' + LCurrentProject.FileName);      
    TDebugLog.Log('Project path: ' + LPath);

    // Check if selected path starts with this project's path
    if (LPath <> '') and (Pos(UpperCase(LPath), UpperCase(ASelectedPath)) = 1) then
    begin
      Result := LCurrentProject;
      AProjectPath := LPath;
      TDebugLog.Log('Found correct project: ' + LCurrentProject.FileName);
      Break;
    end;
  end;
end;

function TProjectPlusMenuItem._CreateCommand(const AVerb, ASelectedPath, AProjectPath: string; const AProject: IOTAProject): IProjectPlusCommand;
begin
  Result := nil;
  case IndexText(AVerb, ['NewUnit', 'NewFolder', 'AddFolders', 'RemoveUnitsFromFolder']) of
    0: // NewUnit
    begin
      Result := TNewUnitCommand.Create(AProject, ASelectedPath, AProjectPath);
      TDebugLog.Log('Created TNewUnitCommand');
    end;
    1: // NewFolder
    begin
      Result := TNewFolderCommand.Create(AProject, ASelectedPath, AProjectPath);
      TDebugLog.Log('Created TNewFolderCommand');
    end;
    2: // AddFolders
    begin
      Result := TAddFoldersCommand.Create(AProject, ASelectedPath, AProjectPath);
      TDebugLog.Log('Created TAddFoldersCommand');
    end;
    3: // RemoveUnitsFromFolder
    begin
      Result := TRemoveUnitsFromFolderCommand.Create(AProject, ASelectedPath, AProjectPath);
      TDebugLog.Log('Created TRemoveUnitsFromFolderCommand with correct project');
    end;
  else
  begin
    TDebugLog.Log('Unknown verb: ' + AVerb);
    MessageDlg('Unknown command: ' + AVerb, mtError, [mbOK], 0);
  end;
  end;
end;

procedure TProjectPlusMenuItem.Execute(const AMenuContextList: IInterfaceList);
var
  LCommand: IProjectPlusCommand;
  LSelectedPath: string;
  LProjectPath: string;
  LCorrectProject: IOTAProject;
begin
  TDebugLog.Log('TProjectPlusMenuItem.Execute called with verb: ' + FVerb);

  try
    LSelectedPath := _GetSelectedPath(AMenuContextList);
    TDebugLog.Log('Selected path: ' + LSelectedPath);

    LCorrectProject := _FindCorrectProject(LSelectedPath, LProjectPath);

    // If no correct project found, use the original FProject as fallback
    if not Assigned(LCorrectProject) then
    begin
      LCorrectProject := FProject;
      if Assigned(FProject) then
      begin
        LProjectPath := ExtractFilePath(FProject.FileName);
        TDebugLog.Log('Using fallback project: ' + FProject.FileName);
      end;
    end;

    TDebugLog.Log('Final selected path: ' + LSelectedPath);
    TDebugLog.Log('Final project path: ' + LProjectPath);

    // Handle parent menu - no action needed, just display submenu
    if FVerb = 'AddMenu' then
    begin
      TDebugLog.Log('Parent Add menu clicked - showing submenu');
      Exit;
    end;

    // Create command based on verb
    LCommand := _CreateCommand(FVerb, LSelectedPath, LProjectPath, LCorrectProject);

    // Execute command
    if Assigned(LCommand) then
    begin
      TDebugLog.Log('Executing command: ' + LCommand.GetName);
      LCommand.Execute;
    end;

  except
    on E: Exception do
    begin
      TDebugLog.Log('Error in Execute: ' + E.Message);
      MessageDlg('Error executing command: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TProjectPlusMenuItem.PreExecute(const AMenuContextList: IInterfaceList): Boolean;
begin
  Result := True;
end;

function TProjectPlusMenuItem.PostExecute(const AMenuContextList: IInterfaceList): Boolean;
begin
  Result := False;
end;

procedure Register;
begin
  TDebugLog.Log('ProjectsManagerPlus: Register procedure called');

  if not Assigned(BorlandIDEServices) then
  begin
    TDebugLog.Log('ProjectsManagerPlus: BorlandIDEServices is not assigned');
    Exit;
  end;

  TDebugLog.Log('ProjectsManagerPlus: BorlandIDEServices is assigned');

  // Avoid double registration
  if Assigned(GMenuNotifier) then
  begin
    TDebugLog.Log('ProjectsManagerPlus: MenuNotifier already exists, skipping registration');
    Exit;
  end;

  GMenuNotifier := TProjectPlusMenuNotifier.Create;

  try
    GNotifierIndex := (BorlandIDEServices as IOTAProjectManager).AddMenuItemCreatorNotifier(GMenuNotifier);
    TDebugLog.Log('ProjectsManagerPlus: Menu item creator notifier added (Delphi 2010+) - Index: ' + IntToStr(GNotifierIndex));
  except
    on E: Exception do
    begin
      TDebugLog.Log('ProjectsManagerPlus: Error adding menu item creator notifier: ' + E.Message);
      FreeAndNil(GMenuNotifier);
    end;
  end;

  if GNotifierIndex >= 0 then
    TDebugLog.Log('ProjectsManagerPlus: Registration completed successfully')
  else
    TDebugLog.Log('ProjectsManagerPlus: Registration failed - invalid notifier index');
end;

procedure Finalize;
var
  LProjectManager: IOTAProjectManager;
begin
  TDebugLog.Log('ProjectsManagerPlus: Finalize procedure called');

  if Assigned(BorlandIDEServices) and Assigned(GMenuNotifier) and (GNotifierIndex >= 0) then
  begin
    try
      if Supports(BorlandIDEServices, IOTAProjectManager, LProjectManager) then
      begin
        LProjectManager.RemoveMenuItemCreatorNotifier(GNotifierIndex);
        TDebugLog.Log('ProjectsManagerPlus: Menu item creator notifier removed');
      end;
    except
      on E: Exception do
        TDebugLog.Log('ProjectsManagerPlus: Error removing notifier: ' + E.Message);
    end;
  end;
  
  // Force nullification regardless of exceptions
  GMenuNotifier := nil;
  GNotifierIndex := -1;

  TDebugLog.Log('ProjectsManagerPlus: Finalization completed');
end;

initialization
  Register;

finalization
  Finalize;

end.



