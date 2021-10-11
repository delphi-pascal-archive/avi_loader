unit a_prev;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, ExtCtrls, StdCtrls, a_loader, layer, ImgList;

type
  Tfrm_prev = class(TForm)
    _tool_main: TToolBar;
    btn_plus: TToolButton;
    btn_minus: TToolButton;
    btn_exit: TToolButton;
    ImageList1: TImageList;
    sb_prev: TScrollBox;
    Image1: TImage;
    s_bar: TStatusBar;
    btn_prev: TToolButton;
    btn_next: TToolButton;
    procedure btn_plusClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_exitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_prevClick(Sender: TObject);
    procedure btn_nextClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_prev   : Tfrm_prev;
  ilayer     : TGridLayer;
  counter,
  zoom       : integer;
  bmp        : TBitmap;
  
implementation

{$R *.DFM}

procedure Tfrm_prev.btn_plusClick(Sender: TObject);
begin
   if frm_main.lbAVI.ItemIndex = - 1 then exit;
   case (Sender as TToolButton).Tag of
     0 : if zoom < 32 then zoom := zoom + 1;
     1 : if zoom > 1 then zoom := zoom - 1;
   end;
   s_bar.simpletext := ' Zoom: ' + IntToStr((zoom) * 100) + '%';
   image1.width := zoom * bmp.width;
   image1.height := zoom * bmp.height;
   if zoom > 2 then begin
     ilayer.top := image1.top;
     ilayer.left := image1.left;
     ilayer.width := image1.width;
     ilayer.height := image1.height;
     ilayer.gridstep  := zoom;
     ilayer.grid := true;
     ilayer.visible := true;
     ilayer.refresh;
   end else ilayer.visible := false;
   image1.autosize := false;
   image1.stretch := true;
   image1.refresh;
   image1.sendtoback;
end;

procedure Tfrm_prev.FormCreate(Sender: TObject);
begin
   ilayer := tgridlayer.create(frm_prev);
   ilayer.parent := sb_prev;
   ilayer.left := 1;
   ilayer.top := 1;
   ilayer.width := 50;
   ilayer.height := 50;
   ilayer.borderstyle := bssingle;
   ilayer.gridstyle := gsline;
   ilayer.gridcolor := clbtnshadow;
   ilayer.visible := false;
end;

procedure Tfrm_prev.FormShow(Sender: TObject);
begin
   zoom := 1;
   s_bar.simpletext := ' Zoom: 100%';
   counter := frm_main.lbAVI.ItemIndex;
   btn_prev.Enabled := (counter > 0);
   btn_next.Enabled := (counter < frm_main.lbAVI.Items.Count - 1);
   if frm_main.lbAVI.ItemIndex <> - 1 then begin
     bmp := TBitmap(frm_main.lbAVI.Items.Objects[counter]);
     image1.picture.bitmap := bmp;
     btn_plusclick(btn_minus);
  end else image1.picture.graphic := nil;
end;

procedure Tfrm_prev.FormDestroy(Sender: TObject);
begin
  ilayer.free;
end;

procedure Tfrm_prev.btn_exitClick(Sender: TObject);
begin
    close;
end;

procedure Tfrm_prev.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   ilayer.visible := false;
end;

procedure Tfrm_prev.btn_prevClick(Sender: TObject);
begin
  if counter > 0 then begin
     counter := counter - 1;
     bmp := TBitmap(frm_main.lbAVI.Items.Objects[counter]);
     image1.picture.bitmap := bmp;
     btn_plusclick(btn_prev);
     btn_prev.Enabled := (counter > 0);
     btn_next.Enabled := (counter < frm_main.lbAVI.Items.Count - 1);
  end;
end;

procedure Tfrm_prev.btn_nextClick(Sender: TObject);
begin
  if counter < frm_main.lbAVI.Items.Count - 1 then begin
     counter := counter + 1;
     bmp := TBitmap(frm_main.lbAVI.Items.Objects[counter]);
     image1.picture.bitmap := bmp;
     btn_plusclick(btn_next);
     btn_prev.Enabled := (counter > 0);
     btn_next.Enabled := (counter < frm_main.lbAVI.Items.Count - 1);
  end;
end;

end.
