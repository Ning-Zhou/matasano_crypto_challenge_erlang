-module(solution).
-export([test_base64/0, test_create_pair_list/0, test_hamming_d/0]).

test_base64()->
    Str = "Hello, world!",
    Binary = erlang:list_to_binary(Str),
    io:format("~p~n",[Binary]),
    Base64Binary = base64:encode(Binary),
    io:format("~p~n",[Base64Binary]),
    Binary1 = base64:decode(Base64Binary),
    io:format("~p~n",[Binary1]).


test_create_pair_list()->
    StrPairList = create_pair_list([<<"string1">>,<<"string2">>,<<"string3">>,<<"string4">>]),
    io:format("~p~n",[StrPairList]).

% create tuple list without duplicate pair. 
% [a, b, c, d] -> [{a,b}, {a,c}, {a,d}, {b,c}, {b,d}, {c,d}]
create_pair_list(List)->
    create_pair_list(List,[]).

create_pair_list([],PairList) ->
    PairList;
create_pair_list(List,PairList)->
    [H|L] = List,
    create_pair_list(L,[{H,X}||X<-L]++PairList).

test_hamming_d()->
    hamming_d(2#11111111, 2#1111)/8.

hamming_d(IntA, IntB)->
    bitpop:count(IntA bxor IntB).

test_average_hd()->
    average_hd([16#]).

average_hd(IntList)->
    IntPairList = create_pair_list(IntList),
    DistanceList = [hamming_d(X)||X<-IntPairList],
    lists:sum(DistanceList)/length(DistanceList).
