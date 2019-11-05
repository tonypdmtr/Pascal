{ **************************************************************
  * Programmer: Original: Tom Rugg & Phil Feldman              *
  *           : Tony Papadimitriou <tonyp@acm.org>             *
  * Unit      : Business                                       *
  * Uses      : Nothing                                        *
  * Includes  : Nothing                                        *
  * Created   : July 22, 1990                                  *
  * Updated   : December 6, 1990                               *
  * Language  : Turbo Pascal 6.0 & FPC v3.0.4                  *
  * Purpose   : Financial functions                            *
  * -------------------- Version History --------------------- *
  * 1.00      : Original                                       *
  ************************************************************** }
unit Business;

{ **************************************************************
  *        U N I T   I N T E R F A C E   S E C T I O N         *
  ************************************************************** }

interface

const ARRAY_SIZE = 250; { upper limit of ArrayType below }
type ArrayType = array[1..ARRAY_SIZE] of real;

function AnnuDep(FinalValue,InterestRate:real;TotalNumDep,NumDepPerYr:Integer):real;
function AnnuFV(Deposit,InterestRate:real;TotalNumDep,NumDepPerYr:Integer):real;
function AnnuTND(Deposit,FinalValue,InterestRate:real;NumDepPerYr:Integer):real;
function FutGrow(Rate,Base:real;NewTime:Integer):real;
function InvestFV(Principal,InterestRate:real;CompoundYear,NumberMonths:Integer):real;
function InvestP(FinalValue,InterestRate:real;CompoundYear,NumberMonths:Integer):real;
function InvestIR(Principal,FinalValue:real;CompoundYear,NumberMonths:Integer):real;
function InvestNM(Principal,FinalValue,InterestRate:real;CompoundYear:Integer):real;
function LoanPay(Principal,InterestRate:real;TotalNumPay,NumPayPerYr:Integer):real;
function LoanPrin(Payment,InterestRate:real;TotalNumPay,NumPayPerYr:Integer):real;
function LoanTNP(Principal,Payment,InterestRate:real;NumPayPerYr:Integer):real;
function WDrawP(Withdrawal,InterestRate:real;TotalNumW,NumWPerYr:Integer):real;
function WDrawWD(Principal,InterestRate:real;TotalNumW,NumWPerYr:Integer):real;
function WDrawTNW(Principal,Withdrawal,InterestRate:real;NumWPerYr:Integer):real;
procedure GrowRate(PastDataArray:ArrayType;Count:Integer;var Rate,Base:real;var OK:Boolean);

{ **************************************************************
  *   U N I T   I M P L E M E N T A T I O N   S E C T I O N    *
  ************************************************************** }

implementation

{ **************************************************************
  * Purpose   : Calculate regular deposit for an annuity       *
  ************************************************************** }
function AnnuDep(FinalValue,InterestRate:real;TotalNumDep,NumDepPerYr:Integer):real;
var Product: real;
    J: Integer;
begin
  Product := 1.0;
  for J := 1 to TotalNumDep do
    Product := Product * (1.0 + InterestRate / 100.0 / NumDepPerYr);
  AnnuDep := FinalValue * InterestRate / 100.0 / NumDepPerYr / (Product - 1.0);
end; { AnnuDep }

{ **************************************************************
  * Purpose   : Calculate the final value of an annuity        *
  ************************************************************** }
function AnnuFV(Deposit,InterestRate:real;TotalNumDep,NumDepPerYr:Integer):real;
var Product: real;
    J: Integer;
begin
  Product := 1.0;
  for J := 1 to TotalNumDep do
    Product := Product * (1.0 + InterestRate / 100.0 / NumDepPerYr);
  AnnuFV := Deposit * (Product - 1.0) * NumDepPerYr * 100.0 / InterestRate;
end; { AnnuFV }

{ **************************************************************
  * Purpose   : Calculate the total number of deposits for an  *
  *           : annuity                                        *
  ************************************************************** }
function AnnuTND(Deposit,FinalValue,InterestRate:real;NumDepPerYr:Integer):real;
var Temp,RealTND: real;
begin
  Temp := InterestRate / 100.0 / NumDepPerYr;
  RealTND := Ln(1.0 + FinalValue * Temp / Deposit) / Ln(1.0 + Temp);
  AnnuTND := RealTND;
end; { AnnuTND }

{ **************************************************************
  * Purpose   : Project future values based on a growth rate   *
  ************************************************************** }
function FutGrow(Rate,Base:real;NewTime:Integer):real;
var Term,Product: real;
    J: Integer;
begin
  Product := 1.0;
  Term := Rate / 100.0 + 1.0;
  for J := 1 to NewTime - 1 do Product := Product * Term;
  FutGrow := Base * Product;
end; { FutGrow }

{ **************************************************************
  * Purpose   : Calculate the average growth rate of time-     *
  *           : series data                                    *
  ************************************************************** }
procedure GrowRate(PastDataArray:ArrayType;Count:Integer;var Rate,Base:real;var OK:Boolean);
var SumOfLogs,WeightedSum,Value,LogValue,Temp: real;
    J: Integer;
begin
  if Count < 2 then
  begin
    OK := False;
    Exit;
  end;
  SumOfLogs := 0.0;
  WeightedSum := 0.0;
  for J := 1 to Count do
  begin
    Value := PastDataArray[J];
    if Value <= 0.0 then
    begin
      OK := False;
      Exit;
    end;
    LogValue := Ln(Value);
    SumOfLogs := SumOfLogs + LogValue;
    WeightedSum := WeightedSum + (J - 1) * LogValue;
  end;
  OK := True;
  Temp := 6.0 * (2.0 * WeightedSum / (Count - 1) - SumOfLogs) / Count / (Count + 1);
  Rate := 100.0 * (Exp(Temp) - 1.0);
  Base := Exp(SumOfLogs / Count - Temp * (Count - 1) / 2.0);
