program ArgusS;

uses
  Forms,
  UMain in 'UMain.pas' {FMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
