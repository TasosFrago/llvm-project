; RUN: llc -mtriple=riscv32 -mattr=+xzkp128b < %s | FileCheck %s
;
; Cover the 128-bit big-number type as well as the 256-bit variants.

declare <4 x i32> @llvm.riscv.bmv.v4i32(<4 x i32>)

define i32 @extract_first(ptr %p) {
; CHECK-LABEL: extract_first:
; CHECK: bext.w {{.*}}, zero, 31
; CHECK: ret
  %v = load <4 x i32>, ptr %p, align 16
  %b = call <4 x i32> @llvm.riscv.bmv.v4i32(<4 x i32> %v)
  %word = extractelement <4 x i32> %b, i32 0
  ret i32 %word
}

define i32 @extract_last(ptr %p) {
; CHECK-LABEL: extract_last:
; CHECK: li [[INDEX:[a-z][a-z0-9]*]], 3
; CHECK: bext.w {{.*}}, [[INDEX]], 31
; CHECK: ret
  %v = load <4 x i32>, ptr %p, align 16
  %b = call <4 x i32> @llvm.riscv.bmv.v4i32(<4 x i32> %v)
  %word = extractelement <4 x i32> %b, i32 3
  ret i32 %word
}

define i32 @extract_variable(ptr %p, i32 %index) {
; CHECK-LABEL: extract_variable:
; CHECK: bext.w {{.*}}, a1, 31
; CHECK: ret
  %v = load <4 x i32>, ptr %p, align 16
  %b = call <4 x i32> @llvm.riscv.bmv.v4i32(<4 x i32> %v)
  %word = extractelement <4 x i32> %b, i32 %index
  ret i32 %word
}
