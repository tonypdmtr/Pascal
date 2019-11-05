{ **************************************************************
  * Programmer: Tony Papadimitriou <tonyp@acm.org>             *
  * Program   : Tennis                                         *
  * Created   : April 18, 1989                                 *
  * Updated   : Thursday, May 21, 1992  9:52 pm                *
  * Language  : Turbo Pascal 6.0 and FPC v3.0.4                *
  * Purpose   : Produce a 3-D tennis court moving viewer X,Y,Z *
  ************************************************************** }
program Tennis;
uses Crt, Graph;

const
  XMagnify = 18;
  YMagnify = 18;
  {---}
  xTop = 20;
  xBot = -20;
  center_x = (xTop-xBot)/2;
  {---}
  maxPoints = 18; { maximum number of object points to be defined }
  d = 12; { the distance between the eye and the screen }
  w = (xTop - xBot) / 2; { the half-width of the screen }
  s = 3; { the half-width of the object plus a margin}

var x, y, z: real; { The coordinates of the desired viewpoint }
    xw, yw, zw: array [1..maxPoints] of real; { 3-D world coordinates }
    xs, ys: array[1..maxPoints] of real; { 2-D screen coordinates }
    XOffset,YOffset: real;
    maxY: Integer; { keeps GetMaxY for regular reference }
    coefficient: real;
{$ifndef SINGLEPAGE}
    lastPage: Word; { graphics video page EGA/VGA/Hercules only }
{$endif}

{ **************************************************************
  * Purpose: Setup the drawing equipment                       *
  ************************************************************** }
procedure GetStarted;
var
  GraphDriver,GraphMode: Integer;
begin
  GraphDriver := Detect;
  InitGraph(GraphDriver,GraphMode,'');
  ClearDevice;
  SetViewPort(0, 0, GetMaxX, GetMaxY,ClipOn);
  SetLineStyle(SolidLn,0,NormWidth);
  XOffset := GetMaxX div 2;
  maxY := GetMaxY;
  YOffset := maxY div 2;
{$ifndef SINGLEPAGE}
  lastPage := 0; { initially draw and view page 0 }
  SetActivePage(lastPage);
  SetVisualPage(lastPage);
{$endif}
end; { GetStarted }

{ **************************************************************
  * Purpose   : Define the world coordinates of the court      *
  ************************************************************** }
procedure InitializeObject;
begin
  xw[ 1] := -2.0; yw[ 1] := 0.0; zw[ 1] :=  3.0;
  xw[ 2] := -2.0; yw[ 2] := 0.0; zw[ 2] := -3.0;
  xw[ 3] :=  2.0; yw[ 3] := 0.0; zw[ 3] := -3.0;
  xw[ 4] :=  2.0; yw[ 4] := 0.0; zw[ 4] :=  3.0;
  xw[ 5] := -1.5; yw[ 5] := 0.0; zw[ 5] :=  2.5;
  xw[ 6] := -1.5; yw[ 6] := 0.0; zw[ 6] := -2.5;
  xw[ 7] :=  1.5; yw[ 7] := 0.0; zw[ 7] := -2.5;
  xw[ 8] :=  1.5; yw[ 8] := 0.0; zw[ 8] :=  2.5;
  xw[ 9] := -2.0; yw[ 9] := 0.0; zw[ 9] :=  0.0;
  xw[10] := -2.0; yw[10] := 0.5; zw[10] :=  0.0;
  xw[11] :=  2.0; yw[11] := 0.5; zw[11] :=  0.0;
  xw[12] :=  2.0; yw[12] := 0.0; zw[12] :=  0.0;
  xw[13] := -1.5; yw[13] := 0.0; zw[13] :=  3.0;
  xw[14] := -1.5; yw[14] := 0.0; zw[14] := -3.0;
  xw[15] :=  1.5; yw[15] := 0.0; zw[15] :=  3.0;
  xw[16] :=  1.5; yw[16] := 0.0; zw[16] := -3.0;
  xw[17] :=  0.0; yw[17] := 0.0; zw[17] :=  2.5;
  xw[18] :=  0.0; yw[18] := 0.0; zw[18] := -2.5;
