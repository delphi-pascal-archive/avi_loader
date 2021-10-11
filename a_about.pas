unit a_about;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, jpeg;

procedure LoadJPEGFromRes(_JPEG : string; _pic : TPicture);

type
  Tfrm_about = class(TForm)
    _splash: TImage;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_about: Tfrm_about;

implementation

{$R *.DFM}

procedure LoadJPEGFromRes(_JPEG : string; _pic : TPicture);
   var
       ResHandle : THandle;
       MemHandle : THandle;
       MemStream : TMemoryStream;
       ResPtr    : PByte;
       ResSize   : Longint;
       JPEGImage : TJPEGImage;
begin

       ResHandle := FindResource(hInstance, PChar(_JPEG), RT_RCDATA);
       MemHandle := LoadResource(hInstance, ResHandle);
       ResPtr    := LockResource(MemHandle);
       MemStream := TMemoryStream.Create;
       JPEGImage := TJPEGImage.Create;
       JPEGImage.PixelFormat := jf24bit;
       JPEGImage.Grayscale := False;
       ResSize := SizeOfResource(hInstance, ResHandle);
       MemStream.SetSize(ResSize);
       MemStream.Write(ResPtr^, ResSize);
       FreeResource(MemHandle);
       MemStream.Seek(0, 0);
       JPEGImage.LoadFromStream(MemStream);
       _pic.Assign(JPEGImage);
       JPEGImage.Free;
       MemStream.Free;
end;

procedure Tfrm_about.FormShow(Sender: TObject);
begin
   LoadJPEGFromRes('HYDROS', _splash.picture);
//   _splash.refresh;
end;

procedure Tfrm_about.FormHide(Sender: TObject);
begin
   _splash.picture.graphic := nil;
end;

end.
