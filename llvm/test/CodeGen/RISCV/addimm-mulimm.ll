; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
;; Test that (mul (add x, c1), c2) can be transformed to
;; (add (mul x, c2), c1*c2) if profitable.

; RUN: llc -mtriple=riscv32 -mattr=+m,+zba -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32IMB %s
; RUN: llc -mtriple=riscv64 -mattr=+m,+zba -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64IMB %s

define i32 @add_mul_combine_accept_a1(i32 %x) {
; RV32IMB-LABEL: add_mul_combine_accept_a1:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    sh1add a1, a0, a0
; RV32IMB-NEXT:    slli a0, a0, 5
; RV32IMB-NEXT:    sub a0, a0, a1
; RV32IMB-NEXT:    addi a0, a0, 1073
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_accept_a1:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    sh1add a1, a0, a0
; RV64IMB-NEXT:    slli a0, a0, 5
; RV64IMB-NEXT:    sub a0, a0, a1
; RV64IMB-NEXT:    addiw a0, a0, 1073
; RV64IMB-NEXT:    ret
  %tmp0 = add i32 %x, 37
  %tmp1 = mul i32 %tmp0, 29
  ret i32 %tmp1
}

define signext i32 @add_mul_combine_accept_a2(i32 signext %x) {
; RV32IMB-LABEL: add_mul_combine_accept_a2:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    sh1add a1, a0, a0
; RV32IMB-NEXT:    slli a0, a0, 5
; RV32IMB-NEXT:    sub a0, a0, a1
; RV32IMB-NEXT:    addi a0, a0, 1073
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_accept_a2:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    sh1add a1, a0, a0
; RV64IMB-NEXT:    slli a0, a0, 5
; RV64IMB-NEXT:    sub a0, a0, a1
; RV64IMB-NEXT:    addiw a0, a0, 1073
; RV64IMB-NEXT:    ret
  %tmp0 = add i32 %x, 37
  %tmp1 = mul i32 %tmp0, 29
  ret i32 %tmp1
}

define i64 @add_mul_combine_accept_a3(i64 %x) {
; RV32IMB-LABEL: add_mul_combine_accept_a3:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    li a2, 29
; RV32IMB-NEXT:    sh1add a3, a1, a1
; RV32IMB-NEXT:    slli a1, a1, 5
; RV32IMB-NEXT:    sub a1, a1, a3
; RV32IMB-NEXT:    sh1add a3, a0, a0
; RV32IMB-NEXT:    mulhu a2, a0, a2
; RV32IMB-NEXT:    slli a0, a0, 5
; RV32IMB-NEXT:    sub a3, a0, a3
; RV32IMB-NEXT:    add a1, a2, a1
; RV32IMB-NEXT:    addi a0, a3, 1073
; RV32IMB-NEXT:    sltu a2, a0, a3
; RV32IMB-NEXT:    add a1, a1, a2
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_accept_a3:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    sh1add a1, a0, a0
; RV64IMB-NEXT:    slli a0, a0, 5
; RV64IMB-NEXT:    sub a0, a0, a1
; RV64IMB-NEXT:    addi a0, a0, 1073
; RV64IMB-NEXT:    ret
  %tmp0 = add i64 %x, 37
  %tmp1 = mul i64 %tmp0, 29
  ret i64 %tmp1
}

define i32 @add_mul_combine_accept_b1(i32 %x) {
; RV32IMB-LABEL: add_mul_combine_accept_b1:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    sh3add a1, a0, a0
; RV32IMB-NEXT:    slli a0, a0, 5
; RV32IMB-NEXT:    sub a0, a0, a1
; RV32IMB-NEXT:    lui a1, 50
; RV32IMB-NEXT:    addi a1, a1, 1119
; RV32IMB-NEXT:    add a0, a0, a1
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_accept_b1:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    sh3add a1, a0, a0
; RV64IMB-NEXT:    slli a0, a0, 5
; RV64IMB-NEXT:    sub a0, a0, a1
; RV64IMB-NEXT:    lui a1, 50
; RV64IMB-NEXT:    addi a1, a1, 1119
; RV64IMB-NEXT:    addw a0, a0, a1
; RV64IMB-NEXT:    ret
  %tmp0 = add i32 %x, 8953
  %tmp1 = mul i32 %tmp0, 23
  ret i32 %tmp1
}

define signext i32 @add_mul_combine_accept_b2(i32 signext %x) {
; RV32IMB-LABEL: add_mul_combine_accept_b2:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    sh3add a1, a0, a0
; RV32IMB-NEXT:    slli a0, a0, 5
; RV32IMB-NEXT:    sub a0, a0, a1
; RV32IMB-NEXT:    lui a1, 50
; RV32IMB-NEXT:    addi a1, a1, 1119
; RV32IMB-NEXT:    add a0, a0, a1
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_accept_b2:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    sh3add a1, a0, a0
; RV64IMB-NEXT:    slli a0, a0, 5
; RV64IMB-NEXT:    sub a0, a0, a1
; RV64IMB-NEXT:    lui a1, 50
; RV64IMB-NEXT:    addi a1, a1, 1119
; RV64IMB-NEXT:    addw a0, a0, a1
; RV64IMB-NEXT:    ret
  %tmp0 = add i32 %x, 8953
  %tmp1 = mul i32 %tmp0, 23
  ret i32 %tmp1
}

