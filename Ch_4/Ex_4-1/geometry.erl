%% @author Jabari James <jabarimail@gmail.com>
%% jsquared, Inc., 2014.
%% @copyright 2014 by jsquared
%% @version 0.1
-module(geometry).
-export([area/1, test/0, perimeter/1]).

%% Added clauses to compute the areas of circles and rightangled
%% triangles. Added clauses for computing the perimeters of 
%% different geometric objects.

area({rectangle, Width, Height}) -> Width * Height;
area({square, Side}) -> Side * Side;
area({circle, Radius}) -> math:pi() * math:pow(Radius,2);
area({triangle, Base, Height}) -> 1/2 * Base * Height.

perimeter({rectangle, Width, Height}) -> (2 * Width) + (2 * Height);
perimeter({square, Side}) -> 4 * Side;
perimeter({circle, Radius}) -> 2 * math:pi() * Radius;
perimeter({triangle, SideA, SideB, SideC}) -> SideA + SideB + SideC.

test() ->
	12 = area({rectangle, 3, 4}),
	4  = area({square, 2}),
	28.274333882308138 = area({circle, 3}),
	10.0 = area({triangle, 4, 5}),
	18.84955592153876 = perimeter({circle,3}),
	20 = perimeter({rectangle, 4, 6}),
	36 = perimeter({square, 9}),
	16 = perimeter({triangle, 4, 5, 7}),
	test_passed.