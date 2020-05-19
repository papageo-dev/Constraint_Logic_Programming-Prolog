%%% Constraint Logic Programming
%%% Prolog
%%% Lab 9
%%% ECLiPSe Constraints 
%%% Limit: element/3 and Search: branch_and_bound



%%% Include libraries
:-use_module(library(ic)).
:-use_module(library(ic_global)).
:-use_module(library(branch_and_bound)).
:-use_module(library(ic_edge_finder)).


%%% Exec1 

%%% worker(Id, Jobs, Cost)
worker(1,[4,1,3,5,6],[30,8,30,20,10]). 
worker(2,[6,3,5,2,4],[140,20,70,10,90]). 
worker(3,[8,4,5,7,10],[60,80,10,20,30]). 
worker(4,[3,7,8,9,1],[30,40,10,70,10]). 
worker(5,[7,1,5,6,4],[40,10,30,20,10]). 
worker(6,[8,4,7,9,5],[20,100,130,220,50]). 
worker(7,[5,6,7,4,10],[30,30,30,20,10]). 
worker(8,[2,6,10,8,3],[50,40,20,10,60]). 
worker(9,[1,3,10,9,6],[50,40,10,20,30]). 
worker(10,[1,2,7,9,3],[20,20,30,40,50]). 

%%% solveWorkers/2
%%% solveWorkers(Jobs,Cost)
%%% Return job for each worker with the lowest possible cost
solveWorkers(Jobs,Cost):-
    findall(W,worker(W,_,_),Workers),                 %%% Find worker's Id([1,2,3...10])
    constrain_workers(Workers,Jobs,Costs),            %%% Find Jobs and costs for all Workers
    ic_global:alldifferent(Jobs),                     %%% Different Job for any Worker
    sumlist(Costs,Cost),
    bb_min(labeling(Jobs),Cost,_).
    
constrain_workers([],[],[]).
constrain_workers([W|Rest], [J|Jobs], [C|Costs]):-
    worker(W,ListJobs,ListCosts),
    element(I,ListJobs,J),
    element(I,ListCosts,C),
    constrain_workers(Rest,Jobs,Costs).


%%% Exec 2

%%% num_gen_min/3
%%% num_gen_min(N1, N2, D)
%%% Return the remaining digits([N1,N2..M3]) for the lower difference in numbers
num_gen_min([N1,5,N2,N3,3],[M1,M2,0,M3,1], Diff):-
	[N1,N2,N3,M1,M2,M3] #:: [0..9],
	ic:alldifferent([N1,N2,N3,M1,M2,M3,5,3,0,1]),
	Num1 #= 10000 * N1 + 5 * 1000 + 100 * N2 + 10 * N3 + 3,
	Num2 #= 10000 * M1 + 1000 * M2 + 100 * 0 + 10 * M3 + 1,
	Diff #= abs(Num1 - Num2),
	bb_min(labeling([N1,N2,N3,M1,M2,M3]),Diff,_).


%%% Exec 3

student(alex,[4,1,3,5,6]).
student(nick,[6,3,5,2,4]).
student(jack,[8,4,5,7,10]).
student(helen,[3,7,8,9,1]).
student(maria,[7,1,5,6,4]).
student(evita,[8,4,7,9,5]).
student(jacky,[5,6,7,4,10]).
student(peter,[2,6,10,8,3]).
student(john,[1,3,10,9,6]).
student(mary,[1,6,7,9,10]).

%%% solveStudents/2  
%%% solveStudents(Stds,Cost)
%%% Return best assignment(lower cost) of dissertations to students, by their choices
solveStudents(Stds,Cost):-
	collect_students(Stds),
	state_constraints(Stds,Theses,Cost),
        bb_min(labeling(Theses),Cost,_).

%%% collecting the number of students.
collect_students(Stds):-
	findall((S,_),student(S,_),Stds).
	
