-module(chllge11).
-export([solution/0]).

-define(BLOCK_SIZE, 16).

encryption_oracle(<<Bin/binary>>) ->
    {CipherText, _ } = encryption_oracle_with_key(Bin),
    CipherText.

encryption_oracle_with_Key(<<Bin/binary>>) ->
    BinSize = byte_size(Bin),
    Bin1 = case BinSize rem ?BLOCK_SIZE of 
	       0 -> Bin;
	       Rem -> pkcs:no_7_pad(Bin, BinSize+?BLOCK_SIZE-Rem)
	   end,
    Key = aes:generate_random_aes_key(),
    
    HeadCount = crypto:rand_uniform(5, 11),
    TailCount = crypto:rand_uniform(5, 11),
    Head = crypto:strong_rand_bytes(HeadCount),
    Tail = crypto:strong_rand_bytes(TailCount),

    CipherText = aes:cipher(<<Head/binary, Bin1/binary,Tail/binary>>,Key),

    {CipherText, Key}.
    
    
    
