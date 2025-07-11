//===-- include/flang-rt/runtime/stat.h -------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// Defines the values returned by the runtime for STAT= specifiers
// on executable statements.

#ifndef FLANG_RT_RUNTIME_STAT_H_
#define FLANG_RT_RUNTIME_STAT_H_
#include "flang/Common/ISO_Fortran_binding_wrapper.h"
#include "flang/Common/api-attrs.h"
#include "flang/Runtime/magic-numbers.h"
namespace Fortran::runtime {

class Descriptor;
class Terminator;

// The value of STAT= is zero when no error condition has arisen.

enum Stat {
  StatOk = 0, // required to be zero by Fortran

  // Interoperable STAT= codes (>= 11)
  StatBaseNull = CFI_ERROR_BASE_ADDR_NULL,
  StatBaseNotNull = CFI_ERROR_BASE_ADDR_NOT_NULL,
  StatInvalidElemLen = CFI_INVALID_ELEM_LEN,
  StatInvalidRank = CFI_INVALID_RANK,
  StatInvalidType = CFI_INVALID_TYPE,
  StatInvalidAttribute = CFI_INVALID_ATTRIBUTE,
  StatInvalidExtent = CFI_INVALID_EXTENT,
  StatInvalidDescriptor = CFI_INVALID_DESCRIPTOR,
  StatMemAllocation = CFI_ERROR_MEM_ALLOCATION,
  StatOutOfBounds = CFI_ERROR_OUT_OF_BOUNDS,

  // Standard STAT= values (>= 101)
  StatFailedImage = FORTRAN_RUNTIME_STAT_FAILED_IMAGE,
  StatLocked = FORTRAN_RUNTIME_STAT_LOCKED,
  StatLockedOtherImage = FORTRAN_RUNTIME_STAT_LOCKED_OTHER_IMAGE,
  StatMissingEnvVariable = FORTRAN_RUNTIME_STAT_MISSING_ENV_VAR,
  StatMissingCurrentWorkDirectory = FORTRAN_RUNTIME_STAT_MISSING_CWD,
  StatStoppedImage = FORTRAN_RUNTIME_STAT_STOPPED_IMAGE,
  StatUnlocked = FORTRAN_RUNTIME_STAT_UNLOCKED,
  StatUnlockedFailedImage = FORTRAN_RUNTIME_STAT_UNLOCKED_FAILED_IMAGE,

  // Additional "processor-defined" STAT= values
  StatInvalidArgumentNumber = FORTRAN_RUNTIME_STAT_INVALID_ARG_NUMBER,
  StatMissingArgument = FORTRAN_RUNTIME_STAT_MISSING_ARG,
  StatValueTooShort = FORTRAN_RUNTIME_STAT_VALUE_TOO_SHORT, // -1
  StatMoveAllocSameAllocatable =
      FORTRAN_RUNTIME_STAT_MOVE_ALLOC_SAME_ALLOCATABLE,
  StatBadPointerDeallocation = FORTRAN_RUNTIME_STAT_BAD_POINTER_DEALLOCATION,

  // Dummy status for work queue continuation, declared here to perhaps
  // avoid collisions
  StatContinue = 201
};

RT_API_ATTRS const char *StatErrorString(int);
RT_API_ATTRS int ToErrmsg(const Descriptor *errmsg, int stat); // returns stat
RT_API_ATTRS int ReturnError(Terminator &, int stat,
    const Descriptor *errmsg = nullptr, bool hasStat = false);
} // namespace Fortran::runtime
#endif // FLANG_RT_RUNTIME_STAT_H_
