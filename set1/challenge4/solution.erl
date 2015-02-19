-module(solution).
-export([test_solution/0]).

test_solution()->
    io:format("~p~n", [solution()]).


solution()->
    Lines = read_lines("4.txt"),
    Evaluations = [decipher(string:strip(X, both, $\n))||X<-Lines],
    
    Scores = [Score || {Score,_,_} <- Evaluations],
    Max_Score = lists:max(Scores),
    io:format("~p~n", [Max_Score]),
    lists:keyfind(Max_Score, 1, Evaluations).



read_lines(Filename) ->
    {ok, Device} = file:open(Filename, [read]),
    % io:format("~p~n", [Device]),
    Lines = read_lines_from(Device),
    file:close(Device),
    Lines.
    
read_lines_from(FileDevice) ->
        case file:read_line(FileDevice) of
	    {ok, Data} ->
		    %io:format("~p~n", [Data]),
		[Data | read_lines_from(FileDevice)];
	    eof        -> []
    end.



decipher(Encrypted_Text)->
    {ok,[Encrypted_Int], _} = io_lib:fread("~16u", Encrypted_Text),
    {Estimated_Score, Estimated_Key} = best_guess_key(Encrypted_Int, length(Encrypted_Text) div 2),
    Estimated_String= decipher(Encrypted_Int, Estimated_Key, length(Encrypted_Text) div 2),

    {Estimated_Score, Estimated_Key, Estimated_String}.


best_guess_key(Encrypted_Int, Length) ->
    best_guess_key(Encrypted_Int, Length, 0, {0, 0}).

best_guess_key(_Encrypted_Int, _Length, 256, {Best_Score, Best_key})-> 
    %io:format(io:format("~p~n", [Best_Score])),
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

text_scoring(Text_Binary) ->
    {Score, _} = text_scoring(Text_Binary, 0, 0),
    Score.

text_scoring(<<>>, Num_Scored_Letters, Num_Letters) ->
    {Num_Scored_Letters, Num_Letters};
text_scoring(<<X:8, Rest_String/binary>>, Num_Scored_Letters, Num_Letters) ->
%    Point = case lists:member(X, "etaoinshrdlu") of
    Point = case lists:member(X, "abcdefghijklmnopqrstuvwxyz") of
		true -> 1;
		false -> 0
	    end,
    text_scoring(Rest_String, Num_Scored_Letters + Point, Num_Letters+1).
