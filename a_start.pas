unit a_start;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, a_about;

type
  Tfrm_start = class(TForm)
    i_start: TImage;
    Label1: TLabel;
    Shape1: TShape;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_start: Tfrm_start;

implementation

{$R *.DFM}

procedure Tfrm_start.FormCreate(Sender: TObject);
begin
  LoadJPEGFromRes('CLOCK', TPicture(i_start.Picture));
end;

end.
