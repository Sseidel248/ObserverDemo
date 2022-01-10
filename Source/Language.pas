unit Language;

interface

uses
  Generics.Collections,
  Vcl.Controls;

type
  TLangMarker = (
    lmGerman,
    lmEnglish
  );

  IAppLanguage = interface
    procedure Update(ALangMarker: TLangMarker);
  end;

  TAppLanguage = class
    Language: TLangMarker;
    Observers: TList<TObject>;
    function FindObject(AObj: TObject): TObject;
  public
    constructor Create();
    destructor Destroy(); override;
    procedure RegisterObj(AObj: TObject);
    procedure RegisterCtrl(ACtrl: TControl; German, English: String);
    procedure AddHint(ACtrl: TControl; German, English: String);
    procedure Unregister(AObj: TObject);
    procedure NotifyObservers(ALangMarker: TLangMarker);
    procedure InitObservers();
  end;

implementation

uses
  Vcl.Forms,
  Vcl.StdCtrls,
  ConfigReader;

type
  //Dient dazu auf die Caption eines WinControls zuzugreifen
  //Dadurch gibt es nur noch einen Typecast von Buttons, etc
  TTextControl = class(TControl)
  public
    property Caption;
    property Text;
    property Hint;
  end;

  TCaptionController = class(TInterfacedObject, IAppLanguage)
  private
    FCtrl: TControl;
    FGerman: String;
    FEnglish: String;
    FGermanHint: String;
    FEnglishHint: String;
    function Decide(ALangMarker: TLangMarker; German, English: String): String;
    function GetCaption(ALangMarker: TLangMarker): String;
    function GetHint(ALangMarker: TLangMarker): String;
  public
    constructor Create(ACtrl: TControl; const AGerman, AEnglish : String);
    procedure AddHint(const AGerman, AEnglish : String);
    procedure Update(ALangMarker: TLangMarker);
  end;

{$Region 'TLanguage'}
function TAppLanguage.FindObject(AObj: TObject): TObject;
var
Obj: TObject;
begin
  Result := nil;
  for Obj in Self.Observers do
  begin
    if Obj is TCaptionController then
    begin
      if TCaptionController(Obj).FCtrl = TControl(AObj) then
      begin
        Result := Obj;
        Break;
      end;
    end;
  end;
end;

constructor TAppLanguage.Create();
begin
  Self.Language := lmEnglish;
  Self.Observers := TList<TObject>.Create;
end;

destructor TAppLanguage.Destroy();
begin
  Self.Observers.Free;
end;

procedure TAppLanguage.RegisterObj(AObj: TObject);
begin
  Self.Observers.Add(AObj);
end;

procedure TAppLanguage.RegisterCtrl(ACtrl: TControl; German, English: String);
begin
  Self.Observers.Add(TCaptionController.Create(ACtrl, German, English));
end;

procedure TAppLanguage.AddHint(ACtrl: TControl; German, English: String);
var
Obj: TObject;
begin
  if ACtrl is TControl then
  begin
    Obj := Self.FindObject(TObject(ACtrl));
    if Assigned(Obj) then
      TCaptionController(Obj).AddHint(German,English);
  end
end;

procedure TAppLanguage.Unregister(AObj: TObject);
var
Obj: TObject;
begin
  if AObj is TControl then
  begin
    Obj := Self.FindObject(AObj);
    if Assigned(Obj) then
      Self.Observers.Extract(TCaptionController(Obj));
  end
  else
    Self.Observers.Extract(AObj);
end;

procedure TAppLanguage.NotifyObservers(ALangMarker: TLangMarker);
begin
  if Self.Language <> ALangMarker then
  begin
    Self.Language := ALangMarker;
    Self.InitObservers();
  end;
end;

procedure TAppLanguage.InitObservers();
var
AObj: TObject;
begin
  for AObj in Self.Observers do
  begin
    if AObj is TCaptionController then
      TCaptionController(AObj).Update(Self.Language)
    else if AObj is TConfigController then
      TConfigController(AObj).Update(Self.Language)
  end;
end;
{$EndRegion}

{$Region 'TCaptionController'}
function TCaptionController.Decide(ALangMarker: TLangMarker; German, English: String): String;
begin
  case ALangMarker of
    lmGerman: Result := German;
    lmEnglish: Result := English;
    else Result := English;
  end;
end;

function TCaptionController.GetCaption(ALangMarker: TLangMarker): String;
begin
  Result := Self.Decide(ALangMarker,Self.FGerman,Self.FEnglish);
end;

function TCaptionController.GetHint(ALangMarker: TLangMarker): String;
begin
  Result := Self.Decide(ALangMarker,Self.FGermanHint,Self.FEnglishHint);
end;

constructor TCaptionController.Create(ACtrl: TControl; const AGerman, AEnglish : String);
begin
  Self.FCtrl := ACtrl;
  Self.FGerman := AGerman;
  Self.FEnglish := AEnglish;
end;

procedure TCaptionController.AddHint(const AGerman, AEnglish : String);
begin
  Self.FGermanHint := AGerman;
  Self.FEnglishHint := AEnglish;
end;

procedure TCaptionController.Update(ALangMarker: TLangMarker);
begin
  TTextControl(Self.FCtrl).Caption := Self.GetCaption(ALangMarker);
  TTextControl(Self.FCtrl).Hint := Self.GetHint(ALangMarker);
end;
{$EndRegion}

end.
