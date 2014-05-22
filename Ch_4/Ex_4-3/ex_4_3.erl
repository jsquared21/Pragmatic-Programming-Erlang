%% @author Jabari James <jabarimail@gmail.com>
%% jsquared, Inc., 2014.
%% @copyright 2014 by jsquared
%% @version 0.1
-module(ex_4_3).
-export([my_time_func/1, my_date_string/0]).

%% Look up the definitions of erlang:now/0, erlang:date/0, and 
%% erlang:time/0. Write a function called my_time_func(F), which 
%% evaluates the fun F and times how long it takes. 

my_time_func(F) ->
	{Start_MegaSecs, Start_Secs, Start_MicroSecs} = now(),
	F,
	{End_MegaSecs, End_Secs, End_MicroSecs} = now(),
	{End_MegaSecs - Start_MegaSecs, 
	End_Secs - Start_Secs, 
	End_MicroSecs - Start_MicroSecs}.

%% Write a function called my_date_string() that neatly formats 
%% the current date and time of day.

my_date_string() ->
	{Yr, Mth, Day} = date(),
	{Hr, Min, _} = time(),
	US_Hr = us_format(Hr),
	case Min < 10 of
		true ->
			io:format("Date: ~p/~p/~p~nTime: ~p:0~p~n",
				[Mth,Day,Yr,US_Hr,Min]);
		_ ->
			io:format("Date: ~p/~p/~p~nTime: ~p:~p~n",
				[Mth,Day,Yr,US_Hr,Min])
	end.

us_format(Hr) when Hr > 12 -> Hr - 12;
us_format(Hr) -> Hr.
	
