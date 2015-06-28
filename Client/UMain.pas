unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  ExtCtrls, JPEG, IdAntiFreezeBase, IdAntiFreeze;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    IdTCPClient: TIdTCPClient;
    BGet: TButton;
    Label1: TLabel;
    EHost: TEdit;
    Timer1: TTimer;
    IdAntiFreeze1: TIdAntiFreeze;
    procedure BGetClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure Getimage;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.GetImage;
var
  fStream : TMemoryStream;
  JPEG: TJPEGImage;
  Bitmap: TBitmap;
begin
  Try
    with IdTCPClient do
    begin
      if connected then DisConnect;
      Host := EHost.Text;
      Connect;
      WriteLn('CAP');
      fStream := TMemoryStream.Create;
      while connected do
          ReadStream(fStream,-1,true);
      Disconnect;
      JPEG := TJPEGImage.Create;
      Bitmap := TBitmap.Create;
      fStream.Seek(0,soFromBeginning);
      JPEG.LoadFromStream(fStream);
      Bitmap.Assign(JPEG);
      Form1.Caption := 'Argus Client - '+IntToStr(Bitmap.Width);
      Image1.Picture.Bitmap.Width := Bitmap.Width;
      Image1.Picture.Bitmap.Height := Bitmap.Height;
      BitBlt(Image1.Picture.Bitmap.Canvas.Handle,0,0,Bitmap.Width,Bitmap.Height,Bitmap.Canvas.Handle,0,0,SRCCOPY);

      Image1.Refresh;
      JPEG.Free;
      Bitmap.Free;
      fStream.Free;
    end;
  except
  on E : Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TForm1.BGetClick(Sender: TObject);
begin
  BGet.Enabled := False;
  Getimage;
  BGet.Enabled := True;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  Getimage;
  Timer1.Enabled := True;
end;

end.
