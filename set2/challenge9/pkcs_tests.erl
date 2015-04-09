-module(pkcs_tests).
-include_lib("eunit/include/eunit.hrl").
-import(pkcs, [no_7_pad/2]).

no_7_pad_test()->
    ?assertEqual(<< <<"hello, world!">>/binary, 16#04040404040404:56 >>, no_7_pad(<<"hello, world!">>, 20)).
