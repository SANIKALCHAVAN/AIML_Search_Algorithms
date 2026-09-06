
% =====================================================
% Problem Solving Through Search
% SWI-Prolog
% =====================================================

% ---------------- GRAPH ----------------

graph([
    [a,b,1],
    [a,c,4],
    [b,d,2],
    [b,e,5],
    [c,f,3],
    [d,g,1],
    [e,g,2],
    [f,g,1]
]).

neighbor(X,Y,C) :-
    graph(G),
    member([X,Y,C],G).


% =====================================================
% 1. BREADTH FIRST SEARCH
% =====================================================

bfs(Start,Goal,Path) :-
    bfs_queue([[Start]],Goal,Path).

bfs_queue([[Goal|Rest]|_],Goal,Path) :-
    reverse([Goal|Rest],Path).

bfs_queue([[Current|Rest]|Queue],Goal,Path) :-
    findall(
        [Next,Current|Rest],
        (
            neighbor(Current,Next,_),
            \+ member(Next,[Current|Rest])
        ),
        NewPaths
    ),
    append(Queue,NewPaths,NewQueue),
    bfs_queue(NewQueue,Goal,Path).


% =====================================================
% 2. DEPTH FIRST SEARCH
% =====================================================

dfs(Start,Goal,Path) :-
    dfs_search(Start,Goal,[Start],ReversePath),
    reverse(ReversePath,Path).

dfs_search(Goal,Goal,Path,Path).

dfs_search(Current,Goal,Visited,Path) :-
    neighbor(Current,Next,_),
    \+ member(Next,Visited),
    dfs_search(
        Next,
        Goal,
        [Next|Visited],
        Path
    ).


% =====================================================
% HEURISTIC VALUES
% =====================================================

heuristic(a,4).
heuristic(b,3).
heuristic(c,4).
heuristic(d,1).
heuristic(e,2).
heuristic(f,1).
heuristic(g,0).


% =====================================================
% 3. BEST FIRST SEARCH
% =====================================================

best_first(Start,Goal,Path) :-
    best_first_search([[Start]],Goal,ReversePath),
    reverse(ReversePath,Path).

best_first_search([[Goal|Rest]|_],Goal,[Goal|Rest]).

best_first_search(Paths,Goal,Result) :-
    choose_best(Paths,Best,Remaining),
    Best = [Current|_],

    findall(
        [Next|Best],
        (
            neighbor(Current,Next,_),
            \+ member(Next,Best)
        ),
        Children
    ),

    append(Remaining,Children,NewPaths),

    best_first_search(NewPaths,Goal,Result).


choose_best([First|Rest],Best,Others) :-
    First = [Node|_],
    heuristic(Node,H),
    choose_best(Rest,First,H,Best,Others).

choose_best([],Best,_,Best,[]).

choose_best(
    [Path|Rest],
    CurrentBest,
    CurrentH,
    Best,
    Others
) :-
    Path = [Node|_],
    heuristic(Node,H),

    (
        H < CurrentH
        ->
        choose_best(
            Rest,
            Path,
            H,
            Best,
            Temp
        ),
        Others = [CurrentBest|Temp]
        ;
        choose_best(
            Rest,
            CurrentBest,
            CurrentH,
            Best,
            Temp
        ),
        Others = [Path|Temp]
    ).


% =====================================================
% 4. A* SEARCH
% =====================================================

astar(Start,Goal,Path,Cost) :-
    astar_search(
        [node(Start,0,[Start])],
        Goal,
        ReversePath,
        Cost
    ),
    reverse(ReversePath,Path).

astar_search(
    [node(Goal,G,Path)|_],
    Goal,
    Path,
    G
).

astar_search(Open,Goal,Path,Cost) :-
    choose_best_node(Open,Best,Remaining),

    Best = node(Current,G,OldPath),

    findall(
        node(
            Next,
            NewG,
            [Next|OldPath]
        ),
        (
            neighbor(Current,Next,C),
            \+ member(Next,OldPath),
            NewG is G+C
        ),
        Children
    ),

    append(Remaining,Children,NewOpen),

    astar_search(
        NewOpen,
        Goal,
        Path,
        Cost
    ).


choose_best_node(
    [First|Rest],
    Best,
    Others
) :-
    node_f(First,F),
    choose_best_node(
        Rest,
        First,
        F,
        Best,
        Others
    ).

