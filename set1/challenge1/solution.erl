-module(solution).
-export([test_solution/0]).

hex_str_to_base64(Hex_String)->
    {ok,[Num], _} = io_lib:fread("~16u", Hex_String),
    A = binary:encode_unsigned(Num, big),
    base64:encode(A).

test_solution()->
    Test_String = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d",
    Output = hex_str_to_base64(Test_String),
    io:format("~p~n", [Output]).

