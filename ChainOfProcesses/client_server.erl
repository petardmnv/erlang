-module(client_server).
-export([loop/1, start/1, rpc/2]).


rpc(Server, Request) ->
	Server ! {self(), Request},
	receive 
		{Server, X} -> 
			io:format("Message: ~p from Server: ~p~n", [X, Server]);
		_Any -> unknown_message
	end.

start(N) -> 
	spawn(client_server, loop, [N]).

loop(State) ->
	receive 
		{Client, X} -> 
			%%io:format("X: ~p~n", [X]),
			Client ! {self(), f1(X)},
			NewState = State + X;
			
		_Any -> 
			NewState = State
			
	end,
	%%io:format("NewState: ~p~n", [NewState]),
	loop(NewState).
	
	
f1(X) -> 
	X*X.
	
g1(X) ->
	nok.
