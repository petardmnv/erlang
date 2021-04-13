-module(chain).
-export ([loop/2, start/3]).


%% find flush function in erlang documentation
%% Shell -> P5 -> P4 -> ... -> P1
%% spawn(ring, loop, [])
%% 1. Create chain: 
	%% P5 = spawn(ring, loop, [])	
%% Send msg from P1 to Shell 

loop(0, Parent) -> Parent ! {last_child, Parent};
loop(N, Parent) ->
	receive
		create_child -> 
			Child = spawn(chain, loop, [N - 1, self()]),
			io:format("N: ~p, My Parent: ~p, My pid ~p, My child: ~p~n", [N, Parent, self(), Child]),
			Child ! create_child;
		{last_child, LastChildPid} -> 
			io:format("My pid: ~p, Last Child Pid: ~p, sent to Parent pid: ~p~n", [self(), LastChildPid, Parent]),
			Parent ! {last_child, LastChildPid};
			
		{calculate, G} ->
			M = G * 5,
			io:format("I am ~p, Calculated M = ~p~n", [self(), M]),
			Parent ! {calculate, M};
		Any -> Any
	end,
	loop(N, Parent).

	
start(NumberChilds, Parent, G) ->
	FirstChild = spawn(chain, loop, [NumberChilds, Parent]),
	FirstChild ! create_ child,
	
	receive
		{last_child, LastChildPid} ->
			LastChildPid ! {calculate, G}
	end.
	
%% Make calculations endless
%% Make calculations to be fixed by size like (50 loops)
%% Create binary tree for homework 5 level binary tree

	

