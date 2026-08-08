class RISCVXZkpBuiltin<string prototype, string features = ""> : TargetBuiltin {
  let Spellings = ["__builtin_riscv_zkp_" # NAME];
  let Prototype = prototype;
  let Features = features;
}


let Features = "xzkp256b", Attributes = [NoThrow, Const] in {
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

  def bext_w : RISCVXZkpBuiltin<"unsigned int(_Vector<8, unsigned int>, unsigned int, unsigned int)">;
}

let Features = "xzkp256b", Attributes = [NoThrow] in {
  def lbn : RISCVXZkpBuiltin<"_Vector<8, unsigned int>(void *, int)">;

  def sbn : RISCVXZkpBuiltin<"void(_Vector<8, unsigned int>, void *, int)">;
}

let Features = "xzkp128b", Attributes = [NoThrow, Const] in {
  def bmadd128  : RISCVXZkpBuiltin<"_Vector<4, unsigned int>(_Vector<4, unsigned int>, _Vector<4, unsigned int>)">;
  def bmmul128  : RISCVXZkpBuiltin<"_Vector<4, unsigned int>(_Vector<4, unsigned int>, _Vector<4, unsigned int>)">;
  def badd128   : RISCVXZkpBuiltin<"_Vector<4, unsigned int>(_Vector<4, unsigned int>, _Vector<4, unsigned int>)">;
  def bmsub128  : RISCVXZkpBuiltin<"_Vector<4, unsigned int>(_Vector<4, unsigned int>, _Vector<4, unsigned int>)">;
  def bsub128   : RISCVXZkpBuiltin<"_Vector<4, unsigned int>(_Vector<4, unsigned int>, _Vector<4, unsigned int>)">;
  def band128   : RISCVXZkpBuiltin<"_Vector<4, unsigned int>(_Vector<4, unsigned int>, _Vector<4, unsigned int>)">;
  def bor128    : RISCVXZkpBuiltin<"_Vector<4, unsigned int>(_Vector<4, unsigned int>, _Vector<4, unsigned int>)">;
  def bxor128   : RISCVXZkpBuiltin<"_Vector<4, unsigned int>(_Vector<4, unsigned int>, _Vector<4, unsigned int>)">;
  def bsll128   : RISCVXZkpBuiltin<"_Vector<4, unsigned int>(_Vector<4, unsigned int>, _Vector<4, unsigned int>)">;
  def bsrl128   : RISCVXZkpBuiltin<"_Vector<4, unsigned int>(_Vector<4, unsigned int>, _Vector<4, unsigned int>)">;

  def bmv128    : RISCVXZkpBuiltin<"_Vector<4, unsigned int>(_Vector<4, unsigned int>)">;

  def bsltu128  : RISCVXZkpBuiltin<"int(_Vector<4, unsigned int>, _Vector<4, unsigned int>)">;
  def bseq128   : RISCVXZkpBuiltin<"int(_Vector<4, unsigned int>, _Vector<4, unsigned int>)">;

  def bshfl128  : RISCVXZkpBuiltin<"_Vector<4, unsigned int>(_Vector<4, unsigned int>, int)">;

  def bshfli128 : RISCVXZkpBuiltin<"_Vector<4, unsigned int>(_Vector<4, unsigned int>, _Constant int)">;
  def bslli128  : RISCVXZkpBuiltin<"_Vector<4, unsigned int>(_Vector<4, unsigned int>, _Constant int)">;
  def bsrli128  : RISCVXZkpBuiltin<"_Vector<4, unsigned int>(_Vector<4, unsigned int>, _Constant int)">;

  def bext_w128 : RISCVXZkpBuiltin<"unsigned int(_Vector<4, unsigned int>, unsigned int, unsigned int)">;
}

let Features = "xzkp128b", Attributes = [NoThrow] in {
  def lbn128 : RISCVXZkpBuiltin<"_Vector<4, unsigned int>(void *, int)">;

  def sbn128 : RISCVXZkpBuiltin<"void(_Vector<4, unsigned int>, void *, int)">;
}

let Features = "xzkp128b|xzkp256b", Attributes = [NoThrow] in {
  def sync_barrier : RISCVXZkpBuiltin<"void(_Constant int)">;
}
