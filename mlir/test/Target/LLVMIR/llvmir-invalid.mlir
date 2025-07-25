// RUN: mlir-translate -verify-diagnostics -split-input-file -mlir-to-llvmir %s

// expected-error @below{{cannot be converted to LLVM IR}}
func.func @foo() {
  llvm.return
}

// -----

// expected-error @below{{LLVM attribute 'readonly' does not expect a value}}
llvm.func @passthrough_unexpected_value() attributes {passthrough = [["readonly", "42"]]}

// -----

// expected-error @below{{LLVM attribute 'alignstack' expects a value}}
llvm.func @passthrough_expected_value() attributes {passthrough = ["alignstack"]}

// -----

// expected-error @below{{expected 'passthrough' to contain string or array attributes}}
llvm.func @passthrough_wrong_type() attributes {passthrough = [42]}

// -----

// expected-error @below{{expected arrays within 'passthrough' to contain two strings}}
llvm.func @passthrough_wrong_type() attributes {
  passthrough = [[ 42, 42 ]]
}

// -----

llvm.func @unary_float_intr_wrong_type(%arg0 : i32) -> i32 {
  // expected-error @below{{op operand #0 must be floating point LLVM type or LLVM dialect-compatible vector of floating point LLVM type}}
  %0 = "llvm.intr.exp"(%arg0) : (i32) -> i32
  llvm.return %0 : i32
}

// -----

llvm.func @binary_float_intr_wrong_type(%arg0 : f32, %arg1 : i32) -> i32 {
  // expected-error @below{{op operand #1 must be floating point LLVM type or LLVM dialect-compatible vector of floating point LLVM type}}
  %0 = "llvm.intr.pow"(%arg0, %arg1) : (f32, i32) -> i32
  llvm.return %0 : i32
}

// -----

llvm.func @unary_int_intr_wrong_type(%arg0 : f32) -> f32 {
  // expected-error @below{{op operand #0 must be signless integer or LLVM dialect-compatible vector of signless integer}}
  %0 = "llvm.intr.ctpop"(%arg0) : (f32) -> f32
  llvm.return %0 : f32
}

// -----

llvm.func @binary_int_intr_wrong_type(%arg0 : i32, %arg1 : f32) -> f32 {
  // expected-error @below{{op operand #1 must be signless integer or LLVM dialect-compatible vector of signless integer}}
  %0 = "llvm.intr.smax"(%arg0, %arg1) : (i32, f32) -> f32
  llvm.return %0 : f32
}

// -----

llvm.func @ternary_float_intr_wrong_type(%arg0 : f32, %arg1 : f32, %arg2 : i32) -> f32 {
  // expected-error @below{{op operand #2 must be floating point LLVM type or LLVM dialect-compatible vector of floating point LLVM type}}
  %0 = "llvm.intr.fma"(%arg0, %arg1, %arg2) : (f32, f32, i32) -> f32
  llvm.return %0 : f32
}

// -----

llvm.func @powi_intr_wrong_type(%arg0 : f32, %arg1 : f32) -> f32 {
  // expected-error @below{{op operand #1 must be signless integer, but got 'f32'}}
  %0 = "llvm.intr.powi"(%arg0, %arg1) : (f32, f32) -> f32
  llvm.return %0 : f32
}

// -----

llvm.func @memcpy_intr_wrong_type(%src : i64, %dst : i64, %len : i64) {
  // expected-error @below{{op operand #0 must be LLVM pointer type, but got 'i64'}}
  "llvm.intr.memcpy"(%src, %dst, %len) <{isVolatile = false}> : (i64, i64, i64) -> ()
  llvm.return
}

// -----

llvm.func @memmove_intr_wrong_type(%src : !llvm.ptr, %dst : i64, %len : i64) {
  // expected-error @below{{op operand #1 must be LLVM pointer type, but got 'i64'}}
  "llvm.intr.memmove"(%src, %dst, %len) <{isVolatile = false}> : (!llvm.ptr, i64, i64) -> ()
  llvm.return
}

// -----

