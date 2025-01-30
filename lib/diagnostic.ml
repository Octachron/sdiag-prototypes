open Sexplib.Std
open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type box_type = | B | HoV | HV | V | H [@@since 1.0] [@@version 1.0][@@deriving yojson, sexp]

type format_tag =
  | Preservation
  | Modification
  | Insertion
  | Deletion
  | Hint
  | Inline_code
  | Loc
  | Warning
  | Error
  | String_tag of string
  | Unknown_format_tag of string
[@@since 1.0] [@@version 1.0][@@deriving yojson, sexp]


type structured_text =
  | Tbox of structured_text array
  | Tag of format_tag * structured_text array
  | Box of box_type * int * structured_text array
  | With_size of int * structured_text
  | Deprecated of string
  | If_newline
  | Newline
  | Flush of bool
  | Break of (string * int * string) * (string * int * string)
  | Simple_break of int * int
  | Set_tab
  | Tab_break of int * int
  | Text of string
[@@since 1.0] [@@version 1.0][@@deriving yojson, sexp]


type validity =
  | Invalid | Deprecated | Full
[@@since 1.0] [@@version 1.0][@@deriving yojson, sexp]


type metadata = {
  deprecated_paths: string array array option [@sexp.option][@yojson.option];
  invalid_paths: string array array option [@sexp.option][@yojson.option];
  valid: validity;
  downward_compatible: bool;
  version: int * int;
} [@@since 1.0]
[@@version 1.0][@@deriving yojson, sexp]




type config = {
  metadata: metadata
    (**This field describes the scheme version used to generate the diagnostic instance, and if this instance is valid according to this scheme.*);
  linear_magic_number: string;
  cmt_magic_number: string;
  cmxs_magic_number: string;
  ast_intf_magic_number: string;
  ast_impl_magic_number: string;
  cmxa_magic_number: string;
  cmx_magic_number: string;
  cma_magic_number: string;
  cmo_magic_number: string;
  cmi_magic_number: string;
  exec_magic_number: string;
  naked_pointers: bool;
  native_dynlink: bool;
  supports_shared_libraries: bool;
  windows_unicode: bool;
  tsan: bool;
  afl_instrument: bool;
  function_sections: bool;
  flat_float_array: bool;
  default_safe_string: bool;
  safe_string: bool;
  flambda: bool;
  target: string;
  host: string;
  systhread_supported: bool;
  default_executable_name: string;
  os_type: string;
  ext_dll: string;
  ext_lib: string;
  ext_asm: string;
  ext_obj: string;
  ext_exe: string;
  with_frame_pointers: bool;
  asm_cfi_supported: bool;
  asm: string;
  system: string;
  word_size: int;
  int_size: int;
  model: string;
  architecture: string;
  native_compiler: bool;
  native_pack_linker: string;
  native_ldflags: string;
  native_c_libraries: string;
  bytecomp_c_libraries: string;
  native_c_compiler: string;
  bytecomp_c_compiler: string;
  native_cppflags: string;
  native_cflags: string;
  bytecode_cppflags: string;
  bytecode_cflags: string;
  ocamlopt_cppflags: string;
  ocamlopt_cflags: string;
  ocamlc_cppflags: string;
  ocamlc_cflags: string;
  c_compiler: string;
  ccomp_type: string;
  standard_library: string;
  version: string;
} [@@since 1.0]
[@@version 1.0][@@deriving yojson, sexp]
type error_kind =
  | Report_warning_as_error of string
  | Report_warning of string
  | Report_alert_as_error of string
  | Report_alert of string
  | Report_error
[@@since 1.0] [@@version 1.0][@@deriving yojson, sexp]

type loc = {
  characters: (int * int) option [@sexp.option][@yojson.option];
  stop_line: int option [@sexp.option][@yojson.option];
  start_line: int option [@sexp.option][@yojson.option];
  file: string option [@sexp.option][@yojson.option];
} [@@since 1.0]
[@@version 1.0][@@deriving yojson, sexp]


type error_msg = { loc: loc option [@sexp.option][@yojson.option]; msg: structured_text array; } [@@since 1.0]
[@@version 1.0][@@deriving yojson, sexp]
type error_report = {
  footnote: structured_text array option [@sexp.option][@yojson.option];
  sub: error_msg array option [@sexp.option][@yojson.option];
  main: error_msg;
  kind: error_kind;
} [@@since 1.0]
[@@version 1.0][@@deriving yojson, sexp]

type profile = {
  children: profile array option [@sexp.option][@yojson.option];
  columns: float array option [@sexp.option][@yojson.option];
  name: string;
} [@@since 1.0]
[@@version 1.0][@@deriving yojson, sexp]

type debug = {
  profile: (string array * profile array) option [@sexp.option][@yojson.option];
  cmm_invariant: string option [@sexp.option][@yojson.option];
  linear: string array option [@sexp.option][@yojson.option];
  mach: string array option [@sexp.option][@yojson.option];
  unbox_specialised_args: string array option [@sexp.option][@yojson.option];
  unbox_closures: string array option [@sexp.option][@yojson.option];
  unbox_free_vars_of_closures: string array option [@sexp.option][@yojson.option];
  remove_free_vars_equal_to_args: string array option [@sexp.option][@yojson.option];
  cmm: string array option [@sexp.option][@yojson.option];
  raw_clambda: string array option [@sexp.option][@yojson.option];
  clambda: string array option [@sexp.option][@yojson.option];
  rawflambda: string array option [@sexp.option][@yojson.option];
  flambda: string array option [@sexp.option][@yojson.option];
  rawlambda: string option [@sexp.option][@yojson.option];
  lambda: string option [@sexp.option][@yojson.option];
  instr: string option [@sexp.option][@yojson.option];
  shape: string option [@sexp.option][@yojson.option];
  typedtree: string option [@sexp.option][@yojson.option];
  source: string option [@sexp.option][@yojson.option];
  parsetree: string option [@sexp.option][@yojson.option];
} [@@since 1.0]
[@@version 1.0][@@deriving yojson, sexp]


type compiler = {
  metadata: metadata
    (**This field describes the scheme version used to generate the diagnostic instance, and if this instance is valid according to this scheme.*);
  alerts: error_report array option [@sexp.option][@yojson.option];
  warnings: error_report array option [@sexp.option][@yojson.option];
  error: error_report option [@sexp.option][@yojson.option];
  debug: debug option [@sexp.option][@yojson.option];
} [@@since 1.0]
[@@version 1.0][@@deriving yojson, sexp]

type compiler_wm = {
  alerts: error_report array option [@sexp.option][@yojson.option];
  warnings: error_report array option [@sexp.option][@yojson.option];
  error: error_report option [@sexp.option][@yojson.option];
  debug: debug option [@sexp.option][@yojson.option];
} [@@since 1.0][@@deriving yojson, sexp]


type toplevel = {
  metadata: metadata
    (**This field describes the scheme version used to generate the diagnostic instance, and if this instance is valid according to this scheme.*);
  trace: structured_text array array option [@sexp.option][@yojson.option];
  errors: structured_text array array option [@sexp.option][@yojson.option];
  compiler: compiler_wm option [@sexp.option][@yojson.option];
  backtrace: structured_text array option [@sexp.option][@yojson.option];
  output: structured_text array option [@sexp.option][@yojson.option];
} [@@since 1.0]
[@@version 1.0][@@deriving yojson, sexp]
