-module(solution).
-export([test_solution/0, test_decipher/0]).

test_solution()->
    io:format("~p~n", [solution()]).

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

solution()->
    Encrypted_Text = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736",
    {ok,[Encrypted_Int], _} = io_lib:fread("~16u", Encrypted_Text),
    {_Best_Score, Best_Key} = best_guess_key(Encrypted_Int, length(Encrypted_Text) div 2),
    decipher(Encrypted_Int, Best_Key, length(Encrypted_Text) div 2).



best_guess_key(Encrypted_Int, Length) ->
    best_guess_key(Encrypted_Int, Length, 0, {0, 0}).

best_guess_key(_Encrypted_Int, _Length, 256, {Best_Score, Best_key})-> 
    {Best_Score, Best_key};
best_guess_key(Encrypted_Int, Length, Key, {Best_Score, Best_Key})->
    Deciphered_By_Key = decipher(Encrypted_Int, Key, Length),
    Score = text_scoring(Deciphered_By_Key),
    {Best_Score1, Best_Key1} = 
	case Score > Best_Score of 
	    true -> {Score, Key};
	    false -> {Best_Score, Best_Key}
	end,
    best_guess_key(Encrypted_Int, Length, Key+1, {Best_Score1, Best_Key1}).
    

decipher(Encrypted_Int, Key, Length) ->
    Key_Binary = binary:copy(<<Key:8>>,Length),
    Size = Length*8,
    << Key_Int: Size >> = Key_Binary,
    Plain_Int = Encrypted_Int bxor Key_Int,
    <<Plain_Int:Size>>.

test_decipher()->
    Decipher_Binary = decipher(16#ffff, 16#ff, 2),
    io:format("~p", [Decipher_Binary]).

