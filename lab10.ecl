%%% Constraint Logic Programming
%%% Prolog
%%% Lab 10
%%% ECLiPSe CLP Scheduling Constraints



%%% Include libraries
:-use_module(library(ic)).
:-use_module(library(ic_global)).
:-use_module(library(branch_and_bound)).
:-use_module(library(ic_edge_finder)).



%%% Exec 1

%%% museum/1
%%% museum(S)
%%% Return the start time of each visit
museum([Sa,Sb,Sc,Sd]):-
	[Sa,Sb,Sc,Sd] #:: 0..inf, 
	Sa + 2 #= Ea,
	Sb + 1 #= Eb,
	Sc + 2 #= Ec,
	Sd + 5 #= Ed,
	cumulative([Sa,Sb,Sc,Sd],[2,1,2,5],[60,30,50,40], 100),
	ic_global:maxlist([Ea,Eb,Ec,Ed],E),
	bb_min(labeling([Sa,Sb,Sc,Sd]),E,bb_options{strategy:restart}).
	
	

%%% Exec 2

%%% schedule_reads/1
%%% schedule_reads(Starts)
%%% Return the dates on which the study of each course should begin
schedule_reads(S):-
	S = [Sa,Sb,Sc,Sd], 
	S #:: 1..12,                                                        %%% Constraint: Students should start studing at 1st and finish before 12th day of month
	Ea #= Sa + 3,
    Eb #= Sb + 5,
	Ec #= Sc + 2,
	Ed #= Sd + 7,
	Ea #< 12,                                                           
	Eb #< 20,
	Ec #< 8,
	Ed #< 22,
	ic_global:maxlist([Ea,Eb,Ec,Ed],E),
	disjunctive(S,[3,5,2,7]),                                           %%% Constraint: Student can't study for two courses at the same time
	bb_min(labeling(S),E,bb_options{strategy:restart}).
	
	
	