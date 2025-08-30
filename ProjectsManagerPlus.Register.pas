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
    procedure AddMenu(const Project: IOTAProject; const IdentList: TStrings;
      const ProjectManagerMenuList: IInterfaceList; IsMultiSelect: Boolean);
    function CanHandle(const Ident: string): Boolean;
  end;

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

procedure TProjectPlusMenuNotifier.AddMenu(const Project: IOTAProject;
  const IdentList: TStrings; const ProjectManagerMenuList: IInterfaceList;
  IsMultiSelect: Boolean);
var
  LFor: Integer;
begin
  TDebugLog.Log('TProjectPlusMenuNotifier.AddMenu called');

  if not Assigned(IdentList) or (IdentList.Count = 0) then
    Exit;

  TDebugLog.Log('ProjectsManagerPlus: AddMenu - IdentList.Count: ' + IntToStr(IdentList.Count));

  for LFor := 0 to IdentList.Count - 1 do
  begin
    if CProjectContainer = IdentList[LFor] then
    begin
      ProjectManagerMenuList.Add(TProjectPlusMenuItem.Create(
        'Add Folder...', 'AddFolder', 'AddFolders', '', High(Integer), Project));
      TDebugLog.Log('ProjectsManagerPlus: Menu Add Folder criado para projeto');
    end
    else if CDirectoryContainer = IdentList[LFor] then
    begin
      ProjectManagerMenuList.Add(TProjectPlusMenuItem.Create(
        'New Unit...', 'NewUnit', 'NewUnit', '', 100, Project));
      ProjectManagerMenuList.Add(TProjectPlusMenuItem.Create(
        'New Folder...', 'NewFolder', 'NewFolder', '', 101, Project));
      ProjectManagerMenuList.Add(TProjectPlusMenuItem.Create(
        'Add Folder...', 'AddFolder', 'AddFolders', '', 102, Project));
      ProjectManagerMenuList.Add(TProjectPlusMenuItem.Create(
        'Remove Folder', 'RemoveFolder', 'RemoveUnitsFromFolder', '', 103, Project));
      TDebugLog.Log('ProjectsManagerPlus: Menus criados para pasta');
    end;
  end;
end;

function TProjectPlusMenuNotifier.CanHandle(const Ident: string): Boolean;
begin
  TDebugLog.Log('TProjectPlusMenuNotifier.CanHandle called with Ident: ' + Ident);

  Result := (Ident = CProjectContainer) or (Ident = CDirectoryContainer);

  TDebugLog.Log('CanHandle result: ' + BoolToStr(Result, True) + ' for Ident: ' + Ident);
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
  TDebugLog.Log('TProjectPlusMenuItem.Execute called with verb: ' + FVerb);

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

    TDebugLog.Log('Selected path: ' + LSelectedPath);

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
            TDebugLog.Log('Checking project: ' + LCurrentProject.FileName);
            TDebugLog.Log('Project path: ' + LProjectPath);

            // Check if selected path starts with this project's path
            if (LProjectPath <> '') and (Pos(UpperCase(LProjectPath), UpperCase(LSelectedPath)) = 1) then
            begin
              LCorrectProject := LCurrentProject;
              TDebugLog.Log('Found correct project: ' + LCurrentProject.FileName);
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
    case IndexText(FVerb, ['NewUnit', 'NewFolder', 'AddFolders', 'RemoveUnitsFromFolder']) of
      0: // NewUnit
      begin
        LCommand := TNewUnitCommand.Create(LCorrectProject, LSelectedPath, LProjectPath);
        TDebugLog.Log('Created TNewUnitCommand');
      end;
      1: // NewFolder
      begin
        LCommand := TNewFolderCommand.Create(LCorrectProject, LSelectedPath, LProjectPath);
        TDebugLog.Log('Created TNewFolderCommand');
      end;
      2: // AddFolders
      begin
        LCommand := TAddFoldersCommand.Create(LCorrectProject, LSelectedPath, LProjectPath);
        TDebugLog.Log('Created TAddFoldersCommand');
      end;
      3: // RemoveUnitsFromFolder
      begin
        LCommand := TRemoveUnitsFromFolderCommand.Create(LCorrectProject, LSelectedPath, LProjectPath);
        TDebugLog.Log('Created TRemoveUnitsFromFolderCommand with correct project');
      end;
    else
      TDebugLog.Log('Unknown verb: ' + FVerb);
      MessageDlg('Unknown command: ' + FVerb, mtError, [mbOK], 0);
      Exit;
    end;

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

function TProjectPlusMenuItem.PreExecute(const MenuContextList: IInterfaceList): Boolean;
begin
  Result := True;
end;

function TProjectPlusMenuItem.PostExecute(const MenuContextList: IInterfaceList): Boolean;
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
begin
  TDebugLog.Log('ProjectsManagerPlus: Finalize procedure called');

  if Assigned(GMenuNotifier) and (GNotifierIndex >= 0) then
  begin
    try
      (BorlandIDEServices as IOTAProjectManager).RemoveMenuItemCreatorNotifier(GNotifierIndex);
      TDebugLog.Log('ProjectsManagerPlus: Menu item creator notifier removed (Delphi 2010+)');
    except
      on E: Exception do
        TDebugLog.Log('ProjectsManagerPlus: Error removing notifier: ' + E.Message);
    end;
    GMenuNotifier := nil;
    GNotifierIndex := -1;
  end;

  TDebugLog.Log('ProjectsManagerPlus: Finalization completed');
end;

initialization
  Register;

finalization
  Finalize;

end.



