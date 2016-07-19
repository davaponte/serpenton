
unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ActnList, Menus, ExtCtrls;

const
  MaxRows = 20;
  MaxCols = 30;

type
  TDirection = (GoLeft, GoRight, GoUp, GoDown);
  TPiece = (Blank, Border, Snakes, Obstacle, Prize);

  { TMainForm }

  TMainForm = class(TForm)
    ActionPause : TAction;
    ActionRight : TAction;
    ActionUp : TAction;
    ActionDown : TAction;
    ActionLeft : TAction;
    ActionList : TActionList;
    MainMenu : TMainMenu;
    MenuStart : TMenuItem;
    MenuItem2 : TMenuItem;
    MenuQuit : TMenuItem;
    MenuMain : TMenuItem;
    ScrollBox : TScrollBox;
    StatusBar : TStatusBar;
    GameLoop : TTimer;
    procedure ActionDownExecute(Sender : TObject);
    procedure ActionLeftExecute(Sender : TObject);
    procedure ActionPauseExecute(Sender : TObject);
    procedure ActionRightExecute(Sender : TObject);
    procedure ActionUpExecute(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure MenuQuitClick(Sender : TObject);
    procedure MenuStartClick(Sender : TObject);
    procedure MenuMainClick(Sender : TObject);
    procedure GameLoopTimer(Sender : TObject);
  private
    Snake : array of TShape;
    SnakeLength : byte;
    Direction : TDirection;
    Speed : integer;
    SnakeSize : integer;
    GameBoard : array[1..MaxRows, 1..MaxCols] of TPiece;
  public
    { public declarations }
  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.MenuMainClick(Sender : TObject);
begin

end;

procedure TMainForm.GameLoopTimer(Sender : TObject);
var
  c, Row, Col    : integer;
  NewRow, NewCol : integer;
begin
//Chequeo de movimientos imposibles
//TODO:  If (Direction in [GoRight, GoLeft]) then Direction := GoRight;

//Borrado de pantalla...
  ScrollBox.Canvas.Clear;
//...y del array (excluyendo el borde)
  For Row := 2 to MaxRows - 1 do
    For Col := 2 to MaxCols - 1 do
      If (GameBoard[Row, Col] = Snakes) then
        GameBoard[Row, Col] := Blank;

//Chequeo de colisión con borde


//  For c := 1 to
  For c := Length(Snake) - 1 downto 1 do begin
    Snake[c].Left := Snake[c - 1].Left;
    Snake[c].Top := Snake[c - 1].Top;
  end;
  Case Direction of
    GoLeft : begin
      Snake[0].Left := Snake[0].Left - SnakeSize;
    end;
    GoRight : begin
      Snake[0].Left := Snake[0].Left + SnakeSize;
    end;
    GoUp : begin
      Snake[0].Top := Snake[0].Top - SnakeSize;
    end;
    GoDown : begin
      Snake[0].Top := Snake[0].Top + SnakeSize;
    end;
  end;
end;

procedure TMainForm.MenuStartClick(Sender : TObject);
var
  c : byte;
  BoardCol, BoardRow : integer;
//  cl : array[0..2] of TColor = (clYellow, clLime, clNavy);
begin
  If (Length(Snake) > 0) then
    For c := Low(Snake) to Length(Snake) - 1 do Snake[c].Free;
  SetLength(Snake, 3);
  For c := Low(Snake) to Length(Snake) - 1 do begin
    Snake[c] := TShape.Create(Self);
    Snake[c].Brush.Color := clYellow;
    Snake[c].Pen.Color := clYellow;
    BoardCol := MaxCols div 6;
    BoardRow := MaxRows div 2;
    Snake[c].Left := (BoardCol * SnakeSize) + SnakeSize * ((Length(Snake) - 1) - c);
    Snake[c].Top := BoardRow * SnakeSize;
    Snake[c].Width := SnakeSize;
    Snake[c].Height := SnakeSize;
    Snake[c].Parent := ScrollBox;
    GameBoard[BoardRow, BoardCol] := Snakes;
  end;
  Direction := GoUp;
  Speed := 400;
  GameLoop.Interval := Speed;
  GameLoop.Enabled := True;
end;

procedure TMainForm.FormCreate(Sender : TObject);
var
  Row, Col : integer;
  Limit : TShape;
begin
  SnakeSize := 32;
//  Width := MaxCols * SnakeSize; //Sin ajuste extra porque el BorderStyle en el ScrollBox está en bsNone
//  Height := MaxRows * SnakeSize + MainMenu.Height + 20; //GetSystemMetrics(SM_CYCAPTION)

//  WriteLn('MainMenu.Height: ', MainMenu.Height);

  ClientHeight := MaxRows * SnakeSize + MainMenu.Height + 20; //Hay que ver cómo arreglar esto
  ClientWidth := MaxCols * SnakeSize;

  For Row := 1 to MaxRows do begin
    GameBoard[Row][1] := Border;
    Limit := TShape.Create(Self);
    Limit.Brush.Color := clRed;
    Limit.Pen.Color := clRed;
    Limit.Left := 0;
    Limit.Top := (Row - 1) * SnakeSize;
    Limit.Width := SnakeSize;
    Limit.Height := SnakeSize;
    Limit.Parent := ScrollBox;

    GameBoard[Row][MaxCols] := Border;
    Limit := TShape.Create(Self);
    Limit.Brush.Color := clRed;
    Limit.Pen.Color := clRed;
    Limit.Left := (MaxCols - 1) * SnakeSize;
    Limit.Top := (Row - 1) * SnakeSize;
    Limit.Width := SnakeSize;
    Limit.Height := SnakeSize;
    Limit.Parent := ScrollBox;
  end;
  For Col := 1 + 1 to MaxCols - 1 do begin
    GameBoard[1][Col] := Border;
    Limit := TShape.Create(Self);
    Limit.Brush.Color := clRed;
    Limit.Pen.Color := clRed;
    Limit.Left := (Col - 1) * SnakeSize;
    Limit.Top := 0;
    Limit.Width := SnakeSize;
    Limit.Height := SnakeSize;
    Limit.Parent := ScrollBox;

    GameBoard[MaxRows][Col] := Border;
    Limit := TShape.Create(Self);
    Limit.Brush.Color := clRed;
    Limit.Pen.Color := clRed;
    Limit.Left := (Col - 1) * SnakeSize;
    Limit.Top := (MaxRows - 1) * SnakeSize;
    Limit.Width := SnakeSize;
    Limit.Height := SnakeSize;
    Limit.Parent := ScrollBox;
  end;
end;

procedure TMainForm.MenuQuitClick(Sender : TObject);
begin
  GameLoop.Enabled := False;
  Close;
end;

procedure TMainForm.ActionPauseExecute(Sender : TObject);
begin
  WriteLn('TOGGLE PAUSED: <P> OR <PAUSE> PRESSED');
  GameLoop.Enabled := Not GameLoop.Enabled;
end;

procedure TMainForm.ActionRightExecute(Sender : TObject);
begin
  WriteLn('RIGHT KEY PRESSED');
  If Not(Direction in [GoRight, GoLeft]) then Direction := GoRight;
end;

procedure TMainForm.ActionUpExecute(Sender : TObject);
begin
  WriteLn('UP KEY PRESSED');
  If Not(Direction in [GoUp, GoDown]) then Direction := GoUp;
end;

procedure TMainForm.ActionLeftExecute(Sender : TObject);
begin
  WriteLn('LEFT KEY PRESSED');
  If Not(Direction in [GoRight, GoLeft]) then Direction := GoLeft;
end;

procedure TMainForm.ActionDownExecute(Sender : TObject);
begin
  WriteLn('DOWN KEY PRESSED');
  If Not(Direction in [GoUp, GoDown]) then Direction := GoDown;
end;

end.

