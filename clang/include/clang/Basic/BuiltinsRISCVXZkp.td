class RISCVXZkpBuiltin<string prototype, string features = ""> : TargetBuiltin {
  let Spellings = ["__builtin_riscv_zkp_" # NAME];
  let Prototype = prototype;
  let Features = features;
}


let Features = "xzkp", Attributes = [NoThrow, Const] in {
  def bmadd  : RISCVXZkpBuiltin<"_Vector<8, unsigned int>(_Vector<8, unsigned int>, _Vector<8, unsigned int>)">;
  def bmmul  : RISCVXZkpBuiltin<"_Vector<8, unsigned int>(_Vector<8, unsigned int>, _Vector<8, unsigned int>)">;
  def badd   : RISCVXZkpBuiltin<"_Vector<8, unsigned int>(_Vector<8, unsigned int>, _Vector<8, unsigned int>)">;
  def bmsub  : RISCVXZkpBuiltin<"_Vector<8, unsigned int>(_Vector<8, unsigned int>, _Vector<8, unsigned int>)">;
  def bsub   : RISCVXZkpBuiltin<"_Vector<8, unsigned int>(_Vector<8, unsigned int>, _Vector<8, unsigned int>)">;
  def band   : RISCVXZkpBuiltin<"_Vector<8, unsigned int>(_Vector<8, unsigned int>, _Vector<8, unsigned int>)">;
  def bor    : RISCVXZkpBuiltin<"_Vector<8, unsigned int>(_Vector<8, unsigned int>, _Vector<8, unsigned int>)">;
  def bxor   : RISCVXZkpBuiltin<"_Vector<8, unsigned int>(_Vector<8, unsigned int>, _Vector<8, unsigned int>)">;
  def bsll   : RISCVXZkpBuiltin<"_Vector<8, unsigned int>(_Vector<8, unsigned int>, _Vector<8, unsigned int>)">;
  def bsrl   : RISCVXZkpBuiltin<"_Vector<8, unsigned int>(_Vector<8, unsigned int>, _Vector<8, unsigned int>)">;

  def bmv    : RISCVXZkpBuiltin<"_Vector<8, unsigned int>(_Vector<8, unsigned int>)">;

  def bsltu  : RISCVXZkpBuiltin<"int(_Vector<8, unsigned int>, _Vector<8, unsigned int>)">;
  def bseq   : RISCVXZkpBuiltin<"int(_Vector<8, unsigned int>, _Vector<8, unsigned int>)">;

  def bshfl  : RISCVXZkpBuiltin<"_Vector<8, unsigned int>(_Vector<8, unsigned int>, int)">;

  def bshfli : RISCVXZkpBuiltin<"_Vector<8, unsigned int>(_Vector<8, unsigned int>, _Constant int)">;
  def bslli  : RISCVXZkpBuiltin<"_Vector<8, unsigned int>(_Vector<8, unsigned int>, _Constant int)">;
  def bsrli  : RISCVXZkpBuiltin<"_Vector<8, unsigned int>(_Vector<8, unsigned int>, _Constant int)">;
}

let Features = "xzkp", Attributes = [NoThrow] in {
  def lbn : RISCVXZkpBuiltin<"_Vector<8, unsigned int>(void *, int)">;

  def sbn : RISCVXZkpBuiltin<"void(_Vector<8, unsigned int>, void *, int)">;
}
