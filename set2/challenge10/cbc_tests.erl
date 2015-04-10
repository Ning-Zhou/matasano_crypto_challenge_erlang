-module(cbc_tests).
-include_lib("eunit/include/eunit.hrl").
-import(cbc, [inv_cipher/3, cipher/3]).

cipher_test()->
    {ok, CipherText} = file:read_file("10.txt"),
    CipherText1 = << <<X>> || <<X>> <= CipherText, <<X>> =/= <<"\n">>   >>,
    CipherText2 = base64:decode(CipherText1),
    Key = <<"YELLOW SUBMARINE">>,
    %%    inv_cipher(CipherText2, Key).
    PlainText = inv_cipher(CipherText2, Key, <<0:128>>),
    %% If you want to check the PlainText is correct uncomment following line
    %% file:write_file("solution_result.txt", PlainText),
    CipherTextToCheck = cipher(PlainText, Key, <<0:128>>),
    ?assertEqual(CipherText2, CipherTextToCheck).

