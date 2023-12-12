
type arch = ARM | ARM64 | MIPS | X86 | PPC | SPARC | SYSTEMZ | HEXAGON | EVM

type mode =
| BIG_ENDIAN  (* big-endian mode *)
(* arm *)
| ARM       (* ARM mode *)
| THUMB     (* THUMB mode (including Thumb-2) *)
| V8        (* ARMv8 A32 encodings for ARM *)
(* mips *)
| MICRO     (* MicroMips mode *)
| MIPS3     (* Mips III ISA *)
| MIPS32R6  (* Mips32r6 ISA *)
| MIPS32    (* Mips32 ISA *)
| MIPS64    (* Mips64 ISA *)
(* x86 *)
| X86_16    (* 16-bit mode *)
| X86_32    (* 32-bit mode *)
| X86_64    (* 64-bit mode *)
(* ppc  *)
| PPC32     (* 32-bit mode *)
| PPC64     (* 64-bit mode *)
| QPX       (* Quad Processing eXtensions mode *)
(* sparc *)
| SPARC32   (* 32-bit mode *)
| SPARC64   (* 64-bit mode *)
| V9        (* SparcV9 mode *)

type syntax =
| INTEL    (* X86 Intel syntax - default on X86 (KS_OPT_SYNTAX). *)
| ATT      (* X86 ATT asm syntax (KS_OPT_SYNTAX). *)
| NASM     (* X86 Nasm syntax (KS_OPT_SYNTAX). *)
| MASM     (* X86 Masm syntax (KS_OPT_SYNTAX) - unsupported yet. *)
| GAS      (* X86 GNU GAS syntax (KS_OPT_SYNTAX). *)
| RADIX16  (* All immediates are in hex format (i.e 12 is 0x12) *)

val version : int * int
val arch_supported : arch -> bool

type engine
val create : ?syntax:syntax list -> arch -> mode list -> engine
val asm : ?addr:int -> engine -> string -> string * int
