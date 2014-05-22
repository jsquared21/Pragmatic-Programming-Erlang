%% @author Jabari James <jsquared21@gmail.com>
%% jsquared, Inc., 2014.
%% @copyright 2014 by jsquared
%% @version 0.1
-module(math_functions).
-export([even/1, odd/1, filter/2, split/1]).

%% Write a module called math_functions.erl, exporting the functions 
%% even/1 and odd/1. The function even(X) should return true if X is an 
%% even integer and otherwise false. odd(X) should return true if X is an 
%% odd integer.

even(X) -> X rem 2 == 0.
%even(X) when X rem 2 == 0 -> true;
%even(X) when X rem 2 =/= 0 -> false.

odd(X) -> X rem 2 =/= 0.

%% Add a higher-order function to math_functions.erl called filter(F, L), 
%% which returns all the elements X in L for which F(X) is true.

filter(F, L) -> [X||X <- L, F(X) =:= true].  

%% Add a function split(L) to math_functions.erl, which returns {Even, Odd} 
%% where Even is a list of all the even numbers in L and Odd is a list of 
%% all the odd numbers in L. Write this function in two different ways 
%% using accumulators and using the function filter you wrote in the 
%% previous exercise.

split(L) -> split(L, {[],[]}).
split([H|T],{Even, Odd}) ->
	case (H rem 2 =:= 0) of
		true -> split(T,{[H|Even],Odd});
		false -> split(T,{Even,[H|Odd]})
	end;
split([], {Even, Odd}) -> {lists:reverse(Even), lists:reverse(Odd)}.


