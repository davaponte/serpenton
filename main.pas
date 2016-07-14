 
unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ActnList, Menus, ExtCtrls;

type
  TDirection = (GoLeft, GoRight, GoUp, GoDown);
  TPiece = (Blank, Border, Snake, Obstacle, Prize);

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
    Timer : TTimer;
    procedure ActionDownExecute(Sender : TObject);
    procedure ActionLeftExecute(Sender : TObject);
    procedure ActionPauseExecute(Sender : TObject);
    procedure ActionRightExecute(Sender : TObject);
    procedure ActionUpExecute(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure MenuQuitClick(Sender : TObject);
    procedure MenuStartClick(Sender : TObject);
    procedure MenuMainClick(Sender : TObject);
    procedure TimerTimer(Sender : TObject);
  private
    Snake : array of TShape;
    SnakeLength : byte;
    Direction : TDirection;
    Speed : integer;
    SnakeWidth : integer;
    GameBoard : array[1..30, 1..30] of TPiece;
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

procedure TMainForm.TimerTimer(Sender : TObject);
var
  c : integer;
begin
  ScrollBox.Canvas.Clear;
//  For c := 1 to
  For c := Length(Snake) - 1 downto 1 do begin
    Snake[c].Left := Snake[c - 1].Left;
    Snake[c].Top := Snake[c - 1].Top;
  end;
  Case Direction of
    GoLeft : begin
      Snake[0].Left := Snake[0].Left - SnakeWidth;
    end;
    GoRight : begin
      Snake[0].Left := Snake[0].Left + SnakeWidth;
    end;
    GoUp : begin
      Snake[0].Top := Snake[0].Top - SnakeWidth;
    end;
    GoDown : begin
      Snake[0].Top := Snake[0].Top + SnakeWidth;
    end;
  end;
end;

procedure TMainForm.MenuStartClick(Sender : TObject);
var
  c : byte;
//  cl : array[0..2] of TColor = (clYellow, clLime, clNavy);
begin
  If (Length(Snake) > 0) then
    For c := Low(Snake) to Length(Snake) - 1 do Snake[c].Free;
  SetLength(Snake, 10);
  For c := Low(Snake) to Length(Snake) - 1 do begin
    Snake[c] := TShape.Create(Self);
    Snake[c].Brush.Color := clYellow;
    Snake[c].Pen.Color := clYellow;
    Snake[c].Left := SnakeWidth * ((Length(Snake) - 1) - c);
    Snake[c].Top := 0;
    Snake[c].Width := SnakeWidth;
    Snake[c].Height := SnakeWidth;
    Snake[c].Parent := ScrollBox;

  end;
  Direction := GoRight;
  Speed := 400;
  Timer.Interval := Speed;
  Timer.Enabled := True;
end;

procedure TMainForm.ActionPauseExecute(Sender : TObject);
begin
  WriteLn('TOGGLE PAUSED: <P> OR <PAUSE> PRESSED');
  Timer.Enabled := Not Timer.Enabled;
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

procedure TMainForm.FormCreate(Sender : TObject);
var
  c : integer;
  Limit : TShape;
begin
  SnakeWidth := 20;
  ScrollBox.Width := Length(GameBoard[1]) * SnakeWidth;
  ScrollBox.Height := Length(GameBoard[1]) * SnakeWidth;

  Limit := TShape.Create(Self);
  Limit.Brush.Color := clRed;
  Limit.Pen.Color := clRed;
  Limit.Left := 0;
  Limit.Top := 0;
  Limit.Width := ScrollBox.Width;
  Limit.Height := SnakeWidth;
  Limit.Parent := ScrollBox;

  Limit := TShape.Create(Self);
  Limit.Brush.Color := clRed;
  Limit.Pen.Color := clRed;
  Limit.Left := 0;
  Limit.Top := 0;
  Limit.Width := SnakeWidth;
  Limit.Height := ScrollBox.Height;
  Limit.Parent := ScrollBox;

  Limit := TShape.Create(Self);
  Limit.Brush.Color := clRed;
  Limit.Pen.Color := clRed;
  Limit.Left := 0;
  Limit.Top := ScrollBox.Width - SnakeWidth;
  Limit.Width := ScrollBox.Width;
  Limit.Height := SnakeWidth;
  Limit.Parent := ScrollBox;

  Limit := TShape.Create(Self);
  Limit.Brush.Color := clRed;
  Limit.Pen.Color := clRed;
  Limit.Left := ScrollBox.Width - SnakeWidth;
  Limit.Top := 0;
  Limit.Width := SnakeWidth;
  Limit.Height := ScrollBox.Height;
  Limit.Parent := ScrollBox;

  For c := Low(GameBoard[1]) to High(GameBoard[1]) do begin
    GameBoard[1][c] := Border;
    GameBoard[Length(GameBoard[1])][c] := Border;
  end;
end;

procedure TMainForm.MenuQuitClick(Sender : TObject);
begin
  Timer.Enabled := False;
  Close;
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

