unit ProjectsManagerPlus.DebugLogHelper;

interface

type
  TLogLevel = (llInfo, llWarn, llError, llDebug);

  TDebugLog = record
  public
    class var Prefix: string;
    /// <summary>
    /// Envia mensagem para o DebugView com prefixo padrão, thread ID e timestamp.
    /// </summary>
    class procedure Log(const AMessage: string; ALevel: TLogLevel = llInfo); static;
  end;

implementation

uses
  Winapi.Windows,
  System.SysUtils;

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

initialization
  TDebugLog.Prefix := '[ProjectsManagerPlus]';
end.

