:- module(riscv_enums, [reg/2, opc/2, opc/3]).

reg(zero, 0).
reg(ra, 1).
reg(sp, 2).
reg(gp, 3).
reg(tp, 4).
reg(t0, 5).
reg(t1, 6).
reg(t2, 7).
reg(s0, 8).
reg(s1, 9).
reg(a0, 10).
reg(a1, 11).
reg(a2, 12).
reg(a3, 13).
reg(a4, 14).
reg(a5, 15).
reg(a6, 16).
reg(a7, 17).
reg(s2, 18).
reg(s3, 19).
reg(s4, 20).
reg(s5, 21).
reg(s6, 22).
reg(s7, 23).
reg(s8, 24).
reg(s9, 25).
reg(s10, 26).
reg(s11, 27).
reg(t3, 28).
reg(t4, 29).
reg(t5, 30).
reg(t6, 31).

opc(Op, Opcode) :- opc(Op, _, Opcode).
opc(add,    rrr, 0x33).
opc(addi,   rr_simm12, 0x13).
opc(addiw,  unknown, 0x1b).
opc(addw,   unknown, 0x3b).
opc(and,    unknown, 0x7033).
opc(andi,   unknown, 0x7013).
opc(auipc,  unknown, 0x17).
opc(beq,    unknown, 0x63).
opc(bge,    unknown, 0x5063).
opc(bgeu,   unknown, 0x7063).
opc(blt,    unknown, 0x4063).
opc(bltu,   unknown, 0x6063).
opc(bne,    unknown, 0x1063).
opc(div,    unknown, 0x2004033).
opc(divu,   unknown, 0x2005033).
opc(divuw,  unknown, 0x200503b).
opc(divw,   unknown, 0x200403b).
opc(jal,    r_jimm20, 0x6f).
opc(jalr,   unknown, 0x67).
opc(lb,     unknown, 0x3).
opc(lbu,    unknown, 0x4003).
opc(ld,     unknown, 0x3003).
opc(lh,     unknown, 0x1003).
opc(lhu,    unknown, 0x5003).
opc(lui,    unknown, 0x37).
opc(lw,     unknown, 0x2003).
opc(lwu,    unknown, 0x6003).
opc(mul,    unknown, 0x2000033).
opc(mulh,   unknown, 0x2001033).
opc(mulhsu, unknown, 0x2002033).
opc(mulhu,  unknown, 0x2003033).
opc(mulw,   unknown, 0x200003b).
opc(or,     unknown, 0x6033).
opc(ori,    unknown, 0x6013).
opc(rem,    unknown, 0x2006033).
opc(remu,   unknown, 0x2007033).
opc(remuw,  unknown, 0x200703b).
opc(remw,   unknown, 0x200603b).
opc(sb,     unknown, 0x23).
opc(sd,     unknown, 0x3023).
opc(sh,     unknown, 0x1023).
opc(sll,    unknown, 0x1033).
opc(slli,   unknown, 0x1013).
opc(slliw,  unknown, 0x101b).
opc(sllw,   unknown, 0x103b).
opc(slt,    unknown, 0x2033).
opc(slti,   unknown, 0x2013).
opc(sltiu,  unknown, 0x3013).
opc(sltu,   unknown, 0x3033).
opc(sra,    unknown, 0x40005033).
opc(srai,   unknown, 0x40005013).
opc(sraiw,  unknown, 0x4000501b).
opc(sraw,   unknown, 0x4000503b).
opc(srl,    unknown, 0x5033).
opc(srli,   unknown, 0x5013).
opc(srliw,  unknown, 0x501b).
opc(srlw,   unknown, 0x503b).
opc(sub,    unknown, 0x40000033).
opc(subw,   unknown, 0x4000003b).
opc(sw,     unknown, 0x2023).
opc(xor,    rrr, 0x4033).
opc(xori,   unknown, 0x4013).
opc(ecall,  none,    0x73).
