% To run tests:
% erl -make
% erl -noshell -eval "eunit:test(aes, [verbose])" -s init stop
%
-module(aes_tests).
-include_lib("eunit/include/eunit.hrl").
-import(aes, [add_round_key/2, shift_rows/1, inv_shift_rows/1, rot_word/1, xtime/1, mix_column/1, inv_mix_column/1, s_table/2, inv_s_stable/2, sub_bytes/2]).

%% sub_bytes_test()->
%%     State = <<16#193de3bea0f4e22b9ac68d2ae9f84808:128>>,
%%     Expected = <<16#d42711aee0bf98f1b8b45de51e415230:128>>,
%%     ?assertEqual(Expected, sub_bytes(State)).

s_table_test()->
    ?assertEqual(16#63, s_table(1,1)),
    ?assertEqual(16#16, s_table(16,16)),
    ?assertEqual(16#8c, s_table(16,1)),
    ?assertEqual(16#76, s_table(1,16)).

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

inv_shift_rows_test()->
    State = <<16#d4bf5d30e0b452aeb84111f11e2798e5:128>>,
    Expected = <<16#d42711aee0bf98f1b8b45de51e415230:128>>,
    Output = inv_shift_rows(State),
    ?assertEqual(Expected, Output).

rot_word_test()->
    ?assertEqual(<<16#20304010:32>>,rot_word(<<16#10203040:32>>)).

xtime_test()->
    ?assertEqual(16#07, xtime(16#8e)).

mix_column_test()->
    State =    <<16#d4bf5d30e0b452aeb84111f11e2798e5:128>>,
    Expected = <<16#46681e5e0cb199a48f8d37a2806264c:128>>,
    ?assertEqual(Expected, mix_column(State)).

inv_mix_column_test()->
    Expected = <<16#d4bf5d30e0b452aeb84111f11e2798e5:128>>,
    State    = <<16#46681e5e0cb199a48f8d37a2806264c:128>>,
    ?assertEqual(Expected, inv_mix_column(State)).