llvm.func @memset_intr_wrong_type(%dst : !llvm.ptr, %val : i32, %len : i64) {
  // expected-error @below{{op operand #1 must be 8-bit signless integer, but got 'i32'}}
  "llvm.intr.memset"(%dst, %val, %len) <{isVolatile = false}> : (!llvm.ptr, i32, i64) -> ()
  llvm.return
}

// -----

llvm.func @sadd_overflow_intr_wrong_type(%arg0 : i32, %arg1 : f32) -> !llvm.struct<(i32, i1)> {
  // expected-error @below{{op operand #1 must be signless integer or LLVM dialect-compatible vector of signless integer, but got 'f32'}}
  %0 = "llvm.intr.sadd.with.overflow"(%arg0, %arg1) : (i32, f32) -> !llvm.struct<(i32, i1)>
  llvm.return %0 : !llvm.struct<(i32, i1)>
}

// -----

llvm.func @assume_intr_wrong_type(%cond : i16) {
  // expected-error @below{{op operand #0 must be 1-bit signless integer, but got 'i16'}}
  llvm.intr.assume %cond : i16
  llvm.return
}

// -----

llvm.func @vec_reduce_add_intr_wrong_type(%arg0 : vector<4xi32>) -> f32 {
  // expected-error @below{{op requires the same element type for all operands and results}}
  %0 = "llvm.intr.vector.reduce.add"(%arg0) : (vector<4xi32>) -> f32
  llvm.return %0 : f32
}

// -----

llvm.func @vec_reduce_fmax_intr_wrong_type(%arg0 : vector<4xi32>) -> i32 {
  // expected-error @below{{op operand #0 must be LLVM dialect-compatible vector of floating-point}}
  %0 = llvm.intr.vector.reduce.fmax(%arg0) : (vector<4xi32>) -> i32
  llvm.return %0 : i32
}

// -----

llvm.func @matrix_load_intr_wrong_type(%ptr : !llvm.ptr, %stride : i32) -> f32 {
  // expected-error @+2{{invalid kind of type specified: expected builtin.vector, but found 'f32'}}
  %0 = llvm.intr.matrix.column.major.load %ptr, <stride=%stride>
    { isVolatile = 0: i1, rows = 3: i32, columns = 16: i32} : f32 from !llvm.ptr stride i32
  llvm.return %0 : f32
}

// -----

llvm.func @matrix_store_intr_wrong_type(%matrix : vector<48xf32>, %ptr : i32, %stride : i64) {
  // expected-error @below {{op operand #1 must be LLVM pointer type, but got 'i32'}}
  llvm.intr.matrix.column.major.store %matrix, %ptr, <stride=%stride>
    { isVolatile = 0: i1, rows = 3: i32, columns = 16: i32} : vector<48xf32> to i32 stride i64
  llvm.return
}

// -----

llvm.func @matrix_multiply_intr_wrong_type(%arg0 : vector<64xf32>, %arg1 : f32) -> vector<12xf32> {
  // expected-error @+2{{invalid kind of type specified: expected builtin.vector, but found 'f32'}}
  %0 = llvm.intr.matrix.multiply %arg0, %arg1
    { lhs_rows = 4: i32, lhs_columns = 16: i32 , rhs_columns = 3: i32} : (vector<64xf32>, f32) -> vector<12xf32>
  llvm.return %0 : vector<12xf32>
}

// -----

llvm.func @matrix_transpose_intr_wrong_type(%matrix : f32) -> vector<48xf32> {
  // expected-error @below{{invalid kind of type specified: expected builtin.vector, but found 'f32'}}
  %0 = llvm.intr.matrix.transpose %matrix {rows = 3: i32, columns = 16: i32} : f32 into vector<48xf32>
  llvm.return %0 : vector<48xf32>
}

// -----

llvm.func @active_lane_intr_wrong_type(%base : i64, %n : vector<7xi64>) -> vector<7xi1> {
  // expected-error @below{{invalid kind of type specified: expected builtin.integer, but found 'vector<7xi64>'}}
  %0 = llvm.intr.get.active.lane.mask %base, %n : i64, vector<7xi64> to vector<7xi1>
  llvm.return %0 : vector<7xi1>
}

// -----

