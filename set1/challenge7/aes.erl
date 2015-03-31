-module(aes).
-export([add_round_key/2, shift_rows/1, rot_word/1, xtime/1]).

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

rot_word(<<Left:8, Right:24>>)->
    <<Right:24, Left:8>>.
