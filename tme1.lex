%%

%byaccj

%{
	private Parser yyparser;

	public Yylex(java.io.Reader r, Parser yyparser){
		this(r);
		this.yyparser = yyparser;
	}

    public void log(String s) {
      System.err.println("LINE " + yyline + ":" + yycolumn + ":" + s);
    }
%}


PROGRAM = "program"
LET = "let"
IN = "in"
BEGIN = "begin"
END = "end"
CLASS = "class"
IS = "is"
EXTENDS = "extends"
VARS = "vars"
METHODS = "methods"
RETURN = "return"
WRITELN = "writeln"
IF = "if"
THEN = "then"
ELSE = "else"
WHILE = "while"
DO = "do"
NULL = "null"
TRUE = "true"
FALSE = "false"
NUM = [0-9]+
NOT = "not"
AND = "and"
OR = "or"
NEW = "new"
INSTANCEOF = "instanceof"
OBJ = "Obj"
VOID = "Void"
INT = "Int"
BOOL = "Bool"
ID = [_a-zA-Z]+[a-zA-Z0-9]*


%%

{PROGRAM} {log("Lex: program"); return Parser.PROGRAM;}
{LET} {return Parser.LET;}
{IN}	{return Parser.IN;}
{BEGIN}	{log("Lex: BEGIN"); return Parser.BEGIN;}
{END}	{log("Lex: END"); return Parser.END;}
{CLASS}	{return Parser.CLASS;}
{IS}	{return Parser.IS;}
{EXTENDS}	{return Parser.EXTENDS;}
{VARS}	{return Parser.VARS;}
{METHODS}	{return Parser.METHODS;}
{RETURN}	{log("Lex: RETURN"); return Parser.RETURN;}
{WRITELN}	{return Parser.WRITELN;}
{IF}	{return Parser.IF;}
{THEN}	{return Parser.THEN;}
{ELSE}	{return Parser.ELSE;}
{WHILE}	{return Parser.WHILE;}
{DO}	{return Parser.DO;}
{NULL}	{log("Lex: NULL"); return Parser.NULL;}
{TRUE}	{return Parser.TRUE;}
{FALSE}	{return Parser.FALSE;}
{NUM}	{log("Lex: NUM " + yytext()); yyparser.yylval = new ParserVal(yytext()); return Parser.NUM;}
{NOT}	{return Parser.NOT;}
{AND}	{return Parser.AND;}
{OR}	{return Parser.OR;}
{NEW}	{return Parser.NEW;}
{EXTENDS}	{return Parser.EXTENDS;}
{BOOL}	{return Parser.BOOL;}
{INT}}	{return Parser.INT;}
{INSTANCEOF} {return Parser.INSTANCEOF;}
{OBJ}	{return Parser.OBJ;}
{VOID}	{return Parser.VOID;}
{ID} {log("Lex: ID " + yytext()); yyparser.yylval = new ParserVal(yytext());
				return Parser.ID;}

"."
|","
|";"
|":"
|"("
|")"
|":="
|"="
|"<" 
|"+"
|"-"
|"*"
|"/" {log("Lex: " + yytext()); return (int)yycharat(0);}


[ \n\r\t]+ {}
