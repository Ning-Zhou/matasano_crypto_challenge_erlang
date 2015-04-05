-module(aes).
-export([add_round_key/2, shift_rows/1, inv_shift_rows/1, rot_word/1, xtime/1, mix_column/1, inv_mix_column/1, s_table/2, sub_bytes/1, key_expansion/1]).

print(Y)->
    io:format("<<~s>>~n", [[io_lib:format("~2.16.0B ",[X]) || <<X:8>> <= Y ]]).

key_expansion(<<Key:16/binary>>) -> key_expansion(Key, 4, 4);
key_expansion(<<Key:24/binary>>) -> key_expansion(Key, 6, 6);
key_expansion(<<Key:32/binary>>) -> key_expansion(Key, 8, 8).

key_expansion(Key, 4, 44)-> Key;
key_expansion(Key, 6, 52)-> Key;
key_expansion(Key, 8, 60)-> Key;
key_expansion(Key, Nk, I_1) when I_1 rem Nk == 0 ->
    IntervalSize = (Nk - 2)*4,
    HeadSize = (I_1 - Nk)*4,
    <<_Head:HeadSize/binary, Word_I_Nk:32, _Interval:IntervalSize/binary, Temp:4/binary>> = Key,
    <<Temp2_1:32>> = sub_bytes(rot_word(Temp)),
    <<Temp2_2:32>> = r_con(I_1 div Nk),
    Temp2 = Temp2_1 bxor Temp2_2,
    NewWord = Word_I_Nk bxor Temp2,
    key_expansion(<<Key/binary, NewWord:32>>, Nk, I_1 + 1);
key_expansion(Key, 8, I_1) when I_1 rem 8 == 4 ->
    HeadSize = (I_1 - 8)*4,
    <<_Head:HeadSize/binary, Word_I_Nk:32, _Interval:24/binary, Temp:4/binary>> = Key,
    <<Temp2:32>> = sub_bytes(Temp),
    NewWord = Word_I_Nk bxor Temp2,
    key_expansion(<<Key/binary, NewWord:32>>, 8, I_1 + 1);
key_expansion(Key, Nk, I_1) ->
    IntervalSize = (Nk - 2)*4,
    HeadSize = (I_1 - Nk)*4,
    <<_Head:HeadSize/binary, Word_I_Nk:32, _Interval:IntervalSize/binary, Temp:32>> = Key,
    NewWord = Word_I_Nk bxor Temp,
    key_expansion(<<Key/binary, NewWord:32>>, Nk, I_1 + 1).

r_con(X) -> r_con(X, 1).
r_con(1, Accu) -> <<Accu, 0, 0, 0>>;
r_con(X, Accu) -> r_con(X-1, xtime(Accu)).

sub_bytes(State)->
    sub_bytes(State, <<>>).

sub_bytes(<<>>, Accu)-> Accu;
sub_bytes(<<X:4, Y:4, T/binary>>, Accu)->
    sub_bytes(T, <<Accu/binary, (s_table(X+1, Y+1))>>).

