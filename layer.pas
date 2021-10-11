unit layer;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls;

type
   TGridStyle = (gsLine, gsDot, gsCross);
   TLineStyle = TPenStyle;

type
  TGridLayer = class(TGraphicControl)
  private
    FPen : TPen;
    FBrush : TBrush;
    FMode : TCopyMode;
    FHandle : THandle;
    FBorder : TBorderStyle;
    FGrid : Boolean;
    FStep : Integer;
    FStyle : TGridStyle;
    FColor : TColor;
    FOnPaint: TNotifyEvent;
    FGStyle : TLineStyle;
    FBitmap : TBitmap;
    { Private declarations }
  protected
    { Protected declarations }
    procedure Paint; override;
    procedure SetPen(APen : TPen);
    procedure SetBrush(ABrush : TBrush);
    procedure SetMode(AMode : TCopyMode);
    procedure SetBorder(ABorder : TBorderStyle);
    procedure SetGrid(AGrid : Boolean);
    procedure SetStep(AStep : Integer);
    procedure SetStyle(AStyle : TGridStyle);
    procedure SetColor(AColor : TColor);
    procedure SetGStyle(AStyle : TLineStyle);
    procedure DrawGrid;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh; virtual;
    property Canvas;
    property CopyMode : TCopyMode read FMode write SetMode;
    { Public declarations }
  published
    property Align;
    property BorderStyle: TBorderStyle read FBorder write SetBorder;
    property Pen : TPen read FPen write SetPen;
    property Brush : TBrush read FBrush write SetBrush;
    property Grid : Boolean read FGrid write SetGrid;
    property GridStep : Integer read FStep write SetStep;
    property GridStyle : TGridStyle read FStyle write SetStyle;
    property GridColor : TColor read FColor write SetColor;
    property GridLineStyle : TLineStyle read FGStyle write SetGStyle;
    property Font;
    property Visible;
    property DragCursor;
    property DragMode;
    property Enabled;
    property ParentShowHint;
    property ShowHint;
    property OnPaint : TNotifyEvent read FOnPaint write FOnPaint;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    { Published declarations }
  end;

implementation


constructor TGridLayer.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csDoubleClicks];
  FPen := Canvas.Pen;
  FPen.Color := clBlack;
  FPen.Style := psSolid;
  FPen.Mode := pmCopy;
  FPen.Width := 1;
  FBrush := Canvas.Brush;
  FBrush.Color := clBlack;
  FBrush.Style := bsSolid;
  FMode := cmSrcCopy;
  FStep := 70;
  FColor := clBlack;
  FStyle := gsCross;
  FGrid := False;
end;

destructor TGridLayer.Destroy;
begin
  FBitmap.Free;
  inherited Destroy;
end;

procedure TGridLayer.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TGridLayer.Paint;
begin
   if Assigned(FOnPaint) then FOnPaint(Self);
   if FGrid then DrawGrid;
   if FBorder = bsSingle then
     begin
        Canvas.Pen.Color := clBlack;
        Canvas.Pen.Style := psSolid;
        Canvas.Brush.Style := bsClear;
        Canvas.Rectangle(0, 0, Width, Height);
     end;
end;

procedure TGridLayer.Refresh;
begin
    Invalidate;
end;

procedure TGridLayer.SetPen(APen: TPen);
begin
   Canvas.Pen.Assign(APen);
end;

procedure TGridLayer.SetBrush(ABrush: TBrush);
begin
   Canvas.Brush.Assign(ABrush);
end;

procedure TGridLayer.SetMode(AMode : TCopyMode);
begin
   Canvas.CopyMode := AMode;
end;

procedure TGridLayer.SetBorder(ABorder: TBorderStyle);
begin
   if FBorder = ABorder then exit;
   FBorder := ABorder;
   Invalidate;
end;

procedure TGridLayer.SetGrid(AGrid : Boolean);
begin
     FGrid := AGrid;
     Invalidate;
end;
procedure TGridLayer.SetStep(AStep : Integer);
begin
    FStep := AStep;
    Invalidate;
end;
procedure TGridLayer.SetStyle(AStyle : TGridStyle);
begin
    FStyle := AStyle;
    Invalidate;
end;
procedure TGridLayer.SetColor(AColor : TColor);
begin
   FColor := AColor;
   Invalidate;
end;

procedure TGridLayer.DrawGrid;
var
   i, j : Integer;
begin
   Canvas.Pen.Color := FColor;
   Canvas.Pen.Width := 1;
   if FStyle = gsLine then
      begin
        Canvas.Pen.Style := FGStyle;
        i := FStep;
        while i < Width do
        begin
          Canvas.MoveTo(i, 0);
          Canvas.LineTo(i, Height);
          Inc(i, FStep)
        end;
        j := FStep;
        while j < Height do
        begin
          Canvas.MoveTo(0, j);
          Canvas.LineTo(Width, j);
          Inc(j, FStep)
        end;
      end
   else
      begin
        i := 0;
        while i <= Width do
          begin
           j := 0;
           while j <= Height do
             begin
             if FStyle = gsDot then
               Canvas.Pixels[i, j] := FColor
             else
               begin
                 Canvas.Pen.Style := psSolid;
                 Canvas.MoveTo(i - 3, j);
                 Canvas.LineTo(i + 3, j);
                 Canvas.MoveTo(i, j - 3);
                 Canvas.LineTo(i, j + 3);
               end;
             Inc(j, FStep);
             end;
           Inc(i, FStep);
         end;
     end;
 end;

procedure TGridLayer.SetGStyle(AStyle : TLineStyle);
begin
   FGStyle := AStyle;
   Invalidate; 
end;

end.