define i64 @add_mul_combine_accept_b3(i64 %x) {
; RV32IMB-LABEL: add_mul_combine_accept_b3:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    li a2, 23
; RV32IMB-NEXT:    sh3add a3, a1, a1
; RV32IMB-NEXT:    slli a1, a1, 5
; RV32IMB-NEXT:    sub a1, a1, a3
; RV32IMB-NEXT:    sh3add a3, a0, a0
; RV32IMB-NEXT:    mulhu a2, a0, a2
; RV32IMB-NEXT:    slli a0, a0, 5
; RV32IMB-NEXT:    sub a3, a0, a3
; RV32IMB-NEXT:    lui a0, 50
; RV32IMB-NEXT:    addi a0, a0, 1119
; RV32IMB-NEXT:    add a1, a2, a1
; RV32IMB-NEXT:    add a0, a3, a0
; RV32IMB-NEXT:    sltu a2, a0, a3
; RV32IMB-NEXT:    add a1, a1, a2
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_accept_b3:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    sh3add a1, a0, a0
; RV64IMB-NEXT:    slli a0, a0, 5
; RV64IMB-NEXT:    sub a0, a0, a1
; RV64IMB-NEXT:    lui a1, 50
; RV64IMB-NEXT:    addi a1, a1, 1119
; RV64IMB-NEXT:    add a0, a0, a1
; RV64IMB-NEXT:    ret
  %tmp0 = add i64 %x, 8953
  %tmp1 = mul i64 %tmp0, 23
  ret i64 %tmp1
}

define i32 @add_mul_combine_reject_a1(i32 %x) {
; RV32IMB-LABEL: add_mul_combine_reject_a1:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, 1971
; RV32IMB-NEXT:    sh1add a1, a0, a0
; RV32IMB-NEXT:    slli a0, a0, 5
; RV32IMB-NEXT:    sub a0, a0, a1
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_reject_a1:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 1971
; RV64IMB-NEXT:    sh1add a1, a0, a0
; RV64IMB-NEXT:    slli a0, a0, 5
; RV64IMB-NEXT:    subw a0, a0, a1
; RV64IMB-NEXT:    ret
  %tmp0 = add i32 %x, 1971
  %tmp1 = mul i32 %tmp0, 29
  ret i32 %tmp1
}

define signext i32 @add_mul_combine_reject_a2(i32 signext %x) {
; RV32IMB-LABEL: add_mul_combine_reject_a2:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, 1971
; RV32IMB-NEXT:    sh1add a1, a0, a0
; RV32IMB-NEXT:    slli a0, a0, 5
; RV32IMB-NEXT:    sub a0, a0, a1
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_reject_a2:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 1971
; RV64IMB-NEXT:    sh1add a1, a0, a0
; RV64IMB-NEXT:    slli a0, a0, 5
; RV64IMB-NEXT:    subw a0, a0, a1
; RV64IMB-NEXT:    ret
  %tmp0 = add i32 %x, 1971
  %tmp1 = mul i32 %tmp0, 29
  ret i32 %tmp1
}

define i64 @add_mul_combine_reject_a3(i64 %x) {
; RV32IMB-LABEL: add_mul_combine_reject_a3:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    li a2, 29
; RV32IMB-NEXT:    sh1add a3, a1, a1
; RV32IMB-NEXT:    slli a1, a1, 5
; RV32IMB-NEXT:    sub a1, a1, a3
; RV32IMB-NEXT:    sh1add a3, a0, a0
; RV32IMB-NEXT:    mulhu a2, a0, a2
; RV32IMB-NEXT:    slli a0, a0, 5
; RV32IMB-NEXT:    sub a3, a0, a3
; RV32IMB-NEXT:    lui a0, 14
; RV32IMB-NEXT:    addi a0, a0, -185
; RV32IMB-NEXT:    add a1, a2, a1
; RV32IMB-NEXT:    add a0, a3, a0
; RV32IMB-NEXT:    sltu a2, a0, a3
; RV32IMB-NEXT:    add a1, a1, a2
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_reject_a3:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 1971
; RV64IMB-NEXT:    sh1add a1, a0, a0
; RV64IMB-NEXT:    slli a0, a0, 5
; RV64IMB-NEXT:    sub a0, a0, a1
; RV64IMB-NEXT:    ret
  %tmp0 = add i64 %x, 1971
  %tmp1 = mul i64 %tmp0, 29
  ret i64 %tmp1
}

