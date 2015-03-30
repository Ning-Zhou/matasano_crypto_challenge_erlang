% To run tests:
% erl -make
% erl -noshell -eval "eunit:test(aes, [verbose])" -s init stop
%
-module(aes_tests).
-include_lib("eunit/include/eunit.hrl").
-import(aes, [add_round_key/2]).

add_round_key_test()->
    State = <<16#046681e5:32, 16#e0cb199a:32, 16#48f8d37a:32, 16#2806264c:32>>,
    Key = <<16#a0fafe17:32, 16#88542cb1:32, 16#23a33939:32, 16#2a6c7605:32>>,
    Output = add_round_key(State, Key),
    Expected = <<16#a49c7ff2:32, 16#689f352b:32, 16#6b5bea43:32, 16#26a5049:32>>,
    ?assertEqual(Expected, Output).
    
    
    




