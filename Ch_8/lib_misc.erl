%% @author Jabari James <jabarimail@gmail.com>
%% jsquared, Inc., 2014.
%% @copyright 2014 by jsquared
%% @version 0.1
-module(lib_misc).
-export([sum/1]).
-export([most_funs/0, most_named/0, least_named/0, get_fun_count/1]).


sum(L) -> sum(L,0).
sum([], N) -> N;
sum([H|T],N) -> sum(T,H+N).

%% Ex:8-1.
%% Reread the section about Mod:module_info() in this chapter. Give 
%% the command dict:module_info(). How many functions does this 
%% module return?
get_fun_count(Mod) ->
	Funs = Mod:module_info(exports),
	FunsCount = length(Funs),
	io:format("Module ~w has ~p functions.~n",[Mod, FunsCount]).

%% Ex:8-2.
%% The command code:all_loaded() returns a list of {Mod,File} pairs of 
%% all modules that have been loaded into the Erlang system. Use the BIF 
%% Mod:module_info() to find out about these modules. Write functions to 
%% determine which module exports the most functions and which function 
%% name is the most common. Write a function to find all unambiguous 
%% function names, that is, function names that are used in only one 
%% module.
%% functions to determine which module exports the most functions.
most_funs() ->
	{Mods,Fun} = mod_fun_list(),
	Zip = fun(Y, X) -> lists:zip(Y,X) end,
	List =Zip(Mods, [Fun(X)||X <- Mods]), 
	ECount = [{X, length(E)}|| {X, E} <- List],
	{Mod, EPs} = mymax(ECount),
		io:format(
		"Module ~w exports the most functions with ~p functions.~n",
		[Mod, EPs]).

%% functions to determine which function name is the most common.
most_named() ->
	FunList = fun_list(),
	List = fun_count(FunList,[]),
	mymax(List).

%% function to find all unambiguous function names, that is, function 
%% names that are used in only one module.
least_named() ->
	FunList = fun_list(),
	List = fun_count(FunList,[]),
	[X||{X,Y} <-List, Y =:= 0].

%% helper functions.
mod_fun_list() ->
	L = code:all_loaded(),
	Mods = [Module||{Module,_} <- L],
	Fun = fun(X) -> X:module_info(exports) end,
	{Mods,Fun}.

fun_list() ->
	{Mods,Fun} = mod_fun_list(),
	lists:flatten([Fun(X)||X <- Mods]).

fun_count([],NewL) -> NewL;
fun_count(FunList,NewL) ->
	[H|T] = FunList,
	L = [X||X <- T, X == H],
	C = length(L),
		fun_count(T, [{H,C}| NewL]).

mymax([H|T]) -> mymax(T,H).
mymax([], Max) -> Max;
mymax([{_,Count} = H|Rest], {_,Count2} = Max) ->
	case Count > Count2 of
		true -> mymax(Rest, H);
		false -> mymax(Rest, Max)
	end.

