(** The Keystone Framework.

    Thin bindings to the Keystone library. For details, please consult
    the {{: https://www.keystone-engine.org}website}, or [keystone.h] from the
    library distribution. *)

type arch = ARM | ARM64 | MIPS | X86 | PPC | SPARC | SYSTEMZ | HEXAGON | EVM
(** Architecture type.

    For more details, please consult [ks_arch] in [keystone.h]. *)

type mode =
| BIG_ENDIAN  (** Big-endian mode *)
| ARM         (** ARM — ARM mode *)
| THUMB       (** ARM — THUMB mode (including Thumb-2) *)
| V8          (** ARM — ARMv8 A32 encodings for ARM *)
| MICRO       (** MIPS — MicroMips mode *)
| MIPS3       (** MIPS — Mips III ISA *)
| MIPS32R6    (** MIPS — Mips32r6 ISA *)
| MIPS32      (** MIPS — Mips32 ISA *)
| MIPS64      (** MIPS — Mips64 ISA *)
| X86_16      (** X86 — 16-bit mode *)
| X86_32      (** X86 — 32-bit mode *)
| X86_64      (** X86 — 64-bit mode *)
| PPC32       (** PPC — 32-bit mode *)
| PPC64       (** PPC — 64-bit mode *)
| QPX         (** PPC — Quad Processing eXtensions mode *)
| SPARC32     (** SPARC — 32-bit mode *)
| SPARC64     (** SPARC — 64-bit mode *)
| V9          (** SPARC — SparcV9 mode *)
(** Mode.

    For more details, please consult [ks_mode] in [keystone.h]. *)

type syntax =
| INTEL    (** X86 Intel syntax - default on X86 (KS_OPT_SYNTAX). *)
| ATT      (** X86 ATT asm syntax (KS_OPT_SYNTAX). *)
| NASM     (** X86 Nasm syntax (KS_OPT_SYNTAX). *)
| MASM     (** X86 Masm syntax (KS_OPT_SYNTAX) - unsupported yet. *)
| GAS      (** X86 GNU GAS syntax (KS_OPT_SYNTAX). *)
| RADIX16  (** All immediates are in hex format (i.e 12 is 0x12) *)
(** Syntax.

    For more details, please consult [ks_opt_value] in [keystone.h]. *)

val version : int * int

val arch_supported : arch -> bool

type engine

val create : ?syntax:syntax list -> arch -> mode list -> engine
(** [create ~syntax arch modes] is a new {{!engine}assembler} instance.

    [arch] determines the architecture, [modes] the assembler mode(s), and
    [syntax] the syntax flags. Not all modes and not all syntax flags are
    mutually compatible.

    @raise Invalid_argument on illegal option combinations. *)

val asm : ?addr:int -> engine -> string -> string * int
(** [asm ~addr engine program] is [(encoding, stmts)], where [encoding] is the
    binary encoding of instructions, and [stmts] is the number of processed
    statements, obtained by processing the assembly [program] starting at an
    offset [addr], and using the configured assembler instance [engine].

    @raise Invalid_argument on malformed [program].
    *)
