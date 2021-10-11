{*******************************************************}
{                                                       }
{       Example how to read from AVI file               }
{                                                       }
{       Copyright (c) 1995. - 2000. HydroS Co.          }
{                                                       }
{*******************************************************}

unit a_loader;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, a_vfw, MPlayer, ExtCtrls, Spin, ToolWin, ImgList;

type
  Tfrm_main = class(TForm)
    lbAVI: TListBox;
    od1: TOpenDialog;
    DP: TPanel;
    lbInfo: TListBox;
    Label2: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    se1: TSpinEdit;
    ToolBar1: TToolBar;
    btn_open: TToolButton;
    btn_frame: TToolButton;
    il1: TImageList;
    ToolButton3: TToolButton;
    btn_about: TToolButton;
    ToolButton5: TToolButton;
    btn_prev: TToolButton;
    a_bvl: TBevel;
    mp1: TMediaPlayer;
    ToolButton1: TToolButton;
    btn_close: TToolButton;
    procedure btn_openClick(Sender: TObject);
    procedure btn_frameClick(Sender: TObject);
    procedure lbAVIDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure se1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbInfoDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btn_aboutClick(Sender: TObject);
    procedure lbAVIClick(Sender: TObject);
    procedure btn_prevClick(Sender: TObject);
    procedure lbAVIDblClick(Sender: TObject);
    procedure btn_closeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_main: Tfrm_main;
  diff,
  a_W, a_H,
  FrameCount,
  AVIWidth,
  AVIHeight : Integer;
  AVIFrames : array [0..200] of TBitmap;
  Arrow     : TBitmap;

implementation
  uses
   a_prev, a_about;

{$R *.DFM}

procedure Tfrm_main.btn_openClick(Sender: TObject);
var
  i     : Integer;
  afile : PAVIFile;
  afi   : TAVIFileInfo;

  avimsg : Word;
begin
 if od1.execute then begin
      lbAVI.Clear;
      AVIFileInit;
      avimsg := AVIFileOpen(afile, PChar(od1.FileName), OF_READ, nil);
      if avimsg = Word(AVIERR_OK) then begin
         if AVIFileInfo(afile, afi, sizeof(afi)) = 0 then begin
           AVIWidth := afi.dwWidth;
           AVIHeight := afi.dwHeight;
           btn_frame.enabled := true;
         end;
      end;
      lbInfo.Clear;
      lbInfo.Items.Add('AVI file info:');
      lbInfo.Items.Add('Max Bytes Per Second: ' + inttostr(afi.dwMaxBytesPerSec));
      lbInfo.Items.Add('Frames Count: ' + inttostr(afi.dwLength));
      lbInfo.Items.Add('Samples Per Second: ' + floattostr(afi.dwScale / afi.dwRate));
      lbInfo.Items.Add('Time Length (seconds): ' + inttostr(round((afi.dwScale / afi.dwRate) * afi.dwLength)));
      lbInfo.Items.Add('Number Of Streams: ' + inttostr(afi.dwStreams));
      lbInfo.Items.Add('Single Frame Width: ' + inttostr(afi.dwWidth));
      lbInfo.Items.Add('Single Frame Height: ' + inttostr(afi.dwHeight));
      AVIFileRelease(afile);
      AVIFileExit;
      mp1.filename := od1.filename;
      mp1.open;
      if (AVIWidth > 350) or (AVIHeight > 350) then begin
         if AVIWidth >= AVIHeight then begin
            if AVIHeight >= 350 then a_H := 350 else a_H := AVIHeight;
            a_W := 350 * Trunc(AVIWidth / AVIHeight);
         end else begin
            if AVIWidth >= 350 then a_W := 350 else a_W := AVIWidth;
            a_H := 350 * Trunc(AVIWidth / AVIHeight);
         end;
      end else begin
         a_W := AVIWidth;
         a_H := AVIHeight;
      end;
      // DP.Width := a_W;
      // DP.Height := a_H;
      // a_bvl.Width := a_W + 20;
      // a_bvl.Height := a_H + 20;
      mp1.displayrect := rect(0, 0, a_W, a_H);
      mp1.timeformat := tfFrames;
      mp1.StartPos := 0;
      mp1.EndPos   := 0;
      mp1.Play;
//      mp1.Stop;
   end;
end;

procedure Tfrm_main.btn_frameClick(Sender: TObject);
  var
    i     :  INTEGER;
begin
  lbAVI.Clear;
  i := 0;
  FrameCount := 0;
  while i < mp1.Length do begin

    mp1.StartPos := i;
    mp1.EndPos   := i;
    mp1.Play;

    FrameCount := FrameCount + 1;
    AVIFrames[FrameCount - 1] := TBitmap.Create;
    try
      AVIFrames[FrameCount - 1].Width  := a_W;
      AVIFrames[FrameCount - 1].Height := a_H;
      AVIFrames[FrameCount - 1].PixelFormat := pf24bit;

      AVIFrames[FrameCount - 1].Canvas.CopyRect(AVIFrames[FrameCount - 1].Canvas.ClipRect,
                frm_main.Canvas, Rect(DP.Left, DP.Top, DP.Left + AVIWidth, DP.Top  + AVIHeight));
    except
      AVIFrames[FrameCount - 1].Free;
      FrameCount := FrameCount - 1;
    end;

     i := i + diff;
  end;

  Application.ProcessMessages;

  for i := 0 to FrameCount - 1 do
    lbAVI.Items.AddObject('Frame ' + IntToStr(i), TBitmap(AVIFrames[i]));