define i32 @add_mul_combine_reject_c1(i32 %x) {
; RV32IMB-LABEL: add_mul_combine_reject_c1:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, 1000
; RV32IMB-NEXT:    sh3add a1, a0, a0
; RV32IMB-NEXT:    sh3add a0, a1, a0
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_reject_c1:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 1000
; RV64IMB-NEXT:    sh3add a1, a0, a0
; RV64IMB-NEXT:    sh3add a0, a1, a0
; RV64IMB-NEXT:    sext.w a0, a0
; RV64IMB-NEXT:    ret
  %tmp0 = add i32 %x, 1000
  %tmp1 = mul i32 %tmp0, 73
  ret i32 %tmp1
}

define signext i32 @add_mul_combine_reject_c2(i32 signext %x) {
; RV32IMB-LABEL: add_mul_combine_reject_c2:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, 1000
; RV32IMB-NEXT:    sh3add a1, a0, a0
; RV32IMB-NEXT:    sh3add a0, a1, a0
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_reject_c2:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 1000
; RV64IMB-NEXT:    sh3add a1, a0, a0
; RV64IMB-NEXT:    sh3add a0, a1, a0
; RV64IMB-NEXT:    sext.w a0, a0
; RV64IMB-NEXT:    ret
  %tmp0 = add i32 %x, 1000
  %tmp1 = mul i32 %tmp0, 73
  ret i32 %tmp1
}

define i64 @add_mul_combine_reject_c3(i64 %x) {
; RV32IMB-LABEL: add_mul_combine_reject_c3:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    li a2, 73
; RV32IMB-NEXT:    sh3add a3, a1, a1
; RV32IMB-NEXT:    sh3add a1, a3, a1
; RV32IMB-NEXT:    sh3add a3, a0, a0
; RV32IMB-NEXT:    mulhu a2, a0, a2
; RV32IMB-NEXT:    sh3add a3, a3, a0
; RV32IMB-NEXT:    lui a0, 18
; RV32IMB-NEXT:    addi a0, a0, -728
; RV32IMB-NEXT:    add a1, a2, a1
; RV32IMB-NEXT:    add a0, a3, a0
; RV32IMB-NEXT:    sltu a2, a0, a3
; RV32IMB-NEXT:    add a1, a1, a2
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_reject_c3:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 1000
; RV64IMB-NEXT:    sh3add a1, a0, a0
; RV64IMB-NEXT:    sh3add a0, a1, a0
; RV64IMB-NEXT:    ret
  %tmp0 = add i64 %x, 1000
  %tmp1 = mul i64 %tmp0, 73
  ret i64 %tmp1
}

define i32 @add_mul_combine_reject_d1(i32 %x) {
; RV32IMB-LABEL: add_mul_combine_reject_d1:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, 1000
; RV32IMB-NEXT:    sh1add a0, a0, a0
; RV32IMB-NEXT:    slli a0, a0, 6
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_reject_d1:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 1000
; RV64IMB-NEXT:    sh1add a0, a0, a0
; RV64IMB-NEXT:    slliw a0, a0, 6
; RV64IMB-NEXT:    ret
  %tmp0 = add i32 %x, 1000
  %tmp1 = mul i32 %tmp0, 192
  ret i32 %tmp1
}

define signext i32 @add_mul_combine_reject_d2(i32 signext %x) {
; RV32IMB-LABEL: add_mul_combine_reject_d2:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, 1000
; RV32IMB-NEXT:    sh1add a0, a0, a0
; RV32IMB-NEXT:    slli a0, a0, 6
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_reject_d2:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 1000
; RV64IMB-NEXT:    sh1add a0, a0, a0
; RV64IMB-NEXT:    slliw a0, a0, 6
; RV64IMB-NEXT:    ret
  %tmp0 = add i32 %x, 1000
  %tmp1 = mul i32 %tmp0, 192
  ret i32 %tmp1
}

define i64 @add_mul_combine_reject_d3(i64 %x) {
; RV32IMB-LABEL: add_mul_combine_reject_d3:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    li a2, 192
; RV32IMB-NEXT:    sh1add a1, a1, a1
; RV32IMB-NEXT:    mulhu a2, a0, a2
; RV32IMB-NEXT:    sh1add a0, a0, a0
; RV32IMB-NEXT:    slli a1, a1, 6
; RV32IMB-NEXT:    add a1, a2, a1
; RV32IMB-NEXT:    lui a2, 47
; RV32IMB-NEXT:    slli a3, a0, 6
; RV32IMB-NEXT:    addi a0, a2, -512
; RV32IMB-NEXT:    add a0, a3, a0
; RV32IMB-NEXT:    sltu a2, a0, a3
; RV32IMB-NEXT:    add a1, a1, a2
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_reject_d3:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 1000
; RV64IMB-NEXT:    sh1add a0, a0, a0
; RV64IMB-NEXT:    slli a0, a0, 6
; RV64IMB-NEXT:    ret
  %tmp0 = add i64 %x, 1000
  %tmp1 = mul i64 %tmp0, 192
  ret i64 %tmp1
}

