def ZKPUImm8Leaf : ImmLeaf<XLenVT, [{ return isUInt<8>(Imm); }]>;

let Predicates = [HasExtXZkp] in {

  // Math - Differentiated by funct7
  class ZKPRType_Math<bits<7> funct7, string opcodestr>
      : RVInstR<funct7, 0x0, OPC_CUSTOM_0, (outs BRegs:$rd),
                (ins BRegs:$rs1, BRegs:$rs2), opcodestr, "$rd, $rs1, $rs2">;

  def BMODADD : ZKPRType_Math<0x00, "bmadd">;
  def BMODMUL : ZKPRType_Math<0x01, "bmmul">;
  def BADD    : ZKPRType_Math<0x02, "badd">;
  def BMODSUB : ZKPRType_Math<0x20, "bmsub">;
  def BSUB    : ZKPRType_Math<0x21, "bsub">;

  class ZKPRType_MV<bits<7> funct7, bits<3> funct3, string opcodestr>
      : RVInstR<funct7, funct3, OPC_CUSTOM_0, (outs BRegs:$rd),
                (ins BRegs:$rs1), opcodestr, "$rd, $rs1"> {
    let rs2 = 0;
  }

  def BMV : ZKPRType_MV<0x03, 0x0, "mv.bn">;

  class ZKPRType_SHFL<bits<7> funct7, bits<3> funct3, string opcodestr>
      : RVInstR<funct7, funct3, OPC_CUSTOM_0, (outs BRegs:$rd),
                (ins BRegs:$rs1, GPR:$rs2), opcodestr, "$rd, $rs1, $rs2">;

  def BSHFL : ZKPRType_SHFL<0x13, 0x0, "shfl.bn">;

  class ZKPRType_SHFLI<bits<7> funct7, bits<3> funct3, string opcodestr>
      : RVInstR<funct7, funct3, OPC_CUSTOM_0, (outs BRegs:$rd),
                (ins BRegs:$rs1, uimm5:$rs2), opcodestr, "$rd, $rs1, $rs2">;

  def BSHFLI : ZKPRType_SHFLI<0x14, 0x0, "shfli.bn">;

  // Bitwise Logic
  class ZKPRType_Logic<bits<7> funct7, bits<3> funct3, string opcodestr>
      : RVInstR<funct7, funct3, OPC_CUSTOM_0, (outs BRegs:$rd),
                (ins BRegs:$rs1, BRegs:$rs2), opcodestr, "$rd, $rs1, $rs2">;

  def BAND : ZKPRType_Logic<0x00, 0x7, "band">;
  def BOR  : ZKPRType_Logic<0x00, 0x6, "bor">;
  def BXOR : ZKPRType_Logic<0x00, 0x4, "bxor">;

  // Comparisons -> OUTPUTS TO GPR!
  class ZKPRType_Cmp<bits<7> funct7, bits<3> funct3, string opcodestr>
      : RVInstR<funct7, funct3, OPC_CUSTOM_0, (outs GPR:$rd),
                (ins BRegs:$rs1, BRegs:$rs2), opcodestr, "$rd, $rs1, $rs2">;

  def BSLTU : ZKPRType_Cmp<0x00, 0x3, "sltu.bn">;
  def BSEQ  : ZKPRType_Cmp<0x01, 0x2, "seq.bn">; 

  // Shifts
  class ZKPRType_Shift<bits<7> funct7, bits<3> funct3, string opcodestr>
      : RVInstR<funct7, funct3, OPC_CUSTOM_0, (outs BRegs:$rd),
                (ins BRegs:$rs1, BRegs:$rs2), opcodestr, "$rd, $rs1, $rs2">;

  def BSLL : ZKPRType_Shift<0x00, 0x1, "bsll">;
  def BSRL : ZKPRType_Shift<0x00, 0x5, "bsrl">;

  // Shift Immediates
  class ZKPIType_ShiftImm<bits<4> funct4, bits<3> funct3, string opcodestr>
      : RVInstI<funct3, OPC_CUSTOM_0, (outs BRegs:$rd),
                (ins BRegs:$rs1, uimm8:$imm8), opcodestr, "$rd, $rs1, $imm8"> {
    bits<8> imm8;
    let imm12 = { funct4, imm8 };
  }

  def BSLLI : ZKPIType_ShiftImm<0x1, 0x1, "bslli">;
  def BSRLI : ZKPIType_ShiftImm<0x1, 0x5, "bsrli">;

  // I-Type
  def LBN : RVInstI<0x0, OPC_CUSTOM_1, (outs BRegs:$rd),
                    (ins GPR:$rs1, simm12:$imm12), "lbn", "$rd, ${imm12}(${rs1})"> {
    let mayLoad = 1;
  }

  // S-Type
  def SBN : RVInstS<0x1, OPC_CUSTOM_1, (outs),
                    (ins BRegs:$rs2, GPR:$rs1, simm12:$imm12), "sbn", "$rs2, ${imm12}(${rs1})"> {
    let mayStore = 1;
  }

  // Intrinsic Patterns

  // Math & Logic
  def : Pat<(int_riscv_bmadd   BRegs:$rs1, BRegs:$rs2), (BMODADD BRegs:$rs1, BRegs:$rs2)>;
  def : Pat<(int_riscv_bmmul   BRegs:$rs1, BRegs:$rs2), (BMODMUL BRegs:$rs1, BRegs:$rs2)>;
  def : Pat<(int_riscv_badd    BRegs:$rs1, BRegs:$rs2), (BADD    BRegs:$rs1, BRegs:$rs2)>;
  def : Pat<(int_riscv_bmsub   BRegs:$rs1, BRegs:$rs2), (BMODSUB BRegs:$rs1, BRegs:$rs2)>;
  def : Pat<(int_riscv_bsub    BRegs:$rs1, BRegs:$rs2), (BSUB    BRegs:$rs1, BRegs:$rs2)>;
  def : Pat<(int_riscv_band    BRegs:$rs1, BRegs:$rs2), (BAND    BRegs:$rs1, BRegs:$rs2)>;
  def : Pat<(int_riscv_bor     BRegs:$rs1, BRegs:$rs2), (BOR     BRegs:$rs1, BRegs:$rs2)>;
  def : Pat<(int_riscv_bxor    BRegs:$rs1, BRegs:$rs2), (BXOR    BRegs:$rs1, BRegs:$rs2)>;
  def : Pat<(int_riscv_bsll    BRegs:$rs1, BRegs:$rs2), (BSLL    BRegs:$rs1, BRegs:$rs2)>;
  def : Pat<(int_riscv_bsrl    BRegs:$rs1, BRegs:$rs2), (BSRL    BRegs:$rs1, BRegs:$rs2)>;

  // Move
  def : Pat<(int_riscv_bmv BRegs:$rs1), (BMV BRegs:$rs1)>;

  // Comparisons (Outputs to GPR)
  def : Pat<(int_riscv_bsltu BRegs:$rs1, BRegs:$rs2), (BSLTU BRegs:$rs1, BRegs:$rs2)>;
  def : Pat<(int_riscv_bseq  BRegs:$rs1, BRegs:$rs2), (BSEQ  BRegs:$rs1, BRegs:$rs2)>;

  // Shuffles & Immediates
  def : Pat<(int_riscv_bshfl  BRegs:$rs1, GPR:$rs2),        (BSHFL  BRegs:$rs1, GPR:$rs2)>;
  def : Pat<(int_riscv_bshfli BRegs:$rs1, uimm5:$imm5),     (BSHFLI BRegs:$rs1, uimm5:$imm5)>;
  
  def : Pat<(int_riscv_bslli BRegs:$rs1, ZKPUImm8Leaf:$imm8),      (BSLLI BRegs:$rs1, uimm8:$imm8)>;
  def : Pat<(int_riscv_bsrli BRegs:$rs1, ZKPUImm8Leaf:$imm8),      (BSRLI BRegs:$rs1, uimm8:$imm8)>;

  // Memory Operations
  def : Pat<(int_riscv_lbn GPR:$rs1, simm12:$imm12),             (LBN GPR:$rs1, simm12:$imm12)>;
  def : Pat<(int_riscv_sbn BRegs:$rs2, GPR:$rs1, simm12:$imm12), (SBN BRegs:$rs2, GPR:$rs1, simm12:$imm12)>;

  // Automatic Load Patterns (Handles direct pointers and offset pointers)
  def : Pat<(v8i32 (load GPR:$rs1)), (LBN GPR:$rs1, 0)>;
  def : Pat<(v8i32 (load (add GPR:$rs1, simm12:$imm12))), (LBN GPR:$rs1, simm12:$imm12)>;

  // Automatic Store Patterns (Handles direct pointers and offset pointers)
  def : Pat<(store (v8i32 BRegs:$rs2), GPR:$rs1), (SBN BRegs:$rs2, GPR:$rs1, 0)>;
  def : Pat<(store (v8i32 BRegs:$rs2), (add GPR:$rs1, simm12:$imm12)), (SBN BRegs:$rs2, GPR:$rs1, simm12:$imm12)>;
}
