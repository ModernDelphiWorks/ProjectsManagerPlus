program TestFileServiceCreateFile;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils,
  ProjectsManagerPlus.Services;

var
  LPath: string;
  LContent: string;
  LResult: Boolean;
begin
  LPath := 'TestOutput.txt';
  LContent := 'hello world';
  LResult := TFileService.CreateFile(LPath, LContent);
  if LResult and TFile.Exists(LPath) and (TFile.ReadAllText(LPath) = LContent) then
    Writeln('PASS: file created with expected content')
  else
    Writeln('FAIL: file not created or content mismatch');
  if TFile.Exists(LPath) then
    TFile.Delete(LPath);
end.

