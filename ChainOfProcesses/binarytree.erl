-module(binarytree).
-export([create_tree/2, advanced_tree/2]).


%% Create root
%% Need to get tree depth
%% First root has  childs and so on

create_tree(Parent, 0) -> io:format("Parent Pid: ~p, My Pid: ~p, Depth = ~p ~n", [Parent, self(), 0]);
create_tree(Parent, Depth) ->
	receive
		create_branch ->
		Left = spawn(binarytree, create_tree, [self(), Depth - 1]),
		Right = spawn(binarytree, create_tree, [self(), Depth - 1]),
		io:format("Parent Pid: ~p, My Pid: ~p, Left Child: ~p, Right Child ~p, Depth = ~p~n", [Parent, self(), Left, Right, Depth]),
		Right ! create_branch,
		Left ! create_branch
	end,
create_tree(Parent, Depth).


%%advanced_tree(Parent, Number) ->
	%% Recoursive method for searching of course
	%% Right ! {compare, Nunber} not sure if Right process is made or not
		%% if made than what
		%% if not than you can call Parent ! create_branch
	%% If Right has value than call Right->Left ! compare and Right->Right ! compare
	
%% Starts binary creation and search for empty slot for current number
	





