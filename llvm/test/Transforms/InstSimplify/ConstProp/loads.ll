; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -data-layout="e-p:64:64:64-p1:16:16:16-p2:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-ni:2" -passes=instsimplify -S | FileCheck %s --check-prefixes=CHECK,LE
; RUN: opt < %s -data-layout="E-p:64:64:64-p1:16:16:16-p2:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-ni:2" -passes=instsimplify -S | FileCheck %s --check-prefixes=CHECK,BE

; {{ 0xDEADBEEF, 0xBA }, 0xCAFEBABE}
@g1 = constant {{i32,i8},i32} {{i32,i8} { i32 -559038737, i8 186 }, i32 -889275714 }
@g2 = constant double 1.0
; { 0x7B, 0x06B1BFF8 }
@g3 = constant {i64, i64} { i64 123, i64 112312312 }

; Simple load
define i32 @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i32 -559038737
;
  %r = load i32, ptr getelementptr ({{i32,i8},i32}, ptr @g1, i32 0, i32 0, i32 0)
  ret i32 %r
}

; PR3152
; Load of first 16 bits of 32-bit value.
define i16 @test2() {
; LE-LABEL: @test2(
; LE-NEXT:    ret i16 -16657
;
; BE-LABEL: @test2(
; BE-NEXT:    ret i16 -8531
;
  %r = load i16, ptr getelementptr ({{i32,i8},i32}, ptr @g1, i32 0, i32 0, i32 0)
  ret i16 %r
}

define i16 @test2_addrspacecast() {
; LE-LABEL: @test2_addrspacecast(
; LE-NEXT:    ret i16 -16657
;
; BE-LABEL: @test2_addrspacecast(
; BE-NEXT:    ret i16 -8531
;
  %r = load i16, ptr addrspace(1) addrspacecast(ptr getelementptr ({{i32,i8},i32}, ptr @g1, i32 0, i32 0, i32 0) to ptr addrspace(1))
  ret i16 %r
}

; Load of second 16 bits of 32-bit value.
define i16 @test3() {
; LE-LABEL: @test3(
; LE-NEXT:    ret i16 -8531
;
; BE-LABEL: @test3(
; BE-NEXT:    ret i16 -16657
;
  %r = load i16, ptr getelementptr(i16, ptr getelementptr ({{i32,i8},i32}, ptr @g1, i32 0, i32 0, i32 0), i32 1)
  ret i16 %r
}

; Load of 8 bit field + tail padding.
define i16 @test4() {
; LE-LABEL: @test4(
; LE-NEXT:    ret i16 186
;
; BE-LABEL: @test4(
; BE-NEXT:    ret i16 -17920
;
  %r = load i16, ptr getelementptr(i16, ptr getelementptr ({{i32,i8},i32}, ptr @g1, i32 0, i32 0, i32 0), i32 2)
  ret i16 %r
}

; Load of double bits.
define i64 @test6() {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    ret i64 4607182418800017408
;
  %r = load i64, ptr @g2
  ret i64 %r
}

; Load of double bits.
define i16 @test7() {
; LE-LABEL: @test7(
; LE-NEXT:    ret i16 0
;
; BE-LABEL: @test7(
; BE-NEXT:    ret i16 16368
;
  %r = load i16, ptr @g2
  ret i16 %r
}

; Double load.
define double @test8() {
; LE-LABEL: @test8(
; LE-NEXT:    ret double 0xBADEADBEEF
;
; BE-LABEL: @test8(
; BE-NEXT:    ret double 0xDEADBEEFBA000000
;
  %r = load double, ptr @g1
  ret double %r
}


; i128 load.
define i128 @test_i128() {
; LE-LABEL: @test_i128(
; LE-NEXT:    ret i128 2071796475790618158476296315
;
; BE-LABEL: @test_i128(
; BE-NEXT:    ret i128 2268949521066387161080
;
  %r = load i128, ptr @g3
  ret i128 %r
}

define fp128 @test_fp128() {
; LE-LABEL: @test_fp128(
; LE-NEXT:    ret fp128 0xL000000000000007B0000000006B1BFF8
;
; BE-LABEL: @test_fp128(
; BE-NEXT:    ret fp128 0xL0000000006B1BFF8000000000000007B
;
  %r = load fp128, ptr @g3
  ret fp128 %r
}

define ppc_fp128 @test_ppc_fp128() {
; LE-LABEL: @test_ppc_fp128(
; LE-NEXT:    ret ppc_fp128 bitcast (i128 2071796475790618158476296315 to ppc_fp128)
;
; BE-LABEL: @test_ppc_fp128(
; BE-NEXT:    ret ppc_fp128 bitcast (i128 2268949521066387161080 to ppc_fp128)
;
  %r = load ppc_fp128, ptr @g3
  ret ppc_fp128 %r
}

define x86_fp80 @test_x86_fp80() {
; LE-LABEL: @test_x86_fp80(
; LE-NEXT:    ret x86_fp80 0xKFFFF000000000000007B
;
; BE-LABEL: @test_x86_fp80(
; BE-NEXT:    ret x86_fp80 0xK000000000000007B0000
;
  %r = load x86_fp80, ptr @g3
  ret x86_fp80 %r
}

define bfloat @test_bfloat() {
; LE-LABEL: @test_bfloat(
; LE-NEXT:    ret bfloat 0xR007B
;
; BE-LABEL: @test_bfloat(
; BE-NEXT:    ret bfloat 0xR0000
;
  %r = load bfloat, ptr @g3
  ret bfloat %r
}

; vector load.
define <2 x i64> @test10() {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    ret <2 x i64> <i64 123, i64 112312312>
;
  %r = load <2 x i64>, ptr @g3
  ret <2 x i64> %r
}


; PR5287
; { 0xA1, 0x08 }
@g4 = internal constant { i8, i8 } { i8 -95, i8 8 }

define i16 @test11() nounwind {
; LE-LABEL: @test11(
; LE-NEXT:  entry:
; LE-NEXT:    ret i16 2209
;
; BE-LABEL: @test11(
; BE-NEXT:  entry:
; BE-NEXT:    ret i16 -24312
;
entry:
  %a = load i16, ptr @g4
  ret i16 %a
}


; PR5551
@test12g = private constant [6 x i8] c"a\00b\00\00\00"

define i16 @test12() {
; LE-LABEL: @test12(
; LE-NEXT:    ret i16 98
;
; BE-LABEL: @test12(
; BE-NEXT:    ret i16 25088
;
  %a = load i16, ptr getelementptr inbounds ([3 x i16], ptr @test12g, i32 0, i64 1)
  ret i16 %a
}


; PR5978
@g5 = constant i8 4
define i1 @test13() {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    ret i1 false
;
  %A = load i1, ptr @g5
  ret i1 %A
}

@g6 = constant [2 x ptr] [ptr inttoptr (i64 1 to ptr), ptr inttoptr (i64 2 to ptr)]
define i64 @test14() nounwind {
; CHECK-LABEL: @test14(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i64 1
;
entry:
  %tmp = load i64, ptr @g6
  ret i64 %tmp
}

; Check with address space pointers
@g6_as1 = constant [2 x ptr addrspace(1)] [ptr addrspace(1) inttoptr (i16 1 to ptr addrspace(1)), ptr addrspace(1) inttoptr (i16 2 to ptr addrspace(1))]
define i16 @test14_as1() nounwind {
; CHECK-LABEL: @test14_as1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i16 1
;
entry:
  %tmp = load i16, ptr @g6_as1
  ret i16 %tmp
}

define i64 @test15() nounwind {
; CHECK-LABEL: @test15(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i64 2
;
entry:
  %tmp = load i64, ptr getelementptr inbounds ([2 x ptr], ptr @g6, i32 0, i64 1)
  ret i64 %tmp
}

@gv7 = constant [4 x ptr] [ptr null, ptr inttoptr (i64 -14 to ptr), ptr null, ptr null]
define i64 @test16.1() {
; CHECK-LABEL: @test16.1(
; CHECK-NEXT:    ret i64 0
;
  %v = load i64, ptr @gv7, align 8
  ret i64 %v
}

define i64 @test16.2() {
; CHECK-LABEL: @test16.2(
; CHECK-NEXT:    ret i64 -14
;
  %v = load i64, ptr getelementptr inbounds ([4 x ptr], ptr @gv7, i64 0, i64 1), align 8
  ret i64 %v
}

define i64 @test16.3() {
; CHECK-LABEL: @test16.3(
; CHECK-NEXT:    ret i64 0
;
  %v = load i64, ptr getelementptr inbounds ([4 x ptr], ptr @gv7, i64 0, i64 2), align 8
  ret i64 %v
}

@g7 = constant {[0 x i32], [0 x i8], ptr} { [0 x i32] poison, [0 x i8] poison, ptr null }

define ptr @test_leading_zero_size_elems() {
; CHECK-LABEL: @test_leading_zero_size_elems(
; CHECK-NEXT:    ret ptr null
;
  %v = load ptr, ptr @g7
  ret ptr %v
}

@g8 = constant {[4294967295 x [0 x i32]], i64} { [4294967295 x [0 x i32]] poison, i64 123 }

define i64 @test_leading_zero_size_elems_big() {
; CHECK-LABEL: @test_leading_zero_size_elems_big(
; CHECK-NEXT:    ret i64 123
;
  %v = load i64, ptr @g8
  ret i64 %v
}

@g9 = constant [4294967295 x [0 x i32]] zeroinitializer

define i64 @test_array_of_zero_size_array() {
; CHECK-LABEL: @test_array_of_zero_size_array(
; CHECK-NEXT:    ret i64 poison
;
  %v = load i64, ptr @g9
  ret i64 %v
}

@g_undef = constant { i128 } undef

define ptr @test_undef_aggregate() {
; CHECK-LABEL: @test_undef_aggregate(
; CHECK-NEXT:    ret ptr undef
;
  %v = load ptr, ptr @g_undef
  ret ptr %v
}

@g_poison = constant { i128 } poison

define ptr @test_poison_aggregate() {
; CHECK-LABEL: @test_poison_aggregate(
; CHECK-NEXT:    ret ptr poison
;
  %v = load ptr, ptr @g_poison
  ret ptr %v
}

@g11 = constant <{ [8 x i8], [8 x i8] }> <{ [8 x i8] poison, [8 x i8] zeroinitializer }>, align 4

define ptr @test_trailing_zero_gep_index() {
; CHECK-LABEL: @test_trailing_zero_gep_index(
; CHECK-NEXT:    ret ptr null
;
  %v = load ptr, ptr getelementptr inbounds (<{ [8 x i8], [8 x i8] }>, ptr @g11, i32 0, i32 1, i32 0), align 4
  ret ptr %v
}

define { i64, i64 } @test_load_struct() {
; CHECK-LABEL: @test_load_struct(
; CHECK-NEXT:    ret { i64, i64 } { i64 123, i64 112312312 }
;
  %v = load { i64, i64 }, ptr @g3
  ret { i64, i64 } %v
}

@g_offset = external global i64

@g_neg_one_vec = constant <4 x i8> <i8 -1, i8 -1, i8 -1, i8 -1>

define i8 @load_neg_one_at_unknown_offset() {
; CHECK-LABEL: @load_neg_one_at_unknown_offset(
; CHECK-NEXT:    ret i8 -1
;
  %v = load i8, ptr getelementptr (<4 x i8>, ptr @g_neg_one_vec, i64 0, i64 ptrtoint (ptr @g_offset to i64))
  ret i8 %v
}

@g_with_padding = constant { i32, [4 x i8] } { i32 0, [4 x i8] poison }

define i32 @load_padding() {
; CHECK-LABEL: @load_padding(
; CHECK-NEXT:    ret i32 poison
;
  %v = load i32, ptr getelementptr (i32, ptr @g_with_padding, i64 1)
  ret i32 %v
}

@g_all_poison = constant { i32, [4 x i8] } poison

; Same as the previous case, but with an all-poison initializer.
define i32 @load_all_poison() {
; CHECK-LABEL: @load_all_poison(
; CHECK-NEXT:    ret i32 poison
;
  %v = load i32, ptr getelementptr (i32, ptr @g_all_poison, i64 1)
  ret i32 %v
}

@g_i8_data = constant [16 x i8] c"\01\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00"

define ptr @load_ptr_from_i8_data() {
; LE-LABEL: @load_ptr_from_i8_data(
; LE-NEXT:    ret ptr inttoptr (i64 1 to ptr)
;
; BE-LABEL: @load_ptr_from_i8_data(
; BE-NEXT:    ret ptr inttoptr (i64 72057594037927936 to ptr)
;
  %v = load ptr, ptr @g_i8_data
  ret ptr %v
}

define ptr addrspace(2) @load_non_integral_ptr_from_i8_data() {
; CHECK-LABEL: @load_non_integral_ptr_from_i8_data(
; CHECK-NEXT:    [[V:%.*]] = load ptr addrspace(2), ptr @g_i8_data, align 8
; CHECK-NEXT:    ret ptr addrspace(2) [[V]]
;
  %v = load ptr addrspace(2), ptr @g_i8_data
  ret ptr addrspace(2) %v
}

@g_i1 = constant i1 true

define i8 @load_i8_from_i1() {
; CHECK-LABEL: @load_i8_from_i1(
; CHECK-NEXT:    [[V:%.*]] = load i8, ptr @g_i1, align 1
; CHECK-NEXT:    ret i8 [[V]]
;
  %v = load i8, ptr @g_i1
  ret i8 %v
}

@global9 = internal constant i9 -1

; Reproducer for https://github.com/llvm/llvm-project/issues/81793
define i8 @load_i8_from_i9() {
; CHECK-LABEL: @load_i8_from_i9(
; CHECK-NEXT:    [[V:%.*]] = load i8, ptr @global9, align 1
; CHECK-NEXT:    ret i8 [[V]]
;
  %v = load i8, ptr @global9
  ret i8 %v
}

define i9 @load_i9_from_i9() {
; CHECK-LABEL: @load_i9_from_i9(
; CHECK-NEXT:    ret i9 -1
;
  %v = load i9, ptr @global9
  ret i9 %v
}

; Reproducer for https://github.com/llvm/llvm-project/issues/81793
define i16 @load_i16_from_i17_store(ptr %p) {
; CHECK-LABEL: @load_i16_from_i17_store(
; CHECK-NEXT:    store i17 -1, ptr [[P:%.*]], align 4
; CHECK-NEXT:    [[V:%.*]] = load i16, ptr @global9, align 2
; CHECK-NEXT:    ret i16 [[V]]
;
  store i17 -1, ptr %p
  %v = load i16, ptr @global9
  ret i16 %v
}

@global128 = internal constant i128 1125899906842625
define i128 @load-128bit(){
; CHECK-LABEL: @load-128bit(
; CHECK-NEXT:    ret i128 1125899906842625
;
  %1 = load i128, ptr @global128, align 4
  ret i128 %1
}


@i40_struct = constant { i40, i8 } { i40 0, i8 1 }
@i40_array = constant [2 x i40] [i40 0, i40 1]

define i8 @load_i40_struct_padding() {
; CHECK-LABEL: @load_i40_struct_padding(
; CHECK-NEXT:    ret i8 0
;
  %v = load i8, ptr getelementptr (i8, ptr @i40_struct, i64 6)
  ret i8 %v
}

define i16 @load_i40_struct_partial_padding() {
; CHECK-LABEL: @load_i40_struct_partial_padding(
; CHECK-NEXT:    ret i16 0
;
  %v = load i16, ptr getelementptr (i8, ptr @i40_struct, i64 4)
  ret i16 %v
}

define i8 @load_i40_array_padding() {
; CHECK-LABEL: @load_i40_array_padding(
; CHECK-NEXT:    ret i8 0
;
  %v = load i8, ptr getelementptr (i8, ptr @i40_array, i64 6)
  ret i8 %v
}

define i16 @load_i40_array_partial_padding() {
; CHECK-LABEL: @load_i40_array_partial_padding(
; CHECK-NEXT:    ret i16 0
;
  %v = load i16, ptr getelementptr (i8, ptr @i40_array, i64 4)
  ret i16 %v
}
