:- set_prolog_flag(double_quotes, string).

typeExpr(true, bool).
typeExpr(false, bool).

typeExpr(X, int) :- integer(X).

typeInstr(write(Expr), void) :- typeExpr(Expr, _).
typeInstr(return(Expr), Type) :- typeExpr(Expr, Type).

/*
typeInstrList([Instr], Type) :- typeInstr(Instr, Type).
*/
typeInstr(if(Expr1, InstrList1, InstrList2), Type)   :- 
	typeExpr(Expr1, bool),
	typeInstrList(InstrList1, Type ),
	typeInstrList(InstrList2, Type).
premier1([X|_],X).

/* le type d'une liste d'instructions est le type de la derniere instruction */
typeInstrList([Instr|InstrList}], Type) :- typeInstr(Instr, _),typeInstrList(InstrList,Type).
typeInstrList([], void).

/*
typeInstr(if(Expr1, InstrList1, InstrList2), InstrSeq) :- typeExpr((Expr1, InstrList1, InstrList2), InstrSeq).
*/

/* On peut matcher les listes comme ca:
   [X] = une liste a un element (et l'element est X)
   [X, Y] = une liste a 2 elements
   etc
   [] = liste vide
   [Head | Tail] = liste non vide; Head = le premier element; Tail = la liste des autres
      ->  [1] : Head=1, Tail=[]
      ->  [1,2] : Head=1, Tail=[2]
      ->  [1,2,3] : Head=1, Tail=[2, 3]
*/

listLen([], 0).
listLen([_|Tail], X) :- listLen(Tail, Y), X is Y+1.

getLastElement( InstrList ) :- 

/*
?- getLastElement([1,2,yop], X).
X = yop.
*/

/*
[1,2,3] "matché par" [Head|Tail] alors Head=1 et Tail=[2,3]
*/

/*isProgramOk(program([],[],InstrList)) :- typeInstrList(InstrList, _).*/
isProgramOk(program([],[],InstrList)) :- typeInstrList(if(Expr1, InstrList1, InstrList2), _).
