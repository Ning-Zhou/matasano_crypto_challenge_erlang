-module(ecb).
-export([is_ecb_cipher_binary/2]).

is_member(SubBin, Bin) when bit_size(SubBin) > bit_size(Bin) -> false;
is_member(SubBin, Bin) ->
    SubSize = byte_size(SubBin),
    <<H:SubSize/binary, _T/bitstring>> = Bin,
    case H == SubBin of
	true -> %% print(H),
	    true;
	false -> <<_P:4, R/bitstring>> = Bin, is_member(SubBin, R)
    end.

is_ecb_cipher_binary(Bitstring, Ecbsize) when bit_size(Bitstring) < Ecbsize*16 -> false;
is_ecb_cipher_binary(Bitstring, EcbSize)->
    %% print(Bitstring),
    <<Head:EcbSize/binary, Tail/bitstring>> = Bitstring,
    case is_member(Head, Tail) of 
	true ->
	    true;
	false -> 
	    <<_P:4, T/bitstring>> = Bitstring,
	    is_ecb_cipher_binary(T, EcbSize)
    end.

%% print(Y)->
%%    io:format("~p~n", [Y]).