define i32 @add_mul_combine_reject_e1(i32 %x) {
; RV32IMB-LABEL: add_mul_combine_reject_e1:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, 1971
; RV32IMB-NEXT:    sh1add a1, a0, a0
; RV32IMB-NEXT:    slli a0, a0, 5
; RV32IMB-NEXT:    sub a0, a0, a1
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_reject_e1:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 1971
; RV64IMB-NEXT:    sh1add a1, a0, a0
; RV64IMB-NEXT:    slli a0, a0, 5
; RV64IMB-NEXT:    subw a0, a0, a1
; RV64IMB-NEXT:    ret
  %tmp0 = mul i32 %x, 29
  %tmp1 = add i32 %tmp0, 57159
  ret i32 %tmp1
}

define signext i32 @add_mul_combine_reject_e2(i32 signext %x) {
; RV32IMB-LABEL: add_mul_combine_reject_e2:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, 1971
; RV32IMB-NEXT:    sh1add a1, a0, a0
; RV32IMB-NEXT:    slli a0, a0, 5
; RV32IMB-NEXT:    sub a0, a0, a1
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_reject_e2:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 1971
; RV64IMB-NEXT:    sh1add a1, a0, a0
; RV64IMB-NEXT:    slli a0, a0, 5
; RV64IMB-NEXT:    subw a0, a0, a1
; RV64IMB-NEXT:    ret
  %tmp0 = mul i32 %x, 29
  %tmp1 = add i32 %tmp0, 57159
  ret i32 %tmp1
}

define i64 @add_mul_combine_reject_e3(i64 %x) {
; RV32IMB-LABEL: add_mul_combine_reject_e3:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    li a2, 29
; RV32IMB-NEXT:    sh1add a3, a1, a1
; RV32IMB-NEXT:    slli a1, a1, 5
; RV32IMB-NEXT:    sub a1, a1, a3
; RV32IMB-NEXT:    sh1add a3, a0, a0
; RV32IMB-NEXT:    mulhu a2, a0, a2
; RV32IMB-NEXT:    slli a0, a0, 5
; RV32IMB-NEXT:    sub a3, a0, a3
; RV32IMB-NEXT:    lui a0, 14
; RV32IMB-NEXT:    addi a0, a0, -185
; RV32IMB-NEXT:    add a1, a2, a1
; RV32IMB-NEXT:    add a0, a3, a0
; RV32IMB-NEXT:    sltu a2, a0, a3
; RV32IMB-NEXT:    add a1, a1, a2
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_reject_e3:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 1971
; RV64IMB-NEXT:    sh1add a1, a0, a0
; RV64IMB-NEXT:    slli a0, a0, 5
; RV64IMB-NEXT:    sub a0, a0, a1
; RV64IMB-NEXT:    ret
  %tmp0 = mul i64 %x, 29
  %tmp1 = add i64 %tmp0, 57159
  ret i64 %tmp1
}

define i32 @add_mul_combine_reject_f1(i32 %x) {
; RV32IMB-LABEL: add_mul_combine_reject_f1:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, 1972
; RV32IMB-NEXT:    sh1add a1, a0, a0
; RV32IMB-NEXT:    slli a0, a0, 5
; RV32IMB-NEXT:    sub a0, a0, a1
; RV32IMB-NEXT:    addi a0, a0, 11
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_reject_f1:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 1972
; RV64IMB-NEXT:    sh1add a1, a0, a0
; RV64IMB-NEXT:    slli a0, a0, 5
; RV64IMB-NEXT:    sub a0, a0, a1
; RV64IMB-NEXT:    addiw a0, a0, 11
; RV64IMB-NEXT:    ret
  %tmp0 = mul i32 %x, 29
  %tmp1 = add i32 %tmp0, 57199
  ret i32 %tmp1
}

define signext i32 @add_mul_combine_reject_f2(i32 signext %x) {
; RV32IMB-LABEL: add_mul_combine_reject_f2:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, 1972
; RV32IMB-NEXT:    sh1add a1, a0, a0
; RV32IMB-NEXT:    slli a0, a0, 5
; RV32IMB-NEXT:    sub a0, a0, a1
; RV32IMB-NEXT:    addi a0, a0, 11
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_reject_f2:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 1972
; RV64IMB-NEXT:    sh1add a1, a0, a0
; RV64IMB-NEXT:    slli a0, a0, 5
; RV64IMB-NEXT:    sub a0, a0, a1
; RV64IMB-NEXT:    addiw a0, a0, 11
; RV64IMB-NEXT:    ret
  %tmp0 = mul i32 %x, 29
  %tmp1 = add i32 %tmp0, 57199
  ret i32 %tmp1
}

