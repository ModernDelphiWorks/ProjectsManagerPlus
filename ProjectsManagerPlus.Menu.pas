unit ProjectsManagerPlus.Menu;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  Vcl.Dialogs,
  Vcl.Controls,
  Winapi.Windows,
  ProjectsManagerPlus.Commands,
  ProjectsManagerPlus.Types,
  ProjectsManagerPlus.DebugLogHelper;

type
  TProjectPlusMenu = class(TNotifierObject, IOTAProjectManagerMenu)
  private
    FProject: IOTAProject;
    FCaption: string;
    FName: string;
    FParent: string;
    FPosition: Integer;
    FVerb: string;
    FChecked: Boolean;
    FEnabled: Boolean;
    FHelpContext: Integer;
    FMultiSelectable: Boolean;
    FMenuType: string;
  public
    constructor Create(const AProject: IOTAProject); overload;
    constructor Create(const AProject: IOTAProject; const ACaption, AMenuType: string); overload;
    { IOTANotifier }
    procedure AfterSave;
    procedure BeforeSave;
    procedure Destroyed;
    procedure Modified;
    { IOTALocalMenu }
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
    { IOTAProjectManagerMenu }
    function GetIsMultiSelectable: Boolean;
    procedure SetIsMultiSelectable(Value: Boolean);
    procedure Execute(const MenuContextList: IInterfaceList); overload;
    function PreExecute(const MenuContextList: IInterfaceList): Boolean;
    function PostExecute(const MenuContextList: IInterfaceList): Boolean;
  end;

implementation

{ TProjectPlusMenu }

constructor TProjectPlusMenu.Create(const AProject: IOTAProject);
begin
  Create(AProject, 'ProjectsManagerPlus', 'Default');
end;

constructor TProjectPlusMenu.Create(const AProject: IOTAProject; const ACaption, AMenuType: string);
begin
  FProject := AProject;
  FCaption := ACaption;
  FMenuType := AMenuType;
  FName := 'ProjectPlus.' + AMenuType;
  FParent := '';
  FPosition := -17;
  FVerb := AMenuType + 'Verb';
  FChecked := False;
  FEnabled := True;
  FHelpContext := 0;
  FMultiSelectable := False;
end;

{ IOTANotifier }

procedure TProjectPlusMenu.AfterSave;
begin
end;

procedure TProjectPlusMenu.BeforeSave;
begin
end;

procedure TProjectPlusMenu.Destroyed;
begin
end;

procedure TProjectPlusMenu.Modified;
begin
end;

{ IOTALocalMenu }

function TProjectPlusMenu.GetCaption: string;
begin
  Result := FCaption;
end;

function TProjectPlusMenu.GetChecked: Boolean;
begin
  Result := FChecked;
end;

function TProjectPlusMenu.GetEnabled: Boolean;
begin
  Result := FEnabled;
end;

function TProjectPlusMenu.GetHelpContext: Integer;
begin
  Result := FHelpContext;
end;

function TProjectPlusMenu.GetName: string;
begin
  Result := FName;
end;

function TProjectPlusMenu.GetParent: string;
begin
  Result := FParent;
end;

function TProjectPlusMenu.GetPosition: Integer;
begin
  Result := FPosition;
end;

function TProjectPlusMenu.GetVerb: string;
begin
  Result := FVerb;
end;

procedure TProjectPlusMenu.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

procedure TProjectPlusMenu.SetChecked(Value: Boolean);
begin
  FChecked := Value;
end;

procedure TProjectPlusMenu.SetEnabled(Value: Boolean);
begin
  FEnabled := Value;
end;

procedure TProjectPlusMenu.SetHelpContext(Value: Integer);
begin
  FHelpContext := Value;
end;

procedure TProjectPlusMenu.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TProjectPlusMenu.SetParent(const Value: string);
begin
  FParent := Value;
end;

procedure TProjectPlusMenu.SetPosition(Value: Integer);
begin
  FPosition := Value;
end;

procedure TProjectPlusMenu.SetVerb(const Value: string);
begin
  FVerb := Value;
end;

{ IOTAProjectManagerMenu }

function TProjectPlusMenu.GetIsMultiSelectable: Boolean;
begin
  Result := FMultiSelectable;
end;

procedure TProjectPlusMenu.SetIsMultiSelectable(Value: Boolean);
begin
  FMultiSelectable := Value;
end;

procedure TProjectPlusMenu.Execute(const MenuContextList: IInterfaceList);
var
  LCmd: IProjectPlusCommand;
  LSelectedPath: string;
  LProjectPath: string;
begin
  TDebugLog.Log('ProjectsManagerPlus: Execute called for MenuType: ' + FMenuType);

  // Determine project path; menu context currently ignored
  LSelectedPath := '';
  if Assigned(FProject) then
    LProjectPath := ExtractFilePath(FProject.FileName)
  else
    LProjectPath := GetCurrentDir;

  TDebugLog.Log('ProjectsManagerPlus: ProjectPath: ' + LProjectPath);

  // Execute command based on menu type
  if FMenuType = 'NewUnit' then
  begin
    TDebugLog.Log('ProjectsManagerPlus: Creating NewUnitCommand');
    LCmd := TNewUnitCommand.Create(FProject, LSelectedPath, LProjectPath);
    LCmd.Execute;
  end
  else if FMenuType = 'NewFolder' then
  begin
    TDebugLog.Log('ProjectsManagerPlus: Creating NewFolderCommand');
    LCmd := TNewFolderCommand.Create(FProject, LSelectedPath, LProjectPath);
    LCmd.Execute;
  end
  else if FMenuType = 'AddFolders' then
  begin
    TDebugLog.Log('ProjectsManagerPlus: Creating AddFoldersCommand');
    LCmd := TAddFoldersCommand.Create(FProject, LSelectedPath, LProjectPath);
    LCmd.Execute;
  end
  else
  begin
    TDebugLog.Log('ProjectsManagerPlus: Unknown MenuType: ' + FMenuType);
  end;
end;

function TProjectPlusMenu.PreExecute(const MenuContextList: IInterfaceList): Boolean;
begin
  Result := True; // allow execution
end;

function TProjectPlusMenu.PostExecute(const MenuContextList: IInterfaceList): Boolean;
begin
  Result := True; // no special cleanup
end;

end.



