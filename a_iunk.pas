unit a_iunk;

interface

uses Windows;

type
  HResult = Longint;
  PGUID = ^TGUID;
  TGUID = record
    D1: Longint;
    D2: Word;
    D3: Word;
    D4: array[0..7] of Byte;
  end;

{ Interface ID }

  PIID = PGUID;
  TIID = TGUID;

{ Class ID }

  PCLSID = PGUID;
  TCLSID = TGUID;

{ IUnknown interface }

  IUnknown = class
  public
    function QueryInterface(const iid: TIID; var obj): HResult; virtual; stdcall; abstract;
    function AddRef: Longint; virtual; stdcall; abstract;
    function Release: Longint; virtual; stdcall; abstract;
  end;

implementation

end.
