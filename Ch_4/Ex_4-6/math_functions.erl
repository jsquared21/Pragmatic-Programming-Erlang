%% @author Jabari James <jsquared21@gmail.com>
%% jsquared, Inc., 2014.
%% @copyright 2014 by jsquared
%% @version 0.1
-module(math_functions).
-export([even/1, odd/1, filter/2]).

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