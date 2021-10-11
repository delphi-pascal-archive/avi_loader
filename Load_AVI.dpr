program Load_AVI;

uses
  Forms,
  Windows,
  a_loader in 'a_loader.pas' {frm_main},
  a_vfw in 'a_vfw.pas',
  a_iunk in 'a_iunk.pas',
  a_about in 'a_about.pas' {frm_about},
  a_prev in 'a_prev.pas' {frm_prev},
  a_start in 'a_start.pas' {frm_start};

{$R *.RES}
{$R source.RES}

 var
  frm_start : Tfrm_start;

begin
  Application.Initialize;
try
  frm_start := Tfrm_start.Create(Application);
  frm_start.Show;
  frm_start.Refresh;
  Application.ProcessMessages;
  Application.CreateForm(Tfrm_main, frm_main);
  Application.CreateForm(Tfrm_about, frm_about);
  Application.CreateForm(Tfrm_prev, frm_prev);
  finally
  Sleep (1000);
  Application.ProcessMessages;
  frm_start.Close;
  frm_start.Release;
  Application.ProcessMessages;
  Application.Run;
end;
end.
