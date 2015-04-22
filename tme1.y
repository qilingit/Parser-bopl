%{
		import java.io.*;
%}

%token	PROGRAM
%token	LET
%token	IN
%token	BEGIN
%token	END
%token	CLASS
%token	IS
%token	EXTENDS
%token	VARS
%token	METHODS
%token	RETURN
%token	WRITELN
%token	IF
%token	THEN
%token	ELSE
%token	WHILE
%token	DO
%token	NULL
%token	TRUE
%token	FALSE
%token	<sval> NUM
%token	NOT
%token	AND
%token	OR
%token	NEW
%token	INSTANCEOF
%token 	OBJ
%token 	VOID
%token	INT
%token	BOOL
%token	<sval> ID


%start prog
%type <sval> classes
%type <sval> class
%type <sval> nonemptyclasses
%type <sval> locals
%type <sval> extends
%type <sval> vardeclist
%type <sval> vardecs
%type <sval> vardec
%type <sval> methodlist
%type <sval> methods
%type <sval> method
%type <sval> classtype
%type <sval> ids
%type <sval> ids2
%type <sval> argdeclist
%type <sval> argdecs
%type <sval> argdec
%type <sval> instrlist
%type <sval> instrseq
%type <sval> instr
%type <sval> exp
%type <sval> arglist
%type <sval> args
%%

prog: PROGRAM classes locals instrlist { System.out.println("program("+$2+","+$3+", "+$4+")"); }
		;

classes:	{ $$ = "[]";} 
	|	nonemptyclasses	{ $$ = "[" + $1 +"]"; }
	;

nonemptyclasses:	class {System.err.println("LINE "); $$ = $1;}
		|	class nonemptyclasses { $$ = $1+ "," + $2;}
		;

class:	CLASS ID extends IS vardeclist methodlist	{ $$ = "class (" + $2 + ","+ $3 +","+ $5 +","+ $6 +")"; }
		;

extends:	{ $$ = "obj";}
				|	extends classtype {$$ = $2;}
				;

classtype: OBJ	{$$ = "obj";}
					|VOID	{$$ = "void";}
					|INT	{$$ = "int";}
					|BOOL	{$$ = "bool";}
					|ID	{$$ = $1;}
					;

vardeclist:	{$$ = "[]";}
					|	VARS vardecs {$$ = "["+$2+"]";}
					;

vardecs: vardec
				|vardecs vardec {$$ = $1 + "," + $2; }
				;

vardec: classtype ids ";" {$$="var (" +$1+ ", "+ $2 +")"; }
				;

ids: {$$ = "[]";}
  | ids2 { $$ = "["+$1+"]";}
	;

ids2 : ID {$$ = $1;}
  | ids2 "," ID  {$$ = $1+","+$3;}
	;

methodlist: {$$ = "[]";}
					| METHODS methods {$$ = "["+$2+"]";}
					;

methods: method {$$ = $1;}
			|methods method	{$$ = $2;}
			;

method: classtype ID "(" argdeclist ")" locals instrlist	{$$ = "method( "+$2+", "+$4+", "+$6+", "+$7;}
			;

argdeclist: {$$ = "[]";}
					|	argdecs {$$ = "[" + $1 + "]"; }
					;

argdecs: argdec {$$ = $1;}
			|	 argdecs ";" argdec { $$ = $1 + "," + $3;} 
			;

argdec: classtype ID {$$="["+$1+" "+$2+"]";}
			;

locals: {$$="[]";}
			|	LET vardecs IN	{$$ = $2;}
			;

instrlist: BEGIN instrseq END { System.err.println("HELLO"); $$ = "["+$2+"]";}
					;

instrseq:	{$$="";}
		| instr  {$$ =$1;}
		|	instrseq ";" instr {$$ = $1+","+$3;}
		;

instr:	exp "." ID "("arglist")"	{$$ = "call (" +$1+", "+$3+", ["+$5+"])";}
	|	ID ":=" exp	{$$ = "setvar("+$1+", "+$3+")";}
	|	exp "." ID ":=" exp	{$$ = "setfield("+$1+", "+$3+", "+$5+")";}
	|	RETURN exp	{$$ = "return("+$2+")";}
	|	WRITELN exp	{$$ = "write("+$2+")";}
	|	IF exp THEN instrlist ELSE instrlist
			{$$ = "if("+$2+", "+$4+", "+$6+")";}
	|	WHILE exp DO instrlist	{$$ = "while("+$2+", ["+$4+"])";}
	;

exp:	NULL		{$$ ="nil";}
	| 	TRUE		{$$ ="true";}
	| 	FALSE		{$$ ="false";}
	| 	NUM			{$$ = $1;}
	|	ID			{$$ = "\""+$1+"\"";}
	|	NEW classtype	{$$ = "new( "+$2+")";}
	|	NOT exp		{$$ = "not("+$2+")";}
	|	"(" exp ")"	{ $$ = "("+$2+")";}
	|	exp "." ID	{$$ = "getfield("+$1+", "+$3+")";}
	|	exp "." ID "(" arglist ")"	{$$ = "call("+$1+", "+$3+", ["+$5+"])";}
	|	exp INSTANCEOF classtype	{$$ = "instanceof( "+$3+", "+$1+")";}
	|	exp AND exp	{$$ = "and("+$1+", "+$3+")";}
	|	exp OR	exp	{$$ = "or("+$1+", "+$3+")";}
	|	exp "+" exp	{$$ = "add("+$1+", "+$3+")"; }
	|	exp "-" exp	{$$ = "sub("+$1+", "+$3+")"; }
	|	exp "*" exp	{$$ = "mul("+$1+", "+$3+")"; }
	|	exp "/" exp	{$$ = "div("+$1+", "+$3+")"; }
	|	exp "="	exp	{$$ = "eq("+$1+", "+$3+")"; }
	|	exp "<"	exp	{$$ = "lt("+$1+", "+$3+")"; }
	;
			
arglist:	{$$ = "[]";}
		|	args	{$$ ="["+$1+"]";}
		;

args:	exp	{$$ = $1;}
	|	args "," exp	{$$ = $1+","+$3;}
	;

%%

private Yylex lexer;

private int yylex () {
	int yyl_return = -1;
	try {
		yylval = new ParserVal(0);
		yyl_return = lexer.yylex();
	}
	catch (IOException e) {
		System.err.println("IO error :"+e);
	}
	return yyl_return;
}


public void yyerror (String error) {
	System.err.println ("Error: " + error);
}

public Parser(Reader r) {
	lexer = new Yylex(r, this);
}

static boolean interactive;

public static void main(String args[]) throws IOException {
	System.out.println("TP APS 2015");
	Parser yyparser;
	if ( args.length > 0 ) {
		// parse a file
		yyparser = new Parser(new FileReader(args[0]));
	}
	else {
		// interactive mode
		System.out.println("[Quit with CTRL-D]");
		System.out.print("Expression: ");
		interactive = true;
		yyparser = new Parser(new InputStreamReader(System.in));
	}
    System.err.println("YACC: Parsing...");
	yyparser.yyparse();
    System.err.println("YACC: Parsed...");
	if (interactive) {
		System.out.println();
		System.out.println("Have a nice day");
	}
}
