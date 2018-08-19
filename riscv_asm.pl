:- module(riscv_asm, [asm/3]).
:- use_module(library(clpfd)).
:- use_module(riscv_enums).

bitfold(N, V, O) :- call(N, NArr), append(V, NArr, O).
bitcat(Bits, Bin) :- foldl(bitfold, Bits, [], Bin).
bits(N, Width, A) :- bit_array(N, A, Width).

b(N, Len, V) :-
    Mask is 1 << (Len - 1),
    V #= N /\ Mask,
    N #= V /\ Mask.
b(N, Shift, Len, V) :-
    Ns #= N >> Shift,
    Vs #= V << Shift,
    b(Ns, Len, V),
    b(N, Len, Vs).

asm(Op, Args, Bin) :-
    opc(Op, Encoding, Opcode),
    encode(Opcode, Encoding, Args, Bin).

encode(Opcode, rr_simm12, [RD, RS, Imm], Bin) :-
    RDNum #= Bin >> 7 /\ 0x1f, RSNum #= Bin >> 15 /\ 0x1f, Imm #= Bin >> 20 /\ 0xfff,
    Bin #= Opcode \/ RDNum << 7 \/ RSNum << 15 \/ Imm << 20,
    reg(RD, RDNum), reg(RS, RSNum), between(0, 0xfff, Imm).

encode(Opcode, rrr, [RD, RS1, RS2], Bin) :-
    RDNum #= Bin >> 7 /\ 0x1f, RS1Num #= Bin >> 15 /\ 0x1f, RS2Num #= Bin >> 20 /\ 0x1f,
    Bin #= Opcode \/ RDNum << 7 \/ RS1Num << 15 \/ RS2Num << 20,
    reg(RD, RDNum), reg(RS1, RS1Num), reg(RS2, RS2Num).

% encode(Opcode, r_jimm20, [RD, Imm], Bin) :-
%     reg(RD, RDNum), between(-0x7fffff, 0x7fffff, Imm),
%     bit_array(Imm, N, 20),
%     bitcat([rs(N, 20), rs(N, 10, 10), rs(N, 11), rs(N, 19, 12), bits(RDNum, 5), bits(Opcode, 7)], Bin).

% encode(Opcode, sbimm12, [Imm], Bin) :-
%     between(0, 0xfff, Imm),
%     Bin is (Imm /\ 1 << 12) << 19 \/
