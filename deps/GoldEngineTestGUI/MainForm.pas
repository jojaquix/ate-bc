unit MainForm;

{
'===============================================================================
' Refactored 2018, Thaddy de Koning: use a generic stack
' Refactored 2021, Jhon Quintero: using Gold_Parser_5 package
'===============================================================================
}
{$IFDEF FPC}{$MODE Delphi}{$ENDIF}
{$M+}

interface

uses
  {$ifdef fpc}LCLIntf, LCLType,{$else}types,{$endif} SysUtils, Classes,
  Graphics, Controls, Forms,
  Dialogs, gold_types, cgt, StdCtrls, GOLDParser, Symbol;

type
  TMain = class(TForm)
    cmdParse: TButton;
    GroupBox1: TGroupBox;
    txtTestInput: TMemo;
    Label1: TLabel;
    txtCGTFilePath: TEdit;
    Label2: TLabel;
    chkTrimReductions: TCheckBox;
    GroupBox2: TGroupBox;
    txtParseTree: TMemo;
    cmdClose: TButton;
    OpenDialog1: TOpenDialog;
    cmdOpenFile: TButton;
    procedure cmdParseClick(Sender: TObject);
    procedure cmdCloseClick(Sender: TObject);
    procedure cmdOpenFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main: TMain;

implementation

{$ifdef fpc}{$R *.lfm}{$else delphi}{$R *.dfm}{$endif}

procedure TMain.cmdParseClick(Sender: TObject);
var
  gp: TGOLDParser;
begin
  gp := TGOLDParser.Create(txtCGTFilePath.Text, txtTestInput.Text);
  gp.DoParse;

  if gp.ParsedOk then
     txtParseTree.Text:= GP.Tree
  else
    txtParseTree.Text:= GP.Log;

  FreeAndNil(gp);
end;



procedure TMain.cmdCloseClick(Sender: TObject);
begin

  Application.Terminate;

end;

procedure TMain.cmdOpenFileClick(Sender: TObject);
begin

  if OpenDialog1.Execute then
    txtCGTFilePath.Text := OpenDialog1.FileName;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  txtCGTFilePath.Text := ExtractFileDir(Application.ExeName) + '\simple.cgt';
  //ShowMessage('Warning: This is the Alpha version of the GOLD Parser Engine Delphi version!'#13#10#13#10'Use it at youre own risk! I am not responsible for any damage wich might have been caused by this program!');

end;

end.
