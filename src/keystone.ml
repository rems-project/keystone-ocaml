
(* Keep synced with t_arches[] in C. *)
type arch = ARM | ARM64 | MIPS | X86 | PPC | SPARC | SYSTEMZ | HEXAGON | EVM

(* Keep synced with t_modes[] in C. *)
type mode =
| BIG_ENDIAN
| ARM | THUMB | V8
| MICRO | MIPS3 | MIPS32R6 | MIPS32 | MIPS64
| X86_16 | X86_32 | X86_64
| PPC32 | PPC64 | QPX
| SPARC32 | SPARC64 | V9

(* Keep synced with t_opts[] in C. *)
type syntax = INTEL | ATT | NASM | MASM | GAS | RADIX16

type engine

external version0 : unit -> int = "caml_ks_version"
external arch_supported : arch -> bool = "caml_ks_arch_supported"
external create0 : arch -> mode list -> engine = "caml_ks_open"
external set_syntax : engine -> syntax list -> unit = "caml_ks_set_syntax_opt"
external asm0 : engine -> string -> int -> string * int = "caml_ks_asm"

let version = (version0 () lsr 8) land 0xff, version0 () land 0xff
let create ?syntax arch mode =
  let t = create0 arch mode in
  (match syntax with Some s -> set_syntax t s | _ -> ());
  t
let asm ?(addr = 0) t prg = asm0 t prg addr
