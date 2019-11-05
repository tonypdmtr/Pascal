{ **************************************************************
  * Programmer: Tony Papadimitriou <tonyp@acm.org>             *
  * Program   : SCT (Sine, Cosine, Tangent)                    *
  * Uses      : CRT,GRAPH                                      *
  * Includes  : Nothing                                        *
  * Links     : Nothing                                        *
  * Created   : December 17, 1990                              *
  * Updated   : November 5, 2019                               *
  * Language  : Turbo Pascal 6.0 and FPC v3.0.4                *
  * Purpose   : Create a sine, cosine, and tangent waves       *
  * -------------------- Version History --------------------- *
  * 1.00      : Original                                       *
  ************************************************************** }
program SCT;
uses Graph;

procedure CreateHorizon(step:Integer);
var X,Y: Integer;
    s: string;
begin
  SetColor(Blue);
  Y := GetMaxY div 2;
  Line(0,Y,GetMaxX,Y);
  for X := 0 to GetMaxX div step do
  begin
    Str(X:1,s);
    MoveTo(X*step,Y+8);
    SetColor(Green);
    LineTo(X*step,Y);
    SetColor(LightGreen);
    OutTextXY(X*step,Y+10,s);
  end; { for }
end; { CreateHorizon }

procedure CreateSinWave(step:Integer);
var X,Y,ul: Integer;
begin
  ul := GetMaxY div 2;
  SetColor(Yellow);
  for X := 0 to GetMaxX do
  begin
    Y := ul + Trunc(Sin(X / step)*ul);
    if X = 0 then MoveTo(X,Y);
    LineTo(X,Y);
  end; { for }
end; { CreateSinWave }

procedure CreateCosWave(step:Integer);
var X,Y,ul: Integer;
begin
  ul := GetMaxY div 2;
  SetColor(Red);
  for X := 0 to GetMaxX do
  begin
    Y := ul + Trunc(Cos(X / step)*ul);
    if X = 0 then MoveTo(X,Y);
    LineTo(X,Y);
  end; { for }
end; { CreateCosWave }

procedure CreateTanWave(step:Integer);
var X,Y,ul: Integer;
begin
  ul := GetMaxY div 2;
  SetColor(Cyan);
  for X := 0 to GetMaxX do
  begin
    Y := ul + Trunc(Sin(X / step) / Cos(X / step)*ul);
    if X = 0 then MoveTo(X,Y);
    LineTo(X,Y);
  end; { for }
end; { CreateTanWave }

var gd,gm,errorCode,step: Integer;
begin
  if ParamCount = 0 then
  begin
    Writeln('Give step to use (1-320) or as parameter');
    Readln(step);
  end { if }
  else Val(ParamStr(1),step,errorCode);
  if (step < 1) or (step > 320) then
  begin
    step := 102;
    Writeln('Using default step (',step,')');
  end;
  gd := Detect;
  InitGraph(gd,gm,'');
  errorCode := GraphResult;
  if errorCode <> grOK then Halt(1);
  errorCode := TextWidth(' ');
  SetColor(Yellow);
  OutTextXY(0,0,'SINE');
  SetColor(Red);
  OutTextXY(errorCode*5,0,'COSINE');
  SetColor(Cyan);
  OutTextXY(errorCode*12,0,'TANGENT');
  CreateHorizon(step);
  CreateSinWave(step);
  CreateCosWave(step);
  CreateTanWave(step);
  Readln;
  CloseGraph;
end.