llvm.func @masked_load_intr_wrong_type(%ptr : i64, %mask : vector<7xi1>) -> vector<7xf32> {
  // expected-error @below{{op operand #0 must be LLVM pointer type, but got 'i64'}}
  %0 = llvm.intr.masked.load %ptr, %mask { alignment = 1: i32} : (i64, vector<7xi1>) -> vector<7xf32>
  llvm.return %0 : vector<7xf32>
}

// -----

llvm.func @masked_store_intr_wrong_type(%vec : vector<7xf32>, %ptr : !llvm.ptr, %mask : vector<7xi32>) {
  // expected-error @below{{op operand #2 must be LLVM dialect-compatible vector of 1-bit signless integer, but got 'vector<7xi32>}}
  llvm.intr.masked.store %vec, %ptr, %mask { alignment = 1: i32} : vector<7xf32>, vector<7xi32> into !llvm.ptr
  llvm.return
}

// -----

llvm.func @masked_gather_intr_wrong_type(%ptrs : vector<7xf32>, %mask : vector<7xi1>) -> vector<7xf32> {
  // expected-error @below{{op operand #0 must be LLVM dialect-compatible vector of LLVM pointer type, but got 'vector<7xf32>'}}
  %0 = llvm.intr.masked.gather %ptrs, %mask { alignment = 1: i32} : (vector<7xf32>, vector<7xi1>) -> vector<7xf32>
  llvm.return %0 : vector<7xf32>
}

// -----

llvm.func @masked_gather_intr_wrong_type_scalable(%ptrs : vector<7x!llvm.ptr>, %mask : vector<[7]xi1>) -> vector<[7]xf32> {
  // expected-error @below{{expected operand #1 type to be 'vector<[7]x!llvm.ptr>'}}
  %0 = llvm.intr.masked.gather %ptrs, %mask { alignment = 1: i32} : (vector<7x!llvm.ptr>, vector<[7]xi1>) -> vector<[7]xf32>
  llvm.return %0 : vector<[7]xf32>
}

// -----

llvm.func @masked_scatter_intr_wrong_type(%vec : f32, %ptrs : vector<7x!llvm.ptr>, %mask : vector<7xi1>) {
  // expected-error @below{{invalid kind of type specified: expected builtin.vector, but found 'f32'}}
  llvm.intr.masked.scatter %vec, %ptrs, %mask { alignment = 1: i32} : f32, vector<7xi1> into vector<7x!llvm.ptr>
  llvm.return
}

// -----

llvm.func @masked_scatter_intr_wrong_type_scalable(%vec : vector<[7]xf32>, %ptrs : vector<7x!llvm.ptr>, %mask : vector<[7]xi1>) {
  // expected-error @below{{expected operand #2 type to be 'vector<[7]x!llvm.ptr>'}}
  llvm.intr.masked.scatter %vec, %ptrs, %mask { alignment = 1: i32} : vector<[7]xf32>, vector<[7]xi1> into vector<7x!llvm.ptr>
  llvm.return
}

// -----

llvm.func @stepvector_intr_wrong_type() -> vector<7xf32> {
  // expected-error @below{{op result #0 must be LLVM dialect-compatible vector of signless integer, but got 'vector<7xf32>'}}
  %0 = llvm.intr.stepvector : vector<7xf32>
  llvm.return %0 : vector<7xf32>
}

// -----

