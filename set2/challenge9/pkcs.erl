-module(pkcs).
-export([no_7_pad/2]).

no_7_pad(Bin, Size)->
    BinSize = byte_size(Bin),
    case BinSize >= Size of 
	true ->
	    Bin;
	false -> 
	    PadSize = Size - BinSize,
	    PaddedBin = binary:copy(<<4:8>>, PadSize),
	    <<Bin/binary, PaddedBin/binary>>
    end.      
