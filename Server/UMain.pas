unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdTCPServer, JPEG, IdThreadMgr,
  IdThreadMgrDefault, IdAntiFreezeBase, IdAntiFreeze, ShellApi, Menus,
  ExtCtrls, StdCtrls;

const
  WM_TASKBAREVENT = WM_USER+1;

type
  TFMain = class(TForm)
    IdTCPServer: TIdTCPServer;
    IdAntiFreeze1: TIdAntiFreeze;
    PopupMenu1: TPopupMenu;
    MIQuit: TMenuItem;
    Timer1: TTimer;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure IdTCPServerExecute(AThread: TIdPeerThread);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MIQuitClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  protected
    procedure WMTASKBAREVENT(var message: TMessage); message WM_TASKBAREVENT;
  end;

var
  FMain: TFMain;

implementation

{$R *.DFM}

procedure TFMain.FormCreate(Sender: TObject);
var tnid: TNOTIFYICONDATA;
begin
  IdTCPServer.Active := true;
  ShowWindow(GetWindow(handle,GW_OWNER),SW_HIDE); // hide Window
  tnid.cbSize := sizeof(TNOTIFYICONDATA);
  tnid.Wnd := FMain.handle;
  tnid.uID := 1;
  tnid.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
  tnid.uCallBackMessage := WM_TASKBAREVENT;
  tnid.hIcon := FMain.Icon.Handle;
  strcopy(tnid.szTip,'Argus Server');
  Shell_NotifyIcon(NIM_ADD, @tnid);
end;

procedure TFMain.IdTCPServerExecute(AThread: TIdPeerThread);
var
    s, sCommand, sAction : string;
    fStream : TMemoryStream;
    Bmp : TBitmap;
    JPEG: TJPEGImage;
    dc: HDC;
begin
  try
    s := uppercase(AThread.Connection.ReadLn);
    sCommand := copy(s,1,3);
    sAction := copy(s,5,100);
    if sCommand = 'CAP' then
    begin
      //windowstate := wsminimized;
      Bmp := TBitmap.Create;
      dc := GetDC(0);
      Bmp.Width := Screen.Width;
      Bmp.Height := Screen.Height;
      BitBlt(Bmp.Canvas.Handle,0,0,Screen.Width,Screen.Height,DC,0,0,SRCCOPY);
      ReleaseDC(0,DC);
      fStream := TMemoryStream.Create;
      JPeg := TJPEGImage.Create;
      with JPeg do
      begin
        CompressionQuality := 50;
        ProgressiveEncoding := true;
        PixelFormat := jf24Bit;
        Smoothing := false;
        Assign(Bmp);
        Compress;
        SaveToStream(fStream);
      end;
      AThread.Connection.OpenWriteBuffer;
      AThread.Connection.WriteStream(fStream);
      AThread.Connection.CloseWriteBuffer;
      AThread.Connection.Disconnect;
      fStream.Free;
      JPeg.Free;
      Bmp.Free;
    end;
  except on E : Exception do
    ShowMessage(E.Message);
  End;
end;

procedure TFMain.WMTASKBAREVENT(var message: TMessage);
var point: TPoint;
begin
  case message.LParamLo of
    WM_LBUTTONDBLCLK: FMain.Show;
    WM_RBUTTONDOWN:
    begin
      GetCursorPos(point);
      popupmenu1.popup(point.x,point.y);
    end;
  end;
end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
var tnid: TNOTIFYICONDATA;
begin
  IdTCPServer.Active := false;
  tnid.cbSize := sizeof(TNOTIFYICONDATA);
  tnid.Wnd := FMain.Handle;
  tnid.uID := 1;
  Shell_NotifyIcon(NIM_DELETE, @tnid);
end;

procedure TFMain.MIQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TFMain.Timer1Timer(Sender: TObject);
begin
  self.hide;
  timer1.enabled := false;
end;

end.
