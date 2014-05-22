%% @author Jabari James <jsquared21@gmail.com>
%% jsquared, Inc., 2014.
%% @copyright 2014 by jsquared
%% @version 0.1
-module(myfile).
-export([read/1]).

read(File) ->
		case file:read_file(File) of
			{ok, Bin}  -> Bin;
			{error, Why}  -> error({"read file error", Why})
		end.