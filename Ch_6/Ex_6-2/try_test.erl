%% @author Jabari James <jsquared21@gmail.com>
%% jsquared, Inc., 2014.
%% @copyright 2014 by jsquared
%% @version 0.1
-module(try_test).
-compile(export_all).

generate_execption(1) -> a;
generate_execption(2) -> throw(a);
generate_execption(3) -> exit(a);
generate_execption(4) -> {'EXIT', a};
generate_execption(5) -> error(a).

demo1() ->
	[catcher(I)||I <- [1,2,3,4,5]].

demo2() ->
	[{I, (catch generate_execption(I))}||I <- [1,2,3,4,5]].

demo3() ->
	try generate_execption(5)
	catch
		error:X -> log_file({X, erlang:get_stacktrace()}),
					client_log()
	end.

catcher(N) ->
	try generate_execption(N) of
		Val -> {N, normal, Val}
	catch
		throw:X -> 
			log_file({N, caught, thrown, X}),
			client_log();
		exit:X -> 
			log_file({N, caught, exited, X}),
			client_log();
		error:X -> 
			log_file({N, caught, error, X}),
			client_log()
	end.

client_log() ->
	io:format("Oops! Wrong input, please try agian.~n").

log_file(Log) ->
	case file:read_file_info(try_test_log) of
		{error, enoent} ->
			file:write_file(try_test_log,
					io_lib:fwrite("TimeStamp: ~p.\nError: ~p.\n\n", 
									[now(),Log]));
		{ok, _FileInfo} ->
			file:write_file(try_test_log,
					io_lib:fwrite("TimeStamp: ~p.\nError: ~p.\n\n", 
									[now(),Log]),
					[append])
	end.
