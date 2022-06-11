-module(gol).
-export([mod/2, initialize/2, query/3, assign/4, setup/0, print/1, draw/1]).

-record(grid, {height=20, width=20, rows}).

mod(X,Y) ->
    if  (X > 0) -> X rem Y;
        (X < 0) -> Y + X rem Y;
        true -> 0
    end.

initialize(H, W) when (H > 0) and (W > 0) ->
    D1A = array:new(H),
    D2A = array:map(fun(_X, _T) -> array:new([{size, W}, {fixed, true}, {default, false}]) end, D1A),
    #grid{height=H, width=W, rows=D2A};
initialize(_,_) ->
    false.

query(G,X,Y) ->
    R = array:get(mod(Y, G#grid.height), G#grid.rows),
    array:get(mod(X, G#grid.width), R).

assign(G,X,Y,S) ->
    R = array:get(mod(Y, G#grid.height), G#grid.rows),
    CH = array:set(mod(X, G#grid.width), S, R),
    NA = array:set(mod(Y, G#grid.height), CH, G#grid.rows),
    G#grid{rows=NA}.

setup() ->
    G = initialize(10,10),
    G1 = assign(G,3,3,true),
    G2 = assign(G1, 4, 3, true),
    G3 = assign(G2, 5, 3, true),
    assign(G3, 4, 4, true).

print(G) ->
    HIndex = lists:seq(0, G#grid.height -1),
    RIndex = lists:seq(0, G#grid.width - 1),

    lists:foreach(fun(Y) ->

        io:format("| "),
        
        lists:foreach(fun(X) ->

                

            io:format("~s |", [draw(query(G, X, Y))])
            end,
            RIndex

            ),
        io:format(" | ~n")
    end, HIndex).

draw(VS) ->
    if VS =:= true -> 'x';
    true -> ' '
    end.