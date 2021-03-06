-module(solution).
-export([test_base64/0, create_pair_list/1, hamming_d/2, binary_to_keysize_binary_list/2, average_hd/1, read_6_txt_into_a_bianry/0, solution/0, transpose_binary_list/1]).

-define(MIN_KEYSIZE, 2).
-define(MAX_KEYSIZE, 40).

% Read the file, strip the newline delimiter, keyword size range is 2 to 40, for lists:seq(2,20), we can calculate the average_hd, then choose the minimum of the list of average_hd returned values.
print(VariableName,Value)->
    io:format("~p: ~p~n",[VariableName,Value]).

solution()->
    Base64Binary = read_6_txt_into_a_bianry(),
    Binary = base64:decode(Base64Binary),

    Estimated_Keysize = estimate_keysize(Binary),
    %% io:format("Estimated_Keysize: ~p~n",[Estimated_Keysize]),
    PlainTextForEachKeyList = decipher_data_in_a_binary(Binary, Estimated_Keysize),

    PlainTextInKeySizeBinaryList = transpose_binary_list([decipher(X) || X <- PlainTextForEachKeyList]),
    %% transpose the list above, then we will get the plain text.

    PlainTextInKeySizeStringList = [binary_to_list(X)||X<-PlainTextInKeySizeBinaryList],

    PlainText = lists:flatten(PlainTextInKeySizeStringList),
    %% Plain_text = decipher(Binary, Estimated_Keysize),
    io:format("Plain_text: ~p~n",[PlainText]).


decipher_data_in_a_binary(Binary, Keysize)->
    %% Return Binary List with element size is keysize
    %% print("Keysize", Keysize),
    %% print("Binary", Binary),
    KeysizeBinaryList = binary_to_keysize_binary_list(Keysize, Binary),
    %% print("KeysizeBinaryList",KeysizeBinaryList),
    %% BinaryList is a list with size of keysize
    transpose_binary_list(KeysizeBinaryList).
    %% Estimate the key for each binary in BinaryList
    %% decipher(X) returns decipher binary

%% one_key_xor_decipher(Binary)->
    %% Binary is a ciphered text in form of binary. It's ciphered with one key in XOR operation

decipher(EncryptedBinary)->
    {_Estimated_Score, Estimated_Key} = estimate_key(EncryptedBinary),
    Estimated_String= decipher(EncryptedBinary, Estimated_Key),
    Estimated_String.

estimate_key(EncryptedBinary) ->
    estimate_key(EncryptedBinary, 0, {0, 0}).

estimate_key(_EncryptedBinary, 256, {Best_Score, Best_key})->
    %io:format(io:format("~p~n", [Best_Score])),
    {Best_Score, Best_key};
estimate_key(EncryptedBinary, Key, {Best_Score, Best_Key})->
    Deciphered_By_Key = decipher(EncryptedBinary, Key),
    Score = text_scoring(Deciphered_By_Key),
    {Best_Score1, Best_Key1} =
	case Score > Best_Score of
	    true -> {Score, Key};
	    false -> {Best_Score, Best_Key}
	end,
    estimate_key(EncryptedBinary, Key+1, {Best_Score1, Best_Key1}).

decipher(EncryptedBinary, Key) ->
    Length = byte_size(EncryptedBinary),
    Key_Binary = binary:copy(<<Key:8>>,Length),
    Size = Length*8,
    << Key_Int: Size >> = Key_Binary,
    << Encrypted_Int: Size >> = EncryptedBinary,
    Plain_Int = Encrypted_Int bxor Key_Int,
    <<Plain_Int:Size>>.

text_scoring(Text_Binary) ->
    {Score, _} = text_scoring(Text_Binary, 0, 0),
    Score.

text_scoring(<<>>, Num_Scored_Letters, Num_Letters) ->
    {Num_Scored_Letters, Num_Letters};
text_scoring(<<X:8, Rest_String/binary>>, Num_Scored_Letters, Num_Letters) ->
    Point = case lists:member(X, "etaoinshrdlu") of
%    Point = case lists:member(X, "abcdefghijklmnopqrstuvwxyz") of
		true -> 1;
		false -> 0
	    end,
    text_scoring(Rest_String, Num_Scored_Letters + Point, Num_Letters+1).



transpose_binary_list(KeysizeBinaryList)->
    transpose_binary_list(KeysizeBinaryList, byte_size(lists:nth(1, KeysizeBinaryList)), []).

transpose_binary_list(_KeysizeBinaryList, 0, TransposedList)->
    TransposedList;
