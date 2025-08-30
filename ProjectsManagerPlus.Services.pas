unit ProjectsManagerPlus.Services;

interface

uses
  ToolsAPI,
  System.SysUtils,
  System.Classes;

type
  /// <summary>
  /// Provides helper methods for file operations.
  /// </summary>
  TFileService = class
  public
    class function CreateFile(const APath, AContent: string): Boolean;
    class function CreateFolder(const APath: string): Boolean;
  end;

implementation

{ TFileService }

class function TFileService.CreateFile(const APath, AContent: string): Boolean;
var
  LFile: TextFile;
begin
  Result := False;
  try
    AssignFile(LFile, APath);
    Rewrite(LFile);
    if AContent <> '' then
      Write(LFile, AContent);
    CloseFile(LFile);
    Result := True;
  except
    on E: Exception do
      Result := False;
  end;
end;

class function TFileService.CreateFolder(const APath: string): Boolean;
begin
  Result := ForceDirectories(APath);
end;

end.

