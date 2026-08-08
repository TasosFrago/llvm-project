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

  def SYNCBAR : RVInstI<0x2, OPC_CUSTOM_1, (outs), (ins simm12:$imm12), "sync", "$imm12"> {
    let rd = 0;
    let rs1 = 0;
    let hasSideEffects = 1;
    let mayLoad = 1;
    let mayStore = 1;
  }

  class ZKPRType_BEXT<bits<2> funct2, bits<3> funct3, string opcodestr>
      : RVInstR<0x0, funct3, OPC_CUSTOM_1, (outs GPR:$rd),
                (ins BRegs:$rs1, GPR:$rs2, uimm5:$imm5), opcodestr, "$rd, $rs1, $rs2, $imm5"> {
    bits<5> imm5;

    let Inst{31-27} = imm5;
    let Inst{26-25} = funct2;
  }

  def BEXT_W : ZKPRType_BEXT<0x0, 0x3, "bext.w">;

  // Intrinsic Patterns

  multiclass ZKP_Pat_Math<Intrinsic intr, Instruction inst> {
    def : Pat<(v8i32 (intr (v8i32 BRegs:$rs1), (v8i32 BRegs:$rs2))), (inst BRegs:$rs1, BRegs:$rs2)>;
    def : Pat<(v4i32 (intr (v4i32 BRegs:$rs1), (v4i32 BRegs:$rs2))), (inst BRegs:$rs1, BRegs:$rs2)>;
  }

  // Math & Logic
  defm : ZKP_Pat_Math<int_riscv_bmadd,   BMODADD >;
  defm : ZKP_Pat_Math<int_riscv_bmmul,   BMODMUL >;
  defm : ZKP_Pat_Math<int_riscv_badd,    BADD    >;
  defm : ZKP_Pat_Math<int_riscv_bmsub,   BMODSUB >;
  defm : ZKP_Pat_Math<int_riscv_bsub,    BSUB    >;
  defm : ZKP_Pat_Math<int_riscv_band,    BAND    >;
  defm : ZKP_Pat_Math<int_riscv_bor,     BOR     >;
  defm : ZKP_Pat_Math<int_riscv_bxor,    BXOR    >;
  defm : ZKP_Pat_Math<int_riscv_bsll,    BSLL    >;
  defm : ZKP_Pat_Math<int_riscv_bsrl,    BSRL    >;

  // Comparisons
  multiclass ZKP_Pat_CMP<Intrinsic intr, Instruction inst> {
    def : Pat<(intr (v8i32 BRegs:$rs1), (v8i32 BRegs:$rs2)), (inst BRegs:$rs1, BRegs:$rs2)>;
    def : Pat<(intr (v4i32 BRegs:$rs1), (v4i32 BRegs:$rs2)), (inst BRegs:$rs1, BRegs:$rs2)>;
  }
  defm : ZKP_Pat_CMP<int_riscv_bsltu, BSLTU>;
  defm : ZKP_Pat_CMP<int_riscv_bseq,  BSEQ>;

  // Move
  multiclass ZKP_Pat_MV<Intrinsic intr, Instruction inst> {
    def : Pat<(v8i32 (intr (v8i32 BRegs:$rs1))), (inst BRegs:$rs1)>;
    def : Pat<(v4i32 (intr (v4i32 BRegs:$rs1))), (inst BRegs:$rs1)>;
  }
  defm : ZKP_Pat_MV<int_riscv_bmv, BMV>;

  // Shuffles & Immediates
  multiclass ZKP_Pat_SHFL<Intrinsic intr, Instruction inst> {
    def : Pat<(v8i32 (intr (v8i32 BRegs:$rs1), GPR:$rs2)), (inst BRegs:$rs1, GPR:$rs2)>;
    def : Pat<(v4i32 (intr (v4i32 BRegs:$rs1), GPR:$rs2)), (inst BRegs:$rs1, GPR:$rs2)>;
  }

  multiclass ZKP_Pat_SHFLI<Intrinsic intr, Instruction inst, PatFrag imm_type> {
    def : Pat<(v8i32 (intr (v8i32 BRegs:$rs1), imm_type:$imm)), (inst BRegs:$rs1, imm_type:$imm)>;
    def : Pat<(v4i32 (intr (v4i32 BRegs:$rs1), imm_type:$imm)), (inst BRegs:$rs1, imm_type:$imm)>;
  }

  defm : ZKP_Pat_SHFL<int_riscv_bshfl, BSHFL>;
  defm : ZKP_Pat_SHFLI<int_riscv_bshfli, BSHFLI, uimm5>;

  defm : ZKP_Pat_SHFLI<int_riscv_bslli, BSLLI, ZKPUImm8Leaf>;
  defm : ZKP_Pat_SHFLI<int_riscv_bsrli, BSRLI, ZKPUImm8Leaf>;

  // Memory Operations
  multiclass ZKP_Pat_Load<Intrinsic intr, Instruction inst> {
    def : Pat<(v8i32 (intr GPR:$rs1, simm12:$imm12)), (inst GPR:$rs1, simm12:$imm12)>;
    def : Pat<(v4i32 (intr GPR:$rs1, simm12:$imm12)), (inst GPR:$rs1, simm12:$imm12)>;
  }

  multiclass ZKP_Pat_Store<Intrinsic intr, Instruction inst> {
    def : Pat<(intr (v8i32 BRegs:$rs2), GPR:$rs1, simm12:$imm12), (inst BRegs:$rs2, GPR:$rs1, simm12:$imm12)>;
    def : Pat<(intr (v4i32 BRegs:$rs2), GPR:$rs1, simm12:$imm12), (inst BRegs:$rs2, GPR:$rs1, simm12:$imm12)>;
  }

  defm : ZKP_Pat_Load<int_riscv_lbn, LBN>;
  defm : ZKP_Pat_Store<int_riscv_sbn, SBN>;

  // Automatic Load Patterns (Handles direct pointers and offset pointers)
  def : Pat<(v8i32 (load (AddrRegImm (XLenVT GPR:$rs1), simm12:$imm12))),
	    (LBN GPR:$rs1, simm12:$imm12)>;

  def : Pat<(store (v8i32 BRegs:$rs2), (AddrRegImm (XLenVT GPR:$rs1), simm12:$imm12)),
	    (SBN BRegs:$rs2, GPR:$rs1, simm12:$imm12)>;

  def : Pat<(v4i32 (load (AddrRegImm (XLenVT GPR:$rs1), simm12:$imm12))),
	    (LBN GPR:$rs1, simm12:$imm12)>;

  def : Pat<(store (v4i32 BRegs:$rs2), (AddrRegImm (XLenVT GPR:$rs1), simm12:$imm12)),
	    (SBN BRegs:$rs2, GPR:$rs1, simm12:$imm12)>;

  def : Pat<(int_riscv_sync_barrier simm12:$imm12), (SYNCBAR simm12:$imm12)>;

  def : Pat<(int_riscv_bext_w (v8i32 BRegs:$rs1), GPR:$rs2, uimm5:$imm5),
  	    (BEXT_W BRegs:$rs1, GPR:$rs2, uimm5:$imm5)>;
  def : Pat<(int_riscv_bext_w (v4i32 BRegs:$rs1), GPR:$rs2, uimm5:$imm5),
  	    (BEXT_W BRegs:$rs1, GPR:$rs2, uimm5:$imm5)>;
}