// expected-error @below{{target features can not contain ','}}
llvm.func @invalid_target_feature() attributes { target_features = #llvm.target_features<["+bad,feature", "+test"]> }
{
}

// -----

// expected-error @below{{target features must start with '+' or '-'}}
llvm.func @missing_target_feature_prefix() attributes { target_features = #llvm.target_features<["sme"]> }
{
}

// -----

// expected-error @below{{target features can not be null or empty}}
llvm.func @empty_target_feature() attributes { target_features = #llvm.target_features<["", "+sve"]> }
{
}

// -----

llvm.comdat @__llvm_comdat {
  llvm.comdat_selector @foo any
}

llvm.comdat @__llvm_comdat_1 {
  // expected-error @below{{comdat selection symbols must be unique even in different comdat regions}}
  llvm.comdat_selector @foo any
}

// -----

llvm.func @foo() {
  // expected-error @below{{must appear at the module level}}
  llvm.linker_options ["test"]
}

// -----

llvm.func @foo() {
  // expected-error @below{{must appear at the module level}}
  llvm.module_flags [#llvm.mlir.module_flag<error, "wchar_size", 4>]
}

// -----

module attributes {} {
  // expected-error @below{{expected a module flag attribute}}
  llvm.module_flags [4 : i32]
}

// -----

module @does_not_exist {
  // expected-error @below{{resource does not exist}}
  llvm.mlir.global internal constant @constant(dense_resource<test0> : tensor<4xf32>) : !llvm.array<4 x f32>
}

// -----

module @raw_data_does_not_match_element_type_size {
  // expected-error @below{{raw data size does not match element type size}}
  llvm.mlir.global internal constant @constant(dense_resource<test1> : tensor<5xf32>) : !llvm.array<4 x f32>
}

{-#
  dialect_resources: {
    builtin: {
      test1: "0x0800000054A3B53ED6C0B33E55D1A2BDE5D2BB3E"
    }
  }
#-}

// -----

module @does_not_exist {
  // expected-error @below{{unsupported dense_resource type}}
  llvm.mlir.global internal constant @constant(dense_resource<test1> : memref<4xf32>) : !llvm.array<4 x f32>
}

{-#
  dialect_resources: {
    builtin: {
      test1: "0x0800000054A3B53ED6C0B33E55D1A2BDE5D2BB3E"
    }
  }
#-}

// -----

module @no_known_conversion_innermost_eltype {
  // expected-error @below{{no known conversion for innermost element type}}
  llvm.mlir.global internal constant @constant(dense_resource<test0> : tensor<4xi4>) : !llvm.array<4 x i4>
}

{-#
  dialect_resources: {
    builtin: {
      test1: "0x0800000054A3B53ED6C0B33E55D1A2BDE5D2BB3E"
    }
  }
#-}

// -----

llvm.mlir.global external @zed(42 : i32) : i32

llvm.mlir.alias external @foo : i32 {
  %0 = llvm.mlir.addressof @zed : !llvm.ptr
  llvm.return %0 : !llvm.ptr
}

llvm.func @call_alias_func() {
  // expected-error @below{{'llvm.dso_local_equivalent' op must reference an alias to a function}}
  %0 = llvm.dso_local_equivalent @foo : !llvm.ptr
  llvm.call %0() : !llvm.ptr, () -> (i32)
  llvm.return
}

// -----

llvm.mlir.global external @y() : !llvm.ptr

llvm.func @call_alias_func() {
  // expected-error @below{{op must reference a global defined by 'llvm.func' or 'llvm.mlir.alias'}}
  %0 = llvm.dso_local_equivalent @y : !llvm.ptr
  llvm.call %0() : !llvm.ptr, () -> (i32)
  llvm.return
}

// -----

llvm.mlir.global external constant @const() {addr_space = 0 : i32, dso_local} : i32 {
  %0 = llvm.mlir.addressof @const : !llvm.ptr
  %1 = llvm.ptrtoint %0 : !llvm.ptr to i64
  // expected-error @below{{'llvm.dso_local_equivalent' op target function with 'extern_weak' linkage not allowed}}
  %2 = llvm.dso_local_equivalent @extern_func : !llvm.ptr
  %3 = llvm.ptrtoint %2 : !llvm.ptr to i64
  %4 = llvm.sub %3, %1 : i64
  %5 = llvm.trunc %4 : i64 to i32
  llvm.return %5 : i32
}

llvm.func extern_weak @extern_func()

// -----

llvm.func @invoke_branch_weights_callee()
llvm.func @__gxx_personality_v0(...) -> i32

llvm.func @invoke_branch_weights() -> i32 attributes {personality = @__gxx_personality_v0} {
  %0 = llvm.mlir.constant(1 : i32) : i32
  // expected-error @below{{expects number of branch weights to match number of successors: 1 vs 2}}
  llvm.invoke @invoke_branch_weights_callee() to ^bb2 unwind ^bb1 {branch_weights = array<i32 : 42>} : () -> ()
^bb1:  // pred: ^bb0
  %1 = llvm.landingpad cleanup : !llvm.struct<(ptr, i32)>
  llvm.br ^bb2
^bb2:  // 2 preds: ^bb0, ^bb1
  llvm.return %0 : i32
}
