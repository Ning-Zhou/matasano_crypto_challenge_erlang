-module(chllge11).
-export([solution/0]).

-define(BLOCK_SIZE, 16).

encryption_oracle(<<Bin/binary>>) ->
    {CipherText, _ } = encryption_oracle_with_key(Bin),
    CipherText.

encryption_oracle_with_Key(<<PlainText/binary>>) ->


    HeadCount = crypto:rand_uniform(5, 11),
    TailCount = crypto:rand_uniform(5, 11),
    Head = crypto:strong_rand_bytes(HeadCount),
    Tail = crypto:strong_rand_bytes(TailCount),

    PlainText1 = <<Head/binary, PlainText/binary, Tail/binary>>
    PlaiTextByteSize = byte_size(PlainText1),

    PlainText2 = case PlainTextByteSize rem ?BLOCK_SIZE of 
	       0 -> PlainText1;
	       Rem -> pkcs:no_7_pad(PlainText1, PlainTextByteSize+?BLOCK_SIZE-Rem)
	   end,
    Key = aes:generate_random_aes_key(),
    
    %% Decide run with ECB or CBC
    
    %% For ECB, the function should repeat calling aes:cipher

    %% For CBC, the function should repeat calling cbc:cipher(PlainText, Key, IV)

    
    CipherText = aes:cipher(PlainText2,Key),

    {CipherText, Key}.
    
    
    
