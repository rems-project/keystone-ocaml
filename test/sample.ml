open Keystone

let test ?syntax arch mode prg =
  Format.printf "%s  =>  %!" prg;
  if not (Keystone.arch_supported arch) then Fmt.pr "ARCH UNSUPPORTED@." else
  let t = create arch mode ?syntax in
  let code, _ = asm t prg in
  Fmt.pr "@[%a@]@." Fmt.(octets () |> on_string) code

let _ =

  (* X86 *)
  test X86 [X86_16] "add eax, ecx";
  test X86 [X86_32] "add eax, ecx";
  test X86 [X86_64] "add rax, rcx";
  test X86 [X86_32] "add %ecx, %eax" ~syntax:[ATT];
  test X86 [X86_64] "add %rcx, %rax" ~syntax:[ATT];

  test X86 [X86_32] "add eax, 0x15";
  test X86 [X86_32] "add eax, 15h";
  test X86 [X86_32] "add eax, 15";

  (* RADIX16 syntax Intel (default syntax) *)
  test X86 [X86_32] "add eax, 15" ~syntax:[RADIX16];
  (* RADIX16 syntax for AT&T *)
  test X86 [X86_32] "add $15, %eax" ~syntax:[RADIX16; ATT];

  (* ARM *)
  test ARM [ARM] "sub r1, r2, r5";
  test ARM [ARM; BIG_ENDIAN] "sub r1, r2, r5";
  test ARM [THUMB] "movs r4, #0xf0";
  test ARM [THUMB; BIG_ENDIAN] "movs r4, #0xf0";

  (* ARM64 *)
  test ARM64 [] "ldr w1, [sp, #0x8]";

  (* Hexagon *)
  test HEXAGON [BIG_ENDIAN] "v23.w=vavg(v11.w,v2.w):rnd";

  (* Mips *)
  test MIPS [MIPS32] "and $9, $6, $7";
  test MIPS [MIPS32; BIG_ENDIAN] "and $9, $6, $7";
  test MIPS [MIPS64] "and $9, $6, $7";
  test MIPS [MIPS64; BIG_ENDIAN] "and $9, $6, $7";

  (* PowerPC *)
  test PPC [PPC32; BIG_ENDIAN] "add 1, 2, 3";
  test PPC [PPC64] "add 1, 2, 3";
  test PPC [PPC64; BIG_ENDIAN] "add 1, 2, 3";

  (* RISCV *)
  (* test RISCV [RISCV32] "addi x0, x0, 10"; *)
  (* test RISCV [RISCV64] "addiw x0, x0, 10"; *)

  (* Sparc *)
  test SPARC [SPARC32] "add %g1, %g2, %g3";
  test SPARC [SPARC32; BIG_ENDIAN] "add %g1, %g2, %g3";

  (* SystemZ *)
  test SYSTEMZ [BIG_ENDIAN] "a %r0, 4095(%r15,%r1)"