define i64 @add_mul_combine_reject_f3(i64 %x) {
; RV32IMB-LABEL: add_mul_combine_reject_f3:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    li a2, 29
; RV32IMB-NEXT:    sh1add a3, a1, a1
; RV32IMB-NEXT:    slli a1, a1, 5
; RV32IMB-NEXT:    sub a1, a1, a3
; RV32IMB-NEXT:    sh1add a3, a0, a0
; RV32IMB-NEXT:    mulhu a2, a0, a2
; RV32IMB-NEXT:    slli a0, a0, 5
; RV32IMB-NEXT:    sub a3, a0, a3
; RV32IMB-NEXT:    lui a0, 14
; RV32IMB-NEXT:    addi a0, a0, -145
; RV32IMB-NEXT:    add a1, a2, a1
; RV32IMB-NEXT:    add a0, a3, a0
; RV32IMB-NEXT:    sltu a2, a0, a3
; RV32IMB-NEXT:    add a1, a1, a2
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_reject_f3:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 1972
; RV64IMB-NEXT:    sh1add a1, a0, a0
; RV64IMB-NEXT:    slli a0, a0, 5
; RV64IMB-NEXT:    sub a0, a0, a1
; RV64IMB-NEXT:    addi a0, a0, 11
; RV64IMB-NEXT:    ret
  %tmp0 = mul i64 %x, 29
  %tmp1 = add i64 %tmp0, 57199
  ret i64 %tmp1
}

define i32 @add_mul_combine_reject_g1(i32 %x) {
; RV32IMB-LABEL: add_mul_combine_reject_g1:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, 100
; RV32IMB-NEXT:    sh3add a1, a0, a0
; RV32IMB-NEXT:    sh3add a0, a1, a0
; RV32IMB-NEXT:    addi a0, a0, 10
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_reject_g1:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 100
; RV64IMB-NEXT:    sh3add a1, a0, a0
; RV64IMB-NEXT:    sh3add a0, a1, a0
; RV64IMB-NEXT:    addiw a0, a0, 10
; RV64IMB-NEXT:    ret
  %tmp0 = mul i32 %x, 73
  %tmp1 = add i32 %tmp0, 7310
  ret i32 %tmp1
}

define signext i32 @add_mul_combine_reject_g2(i32 signext %x) {
; RV32IMB-LABEL: add_mul_combine_reject_g2:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, 100
; RV32IMB-NEXT:    sh3add a1, a0, a0
; RV32IMB-NEXT:    sh3add a0, a1, a0
; RV32IMB-NEXT:    addi a0, a0, 10
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_reject_g2:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 100
; RV64IMB-NEXT:    sh3add a1, a0, a0
; RV64IMB-NEXT:    sh3add a0, a1, a0
; RV64IMB-NEXT:    addiw a0, a0, 10
; RV64IMB-NEXT:    ret
  %tmp0 = mul i32 %x, 73
  %tmp1 = add i32 %tmp0, 7310
  ret i32 %tmp1
}

define i64 @add_mul_combine_reject_g3(i64 %x) {
; RV32IMB-LABEL: add_mul_combine_reject_g3:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    li a2, 73
; RV32IMB-NEXT:    sh3add a3, a1, a1
; RV32IMB-NEXT:    sh3add a1, a3, a1
; RV32IMB-NEXT:    sh3add a3, a0, a0
; RV32IMB-NEXT:    mulhu a2, a0, a2
; RV32IMB-NEXT:    sh3add a3, a3, a0
; RV32IMB-NEXT:    lui a0, 2
; RV32IMB-NEXT:    addi a0, a0, -882
; RV32IMB-NEXT:    add a1, a2, a1
; RV32IMB-NEXT:    add a0, a3, a0
; RV32IMB-NEXT:    sltu a2, a0, a3
; RV32IMB-NEXT:    add a1, a1, a2
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_reject_g3:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 100
; RV64IMB-NEXT:    sh3add a1, a0, a0
; RV64IMB-NEXT:    sh3add a0, a1, a0
; RV64IMB-NEXT:    addi a0, a0, 10
; RV64IMB-NEXT:    ret
  %tmp0 = mul i64 %x, 73
  %tmp1 = add i64 %tmp0, 7310
  ret i64 %tmp1
}

; This test previously infinite looped in DAG combine.
define i64 @add_mul_combine_infinite_loop(i64 %x) {
; RV32IMB-LABEL: add_mul_combine_infinite_loop:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    li a2, 24
; RV32IMB-NEXT:    sh1add a1, a1, a1
; RV32IMB-NEXT:    sh1add a3, a0, a0
; RV32IMB-NEXT:    mulhu a0, a0, a2
; RV32IMB-NEXT:    li a2, 1
; RV32IMB-NEXT:    sh3add a1, a1, a0
; RV32IMB-NEXT:    slli a4, a3, 3
; RV32IMB-NEXT:    slli a2, a2, 11
; RV32IMB-NEXT:    sh3add a0, a3, a2
; RV32IMB-NEXT:    sltu a2, a0, a4
; RV32IMB-NEXT:    add a1, a1, a2
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: add_mul_combine_infinite_loop:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 86
; RV64IMB-NEXT:    sh1add a0, a0, a0
; RV64IMB-NEXT:    slli a0, a0, 3
; RV64IMB-NEXT:    addi a0, a0, -16
; RV64IMB-NEXT:    ret
  %tmp0 = mul i64 %x, 24
  %tmp1 = add i64 %tmp0, 2048
  ret i64 %tmp1
}

