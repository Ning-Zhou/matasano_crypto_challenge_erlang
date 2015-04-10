-module(cbc).
-export([ inv_cipher/3, cipher/3]).

inv_cipher(CipherText, Key, IV)->
    ExpandedKey = aes:key_expansion(Key),
    inv_cipher_body(CipherText, ExpandedKey, IV, <<>>).

inv_cipher_body(CipherText, _ , _, Accu) when byte_size(CipherText) < 16 -> Accu;
inv_cipher_body(<<Head:16/binary, T/binary>>, ExpandedKey, IV, Accu) ->

    PlainText = aes:inv_cipher(Head, ExpandedKey),
    PlainText1 = binary_xor(PlainText, IV),
    inv_cipher_body(T, ExpandedKey, Head, <<Accu/binary, PlainText1/binary>>).

cipher(CipherText, Key, IV)->
    ExpandedKey = aes:key_expansion(Key),
    cipher_body(CipherText, ExpandedKey, IV, <<>>).

cipher_body(CipherText, _ , _, Accu) when byte_size(CipherText) < 16 -> Accu;
cipher_body(<<Head:16/binary, T/binary>>, ExpandedKey, IV, Accu) ->
    
    PlainText = binary_xor(Head, IV),
    CipherText = aes:cipher(PlainText, ExpandedKey),
    cipher_body(T, ExpandedKey, CipherText, <<Accu/binary, CipherText/binary>>).

binary_xor(A, B)->
    BitSizeA = bit_size(A),
    BitSizeB = bit_size(B),
    <<IntA:BitSizeA>> = A,
    <<IntB:BitSizeB>> = B,
    IntC = IntA bxor IntB,
    <<IntC:BitSizeB>>.
