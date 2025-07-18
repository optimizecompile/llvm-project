//===-- Unittests for atof ------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "src/__support/FPUtil/FPBits.h"
#include "src/stdlib/atof.h"

#include "test/UnitTest/ErrnoCheckingTest.h"
#include "test/UnitTest/ErrnoSetterMatcher.h"
#include "test/UnitTest/Test.h"

#include <stddef.h>

using LlvmLibcAToFTest = LIBC_NAMESPACE::testing::ErrnoCheckingTest;
using LIBC_NAMESPACE::testing::ErrnoSetterMatcher::Succeeds;

// This is just a simple test to make sure that this function works at all. It's
// functionally identical to strtod so the bulk of the testing is there.
TEST_F(LlvmLibcAToFTest, SimpleTest) {
  LIBC_NAMESPACE::fputil::FPBits<double> expected_fp =
      LIBC_NAMESPACE::fputil::FPBits<double>(uint64_t(0x405ec00000000000));

  EXPECT_THAT(LIBC_NAMESPACE::atof("123"),
              Succeeds<double>(expected_fp.get_val()));
}

TEST_F(LlvmLibcAToFTest, FailedParsingTest) {
  // atof does not flag errors.
  EXPECT_THAT(LIBC_NAMESPACE::atof("???"), Succeeds<double>(0.0));
}