define i32 @mul3000_add8990_a(i32 %x) {
; RV32IMB-LABEL: mul3000_add8990_a:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, 3
; RV32IMB-NEXT:    lui a1, 1
; RV32IMB-NEXT:    addi a1, a1, -1096
; RV32IMB-NEXT:    mul a0, a0, a1
; RV32IMB-NEXT:    addi a0, a0, -10
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: mul3000_add8990_a:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 3
; RV64IMB-NEXT:    lui a1, 1
; RV64IMB-NEXT:    addi a1, a1, -1096
; RV64IMB-NEXT:    mul a0, a0, a1
; RV64IMB-NEXT:    addiw a0, a0, -10
; RV64IMB-NEXT:    ret
  %tmp0 = mul i32 %x, 3000
  %tmp1 = add i32 %tmp0, 8990
  ret i32 %tmp1
}

define signext i32 @mul3000_add8990_b(i32 signext %x) {
; RV32IMB-LABEL: mul3000_add8990_b:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, 3
; RV32IMB-NEXT:    lui a1, 1
; RV32IMB-NEXT:    addi a1, a1, -1096
; RV32IMB-NEXT:    mul a0, a0, a1
; RV32IMB-NEXT:    addi a0, a0, -10
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: mul3000_add8990_b:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 3
; RV64IMB-NEXT:    lui a1, 1
; RV64IMB-NEXT:    addi a1, a1, -1096
; RV64IMB-NEXT:    mul a0, a0, a1
; RV64IMB-NEXT:    addiw a0, a0, -10
; RV64IMB-NEXT:    ret
  %tmp0 = mul i32 %x, 3000
  %tmp1 = add i32 %tmp0, 8990
  ret i32 %tmp1
}

define i64 @mul3000_add8990_c(i64 %x) {
; RV32IMB-LABEL: mul3000_add8990_c:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    lui a2, 1
; RV32IMB-NEXT:    addi a2, a2, -1096
; RV32IMB-NEXT:    mul a1, a1, a2
; RV32IMB-NEXT:    mulhu a3, a0, a2
; RV32IMB-NEXT:    mul a2, a0, a2
; RV32IMB-NEXT:    lui a0, 2
; RV32IMB-NEXT:    addi a0, a0, 798
; RV32IMB-NEXT:    add a1, a3, a1
; RV32IMB-NEXT:    add a0, a2, a0
; RV32IMB-NEXT:    sltu a2, a0, a2
; RV32IMB-NEXT:    add a1, a1, a2
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: mul3000_add8990_c:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 3
; RV64IMB-NEXT:    lui a1, 1
; RV64IMB-NEXT:    addi a1, a1, -1096
; RV64IMB-NEXT:    mul a0, a0, a1
; RV64IMB-NEXT:    addi a0, a0, -10
; RV64IMB-NEXT:    ret
  %tmp0 = mul i64 %x, 3000
  %tmp1 = add i64 %tmp0, 8990
  ret i64 %tmp1
}

define i32 @mul3000_sub8990_a(i32 %x) {
; RV32IMB-LABEL: mul3000_sub8990_a:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, -3
; RV32IMB-NEXT:    lui a1, 1
; RV32IMB-NEXT:    addi a1, a1, -1096
; RV32IMB-NEXT:    mul a0, a0, a1
; RV32IMB-NEXT:    addi a0, a0, 10
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: mul3000_sub8990_a:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, -3
; RV64IMB-NEXT:    lui a1, 1
; RV64IMB-NEXT:    addi a1, a1, -1096
; RV64IMB-NEXT:    mul a0, a0, a1
; RV64IMB-NEXT:    addiw a0, a0, 10
; RV64IMB-NEXT:    ret
  %tmp0 = mul i32 %x, 3000
  %tmp1 = add i32 %tmp0, -8990
  ret i32 %tmp1
}

define signext i32 @mul3000_sub8990_b(i32 signext %x) {
; RV32IMB-LABEL: mul3000_sub8990_b:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, -3
; RV32IMB-NEXT:    lui a1, 1
; RV32IMB-NEXT:    addi a1, a1, -1096
; RV32IMB-NEXT:    mul a0, a0, a1
; RV32IMB-NEXT:    addi a0, a0, 10
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: mul3000_sub8990_b:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, -3
; RV64IMB-NEXT:    lui a1, 1
; RV64IMB-NEXT:    addi a1, a1, -1096
; RV64IMB-NEXT:    mul a0, a0, a1
; RV64IMB-NEXT:    addiw a0, a0, 10
; RV64IMB-NEXT:    ret
  %tmp0 = mul i32 %x, 3000
  %tmp1 = add i32 %tmp0, -8990
  ret i32 %tmp1
}

