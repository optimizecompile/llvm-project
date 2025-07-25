; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=amdgcn-- -mcpu=tahiti | FileCheck %s --check-prefix=SI
; RUN: llc < %s -mtriple=amdgcn-- -mcpu=fiji -mattr=-flat-for-global | FileCheck %s --check-prefix=VI
; RUN: llc < %s -mtriple=amdgcn-- -mcpu=gfx1100 -mattr=+real-true16 -mattr=-flat-for-global | FileCheck %s --check-prefixes=GFX11,GFX11-TRUE16
; RUN: llc < %s -mtriple=amdgcn-- -mcpu=gfx1100 -mattr=-real-true16 -mattr=-flat-for-global | FileCheck %s --check-prefixes=GFX11,GFX11-FAKE16

define amdgpu_kernel void @madak_f16(
; SI-LABEL: madak_f16:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x9
; SI-NEXT:    s_load_dwordx2 s[8:9], s[4:5], 0xd
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s14, s6
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s12, s2
; SI-NEXT:    s_mov_b32 s13, s3
; SI-NEXT:    s_mov_b32 s15, s7
; SI-NEXT:    s_mov_b32 s10, s6
; SI-NEXT:    s_mov_b32 s11, s7
; SI-NEXT:    buffer_load_ushort v0, off, s[12:15], 0
; SI-NEXT:    buffer_load_ushort v1, off, s[8:11], 0
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    s_waitcnt vmcnt(1)
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cvt_f32_f16_e32 v1, v1
; SI-NEXT:    v_madak_f32 v0, v0, v1, 0x41200000
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    buffer_store_short v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: madak_f16:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x24
; VI-NEXT:    s_load_dwordx2 s[8:9], s[4:5], 0x34
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_mov_b32 s14, s6
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s12, s2
; VI-NEXT:    s_mov_b32 s13, s3
; VI-NEXT:    s_mov_b32 s15, s7
; VI-NEXT:    s_mov_b32 s10, s6
; VI-NEXT:    s_mov_b32 s11, s7
; VI-NEXT:    buffer_load_ushort v0, off, s[12:15], 0
; VI-NEXT:    buffer_load_ushort v1, off, s[8:11], 0
; VI-NEXT:    s_mov_b32 s4, s0
; VI-NEXT:    s_mov_b32 s5, s1
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_madak_f16 v0, v0, v1, 0x4900
; VI-NEXT:    buffer_store_short v0, off, s[4:7], 0
; VI-NEXT:    s_endpgm
;
; GFX11-TRUE16-LABEL: madak_f16:
; GFX11-TRUE16:       ; %bb.0: ; %entry
; GFX11-TRUE16-NEXT:    s_clause 0x1
; GFX11-TRUE16-NEXT:    s_load_b128 s[0:3], s[4:5], 0x24
; GFX11-TRUE16-NEXT:    s_load_b64 s[4:5], s[4:5], 0x34
; GFX11-TRUE16-NEXT:    s_mov_b32 s10, -1
; GFX11-TRUE16-NEXT:    s_mov_b32 s11, 0x31016000
; GFX11-TRUE16-NEXT:    s_mov_b32 s14, s10
; GFX11-TRUE16-NEXT:    s_mov_b32 s15, s11
; GFX11-TRUE16-NEXT:    s_mov_b32 s6, s10
; GFX11-TRUE16-NEXT:    s_mov_b32 s7, s11
; GFX11-TRUE16-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-TRUE16-NEXT:    s_mov_b32 s12, s2
; GFX11-TRUE16-NEXT:    s_mov_b32 s13, s3
; GFX11-TRUE16-NEXT:    buffer_load_u16 v0, off, s[12:15], 0
; GFX11-TRUE16-NEXT:    buffer_load_u16 v1, off, s[4:7], 0
; GFX11-TRUE16-NEXT:    s_mov_b32 s8, s0
; GFX11-TRUE16-NEXT:    s_mov_b32 s9, s1
; GFX11-TRUE16-NEXT:    s_waitcnt vmcnt(0)
; GFX11-TRUE16-NEXT:    v_mul_f16_e32 v0.l, v0.l, v1.l
; GFX11-TRUE16-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GFX11-TRUE16-NEXT:    v_add_f16_e32 v0.l, 0x4900, v0.l
; GFX11-TRUE16-NEXT:    buffer_store_b16 v0, off, s[8:11], 0
; GFX11-TRUE16-NEXT:    s_endpgm
;
; GFX11-FAKE16-LABEL: madak_f16:
; GFX11-FAKE16:       ; %bb.0: ; %entry
; GFX11-FAKE16-NEXT:    s_clause 0x1
; GFX11-FAKE16-NEXT:    s_load_b128 s[0:3], s[4:5], 0x24
; GFX11-FAKE16-NEXT:    s_load_b64 s[4:5], s[4:5], 0x34
; GFX11-FAKE16-NEXT:    s_mov_b32 s10, -1
; GFX11-FAKE16-NEXT:    s_mov_b32 s11, 0x31016000
; GFX11-FAKE16-NEXT:    s_mov_b32 s14, s10
; GFX11-FAKE16-NEXT:    s_mov_b32 s15, s11
; GFX11-FAKE16-NEXT:    s_mov_b32 s6, s10
; GFX11-FAKE16-NEXT:    s_mov_b32 s7, s11
; GFX11-FAKE16-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-FAKE16-NEXT:    s_mov_b32 s12, s2
; GFX11-FAKE16-NEXT:    s_mov_b32 s13, s3
; GFX11-FAKE16-NEXT:    buffer_load_u16 v0, off, s[12:15], 0
; GFX11-FAKE16-NEXT:    buffer_load_u16 v1, off, s[4:7], 0
; GFX11-FAKE16-NEXT:    s_mov_b32 s8, s0
; GFX11-FAKE16-NEXT:    s_mov_b32 s9, s1
; GFX11-FAKE16-NEXT:    s_waitcnt vmcnt(0)
; GFX11-FAKE16-NEXT:    v_mul_f16_e32 v0, v0, v1
; GFX11-FAKE16-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GFX11-FAKE16-NEXT:    v_add_f16_e32 v0, 0x4900, v0
; GFX11-FAKE16-NEXT:    buffer_store_b16 v0, off, s[8:11], 0
; GFX11-FAKE16-NEXT:    s_endpgm
    ptr addrspace(1) %r,
    ptr addrspace(1) %a,
    ptr addrspace(1) %b) #0 {
