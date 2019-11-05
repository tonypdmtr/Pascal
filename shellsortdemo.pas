program ShellSortDemo;


uses Crt,Graph,Drivers;

const
     N = 639;            { number of columns :  x-coordinates }
     Range = 199;        { actual size :        y-coordinates }
     NoPixelColor = Black;
     PixelColor   = LightGreen;

var
   K: Integer;
   Num,Loops,Swaps,Aloops,Aswaps: real;
   A: array [1..N] of Integer;


procedure Swap ( var X,Y:Integer );
var
   Temp: Integer;
begin
     Temp := X;
     X := Y;
     Y := Temp;
     Swaps := Swaps + 1;
end; { Swap }


procedure ShellSort ;
var
   I,J,Incr:Integer;
begin
     Incr := N div 2;
     while Incr > 0 do
     begin
          for I := Incr + 1 to N do
          begin
               J := I - Incr;
               Loops := Loops + 1;
               while J > 0 do
                     if A[J] > A[J+Incr] then
                     begin
                          Loops := Loops + 1;
                          PutPixel (J,A[J],NoPixelColor);
                          PutPixel ((J+Incr),A[J+Incr],NoPixelColor);
                          Swap (A[J],A[J+Incr]);
                          PutPixel (J,A[J],PixelColor);
                          PutPixel ((J+Incr),A[J+Incr],PixelColor);
                          J := J - Incr;
                     end
                     else J := 0;
          end;
          Incr := Incr div 2;
     end;
end;  { ShellSort }


var
   GraphDriver,GraphMode: Integer;
   TempStr,TempStr1,TempStr2: string;
   CH: Char;
begin
     GraphDriver := Detect;
     InitGraph(GraphDriver,GraphMode,'');
     TempStr1 := '';
     TempStr2 := '';
     SetColor(Yellow);
     for K:=1 to N do
     begin
          Num := Range*Random;
          A[K] := Trunc (Num);
          PutPixel (K,A[K],PixelColor);
     end;
     SetBkColor(Black);
     { Sorting start }
     Loops := 0;
     Swaps := 0;
     Delay (1000);
     ShellSort ;
     Aloops := Loops;
     Aswaps := Swaps;
     TempStr := 'Shell Sort: a) Loops, Swaps: ';
     Str(Loops:7:3,TempStr1);
     Str(Swaps:7:3,TempStr2);
     TempStr := TempStr + TempStr1 + ', ' + TempStr2;
     OutTextXY (0,300,TempStr);
     SetColor(LightCyan);
     OutTextXY (0,320,'Press any key to process with an array');
     OutTextXY (0,330,'already sorted but in opposite direction.');
     repeat until KeyPressed;
     CH := ReadKey; if CH = #0 then CH := ReadKey;
     ClearDevice;
     for K:=1 to N do
     begin
          Num := (N-K)/(N/Range);
          A[K] := Trunc (Num);
          PutPixel (K,A[K],PixelColor);
     end;
     { Sorting start }
     Loops := 0;
     Swaps := 0;
     Delay (1000);
     ShellSort ;
     TempStr := 'Shell Sort: a) Loops, Swaps: ';
     Str(Aloops:7:3,TempStr1);
     Str(Aswaps:7:3,TempStr2);
     TempStr := TempStr + TempStr1 + ', ' + TempStr2;
     SetColor(Yellow);
     OutTextXY (0,300,TempStr);
     TempStr := '            b) Loops, Swaps: ';
     Str(Loops:7:3,TempStr1);
     Str(Swaps:7:3,TempStr2);
     TempStr := TempStr + TempStr1 + ', ' + TempStr2;
     OutTextXY (0,310,TempStr);
     SetColor(LightCyan);
     OutTextXY (0,330,'Press any key to exit.');
     repeat until KeyPressed;
     CH := ReadKey; if CH = #0 then CH := ReadKey;
     TextMode(LastMode);
end.
