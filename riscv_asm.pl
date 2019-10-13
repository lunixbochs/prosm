:- module(riscv_asm, [asm/3]).
:- use_module(library(clpfd)).
:- use_module(riscv_enums).

% this uses foldl instead of maplist so we can have "bin0" and "bin0 + 1" versioning
% need to version values too! :( so immediates can unpack
% maybe can version in the encoder shorthand somehow?
% TODO: precompute vmask and include in value array?
pack_enc([Val, Vshift, _, Vmask], Shift, Bin0, Bin) :-
    ValSub #= (Val >> Vshift) /\ Vmask,
    Bin #= Bin0 \/ ValSub << Shift.
    % write(['pack_enc', Bin0, Bin, [Val, Vshift, Vwidth], Shift]), nl.

pack_dec(Bin, [Val, _, _, Vmask], Shift) :-
    Val #= Bin >> Shift /\ Vmask.
    % write(['pack_dec', Bin, [Val, Vshift, Vwidth], Shift]), nl.

pack_shift([_, _, Width, _], V, O) :-
    last(V, Acc),
    Acc1 is Acc + Width,
    append(V, [Acc1], O).

pack(Opcode, ArgsRaw, Bin) :-
    % write([Opcode, ArgsRaw, Bin]), nl,
    Opcode #= Bin /\ Opcode,
    maplist(call, ArgsRaw, Args),
    foldl(pack_shift, Args, [7], Shifts),

    % TODO: this is gross: Shifts is one too long after foldl
    prefix(ShiftP, Shifts),
    length(Shifts, ShiftsC),
    ShiftsC1 is ShiftsC - 1,
    length(ShiftP, ShiftsC1),

    foldl(pack_enc, Args, ShiftP, Opcode, Bin),
    maplist(pack_dec(Bin), Args, ShiftP).
    % write(['bin', Bin, 'args', Args, 'shifts', Shifts]), nl.

% encoding helpers
% Mask is separate so pad() can set a mask of 0 so it always succeeds
b(Val, Width, Out) :- b(Val, 0, Width, Out).
b(Val, Shift, Width, Out) :-
    Mask is (1 << Width) - 1,
    b(Val, Shift, Width, Mask, Out).
b(Val, Shift, Width, Mask, Out) :- Out = [Val, Shift, Width, Mask].
r(Reg, Out) :- reg(Reg, Num), b(Num, 5, Out).
o(Opcode, Out) :- b(Opcode, 7, 32, Out).
pad(Pad, Out) :- b(0, 0, Pad, 0, Out).

asm(Op, Args, Bin) :-
    opc(Op, Encoding, Opcode),
    encode(Opcode, Encoding, Args, Bin).

% encode(Opcode, rr_simm12, [RD, RS, Imm], Bin) :- fail.
%    RDNum #= Bin >> 7 /\ 0x1f, RSNum #= Bin >> 15 /\ 0x1f, Imm #= Bin >> 20 /\ 0xfff,
%    Bin #= Opcode \/ RDNum << 7 \/ RSNum << 15 \/ Imm << 20,
%    reg(RD, RDNum), reg(RS, RSNum), between(0, 0xfff, Imm).

encode(Opcode, rrr, [Rd, Rs1, Rs2], Bin) :-
    pack(Opcode, [r(Rd), pad(3), r(Rs1), r(Rs2)], Bin).

% shift(Args, Shift, I) :-
%     length(Prefix, I),
%     prefix(Prefix, Args),
%     sum_list(Prefix, Shift).
% 
% pack(Opcode, Args, Bin) :-
%     Opcode #= Bin /\ Opcode, Bin #= Bin \/ Opcode,
%     length(Args, ArgC),
%     numlist(1, length(ArgC), Idx),
%     maplist(shifts(Args), Shift, Idx).
% b(Val, Width, Out) :- b(Val, 0, Width, Out).
% b(Val, Shift, Width, Out) :- Out = [Val, Shift, Width].
% r(Reg, Out) :- reg(Reg, Num), b(Num, 7, Out).
% 
% pack(Opcode, [r(RD), r(RS1), r(RS2)], Bin).
% pack(Opcode, [r(RD), r(RS), b(Imm, 20)], Bin).

% encode(Opcode, r_jimm20, [RD, Imm], Bin) :-
%     reg(RD, RDNum), between(-0x7fffff, 0x7fffff, Imm),
%     bit_array(Imm, N, 20),
%     bitcat([rs(N, 20), rs(N, 10, 10), rs(N, 11), rs(N, 19, 12), bits(RDNum, 5), bits(Opcode, 7)], Bin).

% encode(Opcode, sbimm12, [Imm], Bin) :-
%     between(0, 0xfff, Imm),
%     Bin is (Imm /\ 1 << 12) << 19 \/