end;

procedure Tfrm_main.lbAVIDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
   var
     BMP      : TBitmap;
     Offset,
     OffsetT,
     RHeight,
     THeight,
     W, H    : Integer;
     DRect   : TRect;
begin
    with (Control as TListBox).Canvas do begin
        DRect := Bounds(Rect.Left + 95, Rect.Top + 2,
                 (Rect.Right - (Rect.Left + 95)) - 2,
                 (Rect.Bottom - Rect.Top) - 4);
	FillRect(DRect);
        Frame3D(lbAVI.Canvas, Rect, clBtnHighlight, clBtnShadow, 1);
	RHeight := Rect.Bottom - Rect.Top;
	BMP := TBitmap((Control as TListBox).Items.Objects[Index]);
        if BMP <> nil then begin
           if (BMP.Width > 90) or (BMP.Height > 90) then begin
              if BMP.Width >= BMP.Height then begin
                 W := 90;
                 H := Trunc(90 * (BMP.Height / BMP.Width));
              end else begin
                 H := 90;
                 W := Trunc(90 * (BMP.Width / BMP.Height));
              end;
              Offset := (RHeight - H) div 2;
              DRect := Bounds(Rect.Left + 2, Rect.Top + Offset, W, H);
              StretchDraw(DRect, BMP);
           end else begin
             Offset := (RHeight - BMP.Height) div 2;
             Draw(Rect.Left + 1, Rect.Top + Offset, BMP);
           end;
           Offset := 98;
        end;
        THeight := TextHeight((Control as TListBox).Items[Index]);
        OffsetT := (RHeight - THeight) div 2 + 1;
	TextOut(Rect.Left + Offset, Rect.Top + OffsetT, (Control as TListBox).Items[Index])
    end;
end;

procedure Tfrm_main.FormCreate(Sender: TObject);
begin
 FrameCount := 0;
 diff := 1;
 arrow := TBitmap.Create;
 arrow.handle := LoadBitmap(hInstance, 'BMP_ARROW');
 //
 OD1.InitialDir:=ExtractFilePath(Application.ExeName); 
end;

procedure Tfrm_main.se1Change(Sender: TObject);
begin
    diff := se1.value;
end;

procedure Tfrm_main.FormClose(Sender: TObject; var Action: TCloseAction);
  var
   i : Integer;
begin
   lbAVI.Clear;
   lbInfo.Clear;
   arrow.releasehandle;
   arrow.free;
end;

procedure Tfrm_main.lbInfoDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
    var
     RHeight,
     THeight,
     OffsetT,
     Offset  : Integer;
begin
    with (Control as TListBox).Canvas do begin
	RHeight := Rect.Bottom - Rect.Top;
	FillRect(Rect);
        if Index <> 0 then begin
          BrushCopy(Bounds(Rect.Left + 1, Rect.Top + 1, 17, 17), arrow,
                  arrow.Canvas.ClipRect, clFuchsia);
          Offset := 20;
          Font.Style := [];
        end else begin
          Offset := 1;
          Font.Style := [fsBold, fsUnderline];
        end;
        THeight := TextHeight((Control as TListBox).Items[Index]);
        OffsetT := (RHeight - THeight) div 2 + 1;
	TextOut(Rect.Left + Offset, Rect.Top + OffsetT, (Control as TListBox).Items[Index])
    end;
end;

procedure Tfrm_main.btn_aboutClick(Sender: TObject);
begin
    frm_about.showmodal;
end;

procedure Tfrm_main.lbAVIClick(Sender: TObject);
begin
   btn_prev.enabled := (lbAVI.ItemIndex <> - 1);
end;

procedure Tfrm_main.btn_prevClick(Sender: TObject);
begin
   frm_prev.showmodal;
end;

procedure Tfrm_main.lbAVIDblClick(Sender: TObject);
begin
   if lbAVI.ItemIndex <> - 1 then btn_prevclick(btn_prev);
end;

procedure Tfrm_main.btn_closeClick(Sender: TObject);
begin
   Close;
end;

end.

{      if avimsg = Word(AVIERR_BADFORMAT) then begin
       	 ShowMessage('The file couldn’t be read, indicating' + #13
                  + 'a corrupt file or an unrecognized format.');
         AVIFileExit;
         Exit;
      end;
      if avimsg = Word(AVIERR_MEMORY) then begin
       	 ShowMessage('The file could not be opened because of insufficient memory.');
         AVIFileExit;
         Exit;
      end;
      if avimsg = Word(AVIERR_FILEREAD) then begin
       	 ShowMessage('A disk error occurred while reading the file.');
         AVIFileExit;
         Exit;
      end;
      if avimsg = Word(AVIERR_FILEOPEN) then begin
       	 ShowMessage('A disk error occurred while opening the file.');
         AVIFileExit;
         Exit;
      end;
      if avimsg = Word(REGDB_E_CLASSNOTREG) then begin
       	 ShowMessage('According to the registry, the type of file specified' + #13
                  +  'in AVIFileOpen does not have a handler to process it.');
         AVIFileExit;
         Exit;
      end;}

