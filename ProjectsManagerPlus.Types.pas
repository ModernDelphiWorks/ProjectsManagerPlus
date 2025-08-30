unit ProjectsManagerPlus.Types;

interface

type
  /// <summary>
  /// Base interface for ProjectPlus commands.
  /// </summary>
  IProjectPlusCommand = interface
    ['{6FAFCE3A-B364-47DD-B0E3-B2B8F01073A7}']
    procedure Execute;
    function GetName: string;
  end;

implementation

end.

