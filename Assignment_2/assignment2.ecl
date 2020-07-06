%%% Constraint Logic Programming
%%% Prolog
%%% Coursework 2 - 2020
%%% ECLiPSe Constraints 
%%% Constraint Satisfaction



%%% Include libraries
:-lib(ic).
:-lib(ic_global).
:-lib(branch_and_bound).
:-lib(ic_edge_finder).



%%% Exec 1

%%% split_check/3
%%% split_check(OriginalSum,Value1,Value2)
%%% Succeeds if Value1 + Value 2 = OriginalSum and 
%%% numbers Value1 and Value2 do not contain any digits.
split_check(OriginalSum,Value1,Value2):-
	number_of_digits(OriginalSum,Len),
	% numbers consist of digits. The maximum 
	% number of digits is the number of digits of the 
	% Original Sum.
	length(Digits1,Len),
	length(Digits2,Len),
	append(Digits1,Digits2,Digits),
	Digits #:: [0..3,5..9],
	% Evaluate a sequence of digits as an integer.
	evaluate(Digits1,Value1),
	evaluate(Digits2,Value2),
	Value1 #>0, Value2 #> 0, 
	Value1 + Value2 #= OriginalSum,
	% labeling on the digits.
	labeling(Digits).
 
%%% evaluate/2
%%% evaluate(Digits,Value)
%%% Succeeds if Value is the integer formed by the 
%%% sequence of Digits.
evaluate(Digits,Value):-
	evaluate(Digits,_,Value).

%%% evaluate/3
%%% Auxiliary predicate to evaluate/2
%%% The second argument is the position of the digit.
evaluate([],0,0).
evaluate([D|RestD],Exp,Value):-
	evaluate(RestD,RExp,RestValue),
	Exp is RExp + 1,
	F is (10^RExp),
	Value #= D * F + RestValue.

%%% number_of_digits/2
%%% number_of_digits(Number,Digits)
%%% Succeeds if Digits is the number (length) of integer 
%%% Number
number_of_digits(Number,Digits):-
	number_string(Number,Str),
	string_length(Str,Digits).
	


%%% Exec2

%%% Backup(Type,releaseDate,Duration,Bandwidth)
backup(db,srv_d1, 0, 5, 10).
backup(db,srv_d2, 2, 8, 18).
backup(db,srv_d3, 0, 4, 11).
backup(web,srv_w1, 0, 7, 8).
backup(web,srv_w2, 3, 11, 10).

%%% Succeeds by return the minimum total duration(M) of all backup tasks.
schedule_backups(db(StartTimesDB),web(StartTimesWEB),TotalDuration):-
	constraints_on(db,StartTimesDB,DurationsBD,EndTimesBD,CapacityDB),
	constraints_on(web,StartTimesWEB,DurationsWEB,EndTimesWEB,CapacityWEB),
	append(StartTimesDB,StartTimesWEB,StartTimes),
	append(DurationsBD,DurationsWEB,Durations),
	append(EndTimesBD,EndTimesWEB,EndTimes),
	append(CapacityDB,CapacityWEB,Capacity),
	cumulative(StartTimes,Durations,Capacity,25),
	ic_global:maxlist(EndTimes,TotalDuration),
	bb_min(labeling(StartTimes),TotalDuration,_).

%%% constraints_on/5
%%% constraints_on(ServerType,StartTimes,Durations,EndTimes,Capacities)
%%% Succeeds by collecting all infromation on a specific server type
%%% and then creating decision (constraint variables) and all the related 
%%% constraints.
constraints_on(ServerType,StartTimes,Durations,EndTimes,Capacities):-
	% collect Names for the specific server type
	findall(Names,backup(ServerType,Names,_,_,_),ToBackNameList),
	% impose release Date, End times and collect Capacity constraints.
	impose_constraints(ToBackNameList,StartTimes,Durations,EndTimes,Capacities),
	% servers cannot be backed-up simultaneously.
	disjunctive(StartTimes,Durations). 

%%% impose_constraints/5
%%% impose_constraints(Names,StartTimes,Durations,EndTimes,Capacity)
%%% Succeeds by imposing Start, End time constraints, etc.
impose_constraints([],[],[],[],[]).
impose_constraints([Name|Names],[ST|StartTimes],[D|Durations],[E|EndTimes],[C|Capacity]):-
	backup(_,Name,Release,D,C),
	ST #< 100, %%% can be changed and an upper limit can be set.
	ST #>=Release,
	E #= ST + D,
	impose_constraints(Names,StartTimes,Durations,EndTimes,Capacity).



%%%% Exec 3

%%% arrange_list/2
%%% arrange_list(Len,Arrange)
%%% Succeeds of Arrange is a list of length Len, such that 
%%% each number in the list is a hop to the next position,
%%% such that starting from the 1st poistion the hop cycle 
%%% returns to 1 (last hop is 1).
arrange_list(Len,Arrange):-
	length(Arrange,Len),
	length(Nexts,Len),
	Arrange #:: [1..Len],
        % next models the hop.
	% hops should be different OR you get cycles, 
        % i.e. ensures that all positions are visited.
	Nexts #:: [1..Len],
	ic_global:alldifferent(Arrange),
	ic_global:alldifferent(Nexts),
	loop(1,Arrange,Nexts),
	append(Nexts,Arrange,AllVars),
	% for completeness, we label all vars
	labeling(AllVars).

%%% loop/3
%%% loop(Position,List,NextHops)
loop(Position,Arrange,[1]):-
	element(Position,Arrange,1),
	!.

loop(Position,Arrange,[Next|RestNext]):-
	element(Position,Arrange,Next),
	abs(Position - Next) #> 2, 
	loop(Next,Arrange,RestNext).




	
