-module(solution_tests).
-include_lib("eunit/include/eunit.hrl").

transpose_binary_list_test()->
    KeysizeBinaryList = [<<"aeim">>,<<"bfjn">>,<<"cgko">>, <<"dhlp">>],
    TransposedBinaryList = solution:transpose_binary_list(KeysizeBinaryList),
    ?assertEqual([<<"abcd">>,<<"efgh">>,<<"ijkl">>,<<"mnop">>], TransposedBinaryList).

create_pair_list_test()->
    StrPairList = solution:create_pair_list([a,b,c,d]),
    ?assertEqual([{c,d},{b,c},{b,d},{a,b},{a,c},{a,d}],StrPairList).

hamming_d_test()->
    ?assertEqual(0.25, solution:hamming_d(<<2#11111111:16>>, <<2#1111:16>>)).

binary_to_keysize_binary_list_test() ->
    Keysize = 4,
    Binary = <<"abcdefghijklmn">>,
    ?assertEqual([<<"abcd">>, <<"efgh">>, <<"ijkl">>], solution:binary_to_keysize_binary_list(Keysize, Binary)).

average_hd_test()->
%    average_hd([16#ff, 16#ff, 16#fe, 16#fe]).
    ?assertEqual(0.5, solution:average_hd([<<2#1111000000000000:16>>, <<2#111100000000:16>>, <<2#11110000:16>> ,<<2#1111:16>>])).
