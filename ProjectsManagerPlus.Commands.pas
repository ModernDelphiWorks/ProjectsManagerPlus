unit ProjectsManagerPlus.Commands;

interface

uses
  System.Types,
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  ToolsAPI,
  Vcl.Dialogs,
  Vcl.Controls,
  Winapi.Windows,
  ProjectsManagerPlus.Types,
  ProjectsManagerPlus.Services,
  ProjectsManagerPlus.FolderDialog,
  ProjectsManagerPlus.DebugLogHelper;

type
  /// <summary>
  /// Base command class with common functionality.
  /// </summary>
  TBaseProjectCommand = class(TInterfacedObject, IProjectPlusCommand)
  protected
    FProject: IOTAProject;
    FSelectedPath: string;
    FProjectPath: string;
    function _GetSelectedFolderPath: string;
    function _ShowInputDialog(const APrompt, ADefault: string): string;
    procedure _AddFileToProject(const AFileName: string);
    function _CreateEmptyUnitTemplate(const AUnitName: string): string;
  public
    constructor Create(const AProject: IOTAProject; const ASelectedPath, AProjectPath: string);
    procedure Execute; virtual; abstract;
    function GetName: string; virtual; abstract;
  end;

  /// <summary>
  /// Command to create a new unit file.
  /// </summary>
  TNewUnitCommand = class(TBaseProjectCommand)
  public
    procedure Execute; override;
    function GetName: string; override;
  end;

  /// <summary>
  /// Command to create a new folder.
  /// </summary>
  TNewFolderCommand = class(TBaseProjectCommand)
  public
    procedure Execute; override;
    function GetName: string; override;
  end;

  /// <summary>
  /// Command to add units from selected folder(s) to the project.
  /// </summary>
  TAddFoldersCommand = class(TBaseProjectCommand)
  private
    procedure _AddUnitsFromFolder(const AFolderPath: string; AIncludeSubfolders: Boolean);
  public
    procedure Execute; override;
    function GetName: string; override;
  end;

  /// <summary>
  /// Command to remove units from selected folder and subfolders from the project.
  /// </summary>
  TRemoveUnitsFromFolderCommand = class(TBaseProjectCommand)
  private
    function _RemoveUnitsSimple(const AFolderPath: string): Integer;
    function _ConfirmRemoval(const AFolderPath: string): Boolean;
  public
    procedure Execute; override;
    function GetName: string; override;
  end;

implementation

{ TBaseProjectCommand }

constructor TBaseProjectCommand.Create(const AProject: IOTAProject; const ASelectedPath, AProjectPath: string);
begin
  FProject := AProject;
  FSelectedPath := ASelectedPath;
  FProjectPath := AProjectPath;
end;

function TBaseProjectCommand._GetSelectedFolderPath: string;
begin
  TDebugLog.Log('_GetSelectedFolderPath: Starting');
  TDebugLog.Log('_GetSelectedFolderPath: FSelectedPath = "' + FSelectedPath + '"');
  TDebugLog.Log('_GetSelectedFolderPath: FProjectPath = "' + FProjectPath + '"');

  Result := FProjectPath;
  if FSelectedPath <> '' then
  begin
    // Check if FSelectedPath is already an absolute path
    if TPath.IsPathRooted(FSelectedPath) then
    begin
      TDebugLog.Log('_GetSelectedFolderPath: FSelectedPath is absolute path');
      if TFile.Exists(FSelectedPath) then
      begin
        Result := ExtractFilePath(FSelectedPath);
        TDebugLog.Log('_GetSelectedFolderPath: FSelectedPath is file, using directory: "' + Result + '"');
      end
      else if TDirectory.Exists(FSelectedPath) then
      begin
        Result := FSelectedPath;
        TDebugLog.Log('_GetSelectedFolderPath: FSelectedPath is directory: "' + Result + '"');
      end
      else
      begin
        TDebugLog.Log('_GetSelectedFolderPath: FSelectedPath does not exist, using as-is: "' + FSelectedPath + '"');
        Result := FSelectedPath;
      end;
    end
    else
    begin
      TDebugLog.Log('_GetSelectedFolderPath: FSelectedPath is relative, combining with project path');
      Result := TPath.Combine(FProjectPath, FSelectedPath);
      TDebugLog.Log('_GetSelectedFolderPath: Combined result: "' + Result + '"');
    end;
  end;

  TDebugLog.Log('_GetSelectedFolderPath: Final result = "' + Result + '"');
end;

function TBaseProjectCommand._ShowInputDialog(const APrompt, ADefault: string): string;
begin
  Result := ADefault;
  InputQuery('ProjectsManagerPlus', APrompt, Result);