end;

{ **************************************************************
  * Purpose   : First, convert World Coord to Eye Coord        *
  *           : Then, convert Eye Coord to Screen Coord        *
  ************************************************************** }
procedure EffectivePoints;
var
  i: integer;
  c1,c2,xe,ye,ze: real;
begin
  { --- calculate constants for formulas below }
  c1 := sqrt( x * x + z * z);
  c2 := sqrt( x * x + y * y + z * z );
  for i := 1 to maxPoints do
  begin
    { --- World Coord to Eye Coord }
    xe := xw[i] * z / c1 - zw[i] * x / c1;
    ye := -xw[i] * x * y / c1 / c2 + yw[i] * c1 / c2 - zw[i] * y * z / c1 / c2;
    ze := -xw[i] * x / c2 - yw[i] * y / c2 - zw[i] * z / c2 + c2;
    { --- Eye Coord to Screen Coord }
    xs[i] := xe / ze * coefficient;
    ys[i] := ye / ze * coefficient;
  end; { for loop }
end;

procedure MoveTo(index: integer);
begin
  Graph.MoveTo(Trunc(xs[index] * XMagnify + XOffset),
               maxY - Trunc(ys[index] * YMagnify + YOffset));
end; { MoveTo }

procedure LineTo(index: integer);
begin
  Graph.LineTo(Trunc(xs[index] * XMagnify + XOffset),
               maxY - Trunc(ys[index] * YMagnify + YOffset));
end; { LineTo }

{ **************************************************************
  * Purpose   : Draws the tennis court                         *
  ************************************************************** }
procedure DrawObject(color1,color2: Word);
var xStr,yStr,zStr: string; { temp strings for conversions }
begin
  SetColor(White);
  Str(x:4:0,xStr);
  Str(y:4:0,yStr);
  Str(z:4:0,zStr);
  OutTextXY(10,10,'X='+xStr+', Y='+yStr+', Z='+zStr);
  SetColor(color1);
  { --- }
  MoveTo(1);
  LineTo(2);
  LineTo(3);
  LineTo(4);
  LineTo(1);
  { --- }
  MoveTo(5);
  LineTo(6);
  LineTo(7);
  LineTo(8);
  LineTo(5);
  { --- }
  SetColor(color2);
  MoveTo(9);
  LineTo(10);
  LineTo(11);
  LineTo(12);
  LineTo(9);
  { --- }
  SetColor(color1);
  MoveTo(13);
  LineTo(14);
  { --- }
  MoveTo(15);
  LineTo(16);
  { --- }
  MoveTo(17);
  LineTo(18);
end;

{ **************************************************************
  * Purpose   : Draws the net of the tennis court              *
  ************************************************************** }
procedure DrawNet(color: Word);
var
  i,step: integer;
  nx1,nx2,ny1,ny2: real;
begin
  SetColor(color);
  step := 5;
  for i := 1 to step do
  begin
    nx1 := xs[9] + (i - 1) * (xs[10] - xs[9]) / step;
    ny1 := ys[9] + (i - 1) * (ys[10] - ys[9]) / step;
    nx2 := xs[12] + (i - 1) * (xs[11] - xs[12]) / step;
    ny2 := ys[12] + (i - 1) * (ys[11] - ys[12]) / step;
    Graph.MoveTo(Trunc(nx1 * XMagnify + XOffset), maxY - Trunc(ny1 * YMagnify + YOffset));
    Graph.LineTo(Trunc(nx2 * XMagnify + XOffset), maxY - Trunc(ny2 * YMagnify + YOffset));
  end; { for loop }
  step := 30;
  for i := 1 to step do
  begin
    nx1 := xs[9] + (i - 1) * (xs[12] - xs[9]) / step;
    ny1 := ys[9] + (i - 1) * (ys[12] - ys[9]) / step;
    nx2 := xs[10] + (i - 1) * (xs[11] - xs[10]) / step;
    ny2 := ys[10] + (i - 1) * (ys[11] - ys[10]) / step;
    Graph.MoveTo(Trunc(nx1 * XMagnify + XOffset), maxY - Trunc(ny1 * YMagnify + YOffset));
    Graph.LineTo(Trunc(nx2 * XMagnify + XOffset), maxY - Trunc(ny2 * YMagnify + YOffset));
  end; { for loop }
