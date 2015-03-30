-module(aes).
-export([add_round_key/2]).

add_round_key(State, Key)->
    <<State1:128>>=State,
    <<Key1:128>>=Key,
    Output = Key1 bxor State1,
    <<Output:128>>.
