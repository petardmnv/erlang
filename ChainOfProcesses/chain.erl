-module(chain).
-export ([loop/2, start/4, restart_count/2]).


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
			M = G + 1,
			io:format("I am ~p, Calculated M = ~p, going to Parent ~p~n", [self(), M, Parent]),
			Parent ! {calculate, M};
			
		Any -> Any
	end,
	loop(N, Parent).



start(NumberChilds, Parent, G, C) ->
	FirstChild = spawn(chain, loop, [NumberChilds, self()]),
	io:format("Start: My Parent: ~p, My pid ~p~n", [Parent, self()]),
	FirstChild ! create_child,
	
	receive
		{last_child, LastChildPid} -> 
			io:format("Start: My pid: ~p, Last Child Pid: ~p, sent to Parent pid: ~p~n", [self(), LastChildPid, Parent]),
			LastChildPid ! {calculate, G},
			restart_count(LastChildPid, C)
	end.


restart_count(_FirstChild, 1) -> 
	receive
		{calculate, M} ->
			N = M + 1,
			io:format("Origin N =~p, My Pid: ~p~n", [N, self()])
	end,
	io:format("My Pid: ~p and I stopped the summing chain.~n", [self()]);
restart_count(FirstChild, C) ->
	receive
		{calculate, M} ->
			N = M + 1,
			io:format("Origin N = ~p, My Pid: ~p~n", [N, self()]),
			FirstChild ! {calculate, N}
	end,
	restart_count(FirstChild, C-1).

	
%%_ - _ - _ - _ - _
%% new function which keeps start function alive that is the logic becouse we cant loop start function
	
%% Make calculations endless
%% Make calculations to be fixed by size like (50 loops)
%% Create binary tree for homework 5 level binary tree


%% Floler form processes - for homework remove nested message in teacher's code.

	

