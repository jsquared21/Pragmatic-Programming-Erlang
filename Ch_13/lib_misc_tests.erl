%% @author Jabari James <jabarimail@gmail.com>
%% jsquared, Inc., 2014.
%% @copyright 2014 by jsquared
%% @version 0.1

-module (lib_misc_tests).
-compile(export_all).

%% Ex:13-1.
test_my_spawn()->
	lib_misc:my_spawn(?MODULE,my_spawn_test_process,[]).

%% Ex:13-3.
test_my_spawn2() ->
	lib_misc:my_spawn(?MODULE,my_spawn_test_process2,[],10).

%% Ex:13-5.
test_restart_each()->
	List = [{?MODULE,test_abnormal2,[]},{?MODULE,test_normal2,[]},{?MODULE,test_shutdown2,[]}],
	lib_misc:restart_each(List).

%% Ex:13-6.
test_restart_all() ->
	% Swith List for to toggle between an abormal exit or a maunal shutdown.
	%List = [{?MODULE,test_loop,[]},{?MODULE,test_normal,[]},{?MODULE,test_shutdown,[]}],
	List = [{?MODULE,test_loop,[]},{?MODULE,test_normal,[]},{?MODULE,test_abnormal,[]}],
	lib_misc:restart_all(List).
	

%% Ex:13-1. Helper test porcess.
my_spawn_test_process() ->
	timer:sleep(10000),
	Self = self(),
	io:format("~p Exiting normally after 5 Secs.~n",[Self]),
		exit(reason).

%% Ex:13-3. Helper test porcess.
my_spawn_test_process2() ->
timer:sleep(5000),
	Self = self(),
	io:format("~p <- I'm still alive.~n",[Self]),
		my_spawn_test_process2().

%% Ex:13-5. Helper test porcesses.
test_abnormal2() ->
	timer:sleep(5000),
	Self = self(),
	io:format("~p Exiting abnormally.~n",[Self]),
		exit(reason).

test_normal2() ->
	timer:sleep(15000),
	Self = self(),
	io:format("~p Exiting normally.~n",[Self]),
		exit(normal).

test_shutdown2() ->
	timer:sleep(30000),
	Self = self(),
	io:format("~p Maunal shutdown.~n",[Self]),
		exit(shutdown).

%% Ex:13-6. Helper test porcesses.
test_loop() ->
	timer:sleep(5000),
	Self = self(),
	io:format("~p <- Same Pid until we all get killed and restarted.~n",[Self]),
		test_loop().

test_normal() ->
	timer:sleep(10000),
	Self = self(),
	io:format("~p Exiting normally, I will return only when we all restart.~n",[Self]),
		exit(normal).

test_abnormal() ->
	timer:sleep(25000),
	Self = self(),
	io:format("~p I'm a Worker processes that dies abnormally, I will kill everyone with me.~n",[Self]),
	exit(reason).

test_shutdown() ->
	timer:sleep(20000),
	Self = self(),
	io:format("~p I'm manually shutting down everything~n",[Self]),
		exit(shutdown).
