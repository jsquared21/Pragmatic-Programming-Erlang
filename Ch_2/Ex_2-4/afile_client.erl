%% @author Jabari James <jabarimail@gmail.com>
%% jsquared, Inc., 2014.
%% @copyright 2014 by jsquared
%% @version 0.1
-module(afile_client).
-export ([ls/1, get_file/2, put_file/2]).

ls(Server) ->
	Server ! {self(), list_dir},
	receive
		{Server, FileList} ->
			FileList
	end.

get_file(Server, File) ->
	Server ! {self(), {get_file, File}},
	receive
		{Server, Content} ->
			Content
	end.

put_file(Server, File) ->
	Server ! {self(), {put_file, File}},
	receive
		{Server, Content} ->
			Content
	end.