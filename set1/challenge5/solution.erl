-module(solution).
-export([test_solution/0]).

print_binary_to_hex_string(Binary)->
    Size = byte_size(Binary)*8,
    << Int: Size >> = Binary,
    [HexString]= io_lib:fwrite("~.16B",[Int]),
    io:format("~p~n",[HexString]).

binary_repeat_key_xor(Binary, Key)->
    Bytes = byte_size(Binary),
    ByteK = byte_size(Key),
    NumK = Bytes div ByteK,
    BytesR = Bytes rem ByteK,
    BinaryH = binary:copy(Key, NumK),
    BitT = BytesR*8,
    <<BinaryT:BitT, _/binary>> = Key,
    XorBinary = <<BinaryH/binary, BinaryT:BitT>>,
    Bits = Bytes*8,
    <<XorInt:Bits>> = XorBinary,
    <<BinaryInt:Bits>> = Binary,
    IntXored = XorInt bxor BinaryInt,
    <<IntXored:Bits>>.


test_solution()->
    solution().

solution()->
    PlainString = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal",
    PlainBinary = erlang:list_to_binary(PlainString),
    KeyString = "ICE",
    KeyBinary = erlang:list_to_binary(KeyString),
    XoredBinary = binary_repeat_key_xor(PlainBinary, KeyBinary),
    print_binary_to_hex_string(XoredBinary).    