transpose_binary_list(KeysizeBinaryList, RemainingBytes, TransposedList)->
    %% Get_ciphered_bytes_in_a_binary. Each byte is extracted from each binary in position of first byte of RemainingBytes
    Rowbinary = get_one_row_for_first_remainingbyte(KeysizeBinaryList, RemainingBytes),
    transpose_binary_list(KeysizeBinaryList, RemainingBytes-1, TransposedList ++ [Rowbinary]).

get_one_row_for_first_remainingbyte(KeysizeBinaryList, RemainingBytes) ->
    SampleKeysizeBinary = lists:nth(1, KeysizeBinaryList),
    Keysize = byte_size(SampleKeysizeBinary),
    UsedBits = (Keysize - RemainingBytes) * 8,
    BytesInList = [ ExtractedByte || <<_:UsedBits, ExtractedByte:8, _/binary>> <- KeysizeBinaryList],
    list_to_binary(BytesInList).

estimate_keysize(Binary)->
    Score_Keysize_List = [{keysize_score(X, Binary), X}||X <- lists:seq(?MIN_KEYSIZE, ?MAX_KEYSIZE)],
    {_Score, Keysize} = lists:min(Score_Keysize_List),
    Keysize.

keysize_score(Keysize, Binary)->
    BinaryList = binary_to_keysize_binary_list(Keysize, Binary),
    %% io:format("BinaryList: ~p~n",[BinaryList]),
    average_hd(BinaryList).


% Read the file, strip the newline delimiter, pack all data into a binary
read_6_txt_into_a_bianry() ->
    ReversedLines = read_lines("6.txt"),
    Lines = lists:reverse(ReversedLines),
    String = lists:flatten(Lines),
    erlang:list_to_binary(String).

read_lines(Filename) ->
    {ok, Device} = file:open(Filename, [read]),
    %% io:format("~p~n", [Device]),
    Lines = read_lines_from(Device),
    file:close(Device),
    Lines.

read_lines_from(FileDevice) ->
    read_lines_from(FileDevice, []).

read_lines_from(FileDevice, FullList) ->
    case file:read_line(FileDevice) of
	{ok, Data} -> %io:format("~p~n", [Data]),
	    Data1 = string:strip(Data, right, $\n),
	    read_lines_from(FileDevice, [Data1 | FullList]);
	eof        -> FullList
    end.

test_base64()->
    Str = "Hello, world!",
    Binary = erlang:list_to_binary(Str),
    io:format("~p~n",[Binary]),
    Base64Binary = base64:encode(Binary),
    io:format("~p~n",[Base64Binary]),
    Binary1 = base64:decode(Base64Binary),
    io:format("~p~n",[Binary1]).

% create tuple list without duplicate pair.
% [a, b, c, d] -> [{a,b}, {a,c}, {a,d}, {b,c}, {b,d}, {c,d}]
create_pair_list(List)->
    create_pair_list(List,[]).

create_pair_list([],PairList) ->
    PairList;
create_pair_list(List,PairList)->
    [H|L] = List,
    create_pair_list(L,[{H,X}||X<-L]++PairList).


hamming_d(BinaryA, BinaryB)->
    Bits = bit_size(BinaryA),
    <<IntA:Bits>> = BinaryA,
    <<IntB:Bits>> = BinaryB,
    count(IntA bxor IntB)/Bits. %% The bitpop count only takes 32 bit integer, need to adapt that.

count(A)->
    count(A, 0).

count(0, Bits)->
    Bits;
count(A, Accu_Bits) ->
    Bits = bitpop:count(A band 16#FFFFFFFF),
    count(A bsr 32, Accu_Bits+Bits).

average_hd(BinaryList)->
    BinaryPairList = create_pair_list(BinaryList),
    DistanceList = [hamming_d(X,Y)||{X,Y}<-BinaryPairList],
    lists:sum(DistanceList)/length(DistanceList).


binary_to_keysize_binary_list(Keysize, Binary) ->
    binary_to_keysize_binary_list(Keysize, Binary, []).

binary_to_keysize_binary_list(Keysize, Binary, KeysizeBinaryList)
  when byte_size(Binary) < Keysize ->
    KeysizeBinaryList;
binary_to_keysize_binary_list(Keysize, Binary, KeysizeBinaryList) ->
    <<KeysizeBinary:Keysize/binary, B/binary>> = Binary,
    binary_to_keysize_binary_list(Keysize, B, KeysizeBinaryList ++ [KeysizeBinary]).


