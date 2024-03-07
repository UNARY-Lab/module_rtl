# module_rtl

&check; means the module is done; blank means the module is not done yet.

|Module|Verification|Synthesis|
|---|---|---|
|accumulator|&check;||
|adder|&check;||
|adder_reg|&check;||
|adder_bfloat16_reg|&check;||
|fifo_sync|&check;||
|multiplier_bfloat16_reg|&check;||
|multiplier_64b_reg|||
|multiplier_128b_reg|||
|outerprodrc|&check;||
|register|&check;||
|shift_register|&check;||
|sobolrng|&check;||


|Module|Verification|Synthesis|
|---|---|---|
|mod_accumulator|&check;||
|mod_adder|&check;||
|mod_adder_reg|&check;||
|mod_doubler|&check;||
|mod_doubler_reg|&check;||
|mod_multiplier_barrett_32b|||
|mod_multiplier_barrett_64b|||
|mod_multiplier_montgomery|||
|mod_quadrupler|&check;||
|mod_quadrupler_reg|&check;||


To allow synthesis on UCF CECS machines, please refer to automated scripts [here](https://github.com/UNARY-Lab/Tools/tree/main/script-auto-syn-pr-ucf-cecs).
