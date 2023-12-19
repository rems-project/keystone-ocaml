
(* Keep synced with t_arches[] in C. *)
type _ arch =
| ARM : [`ARM] arch
| ARM64 : [`ARM64] arch
| MIPS : [`MIPS] arch
| X86 : [`X86] arch
| PPC : [`PPC] arch
| SPARC : [`SPARC] arch
| SYSTEMZ : [`SYSTEMZ] arch
| HEXAGON : [`HEXAGON] arch
| EVM : [`EVM] arch

(* Keep synced with t_modes[] in C. *)
type _ mode =
| BIG_ENDIAN : [< `ARM | `HEXAGON | `SYSTEMZ | `SPARC | `MIPS | `PPC ] mode
| ARM : [`ARM] mode | THUMB : [`ARM] mode | V8 : [`ARM] mode
| MICRO : [`MIPS] mode | MIPS3 : [`MIPS] mode | MIPS32R6 : [`MIPS] mode | MIPS32 : [`MIPS] mode | MIPS64 : [`MIPS] mode
| X86_16 : [`X86] mode | X86_32 : [`X86] mode | X86_64 : [`X86] mode
| PPC32 : [`PPC] mode | PPC64 : [`PPC] mode | QPX : [`PPC] mode
| SPARC32 : [`SPARC] mode | SPARC64 : [`SPARC] mode | V9 : [`SPARC] mode

(* Keep synced with t_opts[] in C. *)
type syntax = INTEL | ATT | NASM | MASM | GAS | RADIX16

type engine

external version0 : unit -> int = "caml_ks_version"
external arch_supported : _ arch -> bool = "caml_ks_arch_supported"
external create0 : 'a arch -> 'a mode list -> engine = "caml_ks_open"
external set_syntax : engine -> syntax list -> unit = "caml_ks_set_syntax_opt"
external asm0 : engine -> string -> int -> string * int = "caml_ks_asm"

let version = (version0 () lsr 8) land 0xff, version0 () land 0xff
let create ?syntax arch mode =
  let t = create0 arch mode in
  (match syntax with Some s -> set_syntax t s | _ -> ());
  t
let asm ?(addr = 0) t prg = match asm0 t prg addr with
| exception Invalid_argument msg -> Error (`Msg msg)
| v -> Ok v
