# REQUIRES: x86
# This test intentionally checks for fatal errors, and fatal errors aren't supported for testing when main is run twice.
# XFAIL: main-run-twice
# RUN: llvm-mc -filetype=obj -triple=x86_64-unknown-linux %s -o %t
# RUN: not ld.lld %t -o /dev/null --fat-lto-objects 2>&1 | FileCheck %s

# CHECK: error:{{.*}} Invalid bitcode signature

.section        .llvm.lto,"e",@progbits
.Lllvm.embedded.object:
        .asciz  "BC\300\3365\000"
        .size   .Lllvm.embedded.object, 12