end;

{ **************************************************************
  * Purpose   : Modifies X, Y, and Z coord and returns key     *
  ************************************************************** }
function GetNewCoordinates: Char;
const
  ext = #0; { extended keycode indicator }
  esc = #27; { escape }
  ltArrow = #75;
  rtArrow = #77;
  upArrow = #72;
  dnArrow = #80;
  pgUp    = #73;
  pgDn    = #81;
  home    = #71;
var
  key: Char;
  {$ifdef SINGLEPAGE}
  procedure EraseOldObject;
  begin
    EffectivePoints;
    DrawObject(black,black);
    DrawNet(black);
  end; { EraseOldObject }
  {$endif}
begin
  repeat until KeyPressed;
  key := ReadKey;
  case key of
    ext: begin
           key := ReadKey;
           {$ifdef SINGLEPAGE}
           if key in [ltArrow, rtArrow, upArrow, dnArrow, pgUp, pgDn, home] then EraseOldObject;
           {$endif}
           case key of
             ltArrow: x := x - 1;
             rtArrow: x := x + 1;
             upArrow: y := y + 1;
             dnArrow: y := y - 1;
             pgUp   : z := z + 1;
             pgDn   : if z > 4 then z := z - 1;
             home   : begin
                        x := 0;
                        y := 2;
                        z := 10;
                      end;
           end; { case }
           key := ext; { reset to first key code }
         end; { ext case }
  end; { case }
  GetNewCoordinates := key;
end; { GetNewCoordinates }

{ **************************************************************
  * Purpose: Print a message and wait for a key                *
  ************************************************************** }
procedure WaitForKey;
begin
  repeat until KeyPressed;
  ReadKey;
end; { WaitForKey }

{ **************************************************************
  * Purpose: Display all text messages and wait for key        *
  ************************************************************** }
procedure Copyright;
begin
  ClrScr;
  Writeln('3DTennis * Copyright (c) 1990-2019 by Tony G. Papadimitriou');
  Writeln;
  Writeln('After the screen is drawn, you can press:');
  Writeln('   < left arrow to decrease the value of the X axis');
  Writeln('   > right arrow to increase the value of the X axis');
  Writeln('   ^ up arrow to increase the value of the Y axis');
  Writeln('   v down arrow to decrease the value of the Y axis');
  Writeln('   PgUp/PgDn to control the Z axis (PgUp=away, PgDn=close)');
  Writeln('   Home to return to the initial X, Y, Z');
  Writeln('When you are done, press ESC to return to DOS');
  Writeln('Have fun... (press any key to begin)');
  WaitForKey;
end; { Copyright }

{ **************************************************************
  * Purpose: This is the main procedure that calls the others  *
  ************************************************************** }
const
  ESC = #27; { escape }
begin
  Copyright;
  GetStarted;
  InitializeObject;
  {---}
  x := 0; { initial X coordinate }
  y := 2; { initial Y coordinate }
  z := 10; { initial Z coordinate }
  coefficient := d * w / s;
  repeat
    {$ifndef SINGLEPAGE}
    SetActivePage(lastPage);
    {$endif}
    EffectivePoints;
    {$ifndef SINGLEPAGE}
    ClearDevice;
    {$endif}
    DrawObject(yellow,red);
    DrawNet(red);
    {$ifndef SINGLEPAGE}
    SetVisualPage(lastPage);
    lastPage := (lastPage + 1) mod 2;
    {$endif}
  until GetNewCoordinates = ESC;
  CloseGraph;
end.