end;

procedure TBaseProjectCommand._AddFileToProject(const AFileName: string);
var
  LModuleServices: IOTAModuleServices;
begin
  TDebugLog.Log('AddFileToProject: Attempting to add file: ' + AFileName);

  if not Assigned(FProject) then
  begin
    TDebugLog.Log('AddFileToProject: FProject is nil');
    Exit;
  end;

  if not TFile.Exists(AFileName) then
  begin
    TDebugLog.Log('AddFileToProject: File does not exist: ' + AFileName);
    Exit;
  end;

  try
    LModuleServices := BorlandIDEServices as IOTAModuleServices;
    if Assigned(LModuleServices) then
    begin
      FProject.AddFile(AFileName, True);
      TDebugLog.Log('AddFileToProject: Successfully added file: ' + AFileName);
    end
    else
      TDebugLog.Log('AddFileToProject: LModuleServices is nil');
  except
    on E: Exception do
      TDebugLog.Log('AddFileToProject: Exception: ' + E.Message);
  end;
end;

function TBaseProjectCommand._CreateEmptyUnitTemplate(const AUnitName: string): string;
begin
  Result := Format(
    'unit %s;'#13#10#13#10 +
    'interface'#13#10#13#10 +
    'implementation'#13#10#13#10 +
    'end.', [AUnitName]);
end;

{ TAddNewUnitCommand }

procedure TNewUnitCommand.Execute;
var
  LUnitName: string;
  LTargetPath: string;
  LFullPath: string;
  LUnitContent: string;
