-module(solution).
-export([test_base64/0, test_create_pair_list/0, test_hamming_d/0, test_binary_to_keysize_binary_list/0, test_average_hd/0]).

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
    hamming_d(<<2#11111111:16>>, <<2#1111:16>>).

hamming_d(BinaryA, BinaryB)->
    Bits = bit_size(BinaryA),
    <<IntA:Bits>> = BinaryA,
    <<IntB:Bits>> = BinaryB,
    bitpop:count(IntA bxor IntB)/Bits.

test_average_hd()->
%    average_hd([16#ff, 16#ff, 16#fe, 16#fe]).
    average_hd([16#1, 16#1, 16#0, 16#0]).

average_hd(BinaryList)->
    BinaryPairList = create_pair_list(BinaryList),
    DistanceList = [hamming_d(X,Y)||{X,Y}<-BinaryPairList],
    lists:sum(DistanceList)/length(DistanceList).

test_binary_to_keysize_binary_list() ->
    Keysize = 4,
    Binary = <<"abcdefghijklmn">>,
    io:format("~p~n",[binary_to_keysize_binary_list(Keysize,Binary,[])]).


binary_to_keysize_binary_list(Keysize, Binary, KeysizeBinaryList)
  when byte_size(Binary) < Keysize ->
    KeysizeBinaryList;
binary_to_keysize_binary_list(Keysize, Binary, KeysizeBinaryList) ->
    <<KeysizeBinary:Keysize/binary, B/binary>> = Binary,
    binary_to_keysize_binary_list(Keysize, B, [KeysizeBinary|KeysizeBinaryList]).

