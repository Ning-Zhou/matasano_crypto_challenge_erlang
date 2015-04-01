% To run tests:
% erl -make
% erl -noshell -eval "eunit:test(aes, [verbose])" -s init stop
%
-module(aes_tests).
-include_lib("eunit/include/eunit.hrl").
-import(aes, [add_round_key/2, shift_rows/1, rot_word/1, xtime/1, mix_column/1]).

add_round_key_test()->
    State = <<16#046681e5:32, 16#e0cb199a:32, 16#48f8d37a:32, 16#2806264c:32>>,
    Key = <<16#a0fafe17:32, 16#88542cb1:32, 16#23a33939:32, 16#2a6c7605:32>>,
    Output = add_round_key(State, Key),
    Expected = <<16#a49c7ff2:32, 16#689f352b:32, 16#6b5bea43:32, 16#26a5049:32>>,
    ?assertEqual(Expected, Output).
    
shift_rows_test()->
    State = <<16#d42711aee0bf98f1b8b45de51e415230:128>>,
    Output = shift_rows(State),
    Expected = <<16#d4bf5d30e0b452aeb84111f11e2798e5:128>>,
    ?assertEqual(Expected, Output). 

rot_word_test()->
    ?assertEqual(<<16#20304010:32>>,rot_word(<<16#10203040:32>>)).

xtime_test()->
    ?assertEqual(16#07, xtime(16#8e)).

mix_column_test()->
    State =    <<16#d4bf5d30e0b452aeb84111f11e2798e5:128>>,
    Expected = <<16#46681e5e0cb199a48f8d37a2806264c:128>>,
    ?assertEqual(Expected, mix_column(State)).

