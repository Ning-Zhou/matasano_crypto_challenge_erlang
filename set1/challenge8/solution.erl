-module(solution).
-export([solution/0]).

solution()->
    Lines = read_lines("8.txt"),
    [io:format(Line ++ " is the ecb cipher text.\n") || Line <- Lines, is_ecb_cipher_text(Line)].

is_ecb_cipher_text(Line)->
    %% io:format(Line),
    Int = list_to_integer(Line, 16),
    Size = length(Line)*4, 
    Binary = <<Int:Size>>,
    ecb:is_ecb_cipher_binary(Binary, 16).

read_lines(Filename) ->
    {ok, Device} = file:open(Filename, [read]),
    %% io:format("~p~n", [Device]),
    Lines = read_lines_from(Device),
    file:close(Device),
    Lines.

read_lines_from(FileDevice) ->
    lists:reverse(read_lines_from(FileDevice, [])).

read_lines_from(FileDevice, Accu) ->
    case file:read_line(FileDevice) of
	{ok, Data} ->
	    %% io:format("~p~n", [Data]),
	    read_lines_from(FileDevice, [string:strip(Data, right, $\n)|Accu]);
	eof        -> Accu
    end.






