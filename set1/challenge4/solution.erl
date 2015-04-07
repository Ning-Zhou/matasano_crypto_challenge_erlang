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
    lists:reverse(read_lines_from(FileDevice, [])).

read_lines_from(FileDevice, Accu) ->
    case file:read_line(FileDevice) of
	{ok, Data} ->
	    %% io:format("~p~n", [Data]),
	    read_lines_from(FileDevice, [Data|Accu]);
	eof        -> Accu
    end.

decipher(EncryptedText)->
    {ok,[EncryptedInt], _} = io_lib:fread("~16u", EncryptedText),
    EncryptedBits = (length(EncryptedText) div 2) * 8,
    EncryptedBinary = <<EncryptedInt:EncryptedBits>>,
    {Estimated_Score, Estimated_Key} = best_guess_key(EncryptedBinary),
    Estimated_String= decipher(EncryptedBinary, Estimated_Key),

    {Estimated_Score, Estimated_Key, Estimated_String}.


best_guess_key(EncryptedBinary) ->
    best_guess_key(EncryptedBinary, 0, {0, 0}).

best_guess_key(_EncryptedBinary, 256, {Best_Score, Best_key})->
    %io:format(io:format("~p~n", [Best_Score])),
    {Best_Score, Best_key};
best_guess_key(EncryptedBinary, Key, {Best_Score, Best_Key})->
    Deciphered_By_Key = decipher(EncryptedBinary, Key),
    Score = text_scoring(Deciphered_By_Key),
    {Best_Score1, Best_Key1} =
	case Score > Best_Score of
	    true -> {Score, Key};
	    false -> {Best_Score, Best_Key}
	end,
    best_guess_key(EncryptedBinary, Key+1, {Best_Score1, Best_Key1}).


decipher(EncryptedBinary, Key) ->
    Length = byte_size(EncryptedBinary),
    Key_Binary = binary:copy(<<Key:8>>,Length),
    Size = Length*8,
    << Key_Int: Size >> = Key_Binary,
    << Encrypted_Int: Size >> = EncryptedBinary,
    Plain_Int = Encrypted_Int bxor Key_Int,
    <<Plain_Int:Size>>.

test_decipher()->
    Decipher_Binary = decipher(<<16#ffff:16>>, 16#ff),
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
