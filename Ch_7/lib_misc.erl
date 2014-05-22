%% @author Jabari James <jabarimail@gmail.com>
%% jsquared, Inc., 2014.
%% @copyright 2014 by jsquared
%% @version 0.1
-module(lib_misc).
-export([rev_bytes/1,rev_bytes_bitcomp/1]).
-export([term_to_packet/1, packet_to_term/1]).
-export([test/0]).
-export([rev_bits/1]).

%% Ex:7-1 
%% Write a function that reverses the order of bytes in a binary.

rev_bytes(Binary) ->
	List = binary_to_list(Binary),
	Rev = lists:reverse(List),
	list_to_binary(Rev).

%% Ex:7-1.
%% Bit comprehension version.
rev_bytes_bitcomp(Binary) ->
	List = [ X || <<X>> <= Binary ],
	Rev = fun(X) -> lists:reverse(X) end, 
	<< <<X>> || X <- Rev(List) >>.
	%<< <<X>> || X <- Rev([X|| <<X>> <= Binary ]) >>.

%% Ex:7-2.
%% Write a function term_to_packet(Term) -> Packet that returns a 
%% binary consisting of a 4-byte length header N followed by N 
%% bytes of data produced by calling term_to_binary(Term).
%% 8*4 = 32.
term_to_packet(Term) ->
	Bin = term_to_binary(Term),
	Size = byte_size(Bin),
	<<Size:32, Bin/binary>>.

%% Ex: 7-3.
%% Write the inverse function packet_to_term(Packet) ->Term that 
%% is the inverse of the previous function. 
packet_to_term(<<_H:32, Rest/binary>>) ->
	binary_to_term(Rest).

%% Ex:7-4.
%% Tests on Ex:7-2 and Ex:7-3.
test() ->
Packet = <<0,0,0,24,131,108,0,0,0,1,104,1,107,0,12,72,101,108,108,
			111,32,87,111,114,108,100,49,106>>,
Term = [{"Hello World1"}],
Packet = term_to_packet(Term),
Term = packet_to_term(Packet),
{test_passed}.

%% Ex7-5.
%% Write a function to reverse the bits in a binary.
rev_bits(Binary) ->
	List = [ X || <<X:1>> <= Binary ],
	Rev = fun(X) -> lists:reverse(X) end, 
	<< <<X:1>> || X <- Rev(List) >>.
	%<< <<X:1>> || X <- Rev([ X || <<X:1>> <= Binary ]) >>.
