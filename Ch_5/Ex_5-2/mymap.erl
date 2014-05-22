-module(mymap).
-export([map_search_pred/2]).

%% Write a function map_search_pred(Map, Pred) that returns the 
%% first element {Key,Value} in the map for which Pred(Key, Value) 
%% is true.

map_search_pred(Map, Pred) -> 
	{_,Value} = maps:find(Pred,Map),
	{Pred,Value}.