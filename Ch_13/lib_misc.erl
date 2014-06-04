%% @author Jabari James <jabarimail@gmail.com>
%% jsquared, Inc., 2014.
%% @copyright 2014 by jsquared
%% @version 0.1

-module(lib_misc).
-export ([my_spawn/3, my_keep_alive/2, my_spawn/4, running_restarter/0,
		restart_each/1, restart_all/1, on_exit/2, keep_alive/2, running/0]).
%-compile(export_all).

%% Ex:13-1.
%% Write a function my_spawn(Mod, Func, Args) that behaves like 
%% spawn(Mod, Func, Args) but with one difference. If the spawned
%% process dies, a message should be printed saying why the process 
%% died and how long the process lived for before it died.
my_spawn(Mod, Func, Args) ->
			process_flag(trap_exit, true),
			Pid = spawn_link(Mod, Func, Args),
			register(Mod, Pid),
			SpawnTime = time(),
			receive
				{'EXIT', Pid, Reason} ->
					print_details(Pid, Reason, SpawnTime)
			end.

print_details(Pid, Reason, SpawnTime) ->
	{SpawnHr, SpawnMin, SpawnSec} = SpawnTime,
	{EndHr, EndMin, EndSec} = time(),
	{Hour, Minute, Second} = {EndHr - SpawnHr, EndMin - SpawnMin, EndSec - SpawnSec},
	io:format("Process ~p died. Reason:~p. Process lifespan:~p:~p:~p~n",
		[Pid, Reason, Hour, Minute, Second]).
	
%% Ex:13-2. 
%% Solve the previous exercise using the on_exit function shown
%% earlier in this chapter.
my_keep_alive(Name, Fun) ->
register(Name, Pid = spawn_link(Fun)),
on_exit(Pid, fun(_Why) -> keep_alive(Name, Fun) end).
	
%% Ex:13-3. 
%% Write a function my_spawn(Mod, Func, Args, Time) that behaves like 
%% spawn(Mod, Func, Args) but with one difference. If the spawned 
%% process lives for more than Time seconds, it should be killed.
my_spawn(Mod, Func, Args, Time) ->
	spawn_link(Mod, Func, Args),
			receive
				_ -> ok
			after
				Time * 1000 -> exit(reason)
		end.

%% Ex:13-4. 
%% Write a function that creates a registered process that writes out
%% "I'm still running" every five seconds. Write a function that
%% monitors this process and restarts it if it dies. Start the global
%% process and the monitor process. Kill the global process and check
%% that it has been restarted by the monitor process.
running_restarter() ->
	process_flag(trap_exit, true),
	Pid = spawn_link(?MODULE, running, []),
	register(running, Pid),
	receive
		{'EXIT', Pid, normal} -> % not a crash
			ok;
		{'EXIT', Pid, shutdown} -> % manual termination, not crash
			ok;
		{'EXIT', Pid, _} ->
			running_restarter()
	end.

running() ->
	timer:sleep(5000),
	Self = self(),
	io:format("~p I'm still running~n",[Self]),
		exit(reason).

%% Ex:13-5. 
%% Write a function that starts and monitors several worker processes.
%% If any of the worker processes dies abnormally, restart it.
restart_each(List)->
	RPM =[{spawn_monitor(M,F,A),{M,F,A}}||{M,F,A} <- List],
	loop_rpm(RPM).

	loop_rpm(RPM) ->
		receive
			{'DOWN', Ref, process, Pid, normal} -> % not a crash
				UpdateRPM = delete_fun({Pid,Ref},RPM),
				loop_rpm(UpdateRPM);
			{'DOWN', _Ref, process,_Pid, shutdown} -> % manual termination not a crash
				ok;
			{'DOWN', Ref, process, Pid, _Why} ->
				 UpdateRPM = restart_fun({Pid,Ref},RPM),
				 %io:format("~p~n",[UpdateRPM]),
				 loop_rpm(UpdateRPM)
		end. 

restart_fun({Pid,Ref},RPM)->
	case lists:keysearch({Pid,Ref},1,RPM) of
		{value,{_,{M,F,A}}} ->
			NewRPM = lists:keydelete({Pid,Ref},1,RPM),
			NewPR = spawn_monitor(M,F,A),
			[{NewPR,{M,F,A}}|NewRPM];
		false ->
			RPM
	end.

delete_fun({Pid,Ref},RPM)->
	case lists:keysearch({Pid,Ref},1,RPM) =/= false of
		true ->
			lists:keydelete({Pid,Ref},1,RPM);
		false ->
			RPM
	end.


%% Ex:13-6.
%% Write a function that starts and monitors several worker processes.
%% If any of the worker processes dies abnormally, kill all the worker
%% processes and restart them all.
restart_all(List) ->
	process_flag(trap_exit, true),
		spawn_link(fun() -> [spawn_link(M,F,A)||{M,F,A} <- List],
			receive
				X -> X end end),
			receive
				{'EXIT', _Pid, normal} -> % not a crash
					ok;
				{'EXIT', _Pid, shutdown} -> % manual termination, not crash
					ok;
				{'EXIT', Pid, Reason} ->
					io:format("~p~p~nI'm the monitor. I will restart all processes~n",
						[Pid, Reason]),
					restart_all(List)
		end.	

on_exit(Pid, Fun)->
	spawn(fun() -> 
			Ref = monitor(process, Pid),
			receive
				{'DOWN',Ref, process, Pid, Why} ->
					Fun(Why)
			end
		end).

keep_alive(Name, Fun) ->
	register(Name, Pid = spawn(Fun)),
	on_exit(Pid, fun(_Why) -> keep_alive(Name, Fun) end).