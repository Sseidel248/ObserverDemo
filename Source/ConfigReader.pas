unit ConfigReader;

interface

uses
  Generics.Collections,
  Language,
  Classes,
  SysUtils;

type

  TConfig = class
  private
    FConfigPath: String;
  protected
    const //nur innerhalb der Klasse und deren Ableitungen
    SC_General = 'App';
  public
    constructor Create(APath: String);
    property ConfigPath: String read FConfigPath;
  end;

  TAppConfig = class(TConfig)
  private
    FLanguage: TLangMarker;
    FLastPath: String;
  public
    constructor Create();
    procedure Read(Entries: TStrings);
    procedure ChangeLastPath(APath: String);
    procedure ChangeLanguage(ALangMarker: TLangMarker);
    property LastPath: String read FLastPath;
    property Language: TLangMarker read FLanguage;
  end;

  TColHeader = class
  private
    FHeader: String;
    FCol: Integer;
    FDescriptor: String;
    FIsUnique: Boolean;
    FPathVarExist: Boolean;
  public
    constructor Create(EntryParts: TStrings; PathVarExist: Boolean = false);
    property Header: String read FHeader;
    property Col: Integer read FCol;
    property Descriptor: String read FDescriptor;
    property IsUnique: Boolean read FIsUnique;
    property PathVarExist: Boolean read FPathVarExist;
  end;

  TGridConfig = class(TConfig)
  private
    FNumOfCols: Integer;
    FBiggestCol: Integer;
    FExt: String;
    FUniqueIdentCol: Integer;
    FExistPathVar: Boolean;
    FPathVar: String;
    FColHeader: TObjectList<TColHeader>;
    procedure SetBiggestCol(Const ACol: Integer);
    function IncludesPathVar(AEntrie: String): Boolean;
  protected
    const
    SC_BasePath = '<BasePath>';
    SC_RelativePath = '<RelativePath>';
    SC_FilenameBody = '<FilenameBody>';
    SC_Ext = '<Ext>';
  public
    constructor Create(AExt: String);
    destructor Destroy(); override;
    procedure Read(Entries: TStrings);
    function GetPathVar(): String;
    procedure GetDescriptors(var Descriptors: TStringlist);
    procedure GetDescrAndCols(var DescrWithCol: TStringlist);
    property NumOfCols: Integer read FNumOfCols;
    property BiggestCol: Integer read FBiggestCol;
    property Ext: String read FExt;
    property UniqueIdentCol: Integer read FUniqueIdentCol;
  end;

  TConfigController = class(TInterfacedObject, IAppLanguage)
  private
    FConfigs: TObjectList<TConfig>;
    function GetAppConfig(): TAppConfig;
    function GetGridConfig(const ForExt: String): TGridConfig;
    function GetPathVar(const ForExt: String): String;
  public
    constructor Create(ALanguage: TAppLanguage);
    destructor Destroy(); override;
    procedure Load(APath: String);
    procedure Save(AtPath: String);
    procedure UpdateLastPath(ALoadedPath: String);
    procedure Update(ALangMarker: TLangMarker);
    procedure GetDescriptors(var Descriptors: TStringlist; const ForExt: String);
    procedure GetDescrWithCols(var DescrWithCols: TStringlist; const ForExt: String);
    function ConvPathWithPathVar(const ALoadedPath, AExt: String): String;
  end;

implementation

{$Region 'TConfigController'}
function TConfigController.GetAppConfig(): TAppConfig;
var
AConfig: TConfig;
begin
  Result := nil;
  for AConfig in Self.FConfigs do
  begin
    if AConfig is TAppConfig then
      Result := TAppConfig(AConfig);
  end;
end;

function TConfigController.GetGridConfig(const ForExt: String): TGridConfig;
var
AConfig: TConfig;
begin
  Result := nil;
  for AConfig in Self.FConfigs do
  begin
    if AConfig is TGridConfig then
    begin
      if TGridConfig(AConfig).Ext.Equals(ForExt) then
        Result := TGridConfig(AConfig);
    end;
  end;
end;

function TConfigController.GetPathVar(const ForExt: String): String;
var
AGridConfig: TGridConfig;
begin
  Result := 'No_PathVar_Exist';
  AGridConfig := Self.GetGridConfig(ForExt);
  if Assigned(AGridConfig) then
    Result := AGridConfig.GetPathVar();
end;

constructor TConfigController.Create(ALanguage: TAppLanguage);
begin
  Self.FConfigs := TObjectList<TConfig>.Create(true);
end;

destructor TConfigController.Destroy();
begin
  Self.FConfigs.Free;
end;

procedure TConfigController.Load(APath: String);
begin
  //TODO: TKonfigController.Load implementieren
  //Alle Sektionen der Ini auslesen
  //bei der Sektion 'App' -> TAppKonfig Instanz erzeugen und Einträge auslesen
  //SprachFlag mitsetzen
  //bei allen anderen Sektionen -> TGridKonfig Instanz erzeugen und Einträge auslesen
end;

procedure TConfigController.Save(AtPath: String);
begin
  //TODO: TKonfigController.Save implementieren
  //Iteriere über alle Einträge von Self.FConfig und erzeuge die Ini
  //wenn lmGerman = 'D'
  //wenn lmEnglish = 'E'
  //else = 'E'
end;

procedure TConfigController.UpdateLastPath(ALoadedPath: String);
var
AAppConfig: TAppConfig;
begin
  AAppConfig := Self.GetAppConfig;
  if Assigned(AAppConfig) then
    AAppConfig.ChangeLastPath(ALoadedPath);
