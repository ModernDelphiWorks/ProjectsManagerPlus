unit ProjectsManagerPlus.DebugLogHelper;

interface

uses
  Winapi.Windows,
  System.SysUtils;

type
  TLogLevel = (llInfo, llWarn, llError, llDebug);

  TDebugLog = record
  public
    class var Prefix: string;
    /// <summary>
    /// Envia mensagem para o DebugView com prefixo padrão, thread ID e timestamp.
    /// </summary>
    class procedure Log(const AMessage: string; ALevel: TLogLevel = llInfo); static;
    class procedure LogFmt(const ALevel: TLogLevel; const AFormat: string; const AArgs: array of const); static;
  end;

implementation

const
  LOG_TAGS: array [TLogLevel] of string = (
    '[INFO]  ',  // llInfo
    '[WARN]  ',  // llWarn
    '[ERROR] ',  // llError
    '[DEBUG] '   // llDebug
  );

{ TDebugLog }

class procedure TDebugLog.Log(const AMessage: string; ALevel: TLogLevel = llInfo);
var
  LTimestamp: string;
  LThreadId: Cardinal;
  LFormatted: string;
  LTag: string;
begin
  LTimestamp := FormatDateTime('hh:nn:ss.zzz', Now);
  LThreadId := GetCurrentThreadId;
  LTag := LOG_TAGS[ALevel];
  LFormatted := Format('%s %s [%s][TID:%d] %s',
    [LTag, Prefix, LTimestamp, LThreadId, AMessage]);

  OutputDebugString(PChar(LFormatted));
end;

class procedure TDebugLog.LogFmt(const ALevel: TLogLevel; const AFormat: string; const AArgs: array of const);
begin
  Log(Format(AFormat, AArgs), ALevel);
end;

initialization
  TDebugLog.Prefix := '[ProjectsManagerPlus]';

end.

