-module(hello).
-export ([start/1]).

start(Name) ->
	io:format("Hello ~p~n",[Name]).