s_table(X, Y)->
    T = [[16#63, 16#7C, 16#77, 16#7B, 16#F2, 16#6B, 16#6F, 16#C5, 16#30, 16#01, 16#67, 16#2B, 16#FE, 16#D7, 16#AB, 16#76],
	 [16#CA, 16#82, 16#C9, 16#7D, 16#FA, 16#59, 16#47, 16#F0, 16#AD, 16#D4, 16#A2, 16#AF, 16#9C, 16#A4, 16#72, 16#C0],
	 [16#B7, 16#FD, 16#93, 16#26, 16#36, 16#3F, 16#F7, 16#CC, 16#34, 16#A5, 16#E5, 16#F1, 16#71, 16#D8, 16#31, 16#15],
	 [16#04, 16#C7, 16#23, 16#C3, 16#18, 16#96, 16#05, 16#9A, 16#07, 16#12, 16#80, 16#E2, 16#EB, 16#27, 16#B2, 16#75],
	 [16#09, 16#83, 16#2C, 16#1A, 16#1B, 16#6E, 16#5A, 16#A0, 16#52, 16#3B, 16#D6, 16#B3, 16#29, 16#E3, 16#2F, 16#84],
	 [16#53, 16#D1, 16#00, 16#ED, 16#20, 16#FC, 16#B1, 16#5B, 16#6A, 16#CB, 16#BE, 16#39, 16#4A, 16#4C, 16#58, 16#CF],
	 [16#D0, 16#EF, 16#AA, 16#FB, 16#43, 16#4D, 16#33, 16#85, 16#45, 16#F9, 16#02, 16#7F, 16#50, 16#3C, 16#9F, 16#A8],
	 [16#51, 16#A3, 16#40, 16#8F, 16#92, 16#9D, 16#38, 16#F5, 16#BC, 16#B6, 16#DA, 16#21, 16#10, 16#FF, 16#F3, 16#D2],
	 [16#CD, 16#0C, 16#13, 16#EC, 16#5F, 16#97, 16#44, 16#17, 16#C4, 16#A7, 16#7E, 16#3D, 16#64, 16#5D, 16#19, 16#73],
	 [16#60, 16#81, 16#4F, 16#DC, 16#22, 16#2A, 16#90, 16#88, 16#46, 16#EE, 16#B8, 16#14, 16#DE, 16#5E, 16#0B, 16#DB],
	 [16#E0, 16#32, 16#3A, 16#0A, 16#49, 16#06, 16#24, 16#5C, 16#C2, 16#D3, 16#AC, 16#62, 16#91, 16#95, 16#E4, 16#79],
	 [16#E7, 16#C8, 16#37, 16#6D, 16#8D, 16#D5, 16#4E, 16#A9, 16#6C, 16#56, 16#F4, 16#EA, 16#65, 16#7A, 16#AE, 16#08],
	 [16#BA, 16#78, 16#25, 16#2E, 16#1C, 16#A6, 16#B4, 16#C6, 16#E8, 16#DD, 16#74, 16#1F, 16#4B, 16#BD, 16#8B, 16#8A],
	 [16#70, 16#3E, 16#B5, 16#66, 16#48, 16#03, 16#F6, 16#0E, 16#61, 16#35, 16#57, 16#B9, 16#86, 16#C1, 16#1D, 16#9E],
	 [16#E1, 16#F8, 16#98, 16#11, 16#69, 16#D9, 16#8E, 16#94, 16#9B, 16#1E, 16#87, 16#E9, 16#CE, 16#55, 16#28, 16#DF],
	 [16#8C, 16#A1, 16#89, 16#0D, 16#BF, 16#E6, 16#42, 16#68, 16#41, 16#99, 16#2D, 16#0F, 16#B0, 16#54, 16#BB, 16#16]],
    lists:nth(Y,lists:nth(X,T)).

inv_s_table(X, Y)->
    T = [[16#52, 16#09, 16#6A, 16#D5, 16#30, 16#36, 16#A5, 16#38, 16#BF, 16#40, 16#A3, 16#9E, 16#81, 16#F3, 16#D7, 16#FB],
	 [16#7C, 16#E3, 16#39, 16#82, 16#9B, 16#2F, 16#FF, 16#87, 16#34, 16#8E, 16#43, 16#44, 16#C4, 16#DE, 16#E9, 16#CB],
	 [16#54, 16#7B, 16#94, 16#32, 16#A6, 16#C2, 16#23, 16#3D, 16#EE, 16#4C, 16#95, 16#0B, 16#42, 16#FA, 16#C3, 16#4E],
	 [16#08, 16#2E, 16#A1, 16#66, 16#28, 16#D9, 16#24, 16#B2, 16#76, 16#5B, 16#A2, 16#49, 16#6D, 16#8B, 16#D1, 16#25],
	 [16#72, 16#F8, 16#F6, 16#64, 16#86, 16#68, 16#98, 16#16, 16#D4, 16#A4, 16#5C, 16#CC, 16#5D, 16#65, 16#B6, 16#92],
	 [16#6C, 16#70, 16#48, 16#50, 16#FD, 16#ED, 16#B9, 16#DA, 16#5E, 16#15, 16#46, 16#57, 16#A7, 16#8D, 16#9D, 16#84],
	 [16#90, 16#D8, 16#AB, 16#00, 16#8C, 16#BC, 16#D3, 16#0A, 16#F7, 16#E4, 16#58, 16#05, 16#B8, 16#B3, 16#45, 16#06],
	 [16#D0, 16#2C, 16#1E, 16#8F, 16#CA, 16#3F, 16#0F, 16#02, 16#C1, 16#AF, 16#BD, 16#03, 16#01, 16#13, 16#8A, 16#6B],
	 [16#3A, 16#91, 16#11, 16#41, 16#4F, 16#67, 16#DC, 16#EA, 16#97, 16#F2, 16#CF, 16#CE, 16#F0, 16#B4, 16#E6, 16#73],
	 [16#96, 16#AC, 16#74, 16#22, 16#E7, 16#AD, 16#35, 16#85, 16#E2, 16#F9, 16#37, 16#E8, 16#1C, 16#75, 16#DF, 16#6E],
	 [16#47, 16#F1, 16#1A, 16#71, 16#1D, 16#29, 16#C5, 16#89, 16#6F, 16#B7, 16#62, 16#0E, 16#AA, 16#18, 16#BE, 16#1B],
	 [16#FC, 16#56, 16#3E, 16#4B, 16#C6, 16#D2, 16#79, 16#20, 16#9A, 16#DB, 16#C0, 16#FE, 16#78, 16#CD, 16#5A, 16#F4],
	 [16#1F, 16#DD, 16#A8, 16#33, 16#88, 16#07, 16#C7, 16#31, 16#B1, 16#12, 16#10, 16#59, 16#27, 16#80, 16#EC, 16#5F],
	 [16#60, 16#51, 16#7F, 16#A9, 16#19, 16#B5, 16#4A, 16#0D, 16#2D, 16#E5, 16#7A, 16#9F, 16#93, 16#C9, 16#9C, 16#EF],
	 [16#A0, 16#E0, 16#3B, 16#4D, 16#AE, 16#2A, 16#F5, 16#B0, 16#C8, 16#EB, 16#BB, 16#3C, 16#83, 16#53, 16#99, 16#61],
	 [16#17, 16#2B, 16#04, 16#7E, 16#BA, 16#77, 16#D6, 16#26, 16#E1, 16#69, 16#14, 16#63, 16#55, 16#21, 16#0C, 16#7D]],
    lists:nth(Y,lists:nth(X,T)).



xtime(Y)->
    Y1 = Y bsl 1,
    case (Y1 bsr 8) of
	0 -> Y1;
	_ -> Y1 bxor 16#11b
    end.

add_round_key(State, Key)->
    <<State1:128>>=State,
    <<Key1:128>>=Key,
    Output = Key1 bxor State1,
    <<Output:128>>.

shift_rows(<<B1_B1:8, B2_B14:8, B3_B11:8, B4_B8:8,
	     B5_B5:8, B6_B2:8, B7_B15:8, B8_B12:8,
	     B9_B9:8, B10_B6:8, B11_B3:8, B12_B16:8,
	     B13_B13:8, B14_B10:8, B15_B7:8, B16_B4:8>>)->
    <<B1_B1:8, B6_B2:8, B11_B3:8, B16_B4:8,
      B5_B5:8, B10_B6:8, B15_B7:8, B4_B8:8,
      B9_B9:8, B14_B10:8, B3_B11:8, B8_B12:8,
      B13_B13:8, B2_B14:8, B7_B15:8, B12_B16:8>>.


inv_shift_rows(<<B1_B1:8, B6_B2:8, B11_B3:8, B16_B4:8,
		 B5_B5:8, B10_B6:8, B15_B7:8, B4_B8:8,
		 B9_B9:8, B14_B10:8, B3_B11:8, B8_B12:8,
		 B13_B13:8, B2_B14:8, B7_B15:8, B12_B16:8>>)->
    <<B1_B1:8, B2_B14:8, B3_B11:8, B4_B8:8,
      B5_B5:8, B6_B2:8, B7_B15:8, B8_B12:8,
      B9_B9:8, B10_B6:8, B11_B3:8, B12_B16:8,
      B13_B13:8, B14_B10:8, B15_B7:8, B16_B4:8>>.

rot_word(<<Left:8, Right:24>>)->
    <<Right:24, Left:8>>.

multiply(0, _X) -> 0;
multiply(1, X) -> X;
multiply(2, X) -> xtime(X);
multiply(4, X) -> xtime(xtime(X));
multiply(8, X) -> xtime(multiply(4,X));
multiply(Y, X) ->
    lists:foldl(fun(E, Accu) -> multiply(E band Y, X) bxor Accu end,
		0,
		[1, 2, 4, 8]).

mix_column(State) ->
    mix_column(State, <<>>).

mix_column(<<>>, Accu)-> Accu;
mix_column(<<S0:8, S1:8, S2:8, S3:8, T/binary>>, Accu) ->
    NewColumn = <<(multiply(2, S0) bxor multiply(3, S1) bxor multiply(1, S2) bxor multiply(1, S3)),
		  (multiply(1, S0) bxor multiply(2, S1) bxor multiply(3, S2) bxor multiply(1, S3)),
		  (multiply(1, S0) bxor multiply(1, S1) bxor multiply(2, S2) bxor multiply(3, S3)),
		  (multiply(3, S0) bxor multiply(1, S1) bxor multiply(1, S2) bxor multiply(2, S3))
		  >>,
    mix_column(T, <<Accu/binary, NewColumn/binary>>).

inv_mix_column(State) ->
    inv_mix_column(State, <<>>).

inv_mix_column(<<>>, Accu)-> Accu;
inv_mix_column(<<S0:8, S1:8, S2:8, S3:8, T/binary>>, Accu) ->
    NewColumn = <<(multiply(16#e, S0) bxor multiply(16#b, S1) bxor multiply(16#d, S2) bxor multiply(16#9, S3)),
		  (multiply(16#9, S0) bxor multiply(16#e, S1) bxor multiply(16#b, S2) bxor multiply(16#d, S3)),
		  (multiply(16#d, S0) bxor multiply(16#9, S1) bxor multiply(16#e, S2) bxor multiply(16#b, S3)),
		  (multiply(16#b, S0) bxor multiply(16#d, S1) bxor multiply(16#9, S2) bxor multiply(16#e, S3))
		  >>,
    inv_mix_column(T, <<Accu/binary, NewColumn/binary>>).
