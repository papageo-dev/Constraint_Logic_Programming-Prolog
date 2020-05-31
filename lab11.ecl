%%% Constraint Logic Programming
%%% Prolog
%%% Lab 10
%%% ECLipSe Constraints on Sets



%%% Include libraries
:-use_module(library(ic)).
:-use_module(library(ic_global)).
:-use_module(library(lists)).
:-use_module(library(ic_edge_finder)).
:-use_module(library(branch_and_bound)).
:-use_module(library(ic_sets)).
:-import (::)/2 from ic_sets.



%%% Exec 1

%%% houses(values)
houses([1,3,4,5,6,10,12,14,15,17,20,22]).

%%% fair_father/1
%%% fair_father(S1,S2,S3)
fair_father(S1,S2,S3):-
	houses(Houses),
	length(Houses,HowMany),
	
	%intsets([S1,S2,S3],3,1,HowMany),
	intset(S1,1,HowMany),
	intset(S2,1,HowMany),
	intset(S3,1,HowMany),
	Str =..[a|Houses],
	weight(S1,Str,Sum1),
	weight(S2,Str,Sum2),
	weight(S3,Str,Sum3),
	all_disjoint([S1,S2,S3]),
	129 #= Sum1 + Sum2 + Sum3,
	Sum1 #= Sum2,
	Sum2 #= Sum3,
	
	labelSets([S1,S2,S3]),
	write([Sum1,Sum2,Sum3]).
	
	
%%% labelSets/1
%%% labelSets(Groups)
%%% label all sets using indomain set
labelSets([]).
labelSets([G|Groups]):-
	insetdomain(G,_,_,_),
	labelSets(Groups).
	
	
	
%%% Exec 2

%%% value(values)
value([10,30,45,50,65,70,75,80,90,100]).

%%% weight(weights)
weight([100,110,200,210,240,300,430,450,500,600]).

%%% solve/3
%%% solve(N,Groups,Cost)
solve(N,Groups,Cost):-
	value(Values),
	weight(Weights),	
	length(Values,HowMany),
	sumlist(Values,MaxValue),

	intsets(Groups,N,1,HowMany), 
	all_disjoint(Groups),
	%intsets(Ws,N,1,HowMany),
	
	ValueStructure =..[a|Values],
	WeightStructure =..[b|Weights],

	pos_constraints(Groups,ValueStructure,WeightStructure,Cost),
	
	Min #= MaxValue - Cost,
	
	bb_min(labelSets(Groups),Min,_),
	
	pprint(Groups,Values,Weights).


	
%%% label all sets using indomainset	
labelSets([]).
labelSets([G|Groups]):-
	insetdomain(G,_,_,_), 
	labelSets(Groups).	
	
%%% State the sum constraint	
pos_constraints([],_ValueStructure,_WeightStructure,0). 
pos_constraints([G|Groups],ValueStructure,WeightStructure,Cost):-
	weight(G,ValueStructure,Vs),
	weight(G,WeightStructure,Ws),
	%% Limit weights (and everybody should get something)
	Ws #< 600, Ws #>0, 
	pos_constraints(Groups,ValueStructure,WeightStructure,RCost),
	Cost #= RCost + Vs.

%%% Prints nicely the sets on screen.	
pprint([],_,_).
pprint([G|_Groups],Values,Weights):-
	write(G), write("::"), 
	member(X,G),
	nth1(X,Values,N), 
	nth1(X,Weights,W), 
	write("("),write(N),write("-"),write(W), write(")"),write(","),
	fail.
	

pprint([_|Groups],Values,Nums):-
	nl, pprint(Groups,Values,Nums).
	
%%% The nth element of a list
nth1(1,[X|_],X).
nth1(N,[_|Rest],X):-
	N > 1,
	NN is N - 1,
	nth1(NN,Rest,X).
