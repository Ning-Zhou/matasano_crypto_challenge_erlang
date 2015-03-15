-module(solution_tests).
-include_lib("eunit/include/eunit.hrl").

transpose_binary_list_test()->
    KeysizeBinaryList = [<<"aeim">>,<<"bfjn">>,<<"cgko">>, <<"dhlp">>],
    TransposedBinaryList = solution:transpose_binary_list(KeysizeBinaryList),
    ?assertEqual([<<"abcd">>,<<"efgh">>,<<"ijkl">>,<<"mnop">>], TransposedBinaryList).

create_pair_list_test()->
    StrPairList = solution:create_pair_list([a,b,c,d]),
    ?assertEqual([{c,d},{b,c},{b,d},{a,b},{a,c},{a,d}],StrPairList).