begin
  try
    LUnitName := _ShowInputDialog('New unit name:', '');
    if LUnitName = '' then Exit;

    // Remove extension if provided
    if SameText(ExtractFileExt(LUnitName), '.pas') then
      LUnitName := ChangeFileExt(LUnitName, '');

    LTargetPath := _GetSelectedFolderPath;
    LFullPath := TPath.Combine(LTargetPath, LUnitName + '.pas');

    if TFile.Exists(LFullPath) then
    begin
      MessageDlg('File already exists: ' + LFullPath, mtWarning, [mbOK], 0);
      Exit;
    end;

    // Create basic unit content
    LUnitContent := Format(
      'unit %s;'#13#10#13#10 +
      'interface'#13#10#13#10 +
      'implementation'#13#10#13#10 +
      'end.', [LUnitName]);

    if TFileService.CreateFile(LFullPath, LUnitContent) then
    begin
      _AddFileToProject(LFullPath);
      MessageDlg('Unit created successfully: ' + LFullPath, mtInformation, [mbOK], 0);
    end
    else
      MessageDlg('Error creating unit: ' + LFullPath, mtError, [mbOK], 0);
  except
    on E: Exception do
      MessageDlg('Error: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

function TNewUnitCommand.GetName: string;
begin
  Result := 'NewUnit';
end;

{ TAddFoldersCommand }

procedure TAddFoldersCommand.Execute;
var
  LFolderPath: string;
  LIncludeSubfolders: Boolean;
begin
  try
    if TFolderSelectionDialog.Execute(_GetSelectedFolderPath, LFolderPath, LIncludeSubfolders) then
    begin
      if not TDirectory.Exists(LFolderPath) then
      begin
        MessageDlg('Selected folder does not exist: ' + LFolderPath, mtError, [mbOK], 0);
        Exit;
      end;

      _AddUnitsFromFolder(LFolderPath, LIncludeSubfolders);
    end;
  except
    on E: Exception do
      MessageDlg('Error: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TAddFoldersCommand._AddUnitsFromFolder(const AFolderPath: string; AIncludeSubfolders: Boolean);
var
  LFiles: TStringDynArray;
  LFile: string;
  LCount: Integer;
  LSearchOption: TSearchOption;
begin
  TDebugLog.Log('AddUnitsFromFolder: Starting with folder: ' + AFolderPath);
  TDebugLog.Log('AddUnitsFromFolder: Include subfolders: ' + BoolToStr(AIncludeSubfolders, True));

  LCount := 0;

  if AIncludeSubfolders then
    LSearchOption := TSearchOption.soAllDirectories
  else
    LSearchOption := TSearchOption.soTopDirectoryOnly;

  try
    LFiles := TDirectory.GetFiles(AFolderPath, '*.pas', LSearchOption);
    TDebugLog.Log('AddUnitsFromFolder: Found ' + IntToStr(Length(LFiles)) + ' .pas files');

    for LFile in LFiles do
    begin
      TDebugLog.Log('AddUnitsFromFolder: Processing file: ' + LFile);

      if Assigned(FProject) and (FProject.FindModuleInfo(LFile) = nil) then
      begin
        TDebugLog.Log('AddUnitsFromFolder: File not in project, adding: ' + LFile);
        _AddFileToProject(LFile);
        Inc(LCount);
      end
      else
      begin
        if not Assigned(FProject) then
          TDebugLog.Log('AddUnitsFromFolder: FProject is nil')
        else
          TDebugLog.Log('AddUnitsFromFolder: File already in project: ' + LFile);
      end;
    end;
  except
    on E: Exception do
    begin
      TDebugLog.Log('AddUnitsFromFolder: Exception: ' + E.Message, TLogLevel.llError);
      MessageDlg('Error processing folder: ' + E.Message, mtError, [mbOK], 0);
      Exit;
    end;
  end;

  TDebugLog.Log('AddUnitsFromFolder: Added ' + IntToStr(LCount) + ' files');

  if LCount > 0 then
    MessageDlg(Format('Added %d units to project from folder: %s', [LCount, AFolderPath]), mtInformation, [mbOK], 0)
  else
    MessageDlg('No new units found in folder: ' + AFolderPath, mtInformation, [mbOK], 0);
end;

function TAddFoldersCommand.GetName: string;
begin
  Result := 'AddFolders';
end;

{ TNewFolderCommand }

procedure TNewFolderCommand.Execute;
var
  LFolderName: string;
  LTargetPath: string;
  LFullPath: string;
  LUnitName: string;
  LUnitPath: string;
  LUnitContent: string;
begin
  try
    LFolderName := _ShowInputDialog('New folder name:', '');
    if LFolderName = '' then Exit;

    LTargetPath := _GetSelectedFolderPath;
    LFullPath := TPath.Combine(LTargetPath, LFolderName);

    if TDirectory.Exists(LFullPath) then
    begin
      MessageDlg('Folder already exists: ' + LFullPath, mtWarning, [mbOK], 0);
      Exit;
    end;

    // Create physical folder
    if TFileService.CreateFolder(LFullPath) then
    begin
      // Create an empty unit inside the folder so it appears in Project Manager
      LUnitName := LFolderName + 'Unit';
      LUnitPath := TPath.Combine(LFullPath, LUnitName + '.pas');
      LUnitContent := _CreateEmptyUnitTemplate(LUnitName);

      if TFileService.CreateFile(LUnitPath, LUnitContent) then
      begin
        // Add unit to project
        _AddFileToProject(LUnitPath);
        MessageDlg('Folder and unit created successfully: ' + LFullPath, mtInformation, [mbOK], 0);
      end
      else
        MessageDlg('Folder created but error creating unit: ' + LUnitPath, mtError, [mbOK], 0);
    end
    else
      MessageDlg('Error creating folder: ' + LFullPath, mtError, [mbOK], 0);
  except
    on E: Exception do
      MessageDlg('Error: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

function TNewFolderCommand.GetName: string;
begin
  Result := 'NewFolder';
end;

{ TRemoveUnitsFromFolderCommand }

procedure TRemoveUnitsFromFolderCommand.Execute;
var
  LFolderPath: string;
  LRemovedCount: Integer;
  LMessage: string;
begin
  TDebugLog.Log('*** TRemoveUnitsFromFolderCommand.Execute CALLED ***');
  TDebugLog.Log('FProject assigned: ' + BoolToStr(Assigned(FProject), True));
  TDebugLog.Log('FSelectedPath: "' + FSelectedPath + '"');
  TDebugLog.Log('FProjectPath: "' + FProjectPath + '"');
  try
    LFolderPath := _GetSelectedFolderPath;

    TDebugLog.Log('=== SIMPLE REMOVE UNITS STARTING ===');
    TDebugLog.Log('Selected folder: "' + LFolderPath + '"');

    if not TDirectory.Exists(LFolderPath) then
    begin
      MessageDlg('Selected folder does not exist: ' + LFolderPath, mtError, [mbOK], 0);
      Exit;
    end;

    if not _ConfirmRemoval(LFolderPath) then
      Exit;

    LRemovedCount := _RemoveUnitsSimple(LFolderPath);

    if LRemovedCount > 0 then
    begin
      LMessage := Format('Successfully removed %d units from project.', [LRemovedCount]) + #13#10#13#10 +
                  'Folder: ' + LFolderPath;
      MessageDlg(LMessage, mtInformation, [mbOK], 0);
    end
    else
    begin
      LMessage := 'No units found to remove in the selected folder or its subfolders.' + #13#10#13#10 +
                  'This means:' + #13#10 +
                  '• The main folder contains no .pas files in the project' + #13#10 +
                  '• No subfolders contain .pas files in the project' + #13#10#13#10 +
                  'Folder: ' + LFolderPath;
      MessageDlg(LMessage, mtInformation, [mbOK], 0);
    end;
  except
    on E: Exception do
    begin
      TDebugLog.Log('Error removing units: ' + E.Message, TLogLevel.llError);
      MessageDlg('Error removing units: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TRemoveUnitsFromFolderCommand._ConfirmRemoval(const AFolderPath: string): Boolean;
var
  LMessage: string;
  LFileCount: Integer;
  LModuleInfo: IOTAModuleInfo;
  LFor: Integer;
  LModuleCount: Integer;
  LFileName: string;
  LFileDirectory: string;
  LSelectedFolderPath: string;
  LExpandedSelectedPath: string;
  LExpandedFilePath: string;
begin
  LFileCount := 0;
  try
    LExpandedSelectedPath := ExpandFileName(AFolderPath);
    LSelectedFolderPath := IncludeTrailingPathDelimiter(LExpandedSelectedPath).ToUpper;
    LModuleCount := FProject.GetModuleCount;

    for LFor := 0 to LModuleCount - 1 do
    begin
      try
        if Supports(FProject.GetModule(LFor), IOTAModuleInfo, LModuleInfo) then
        begin
          LFileName := LModuleInfo.FileName;
          if SameText(ExtractFileExt(LFileName), '.pas') then
          begin
            LExpandedFilePath := ExpandFileName(LFileName);
            LFileDirectory := IncludeTrailingPathDelimiter(ExtractFilePath(LExpandedFilePath)).ToUpper;
            if LFileDirectory.StartsWith(LSelectedFolderPath) then
              Inc(LFileCount);
          end;
        end;
      except
        // Ignora erros e continua
      end;
    end;
  except
    LFileCount := 0;
  end;

  LMessage := Format('Remove all units (.pas files) from the selected folder and ALL its subfolders?'#13#10#13#10 +
                     'Folder: %s'#13#10 +
                     'Found %d .pas files IN PROJECT that will be removed'#13#10#13#10 +
                     'This action will:'#13#10 +
                     '• Remove units in this folder and subfolders'#13#10 +
                     '• Only remove units already added to the project'#13#10 +
                     '• Files will NOT be deleted from disk'#13#10#13#10 +
                     'Continue?',
                     [AFolderPath, LFileCount]);
  Result := MessageDlg(LMessage, mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

function TRemoveUnitsFromFolderCommand._RemoveUnitsSimple(const AFolderPath: string): Integer;
var
  LModuleInfo: IOTAModuleInfo;
  LFor: Integer;
  LModuleCount: Integer;
  LFileName: string;
  LFileDirectory: string;
  LSelectedFolderPath: string;
  LExpandedSelectedPath: string;
  LExpandedFilePath: string;
  FileExt: string;
  LNormalizedSelected: string;
  LNormalizedFile: string;
begin
  Result := 0;

  if not Assigned(FProject) then Exit;

  LExpandedSelectedPath := ExpandFileName(AFolderPath);
  LSelectedFolderPath := IncludeTrailingPathDelimiter(LExpandedSelectedPath).ToUpper;
  LNormalizedSelected := StringReplace(LSelectedFolderPath, '/', '\', [rfReplaceAll]);

  LModuleCount := FProject.GetModuleCount;

  for LFor := LModuleCount - 1 downto 0 do
  begin
    try
      if Supports(FProject.GetModule(LFor), IOTAModuleInfo, LModuleInfo) then
      begin
        LFileName := LModuleInfo.FileName;
        FileExt := ExtractFileExt(LFileName);

        if SameText(FileExt, '.pas') then
        begin
          LExpandedFilePath := ExpandFileName(LFileName);
          LFileDirectory := IncludeTrailingPathDelimiter(ExtractFilePath(LExpandedFilePath)).ToUpper;
          LNormalizedFile := StringReplace(LFileDirectory, '/', '\', [rfReplaceAll]);

          if LNormalizedFile.StartsWith(LNormalizedSelected) then
          begin
            TDebugLog.Log('[DEBUG] REMOVING: ' + LFileName, TLogLevel.llDebug);
            FProject.RemoveFile(LFileName);
            Inc(Result);
          end;
        end;
      end;
    except
      on E: Exception do
        TDebugLog.Log('[ERROR] Remove failed: ' + E.Message, TLogLevel.llError);
    end;
  end;
end;

function TRemoveUnitsFromFolderCommand.GetName: string;
begin
  Result := 'RemoveUnitsFromFolder';
end;

end.



