-module(solution).
-export([solution/0]).
solution()->
    {ok, CipherText} = file:read_file("7.txt"),
    %% io:format("~p~n",[CipherText]),
    CipherText1 = << <<X>> || <<X>> <= CipherText, <<X>> =/= <<"\n">>   >>,
    CipherText2 = base64:decode(CipherText1),
    %% io:format("~p~n",[CipherText2]),
    Key = <<"YELLOW SUBMARINE">>,
    %%    inv_cipher(CipherText2, Key).
    PlainText = inv_cipher(CipherText2, Key),
    PlainText1 = binary_to_list(PlainText), 
    %%  io:format("~p~n",[PlainText]).
    [io:format("~p~n",[[X]])||X <- PlainText1].

inv_cipher(CipherText, Key)->
    ExpandedKey = aes:key_expansion(Key),
    inv_cipher_body(CipherText, ExpandedKey, <<>>).

inv_cipher_body(CipherText, _, Accu) when byte_size(CipherText) < 16 -> Accu;
inv_cipher_body(<<Head:16/binary, T/binary>>, ExpandedKey, Accu) ->
    PlainText = aes:inv_cipher(Head, ExpandedKey),
    inv_cipher_body(T, ExpandedKey, <<Accu/binary, PlainText/binary>>).




















