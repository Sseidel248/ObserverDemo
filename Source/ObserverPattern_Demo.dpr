program ObserverPattern_Demo;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  ConfigReader in 'ConfigReader.pas',
  Language in 'Language.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
