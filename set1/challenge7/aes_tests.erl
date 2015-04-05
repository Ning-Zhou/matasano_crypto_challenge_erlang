% To run tests:
% erl -make
% erl -noshell -eval "eunit:test(aes, [verbose])" -s init stop
%
-module(aes_tests).
-include_lib("eunit/include/eunit.hrl").
-import(aes, [add_round_key/2, shift_rows/1, inv_shift_rows/1, rot_word/1, xtime/1, mix_column/1, inv_mix_column/1, s_table/2, inv_s_stable/2, sub_bytes/1, key_expansion/1]).
print(X)->
    io:format("~p~n",[X]).

key_expansion_test()->
    Key1 = <<16#2b7e151628aed2a6abf7158809cf4f3c:128>>,
    Expected1 = <<16#2B7E151628AED2A6ABF7158809CF4F3CA0FAFE1788542CB123A339392A6C7605F2C295F27A96B9435935807A7359F67F3D80477D4716FE3E1E237E446D7A883BEF44A541A8525B7FB671253BDB0BAD00D4D1C6F87C839D87CAF2B8BC11F915BC6D88A37A110B3EFDDBF98641CA0093FD4E54F70E5F5FC9F384A64FB24EA6DC4FEAD27321B58DBAD2312BF5607F8D292FAC7766F319FADC2128D12941575C006ED014F9A8C9EE2589E13F0CC8B6630CA6:(32*44)>>,
    ?assertEqual(Expected1, key_expansion(Key1)),

    Key2 = <<16#8e73b0f7da0e6452c810f32b809079e562f8ead2522c6b7b:(32*6)>>,
    Expected2 = <<16#8e73b0f7da0e6452c810f32b809079e562f8ead2522c6b7bfe0c91f72402f5a5ec12068e6c827f6b0e7a95b95c56fec24db7b4bd69b5411885a74796e92538fde75fad44bb095386485af05721efb14fa448f6d94d6dce24aa326360113b30e6a25e7ed583b1cf9a27f939436a94f767c0a69407d19da4e1ec1786eb6fa64971485f703222cb8755e26d135233f0b7b340beeb282f18a2596747d26b458c553ea7e1466c9411f1df821f750aad07d753ca4005388fcc5006282d166abc3ce7b5e98ba06f448c773c8ecc720401002202:(32*52)>>,
    ?assertEqual(Expected2, key_expansion(Key2)),

    Key3 = <<16#603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4:(32*8)>>,
    Expected3 = <<16#603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff49ba354118e6925afa51a8b5f2067fcdea8b09c1a93d194cdbe49846eb75d5b9ad59aecb85bf3c917fee94248de8ebe96b5a9328a2678a647983122292f6c79b3812c81addadf48ba24360af2fab8b46498c5bfc9bebd198e268c3ba709e0421468007bacb2df331696e939e46c518d80c814e20476a9fb8a5025c02d59c58239de1369676ccc5a71fa2563959674ee155886ca5d2e2f31d77e0af1fa27cf73c3749c47ab18501ddae2757e4f7401905acafaaae3e4d59b349adf6acebd10190dfe4890d1e6188d0b046df344706c631e:(32*60)>>,
    ?assertEqual(Expected3, key_expansion(Key3)).



sub_bytes_test()->
    State = <<16#193de3bea0f4e22b9ac68d2ae9f84808:128>>,
    Expected = <<16#d42711aee0bf98f1b8b45de51e415230:128>>,
    ?assertEqual(Expected, sub_bytes(State)).

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