entry:
  %a.val = load half, ptr addrspace(1) %a
  %b.val = load half, ptr addrspace(1) %b

  %t.val = fmul half %a.val, %b.val
  %r.val = fadd half %t.val, 10.0

  store half %r.val, ptr addrspace(1) %r
  ret void
}

define amdgpu_kernel void @madak_f16_use_2(
; SI-LABEL: madak_f16_use_2:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx8 s[8:15], s[4:5], 0x9
; SI-NEXT:    s_load_dwordx2 s[4:5], s[4:5], 0x11
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_mov_b32 s18, s2
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s16, s12
; SI-NEXT:    s_mov_b32 s17, s13
; SI-NEXT:    s_mov_b32 s19, s3
; SI-NEXT:    s_mov_b32 s12, s14
; SI-NEXT:    s_mov_b32 s13, s15
; SI-NEXT:    s_mov_b32 s14, s2
; SI-NEXT:    s_mov_b32 s15, s3
; SI-NEXT:    s_mov_b32 s6, s2
; SI-NEXT:    s_mov_b32 s7, s3
; SI-NEXT:    buffer_load_ushort v0, off, s[16:19], 0 glc
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    buffer_load_ushort v1, off, s[12:15], 0 glc
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    buffer_load_ushort v2, off, s[4:7], 0 glc
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_mov_b32_e32 v3, 0x41200000
; SI-NEXT:    s_mov_b32 s0, s8
; SI-NEXT:    s_mov_b32 s1, s9
; SI-NEXT:    s_mov_b32 s4, s10
; SI-NEXT:    s_mov_b32 s5, s11
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_cvt_f32_f16_e32 v1, v1
; SI-NEXT:    v_cvt_f32_f16_e32 v2, v2
; SI-NEXT:    v_madak_f32 v1, v0, v1, 0x41200000
; SI-NEXT:    v_mac_f32_e32 v3, v0, v2
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v1
; SI-NEXT:    v_cvt_f16_f32_e32 v1, v3
; SI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; SI-NEXT:    buffer_store_short v1, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: madak_f16_use_2:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx8 s[8:15], s[4:5], 0x24
; VI-NEXT:    s_load_dwordx2 s[4:5], s[4:5], 0x44
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    s_mov_b32 s18, s2
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s16, s12
; VI-NEXT:    s_mov_b32 s17, s13
; VI-NEXT:    s_mov_b32 s19, s3
; VI-NEXT:    s_mov_b32 s12, s14
; VI-NEXT:    s_mov_b32 s13, s15
; VI-NEXT:    s_mov_b32 s14, s2
; VI-NEXT:    s_mov_b32 s15, s3
; VI-NEXT:    s_mov_b32 s6, s2
; VI-NEXT:    s_mov_b32 s7, s3
; VI-NEXT:    buffer_load_ushort v0, off, s[16:19], 0 glc
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    buffer_load_ushort v1, off, s[12:15], 0 glc
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    buffer_load_ushort v2, off, s[4:7], 0 glc
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v3, 0x4900
; VI-NEXT:    s_mov_b32 s0, s8
; VI-NEXT:    s_mov_b32 s1, s9
; VI-NEXT:    s_mov_b32 s4, s10
; VI-NEXT:    s_mov_b32 s5, s11
; VI-NEXT:    v_madak_f16 v1, v0, v1, 0x4900
; VI-NEXT:    v_mac_f16_e32 v3, v0, v2
; VI-NEXT:    buffer_store_short v1, off, s[0:3], 0
; VI-NEXT:    buffer_store_short v3, off, s[4:7], 0
; VI-NEXT:    s_endpgm
;
; GFX11-TRUE16-LABEL: madak_f16_use_2:
; GFX11-TRUE16:       ; %bb.0: ; %entry
; GFX11-TRUE16-NEXT:    s_clause 0x1
; GFX11-TRUE16-NEXT:    s_load_b256 s[8:15], s[4:5], 0x24
; GFX11-TRUE16-NEXT:    s_load_b64 s[0:1], s[4:5], 0x44
; GFX11-TRUE16-NEXT:    s_mov_b32 s6, -1
; GFX11-TRUE16-NEXT:    s_mov_b32 s7, 0x31016000
; GFX11-TRUE16-NEXT:    s_mov_b32 s18, s6
; GFX11-TRUE16-NEXT:    s_mov_b32 s19, s7
; GFX11-TRUE16-NEXT:    s_mov_b32 s22, s6
; GFX11-TRUE16-NEXT:    s_mov_b32 s23, s7
; GFX11-TRUE16-NEXT:    s_mov_b32 s2, s6
; GFX11-TRUE16-NEXT:    s_mov_b32 s3, s7
; GFX11-TRUE16-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-TRUE16-NEXT:    s_mov_b32 s16, s12
; GFX11-TRUE16-NEXT:    s_mov_b32 s17, s13
; GFX11-TRUE16-NEXT:    s_mov_b32 s20, s14
; GFX11-TRUE16-NEXT:    s_mov_b32 s21, s15
; GFX11-TRUE16-NEXT:    buffer_load_u16 v0, off, s[16:19], 0 glc dlc
; GFX11-TRUE16-NEXT:    s_waitcnt vmcnt(0)
; GFX11-TRUE16-NEXT:    buffer_load_u16 v1, off, s[20:23], 0 glc dlc
; GFX11-TRUE16-NEXT:    s_waitcnt vmcnt(0)
; GFX11-TRUE16-NEXT:    buffer_load_u16 v2, off, s[0:3], 0 glc dlc
; GFX11-TRUE16-NEXT:    s_waitcnt vmcnt(0)
; GFX11-TRUE16-NEXT:    s_mov_b32 s4, s8
; GFX11-TRUE16-NEXT:    s_mov_b32 s5, s9
; GFX11-TRUE16-NEXT:    s_mov_b32 s0, s10
; GFX11-TRUE16-NEXT:    s_mov_b32 s1, s11
; GFX11-TRUE16-NEXT:    v_mul_f16_e32 v0.h, v0.l, v1.l
; GFX11-TRUE16-NEXT:    v_mul_f16_e32 v0.l, v0.l, v2.l
; GFX11-TRUE16-NEXT:    s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
; GFX11-TRUE16-NEXT:    v_add_f16_e32 v1.l, 0x4900, v0.h
; GFX11-TRUE16-NEXT:    v_add_f16_e32 v0.l, 0x4900, v0.l
; GFX11-TRUE16-NEXT:    buffer_store_b16 v1, off, s[4:7], 0
; GFX11-TRUE16-NEXT:    buffer_store_b16 v0, off, s[0:3], 0
; GFX11-TRUE16-NEXT:    s_endpgm
;
; GFX11-FAKE16-LABEL: madak_f16_use_2:
; GFX11-FAKE16:       ; %bb.0: ; %entry
; GFX11-FAKE16-NEXT:    s_clause 0x1
; GFX11-FAKE16-NEXT:    s_load_b256 s[8:15], s[4:5], 0x24
; GFX11-FAKE16-NEXT:    s_load_b64 s[0:1], s[4:5], 0x44
; GFX11-FAKE16-NEXT:    s_mov_b32 s6, -1
; GFX11-FAKE16-NEXT:    s_mov_b32 s7, 0x31016000
; GFX11-FAKE16-NEXT:    s_mov_b32 s18, s6
; GFX11-FAKE16-NEXT:    s_mov_b32 s19, s7
; GFX11-FAKE16-NEXT:    s_mov_b32 s22, s6
; GFX11-FAKE16-NEXT:    s_mov_b32 s23, s7
; GFX11-FAKE16-NEXT:    s_mov_b32 s2, s6
; GFX11-FAKE16-NEXT:    s_mov_b32 s3, s7
; GFX11-FAKE16-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-FAKE16-NEXT:    s_mov_b32 s16, s12
; GFX11-FAKE16-NEXT:    s_mov_b32 s17, s13
; GFX11-FAKE16-NEXT:    s_mov_b32 s20, s14
; GFX11-FAKE16-NEXT:    s_mov_b32 s21, s15
; GFX11-FAKE16-NEXT:    buffer_load_u16 v0, off, s[16:19], 0 glc dlc
; GFX11-FAKE16-NEXT:    s_waitcnt vmcnt(0)
; GFX11-FAKE16-NEXT:    buffer_load_u16 v1, off, s[20:23], 0 glc dlc
; GFX11-FAKE16-NEXT:    s_waitcnt vmcnt(0)
; GFX11-FAKE16-NEXT:    buffer_load_u16 v2, off, s[0:3], 0 glc dlc
; GFX11-FAKE16-NEXT:    s_waitcnt vmcnt(0)
; GFX11-FAKE16-NEXT:    s_mov_b32 s4, s8
; GFX11-FAKE16-NEXT:    s_mov_b32 s5, s9
; GFX11-FAKE16-NEXT:    s_mov_b32 s0, s10
; GFX11-FAKE16-NEXT:    s_mov_b32 s1, s11
; GFX11-FAKE16-NEXT:    v_mul_f16_e32 v1, v0, v1
; GFX11-FAKE16-NEXT:    v_mul_f16_e32 v0, v0, v2
; GFX11-FAKE16-NEXT:    s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
; GFX11-FAKE16-NEXT:    v_add_f16_e32 v1, 0x4900, v1
; GFX11-FAKE16-NEXT:    v_add_f16_e32 v0, 0x4900, v0
; GFX11-FAKE16-NEXT:    buffer_store_b16 v1, off, s[4:7], 0
; GFX11-FAKE16-NEXT:    buffer_store_b16 v0, off, s[0:3], 0
; GFX11-FAKE16-NEXT:    s_endpgm
    ptr addrspace(1) %r0,
    ptr addrspace(1) %r1,
    ptr addrspace(1) %a,
    ptr addrspace(1) %b,
    ptr addrspace(1) %c) #0 {
entry:
  %a.val = load volatile half, ptr addrspace(1) %a
  %b.val = load volatile half, ptr addrspace(1) %b
  %c.val = load volatile half, ptr addrspace(1) %c

  %t0.val = fmul half %a.val, %b.val
  %t1.val = fmul half %a.val, %c.val
  %r0.val = fadd half %t0.val, 10.0
  %r1.val = fadd half %t1.val, 10.0

  store half %r0.val, ptr addrspace(1) %r0
  store half %r1.val, ptr addrspace(1) %r1
  ret void
}

attributes #0 = { "denormal-fp-math"="preserve-sign,preserve-sign" }
;; NOTE: These prefixes are unused and the list is autogenerated. Do not add tests below this line:
; GFX11: {{.*}}
