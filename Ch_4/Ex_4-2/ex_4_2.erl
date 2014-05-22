%% @author Jabari James <jsquared21@gmail.com>
%% jsquared, Inc., 2014.
%% @copyright 2014 by jsquared
%% @version 0.1
-module(ex_4_2).
-export([my_tuple_to_list/1, test/0]).

%% The BIF tuple_to_list(T) converts the elements of the tuple T 
%% to a list. Write a function called my_tuple_to_list(T) that 
%% does the same thing only not using the BIF that does this.
%% {dog, cat, rat} -> [dog, cat, rat]

my_tuple_to_list(T) ->
	N = size(T),
	Etest = fun(Tuple) -> (fun(X)-> element(X, Tuple) end) end,
	Element = Etest(T),
	[Element(X)||X <- lists:seq(1, N)].

test() -> 
	[dog,cat,rat,s,e,r,t,y,u,king,hat] = 
		my_tuple_to_list({dog,cat,rat,s,e,r,t,y,u,king,hat}),
	test_passed.