#!/usr/bin/env swipl -qg main -s

:- use_module(library(clpfd)).
:- use_module(riscv_enums).
:- use_module(riscv_asm).

asmprint(Op, Args, Bin) :-
    asm(Op, Args, Bin),
    format('asm(~k, ~k, Hex):~n  Hex = ~16r~n', [Op, Args, Bin]).

disprint(Bin) :-
    asm(Op, Args, Bin),
    format('asm(Op, Args, ~16r):~n  Op = ~k~n  Args = ~k ~n', [Bin, Op, Args]).

roundtrip(Op, Args) :-
    nl, asmprint(Op, Args, Bin), disprint(Bin).

% need to split a number into bitslices (shift + width)
% and assert the number is the sum of all the bit slices shifted back

bs(1, [0, 1], [1]).
bs(3, [0, 1], [1]).
bs(3, [0, 1, 1, 1], [1, 1]).
bs(N, Slices, Out).


main(_) :-
    % reg(Name, 0),
    % reg(zero, Num),
    % opc(add, Add, _),
    % write([Name, Num, Add]), nl,

    roundtrip(addi, [a0, a1, 12]),
    roundtrip(addi, [t6, t6, 12]),
    roundtrip(xor, [a0, a1, a2]),
    roundtrip(add, [a0, t6, a2]),
    % roundtrip(jal, [a0, 4]),
    halt.