choose_best_node(
    [],
    Best,
    _,
    Best,
    []
).

choose_best_node(
    [Node|Rest],
    CurrentBest,
    CurrentF,
    Best,
    Others
) :-
    node_f(Node,F),

    (
        F < CurrentF
        ->
        choose_best_node(
            Rest,
            Node,
            F,
            Best,
            Temp
        ),
        Others = [CurrentBest|Temp]
        ;
        choose_best_node(
            Rest,
            CurrentBest,
            CurrentF,
            Best,
            Temp
        ),
        Others = [Node|Temp]
    ).

node_f(
    node(State,G,_),
    F
) :-
    heuristic(State,H),
    F is G+H.


% =====================================================
% 5. HILL CLIMBING
% =====================================================

hill_climbing(Start,Goal,Path) :-
    hill_climb(
        Start,
        Goal,
        [Start],
        ReversePath
    ),
    reverse(ReversePath,Path).

hill_climb(Goal,Goal,Path,Path).

hill_climb(
    Current,
    Goal,
    Visited,
    Path
) :-
    findall(
        Next-H,
        (
            neighbor(Current,Next,_),
            heuristic(Next,H),
            \+ member(Next,Visited)
        ),
        Candidates
    ),

    Candidates \= [],

    best_neighbor(
        Candidates,
        Next,
        NextH
    ),

    heuristic(Current,CurrentH),

    NextH < CurrentH,

    hill_climb(
        Next,
        Goal,
        [Next|Visited],
        Path
    ).

best_neighbor(
    [Next-H|Rest],
    BestNext,
    BestH
) :-
    best_neighbor(
        Rest,
        Next,
        H,
        BestNext,
        BestH
    ).

best_neighbor(
    [],
    BestNext,
    BestH,
    BestNext,
    BestH
).

best_neighbor(
    [Next-H|Rest],
    CurrentNext,
    CurrentH,
    BestNext,
    BestH
) :-
    (
        H < CurrentH
        ->
        best_neighbor(
            Rest,
            Next,
            H,
            BestNext,
            BestH
        )
        ;
        best_neighbor(
            Rest,
            CurrentNext,
            CurrentH,
            BestNext,
            BestH
        )
    ).


% =====================================================
% 6. CONSTRAINT SATISFACTION - N QUEENS
% =====================================================

nqueens(N,Solution) :-
    place_queens(
        1,
        N,
        [],
        Solution
    ).

place_queens(
    Row,
    N,
    Placed,
    Placed
) :-
    Row > N.

place_queens(
    Row,
    N,
    Placed,
    Solution
) :-
    Row =< N,
    between(1,N,Column),

    safe_position(
        Column,
        Row,
        Placed
    ),

    NextRow is Row+1,

    place_queens(
        NextRow,
        N,
        [Column-Row|Placed],
        Solution
    ).

safe_position(_,_,[]).

safe_position(
    Column,
    Row,
    [OldColumn-OldRow|Rest]
) :-
    Column =\= OldColumn,

    abs(Column-OldColumn)
    =\=
    abs(Row-OldRow),

    safe_position(
        Column,
        Row,
        Rest
    ).
%====================================================
% Graph Printing
%====================================================
print_graph :-
  graph(G),
    write('================================'),nl,
     write(' Problem Solving through Search'),nl,
     write('================================'),nl,
    write('Graph : '), 
    nl, 
    write(G), 
    nl.


% =====================================================
% DISPLAY ALL RESULTS
% =====================================================

run :-
    print_graph,
    nl,
    write('=============================='), nl,
    write('SEARCH ALGORITHMS'), nl,
    write('=============================='), nl,

    bfs(a,g,BFS),
    write('BFS              : '),
    write(BFS), nl,

    dfs(a,g,DFS),
    write('DFS              : '),
    write(DFS), nl,

    best_first(a,g,BestFirst),
    write('Best First Search: '),
    write(BestFirst), nl,

    astar(a,g,AStar,Cost),
    write('A* Search        : '),
    write(AStar),
    write(' Cost = '),
    write(Cost), nl,

    (
        hill_climbing(a,g,Hill)
        ->
        write('Hill Climbing    : '),
        write(Hill), nl
        ;
        write('Hill Climbing    : Failed'), nl
    ),

    nqueens(4,Queens),
    write('N-Queens          : '),
    write(Queens), nl,

    write('=============================='), nl.

