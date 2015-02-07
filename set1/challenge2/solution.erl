-module(solution).
-export([test_solution/0]).

hex_string_xor(Hex_StringA, Hex_StringB)->
    {ok,[NumA], _} = io_lib:fread("~16u", Hex_StringA),
    {ok,[NumB], _} = io_lib:fread("~16u", Hex_StringB),
    NumA bxor NumB.

test_solution()->
    Test_StringA = "1c0111001f010100061a024b53535009181c",
    Test_StringB = "686974207468652062756c6c277320657965",
    Output = hex_string_xor(Test_StringA, Test_StringB),
    io:format("~.16b~n", [Output]).

