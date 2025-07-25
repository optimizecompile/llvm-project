//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// UNSUPPORTED: c++03, c++11, c++14, c++17, c++20

// <flat_map>

// flat_multimap()
//    noexcept(
//        is_nothrow_default_constructible_v<key_container_type> &&
//        is_nothrow_default_constructible_v<mapped_container_type> &&
//        is_nothrow_default_constructible_v<key_compare>);

// This tests a conforming extension

#include <cassert>
#include <flat_map>
#include <functional>
#include <vector>

#include "test_macros.h"
#include "MoveOnly.h"
#include "test_allocator.h"

struct ThrowingCtorComp {
  constexpr ThrowingCtorComp() noexcept(false) {}
  constexpr bool operator()(const auto&, const auto&) const { return false; }
};

constexpr bool test() {
#if defined(_LIBCPP_VERSION)
  {
    using C = std::flat_multimap<MoveOnly, MoveOnly>;
    static_assert(std::is_nothrow_default_constructible_v<C>);
    C c;
  }
  {
    using C =
        std::flat_multimap<MoveOnly, MoveOnly, std::less<MoveOnly>, std::vector<MoveOnly, test_allocator<MoveOnly>>>;
    static_assert(std::is_nothrow_default_constructible_v<C>);
    C c;
  }
#endif // _LIBCPP_VERSION
  {
    using C =
        std::flat_multimap<MoveOnly, MoveOnly, std::less<MoveOnly>, std::vector<MoveOnly, other_allocator<MoveOnly>>>;
    static_assert(!std::is_nothrow_default_constructible_v<C>);
    C c;
  }
  {
    using C = std::flat_multimap<MoveOnly, MoveOnly, ThrowingCtorComp>;
    static_assert(!std::is_nothrow_default_constructible_v<C>);
    C c;
  }
  return true;
}

int main(int, char**) {
  test();
#if TEST_STD_VER >= 26
  static_assert(test());
#endif

  return 0;
}
