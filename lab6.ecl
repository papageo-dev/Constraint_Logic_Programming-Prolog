%%% Constraint Logic Programming
%%% Prolog
%%% Lab 6
%%% Operators



%%% All Operators
:-op(500,yfx,and).
:-op(500,yfx,or).
:-op(500,yfx,nor).
:-op(500,yfx,nand).
:-op(500,yfx,xor).
:-op(400,fy,--).
:-op(600,xfx,==>).

--Arg1:-not(Arg1).
 
Arg1 ==> Arg2 :- Arg1 or --Arg2.

Arg1 and Arg2 :- Arg1, Arg2.

Arg1 or _Arg2 :- Arg1.
_Arg1 or Arg2 :-Arg2.

Arg1 xor Arg2 :- Arg1, --Arg2.
Arg1 xor Arg2 :- --Arg1, Arg2.

Arg1 nor Arg2 :- --(Arg1 or Arg2).
Arg1 nand Arg2 :- --(Arg1 and Arg2).

t. 
f:-!,fail.


%%% proper_set_s/1
%%% proper_set_s(List)
%%% Succeeds when the input list contains only unique elements	
proper_set_s(List):-
	setof(S, member(S,List), List).
	
	
%%% model/1
%%% model(Expr)
%%% A model evaluator
%%% allows the existence of variables in expressions
model(Expr):-
	term_variables(Expr, ListOfVars),                                       %%% Return all variables there are in expression
    assign_tf(ListOfVars),                                                  %%% Assign variables as true or false
	Expr.
	
assign_tf([]).
assign_tf([t|Rest]):-
	assign_tf(Rest).
assign_tf([f|Rest]):-
	assign_tf(Rest).
	
	
%%% theory/1
%%% theory(ListOfExpr)
%%% A model evaluator
%%% that accepts a list of expressions propositional logic,
%%% possibly containing variables, and evaluates these(conjugation).
theory([]).
theory([Axiom|Rest]):-
	model(Axiom),
    theory(Rest).

%%% Theoretical proof
%%% (Υ <==> Χ or Y) <=> ((Υ ==> Χ or Y) and (Χ or Y ==> Υ)) 	
%%% setof(Y, theory([X,Y ==> X or Y, X or Y ==> Y]), [f,t]).

