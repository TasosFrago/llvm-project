; RUN: llc -mtriple=riscv32 -mattr=+xzkp256b < %s | FileCheck %s
; RUN: llc -mtriple=riscv32 -mattr=+xzkp256bms < %s | FileCheck %s
;
; Generic i32 lane extraction must use BEXT_W without requiring RVV.
; Keep the loaded value behind BMV so DAG combining cannot replace the
; vector load and extraction with a scalar load.

declare <8 x i32> @llvm.riscv.bmv.v8i32(<8 x i32>)

define i32 @extract_first(ptr %p) {
; CHECK-LABEL: extract_first:
; CHECK: bext.w {{.*}}, zero, 31
; CHECK: ret
  %v = load <8 x i32>, ptr %p, align 32
  %b = call <8 x i32> @llvm.riscv.bmv.v8i32(<8 x i32> %v)
  %word = extractelement <8 x i32> %b, i32 0
  ret i32 %word
}

define i32 @extract_last(ptr %p) {
; CHECK-LABEL: extract_last:
; CHECK: li [[INDEX:[a-z][a-z0-9]*]], 7
; CHECK: bext.w {{.*}}, [[INDEX]], 31
; CHECK: ret
  %v = load <8 x i32>, ptr %p, align 32
  %b = call <8 x i32> @llvm.riscv.bmv.v8i32(<8 x i32> %v)
  %word = extractelement <8 x i32> %b, i32 7
  ret i32 %word
}

define i32 @extract_variable(ptr %p, i32 %index) {
; CHECK-LABEL: extract_variable:
; CHECK: bext.w {{.*}}, a1, 31
; CHECK: ret
  %v = load <8 x i32>, ptr %p, align 32
  %b = call <8 x i32> @llvm.riscv.bmv.v8i32(<8 x i32> %v)
  %word = extractelement <8 x i32> %b, i32 %index
  ret i32 %word
}