define i64 @mul3000_sub8990_c(i64 %x) {
; RV32IMB-LABEL: mul3000_sub8990_c:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    lui a2, 1
; RV32IMB-NEXT:    addi a2, a2, -1096
; RV32IMB-NEXT:    mul a1, a1, a2
; RV32IMB-NEXT:    mulhu a3, a0, a2
; RV32IMB-NEXT:    mul a2, a0, a2
; RV32IMB-NEXT:    lui a0, 1048574
; RV32IMB-NEXT:    addi a0, a0, -798
; RV32IMB-NEXT:    add a1, a3, a1
; RV32IMB-NEXT:    add a0, a2, a0
; RV32IMB-NEXT:    sltu a2, a0, a2
; RV32IMB-NEXT:    add a1, a1, a2
; RV32IMB-NEXT:    addi a1, a1, -1
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: mul3000_sub8990_c:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, -3
; RV64IMB-NEXT:    lui a1, 1
; RV64IMB-NEXT:    addi a1, a1, -1096
; RV64IMB-NEXT:    mul a0, a0, a1
; RV64IMB-NEXT:    addi a0, a0, 10
; RV64IMB-NEXT:    ret
  %tmp0 = mul i64 %x, 3000
  %tmp1 = add i64 %tmp0, -8990
  ret i64 %tmp1
}

define i32 @mulneg3000_add8990_a(i32 %x) {
; RV32IMB-LABEL: mulneg3000_add8990_a:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, -3
; RV32IMB-NEXT:    lui a1, 1048575
; RV32IMB-NEXT:    addi a1, a1, 1096
; RV32IMB-NEXT:    mul a0, a0, a1
; RV32IMB-NEXT:    addi a0, a0, -10
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: mulneg3000_add8990_a:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, -3
; RV64IMB-NEXT:    lui a1, 1048575
; RV64IMB-NEXT:    addi a1, a1, 1096
; RV64IMB-NEXT:    mul a0, a0, a1
; RV64IMB-NEXT:    addiw a0, a0, -10
; RV64IMB-NEXT:    ret
  %tmp0 = mul i32 %x, -3000
  %tmp1 = add i32 %tmp0, 8990
  ret i32 %tmp1
}

define signext i32 @mulneg3000_add8990_b(i32 signext %x) {
; RV32IMB-LABEL: mulneg3000_add8990_b:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, -3
; RV32IMB-NEXT:    lui a1, 1048575
; RV32IMB-NEXT:    addi a1, a1, 1096
; RV32IMB-NEXT:    mul a0, a0, a1
; RV32IMB-NEXT:    addi a0, a0, -10
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: mulneg3000_add8990_b:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, -3
; RV64IMB-NEXT:    lui a1, 1048575
; RV64IMB-NEXT:    addi a1, a1, 1096
; RV64IMB-NEXT:    mul a0, a0, a1
; RV64IMB-NEXT:    addiw a0, a0, -10
; RV64IMB-NEXT:    ret
  %tmp0 = mul i32 %x, -3000
  %tmp1 = add i32 %tmp0, 8990
  ret i32 %tmp1
}

define i64 @mulneg3000_add8990_c(i64 %x) {
; RV32IMB-LABEL: mulneg3000_add8990_c:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    lui a2, 1048575
; RV32IMB-NEXT:    addi a2, a2, 1096
; RV32IMB-NEXT:    mul a1, a1, a2
; RV32IMB-NEXT:    mulhu a3, a0, a2
; RV32IMB-NEXT:    mul a2, a0, a2
; RV32IMB-NEXT:    sub a3, a3, a0
; RV32IMB-NEXT:    lui a0, 2
; RV32IMB-NEXT:    addi a0, a0, 798
; RV32IMB-NEXT:    add a0, a2, a0
; RV32IMB-NEXT:    add a1, a3, a1
; RV32IMB-NEXT:    sltu a2, a0, a2
; RV32IMB-NEXT:    add a1, a1, a2
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: mulneg3000_add8990_c:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, -3
; RV64IMB-NEXT:    lui a1, 1048575
; RV64IMB-NEXT:    addi a1, a1, 1096
; RV64IMB-NEXT:    mul a0, a0, a1
; RV64IMB-NEXT:    addi a0, a0, -10
; RV64IMB-NEXT:    ret
  %tmp0 = mul i64 %x, -3000
  %tmp1 = add i64 %tmp0, 8990
  ret i64 %tmp1
}

