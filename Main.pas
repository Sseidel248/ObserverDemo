unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Language, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    Language: TAppLanguage;
    { Public-Deklarationen }
  end;
var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Self.Language.NotifyObservers(lmGerman);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Self.Language.NotifyObservers(lmEnglish);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Self.Language := TAppLanguage.Create();
  Self.Language.RegisterCtrl(Button1, 'Deutsch', 'German');
  Self.Language.RegisterCtrl(Button2, 'Englisch', 'English');
  Self.Language.RegisterCtrl(Label1, 'Ein Text.', 'A Text.');
  Self.Language.RegisterCtrl(Form1, 'Titel der App', 'Apptitle');
  Self.Language.RegisterCtrl(Panel1, 'Hinweisfläche', 'Hintplanel');
  Self.Language.AddHint(Button1, 'Deutsch', 'German');
  Self.Language.AddHint(Button2, 'Englisch', 'English');
  Button1.ShowHint:=true;
  Self.Language.InitObservers();

//  ShowMessage( 'Anzahl der Komponeneten auf TForm1: ' + IntToStr(self.ComponentCount));
end;

end.