%%% Stating the constraints
alloc_constraints([],[],0).
alloc_constraints([(X,Thesis)|Rest],[Thesis|RestThesis],TotalCost):-
	student(X,Prefs),
	Thesis::Prefs,
	element(Cost,Prefs,Thesis),
	alloc_constraints(Rest,RestThesis,RCost),
	TotalCost #= Cost + RCost.

state_constraints(Students,Theses,Cost):-
	alloc_constraints(Students,Theses,Cost),
	ic_global:alldifferent(Theses).
	
	
%%% Exec 4

%%% box(Id,Weights)
box(1,140).
box(2,200).
box(3,450).
box(4,700).
box(5,120).
box(6,300).
box(7,250).
box(8,125).
box(9,600).
box(10,650).

%%% load_trucks/4
%%% load_trucks(Truck1,Load1,Truck2,Load2)
%%% Find which boxes should each truck carry and the total weight of the boxes, for as much as possible their payload
load_trucks(Truck1,Load1,Truck2,Load2):-
	
        findall(W,box(_,W), Weights),
	length(Truck1,3),
	length(Truck2,4),

	assignBoxes(Truck1,Weights,Load1),
	Load1 #=< 1200,
			
	assignBoxes(Truck2,Weights,Load2),
	Load2 #=< 1350,

	append(Truck1,Truck2,Trucks),
	ic_global:alldifferent(Trucks),
	
	Load #= 2550 - (Load1 + Load2),
        bb_min(labeling(Trucks),Load,bb_options{strategy:restart}).


assignBoxes([],_,0).
assignBoxes([Box|Rest],Weights,W):-
        element(Box,Weights,WBox),
	assignBoxes(Rest,Weights,RW), 
	W #= RW + WBox.	
	
	
%%% Exec 5
	
%%% provider(Name,Capacity,Price)
provider(a,[0,750,1000,1500],[0,10,13,17]).
provider(b,[0,500,1250,2000],[0,8,12,22]).
provider(c,[0,1000,1750,2000],[0,15,18,25]).
provider(d,[0,1000,1500,1750],[0,13,15,17]).

%%% space/2
%%% space(Capacities,Cost)
%%% Return capacities from providers for lower total cost
space(Capacities,Cost):-
    findall(P,provider(P,_,_),Providers),            %%% Find providers's Id([1,2,3...10])
    constrain_providers(Providers,Capacities,Costs), %%% Find Capacities and Costs for all Providers
	sumlist(Capacities,Total),											  
	sumlist(Costs,Cost), 
	Total #> 3600,
	Total #< 4600,
    bb_min(labeling(Capacities),Cost,_).             %%% Find the optimal solution, with lower cost
    
constrain_providers([],[],[]).
constrain_providers([P|Rest], [Cap|Capacities], [C|Costs]):-
    provider(P,ListCapacities,ListCosts),
    element(I,ListCapacities,Cap),
    element(I,ListCosts,C),
    constrain_providers(Rest,Capacities,Costs).
	
	
%%% Exec 6

%%% antennas/3
%%% antennas(N, Max, L)
%%% Return antennas positions(L) and the minimum distance(Max) between them
antennas(N,Max,[0|Ruler]):-
	NN is N - 1,
	length(Ruler,NN),
	UpperLimit is 2^N,
	Ruler #:: 1..UpperLimit,
	ordered(<,Ruler),
	differences([0|Ruler],Diffs),
	append([D1|_], [Dn], Diffs),
	D1 #< Dn,
	ic_global:alldifferent(Diffs),
	ic_global:maxlist(Ruler,Max),
	bb_min(labeling(Ruler),Max, bb_options{strategy:continue}).

differences([],[]).
differences([Var|Rest],Diffs):-
	diffs(Var,Rest,D),
	differences(Rest,RestDiffs),
	append(D,RestDiffs,Diffs).


diffs(_,[],[]).
diffs(Var,[X|Rest],[D|RestD]):-
	X - Var #= D,
	diffs(Var,Rest,RestD).