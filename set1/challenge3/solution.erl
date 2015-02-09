-module(solution).
-export([test_solution/0, test_decipher/0]).

test_solution()->
    io:format("~p~n", [text_scoring(<<"pppetaoinshrdlukkk">>)]).

text_scoring(Text_Binary) ->
    text_scoring(Text_Binary, 0, 0).

text_scoring(<<>>, Num_Scored_Letters, Num_Letters) ->
    {Num_Scored_Letters, Num_Letters};
text_scoring(<<X:8, Rest_String/binary>>, Num_Scored_Letters, Num_Letters) ->
    Point = case lists:member(X, "etaoinshrdlu") of
		true -> 1;
		false -> 0
	    end,
    text_scoring(Rest_String, Num_Scored_Letters + Point, Num_Letters+1).

%% solution()->
%%     Encrypted_Text = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736",
%%     {ok,[Encrypted_Int], _} = io_lib:fread("~16u", Encrypted_Text).
%%     Plain_Text = get_plain_text(Encrypted_Int, length(Encrypted_Text)/2).

%get_plain_text(Encrypted_Int, Length) ->
%best_guess_text(Encrypted_Text, Key, {Best_Score, Best_key})->


decipher(Encrypted_Int, Key, Length) ->
    Key_Binary = binary:copy(<<Key:8>>,Length),
    Size = Length*8,
    << Key_Int: Size >> = Key_Binary,
    Plain_Int = Encrypted_Int bxor Key_Int,
    <<Plain_Int:Size>>.

test_decipher()->
    Decipher_Binary = decipher(16#ffff, 16#ff, 2),
    io:format("~p", [Decipher_Binary]).

