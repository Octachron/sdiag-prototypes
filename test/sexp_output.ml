open Reader.Diagnostic

let version = 1, 0
let metadata = {
  version;
  downward_compatible=true;
  deprecated_paths = None;
  valid = Full;
  invalid_paths = None;
}

let c: compiler = {
  metadata;
  debug = None;
  warnings = None;
  alerts = None;
  error = None;
}

let sexp = sexp_of_compiler c

let () = Format.printf "@[%a@]@." Sexplib.Sexp.pp sexp