end;

procedure TConfigController.Update(ALangMarker: TLangMarker);
var
AAppConfig: TAppConfig;
begin
  AAppConfig := Self.GetAppConfig;
  if Assigned(AAppConfig) then
    AAppConfig.ChangeLanguage(ALangMarker);
end;

procedure TConfigController.GetDescriptors(var Descriptors: TStringlist; const ForExt: String);
var
AGridConfig: TGridConfig;
begin
  AGridConfig := Self.GetGridConfig(ForExt);
  if Assigned(AGridConfig) then
  begin
    AGridConfig.GetDescriptors(Descriptors);
  end;
end;

procedure TConfigController.GetDescrWithCols(var DescrWithCols: TStringlist; const ForExt: String);
var
AGridConfig: TGridConfig;
begin
  AGridConfig := Self.GetGridConfig(ForExt);
  if Assigned(AGridConfig) then
  begin
    AGridConfig.GetDescrAndCols(DescrWithCols);
  end;
end;

function TConfigController.ConvPathWithPathVar(const ALoadedPath, AExt: String): String;
var
PathVar: String;
begin
  PathVar := Self.GetPathVar(AExt);
  if PathVar.Equals('') then
    Exit;
  //TODO: TConfigController.ConvPathWithPathVar implementieren

end;
{$EndRegion}

{$Region 'TAppConfig'}
constructor TAppConfig.Create();
begin
  Self.FLanguage := lmEnglish;
  Self.FLastPath := '';
end;

procedure TAppConfig.Read(Entries: TStrings);
begin
  //TODO: TAppKonfig.Read implementieren
  //wenn 'd' oder 'D' = lmGerman
  //wenn 'e' oder 'E' = lmEnglish
  //else = lmEnglish
end;

procedure TAppConfig.ChangeLastPath(APath: String);
begin
  if Self.FLastPath <> APath then
    Self.FLastPath := APath;
end;

procedure TAppConfig.ChangeLanguage(ALangMarker: TLangMarker);
begin
  if Self.FLanguage <> ALangMarker then
    Self.FLanguage := ALangMarker;
end;
{$EndRegion}

{$Region 'TGridConfig'}
procedure TGridConfig.SetBiggestCol(Const ACol: Integer);
begin
  if ACol > Self.FBiggestCol then
    Self.FBiggestCol := ACol;
end;

function TGridConfig.IncludesPathVar(AEntrie: String): Boolean;
begin
  //TODO: TGridKonfig.IncludesPathVar implementieren
  //prüfen ob in einem Eintrag die folgenden Zeichen vorkommen "<" & ">"
  //wenn ja Rückgabe true
  //else Rückgabe false
  //Zuweisung von: Self.ExistPathVar := <Boolean>;
end;

constructor TGridConfig.Create(AExt: String);
begin
  Self.FExt := AExt;
  Self.FNumOfCols := -1;
  Self.FBiggestCol := -1;
  Self.FUniqueIdentCol := -1;
  Self.FExistPathVar := false;
  Self.FPathVar := '';
  Self.FColHeader := TObjectList<TColHeader>.Create(true);
end;

destructor TGridConfig.Destroy();
begin
  Self.FColHeader.Free;;
end;

procedure TGridConfig.Read(Entries: TStrings);
begin
  //TODO: TGridKonfig.Read implementieren
  //Jeden Eintrag zerlegen
  //Prüfen ob der zweite Eintrag besondere Zeichen enthält ExistVarSigns(...)
  //Wenn Ja, dann TColHeader Instanz erzeugen mit PathVarExist = true
  //--> Self.ColHeader.add(...)
  //else TColHeader Instanz erzeugen mit PathVarExist = false
  //--> Self.ColHeader.add(...)
end;

function TGridConfig.GetPathVar(): String;
begin
  if Self.FExistPathVar then
    Result := Self.FPathVar;
end;

procedure TGridConfig.GetDescriptors(var Descriptors: TStringlist);
var
AColHeader: TColHeader;
begin
  for AColHeader in Self.FColHeader do
  begin
    if not AColHeader.PathVarExist then
      Descriptors.Add(AColHeader.FDescriptor);
  end;
end;

procedure TGridConfig.GetDescrAndCols(var DescrWithCol: TStringlist);
var
AColHeader: TColHeader;
begin
  for AColHeader in Self.FColHeader do
  begin
    if not AColHeader.PathVarExist then
      DescrWithCol.AddPair(AColHeader.FDescriptor, IntToStr(AColHeader.FCol));
  end;
end;
{$EndRegion}

{$Region 'TConfig'}
constructor TConfig.Create(APath: String);
begin
  Self.FConfigPath := APath;
end;
{$EndRegion}

{$Region 'TColHeader'}
constructor TColHeader.Create(EntryParts: TStrings; PathVarExist: Boolean);
var
ACol: String;
begin
  if EntryParts[0].StartsWith('!') then
  begin
    Self.FIsUnique := true;
    ACol := copy(EntryParts[0], 2, length(EntryParts[0]));
    Self.FCol := StrToIntDef(ACol, -99);
  end
  else
  begin
    Self.FIsUnique := false;
    ACol := EntryParts[0];
    Self.FCol := StrToIntDef(EntryParts[0], -99);
  end;
  if Self.FCol = -99 then
    raise Exception.Create(Concat('"', ACol, '" is not a valid column number'));

  if not PathVarExist then
    Self.FDescriptor := EntryParts[1];

  Self.FHeader := EntryParts[2];

  Self.FPathVarExist := PathVarExist;
end;
{$EndRegion}

end.
