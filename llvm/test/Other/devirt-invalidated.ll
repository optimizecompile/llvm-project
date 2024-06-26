; RUN: opt -passes='devirt<0>(inline)' < %s -S | FileCheck %s

; CHECK: define void @e()

define void @e() {
entry:
  call void @b()
  ret void
}

define internal void @b() {
entry:
  call void @d()
  call void @c()
  ret void
}

define internal void @d() {
entry:
  unreachable
}

define internal void @c() {
entry:
  call void @b()
  call void @e()
  ret void
}
