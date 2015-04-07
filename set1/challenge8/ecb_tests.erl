-module(ecb_tests).
-include_lib("eunit/include/eunit.hrl").
-import(ecb, [is_ecb_cipher_binary/2, print/1]).

is_ecb_cipher_binary_test()->
    Input = "8a10247f90d0a05538888ad6205882196f5f6d05c21ec8dca0cb0be02c3f8b09e382963f443aa514daa501257b09a36bf8c4c392d8ca1bf4395f0d5f2542148c7e5ff22237969874bf66cb85357ef99956accf13ba1af36ca7a91a50533c4d89b7353f908c5a166774293b0bf6247391df69c87dacc4125a99ec417221b58170e633381e3847c6b1c28dda2913c011e13fc4406f88a10247f90d0a05538888ad620588219fe73bbf78e803e1d995ce4d",
    Input1 = list_to_integer(Input, 16),
    Size = length(Input)*4, 
    Input2 = <<Input1:Size>>,
    ?assertEqual(true, is_ecb_cipher_binary(Input2, 16)).

