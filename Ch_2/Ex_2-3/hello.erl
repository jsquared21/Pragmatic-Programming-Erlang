%% @author Jabari James <jabarimail@gmail.com>
%% jsquared, Inc., 2014.
%% @copyright 2014 by jsquared
%% @version 0.1
-module(hello).
-export ([start/1]).

start(Name) ->
	io:format("Hello ~p~n",[Name]).