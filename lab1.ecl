%%% Constraint Logic Programming
%%% Prolog
%%% Lab 1
%%% The problem of proportions(IQ Test)


%%% figure/2
%%% figure(ID, PositionAndShapes)
figure(1, middle(triangle, square)).
figure(2, middle(circle, triangle)).
figure(3, middle(square, circle)).
figure(4, middle(square, square)).
figure(5, middle(square, triangle)).
figure(6, middle(triangle, circle)).
figure(7, middle(circle, square)).
figure(8, middle(triangle, triangle)).
figure(9, position(bottom, left)).
figure(10, position(top, left)).
figure(11, position(bottom, right)).
figure(12, position(top, right)).
figure(13, position(top, left)).
figure(14, position(bottom, left)).
figure(15, position(top, right)).
figure(16, position(bottom, right)).

%%% relation/3
%%% relation(Shape1, Shape2, Similarity)
relation(middle(S1,S2), middle(S2,S1), inverse).
relation(middle(S1,_), middle(S1,_), same_shape1).
relation(middle(_,S2), middle(_,S2), same_shape2).
relation(position(S1,_), position(S1,_), same_position_Y).
relation(position(_,S2), position(_,S2), same_position_X).
relation(position(S1,S2), position(S1,S2), same_position).

%%% analogy/4
%%% analogy(Shape1, Shape2, Shape3, Shape4)
analogy(S1,S2,S3,S4):-
    figure(S1,P1),
    figure(S2,P2),
    S1 \= S2,
    relation(P1,P2,S),
    figure(S3,P3),
    figure(S4,P4),
    S3 \= S4,
    relation(P3,P4,S).

