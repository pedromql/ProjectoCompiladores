%{
#include <stdio.h>
#include "symtab.h"
#define NSYMS 100

symtab tab[NSYMS];
symtab *symlook(char *varname);
%}
%left '+' '-'
%left '*' '/'
%left '('
%type  <value> calculations
%type  <value> expression
%token <id> VAR  END
%token <value> NUMBER
%union{
     int value;
     char* id;
}



Prog: ProgHeading ";" ProgBlock ".";							
ProgHeading: PROGRAM ID "(" OUTPUT ")";						
ProgBlock: VarPart FuncPart StatPart;
VarPart: optVarPart;
optVarPart: VAR VarDeclaration ";" VarPart2|;
VarPart2: VarPart2 VarDeclaration ";"| ;
VarDeclaration: IDList ":" ID;
IDList: ID IDList2;
IDList2: IDList2 "," ID|;
FuncPart: FuncPart FuncDeclaration ";" |;
FuncDeclaration: FuncHeading ";" FORWARD | FuncIdent ";" FuncBlock | FuncHeading ";" FuncBlock;
FuncHeading: FUNCTION ID optFuncHeading ":" ID;
optFuncHeading: FormalParamList|;
FuncIdent: FUNCTION ID;
FormalParamList: "(" FormalParams FormalParamList2 ")";
FormalParamList2: FormalParamList2 ";" FormalParams |;
FormalParams: optFormalParams IDList ":" ID;
optFormalParams: VAR |;
FuncBlock: VarPart StatPart;
StatPart: CompStat;
CompStat: BEGIN_ StatList END;
StatList: Stat Stat2;
Stat2: Stat2 ";" Stat|;
Stat: CompStat | IF Expr THEN Stat optStat1 | WHILE Expr DO Stat | REPEAT StatList UNTIL Expr | VAL "(" PARAMSTR "(" Expr ")" "," ID ")" | opStat2 | WRITELN opStat3;
optStat1: ELSE Stat|;
optStat2: ID ASSIGN Expr|;
optStat3:WritelnPList|;
WritelnPList: "(" optWritelnPList WritelnPList2 ")";
optWritelnPList: Expr|STRING;
WritelnPList2: WritelnPList2 "," optWritelnPList|;
Expr: Expr optOperation1 Expr|optOperation2 Expr| "(" Expr ")" |optExpr1| ID optExpr2;
opOperation1: AND|OR|MOD|DIV|LESSEQ|GREATEQ|LESSGREAT|"+"|"-"|"*"|"/"|"<"|">"|"="							
opOperation2: "+"|"-"|NOT;
opExpr1: INTLIT|REALLIT;
opExpr2: ParamList|;
ParamList: "(" Expr repParamList ")";
repParamList: repParamList "," Expr|;





















