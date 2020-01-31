{ **************************************************************
  * Programmer: Tony Papadimitriou <tonyp@acm.org>             *
  * Program   : Fern                                           *
  * Created   : April 18, 1989                                 *
  * Updated   : November 5, 2019                               *
  * Language  : Turbo Pascal 6.0 and FPC v3.0.4                *
  * Purpose   : This program produces a fractal fern           *
  ************************************************************** }
program Fern;
uses Crt,Graph;

{ **************************************************************
  * Routine: GetStarted                                        *
  * Purpose: Setup the drawing equipment                       *
  ************************************************************** }
procedure GetStarted;
var GraphDriver,GraphMode: Integer;
begin
  GraphDriver := Detect;
  InitGraph(GraphDriver,GraphMode,'');
  if GraphDriver = CGA then SetGraphMode(CGAC0);
  ClearDevice;
  SetViewPort(0, 0, GetMaxX, GetMaxY,ClipOn);
  SetColor(Green);
  SetLineStyle(SolidLn,0,NormWidth);
end; { GetStarted }

{ **************************************************************
  * Routine: DrawShape                                         *
  * Purpose: Call the routines that draw the points            *
  ************************************************************** }
procedure DrawShape;
const
  XMagnify = 130;                       //change to scale image
  YMagnify = XMagnify * 9/16;           //aspect ratio of monitor (WAS: 3/4)
var
  XCoord,YCoord,OldXCoord: real;
  XOffset,YOffset,Count,RandSeed,RandomValue,XPos,YPos: Integer;
begin
  XOffset := GetMaxX div 2; YOffset := 0;
  XCoord := 0; YCoord := 0; { original points }
  Randomize; RandSeed := 99;
  for Count := 1 to 10000 do
  begin
    OldXCoord := XCoord;
    RandomValue := Random(RandSeed);
    case RandomValue of
      0     : begin
                XCoord := 0;
                YCoord := YCoord * 0.16;
              end;
      1..85 : begin
                XCoord := XCoord * 0.85 + YCoord * 0.04;
                YCoord := -OldXCoord * 0.04 + YCoord * 0.85 + 1.6;
              end;
      86..94: begin
                XCoord := XCoord * 0.2 - YCoord * 0.26;
                YCoord := OldXCoord * 0.23 + YCoord * 0.22 + 1.6;
              end;
      95..99: begin
                XCoord := -XCoord * 0.15 + YCoord * 0.28;
                YCoord := OldXCoord * 0.26 + YCoord * 0.24 + 0.44;
              end;
    end; { case }
    XPos := Trunc( XCoord * XMagnify ) + XOffset;
    YPos := GetMaxY - Trunc( YCoord * YMagnify + YOffset );
    if Count = 100 then MoveTo(XPos,YPos);
    if Count > 100 then
      case Count mod 2 of
        0 : PutPixel(XPos,YPos,Green);
        1 : PutPixel(XPos,YPos,LightGreen);
      end; { case }
  end; { for loop }
end; { DrawShape }

{ **************************************************************
  * Routine: ShowMessage                                       *
  * Purpose: Display all text messages and wait for key        *
  ************************************************************** }
procedure ShowMessage;
var color: Integer;
begin
  Color := GetColor;
  SetColor(White);
  OutTextXY(1,1,'Fern using fractals (c) 1990-2020 by Tony G. Papadimitriou');
  SetColor(Color);
end; { ShowMessage }

{ **************************************************************
  * Routine: WaitForKey                                        *
  * Purpose: Print a message and wait for a key                *
  ************************************************************** }
procedure WaitForKey;
begin
  repeat until KeyPressed;
end; { WaitForKey }

{ **************************************************************
  * Routine: Main                                              *
  * Purpose: This is the main program routine                  *
  ************************************************************** }
begin
  GetStarted;
  ShowMessage;
  DrawShape;
  WaitForKey;
  CloseGraph;
end.