end; { GrowRate }

{ **************************************************************
  * Purpose   : Calculate the final value of an investment     *
  ************************************************************** }
function InvestFV(Principal,InterestRate:real;CompoundYear,NumberMonths:Integer):real;
var Growth: real;
begin
  Growth := Exp(NumberMonths / 12.0 * CompoundYear * Ln(1.0 + InterestRate / 100.0 / CompoundYear));
  InvestFV := Principal * Growth;
end; { InvestFV }

{ **************************************************************
  * Purpose   : Calculate the principal of an investment       *
  ************************************************************** }
function InvestP(FinalValue,InterestRate:real;CompoundYear,NumberMonths:Integer):real;
var Growth: real;
begin
  Growth := Exp(NumberMonths / 12.0 * CompoundYear * Ln(1.0 + InterestRate / 100.0 / CompoundYear));
  InvestP := FinalValue / Growth;
end; { InvestP }

{ **************************************************************
  * Purpose   : Calculate the interest rate of an investment   *
  ************************************************************** }
function InvestIR(Principal,FinalValue:real;CompoundYear,NumberMonths:Integer):real;
begin
  InvestIR := CompoundYear * (Exp(Ln(FinalValue / Principal) / CompoundYear / NumberMonths * 12.0) - 1.0) * 100.0;
end; { InvestIR }

{ **************************************************************
  * Purpose   : Calculate the term of an investment            *
  ************************************************************** }
function InvestNM(Principal,FinalValue,InterestRate:real;CompoundYear:Integer):real;
var RealNM: real;
begin
  RealNM := Ln(FinalValue / Principal) / Ln(InterestRate / 100.0 / CompoundYear + 1.0) / CompoundYear * 12.0;
  InvestNM := RealNM;
end; { InvestNM }

{ **************************************************************
  * Purpose   : Calculate the regular payment of a loan        *
  ************************************************************** }
function LoanPay(Principal,InterestRate:real;TotalNumPay,NumPayPerYr:Integer):real;
var Temp: real;
begin
  Temp := Exp(-TotalNumPay * Ln(1.0 + InterestRate / 100.0 / NumPayPerYr));
  LoanPay := Principal * InterestRate / 100.0 / NumPayPerYr / (1.0 - Temp);
end; { LoanPay }

{ **************************************************************
  * Purpose   : Calculate the principal for a loan             *
  ************************************************************** }
function LoanPrin(Payment,InterestRate:real;TotalNumPay,NumPayPerYr:Integer):real;
var Temp: real;
begin
  Temp := Exp(-TotalNumPay * Ln(1.0 + InterestRate / 100.0 / NumPayPerYr));
  LoanPrin := Payment * NumPayPerYr * 100.0 / InterestRate * (1.0 - Temp);
end; { LoanPrin }

{ **************************************************************
  * Purpose   : Calculate the total number of payments         *
  *           : required to pay back a loan                    *
  ************************************************************** }
function LoanTNP(Principal,Payment,InterestRate:real;NumPayPerYr:Integer):real;
var Temp,RealTNP: real;
begin
  Temp := Principal * InterestRate / 100.0 / Payment / NumPayPerYr;
  if Temp >= 1 then
    RealTNP := 0.0
  else
    RealTNP := -Ln(1.0 - Temp) / Ln(1.0 + InterestRate / 100.0 / NumPayPerYr);
  LoanTNP := RealTNP;
end; { LoanTNP }

{ **************************************************************
  * Purpose   : Calculate the principal for an investment with *
  *           : withdrawls                                     *
  ************************************************************** }
function WDrawP(Withdrawal,InterestRate:real;TotalNumW,NumWPerYr:Integer):real;
var Product: real;
    J: Integer;
begin
  Product := 1.0;
  for J := 1 to TotalNumW do
    Product := Product * (1.0 + InterestRate / 100.0 / NumWPerYr);
  WDrawP := Withdrawal * NumWPerYr * (1.0 - 1.0 / Product) * 100.0 / InterestRate;
end; { WDrawP }

{ **************************************************************
  * Purpose   : Calculate the maximum periodic withdrawal from *
  *           : an investment                                  *
  ************************************************************** }
function WDrawWD(Principal,InterestRate:real;TotalNumW,NumWPerYr:Integer):real;
var Product: real;
    J: Integer;
begin
  Product := 1.0;
  for J := 1 to TotalNumW do
    Product := Product * (1.0 + InterestRate / 100.0 / NumWPerYr);
  WDrawWD := Principal * InterestRate / 100.0 / NumWPerYr * (1.0 + 1.0 / (Product - 1.0));
end; { WDrawWD }

{ **************************************************************
  * Purpose   : Calculate the total number of withdrawals      *
  *           : until an investment is depleted                *
  ************************************************************** }
function WDrawTNW(Principal,Withdrawal,InterestRate:real;NumWPerYr:Integer):real;
var Temp,RealTNW: real;
begin
  Temp := 1.0 - Principal * InterestRate / 100.0 / NumWPerYr / Withdrawal;
  if Temp <= 0.0 then
    RealTNW := 0
  else
    RealTNW := -Ln(Temp) / Ln(1.0 + InterestRate / 100.0 / NumWPerYr);
  WDrawTNW := RealTNW;
end; { WDrawTNW }

end.