define i32 @mulneg3000_sub8990_a(i32 %x) {
; RV32IMB-LABEL: mulneg3000_sub8990_a:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, 3
; RV32IMB-NEXT:    lui a1, 1048575
; RV32IMB-NEXT:    addi a1, a1, 1096
; RV32IMB-NEXT:    mul a0, a0, a1
; RV32IMB-NEXT:    addi a0, a0, 10
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: mulneg3000_sub8990_a:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 3
; RV64IMB-NEXT:    lui a1, 1048575
; RV64IMB-NEXT:    addi a1, a1, 1096
; RV64IMB-NEXT:    mul a0, a0, a1
; RV64IMB-NEXT:    addiw a0, a0, 10
; RV64IMB-NEXT:    ret
  %tmp0 = mul i32 %x, -3000
  %tmp1 = add i32 %tmp0, -8990
  ret i32 %tmp1
}

define signext i32 @mulneg3000_sub8990_b(i32 signext %x) {
; RV32IMB-LABEL: mulneg3000_sub8990_b:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    addi a0, a0, 3
; RV32IMB-NEXT:    lui a1, 1048575
; RV32IMB-NEXT:    addi a1, a1, 1096
; RV32IMB-NEXT:    mul a0, a0, a1
; RV32IMB-NEXT:    addi a0, a0, 10
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: mulneg3000_sub8990_b:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 3
; RV64IMB-NEXT:    lui a1, 1048575
; RV64IMB-NEXT:    addi a1, a1, 1096
; RV64IMB-NEXT:    mul a0, a0, a1
; RV64IMB-NEXT:    addiw a0, a0, 10
; RV64IMB-NEXT:    ret
  %tmp0 = mul i32 %x, -3000
  %tmp1 = add i32 %tmp0, -8990
  ret i32 %tmp1
}

define i64 @mulneg3000_sub8990_c(i64 %x) {
; RV32IMB-LABEL: mulneg3000_sub8990_c:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    lui a2, 1048575
; RV32IMB-NEXT:    addi a2, a2, 1096
; RV32IMB-NEXT:    mul a1, a1, a2
; RV32IMB-NEXT:    mulhu a3, a0, a2
; RV32IMB-NEXT:    mul a2, a0, a2
; RV32IMB-NEXT:    sub a3, a3, a0
; RV32IMB-NEXT:    lui a0, 1048574
; RV32IMB-NEXT:    addi a0, a0, -798
; RV32IMB-NEXT:    add a0, a2, a0
; RV32IMB-NEXT:    add a1, a3, a1
; RV32IMB-NEXT:    sltu a2, a0, a2
; RV32IMB-NEXT:    add a1, a1, a2
; RV32IMB-NEXT:    addi a1, a1, -1
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: mulneg3000_sub8990_c:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    addi a0, a0, 3
; RV64IMB-NEXT:    lui a1, 1048575
; RV64IMB-NEXT:    addi a1, a1, 1096
; RV64IMB-NEXT:    mul a0, a0, a1
; RV64IMB-NEXT:    addi a0, a0, 10
; RV64IMB-NEXT:    ret
  %tmp0 = mul i64 %x, -3000
  %tmp1 = add i64 %tmp0, -8990
  ret i64 %tmp1
}

; This test case previously caused an infinite loop between transformations
; performed in RISCVISelLowering;:transformAddImmMulImm and
; DAGCombiner::visitMUL.
define i1 @pr53831(i32 %x) {
; RV32IMB-LABEL: pr53831:
; RV32IMB:       # %bb.0:
; RV32IMB-NEXT:    li a0, 0
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: pr53831:
; RV64IMB:       # %bb.0:
; RV64IMB-NEXT:    li a0, 0
; RV64IMB-NEXT:    ret
  %tmp0 = add i32 %x, 1
  %tmp1 = mul i32 %tmp0, 24
  %tmp2 = add i32 %tmp1, 1
  %tmp3 = mul i32 %x, 24
  %tmp4 = add i32 %tmp3, 2048
  %tmp5 = icmp eq i32 %tmp4, %tmp2
  ret i1 %tmp5
}

define i64 @sh2add_uw(i64 signext %0, i32 signext %1) {
; RV32IMB-LABEL: sh2add_uw:
; RV32IMB:       # %bb.0: # %entry
; RV32IMB-NEXT:    srli a3, a2, 27
; RV32IMB-NEXT:    slli a2, a2, 5
; RV32IMB-NEXT:    srli a4, a0, 29
; RV32IMB-NEXT:    sh3add a1, a1, a4
; RV32IMB-NEXT:    sh3add a0, a0, a2
; RV32IMB-NEXT:    sltu a2, a0, a2
; RV32IMB-NEXT:    add a1, a3, a1
; RV32IMB-NEXT:    add a1, a1, a2
; RV32IMB-NEXT:    ret
;
; RV64IMB-LABEL: sh2add_uw:
; RV64IMB:       # %bb.0: # %entry
; RV64IMB-NEXT:    sh2add.uw a0, a1, a0
; RV64IMB-NEXT:    slli a0, a0, 3
; RV64IMB-NEXT:    ret
entry:
  %2 = zext i32 %1 to i64
  %3 = shl i64 %2, 5
  %4 = shl i64 %0, 3
  %5 = add i64 %3, %4
  ret i64 %5
}
