%% @author Jabari James <jabarimail@gmail.com>
%% jsquared, Inc., 2014.
%% @copyright 2014 by jsquared
%% @version 0.1

-module(ring).
-export ([start/3]).

%% Ex:12-3.
%% Write a ring benchmark. Create N processes in a ring. Send a
%% message round the ring M times so that a total of N * M messages
%% get sent. Time how long this takes for different values of N and
%% M.
start(N, M, Message) when N > 1 ->
    statistics(wall_clock),
	spawn(fun() -> ring(N-1, M, Message) end).

	

ring(N, M, Message) when M > 0 ->
	Fun = fun(_, P) -> spawn(fun() -> loop(P) end) end,
	Pid = lists:foldl(Fun, self(), lists:seq(1, N)),
	trace(Pid, Message),
    Pid ! {message, Message},
    loop(Pid, M).



loop(Pid) ->
    receive
        {message, Message} ->
            trace(Pid, Message),
            Pid ! {message, Message},
            loop(Pid);
        stop ->
            Pid ! stop
    end.

loop(Pid, M) ->
    	case M =:= 1 of
    		true ->
                stats(),
    			Pid ! stop; 
    		false -> 
    		receive
    			{message, Message} ->
            	trace(Pid, Message),
            	Pid ! {message, Message},
            	loop(Pid, M-1)
            end
    	end.

trace(Pid, Message) -> io:format("~p -> ~p: ~p~n", [self(), Pid, Message]).

stats() ->
	{_, Time1} = statistics(wall_clock),
	io:format("Ring took: ~p microseconds.~n",
		[Time1]).
