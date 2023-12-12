#include <keystone/keystone.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>

static const ks_arch t_arches[] = {
  KS_ARCH_ARM, KS_ARCH_ARM64, KS_ARCH_MIPS, KS_ARCH_X86, KS_ARCH_PPC,
  KS_ARCH_SPARC, KS_ARCH_SYSTEMZ, KS_ARCH_HEXAGON, KS_ARCH_EVM, KS_ARCH_MAX,
};

static const ks_mode t_modes[] = {
  KS_MODE_BIG_ENDIAN,
  KS_MODE_ARM, KS_MODE_THUMB, KS_MODE_V8,
  KS_MODE_MICRO, KS_MODE_MIPS3, KS_MODE_MIPS32R6, KS_MODE_MIPS32, KS_MODE_MIPS64,
  KS_MODE_16, KS_MODE_32, KS_MODE_64,
  KS_MODE_PPC32, KS_MODE_PPC64, KS_MODE_QPX,
  KS_MODE_SPARC32, KS_MODE_SPARC64, KS_MODE_V9,
};

static const ks_opt_value t_opts[] = {
  KS_OPT_SYNTAX_INTEL, KS_OPT_SYNTAX_ATT, KS_OPT_SYNTAX_NASM,
  KS_OPT_SYNTAX_MASM, KS_OPT_SYNTAX_GAS, KS_OPT_SYNTAX_RADIX16,
};

#define DEFINE_ENUM(name, ctype, table)                                \
  static const int max_##table = sizeof(table) / sizeof(ctype);        \
  static ctype name(value v) {                                         \
    if ((unsigned) Int_val(v) < max_##table) return table[Int_val(v)]; \
    caml_failwith("INTERNAL ERROR");                                   \
  }

#define PRIM(fname, ...) CAMLprim value caml_ks_##fname (__VA_ARGS__)
#define Ks_val(v) (*((ks_engine **) Data_custom_val(v)))
DEFINE_ENUM(Arch_val, ks_arch, t_arches);
DEFINE_ENUM(Mode_val, ks_mode, t_modes);
DEFINE_ENUM(Opt_val, ks_opt_value, t_opts);

PRIM(version) { return Val_int(ks_version(NULL, NULL)); }

PRIM(arch_supported, value arch) {
  return Val_int(ks_arch_supported(Arch_val(arch)));
}

static void caml_ks_close(value ks) { ks_close(Ks_val(ks)); }

PRIM(open, value arch, value modes) {
  CAMLparam2(arch, modes);
  CAMLlocal1(ret);
  int mode = KS_MODE_LITTLE_ENDIAN;
  for (; Is_block(modes); modes = Field(modes, 1)) mode |= Mode_val(Field(modes, 0));
  ks_engine *ks;
  ks_err res = ks_open(Arch_val(arch), mode, &ks);
  if (res != KS_ERR_OK) caml_invalid_argument(ks_strerror(res));
  ret = caml_alloc_final(1, caml_ks_close, 1, 50);
  Ks_val(ret) = ks;
  CAMLreturn(ret);
}

PRIM(set_syntax_opt, value ks, value syns) {
  CAMLparam2(ks, syns);
  int syn = 0;
  for (; Is_block(syns); syns = Field(syns, 1)) syn |= Opt_val(Field(syns, 0));
  ks_err res = ks_option(Ks_val(ks), KS_OPT_SYNTAX, syn);
  if (res != KS_ERR_OK) caml_invalid_argument(ks_strerror(res));
  CAMLreturn(Val_unit);
}

PRIM(asm, value ks, value prog, value addr) {
  CAMLparam3(ks, prog, addr);
  CAMLlocal1(tmp);
  unsigned char *encoding;
  size_t size, stmts;
  ks_err res = ks_asm(Ks_val(ks), String_val(prog), Int_val(addr), &encoding, &size, &stmts);
  if (res != KS_ERR_OK) caml_invalid_argument(ks_strerror(ks_errno(Ks_val(ks))));
  tmp = caml_alloc_tuple(2);
  Store_field(tmp, 0, caml_alloc_initialized_string(size, (char *) encoding));
  Store_field(tmp, 1, Val_int(stmts));
  ks_free(encoding);
  CAMLreturn(tmp);
}
