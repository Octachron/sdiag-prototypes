
let (let*?) = Option.bind



let loc_range (l:Reader.Diagnostic.loc) =
  let*? file = l.file in
  let source = `File file in
  let desc = Grace_source_reader.open_source source in
  let line_starts = Grace_source_reader.line_starts desc in
  let get_line l =
    if l > line_starts.length then assert false
    else line_starts.unsafe_get l
  in
  let*? line_start = l.start_line in
  let start_offset =
    if line_start = 0 then Grace.Byte_index.of_int 0
    else get_line (line_start - 1)
  in
  let*? line_end = l.stop_line in
  let end_offset =
    if line_end = 0 then Grace.Byte_index.of_int 0 else
    get_line (line_end - 1)
  in
  let*? start, stop = l.characters in
  let start = Grace.Byte_index.(add start_offset start) in
  let stop = Grace.Byte_index.(add end_offset stop) in
  Some (Grace.Range.create ~source start stop)




let pp_with_tag tag k = match tag with
  | Reader.Diagnostic.Preservation ->
    Fmt.styled `Bold (Fmt.styled (`Fg `Green) k)
  | Modification | Warning ->
    Fmt.styled `Bold (Fmt.styled (`Fg `Magenta) k)
  | Insertion | Deletion | Error ->
    Fmt.styled `Bold (Fmt.styled (`Fg `Red) k)
  | Hint -> Fmt.styled `Bold (Fmt.styled (`Fg `Red) k)
  | Inline_code | Loc -> Fmt.styled `Bold k
  | String_tag _ -> k
  | Unknown_format_tag _ -> k

let pp_open_box ppf box indent = match box with
  | Reader.Diagnostic.H -> Format.pp_open_hbox ppf ()
  | V -> Format.pp_open_vbox ppf indent
  | B -> Format.pp_open_box ppf indent
  | HV -> Format.pp_open_hvbox ppf indent
  | HoV -> Format.pp_open_hovbox ppf indent

let rec pp_doc ppf = function
  | Reader.Diagnostic.Tbox children -> pp_children ppf children
  | Tag (format_tag, children) ->
    pp_with_tag format_tag pp_children ppf children;
    Format.pp_close_stag ppf ()
  | Box (box_type, indent, children) ->
     pp_open_box ppf box_type indent;
     pp_children ppf children;
     Format.pp_close_box ppf ()
  | With_size (size, s) -> Format.pp_print_as ppf size s
  | Deprecated text | Text text -> Format.pp_print_string ppf text
  | If_newline -> Format.pp_print_if_newline ppf ()
  | Newline -> Format.pp_force_newline ppf ()
  | Flush true -> Format.pp_print_newline ppf ()
  | Flush false -> Format.pp_print_flush ppf ()
  | Break (fits,breaks) -> Format.pp_print_custom_break ppf ~fits ~breaks
  | Simple_break (space, indent) -> Format.pp_print_break ppf space indent
  | Set_tab | Tab_break _ -> ()
and pp_children ppf a = Array.iter (pp_doc ppf) a

let pp = pp_children

module Gd = Grace.Diagnostic
type code = Any

(* let int_of_code = function Any -> 0 *)

module Rd = Reader.Diagnostic

let reprint (e:Reader.Diagnostic.error_report) =
    let level = match e.kind with
      | Report_error | Report_warning_as_error _ | Report_alert_as_error _ ->
        Gd.Severity.Error
      | Report_warning _ | Report_alert _ -> Gd.Severity.Warning
    in
    let main_range = Option.bind e.main.loc loc_range in
    let labels, rem = Array.fold_left (fun (wl,wnl) (msg:Rd.error_msg) ->
        match Option.bind msg.loc loc_range with
        | None -> (wl, msg.msg :: wnl)
        | Some range ->
          Gd.Label.secondaryf ~range "%a" pp_children msg.msg :: wl,
          wnl) ([],[])
        (match e.sub with None -> [| |] | Some sub -> sub)
    in
    match main_range with
    | None ->
      Gd.createf
        ~labels
        ~code:Any
        level
        "%a%a" pp e.main.msg (Fmt.list pp) rem
    | Some main_range ->
      let primary =
        Gd.Label.primaryf ~range:main_range "%a" pp e.main.msg
      in
      Gd.createf
        ~labels:(primary::labels)
        ~code:Any
        level
        "%a" (Fmt.list pp) rem

let () =
  let input = Yojson.Safe.from_channel stdin in
  let d = Rd.compiler_of_yojson input in
  match d.error with
  | None -> ()
  | Some e ->
    let d = Grace_source_reader.with_reader (fun () -> reprint e) in
    Format.printf
      "%a@."
      Grace_ansi_renderer.(pp_diagnostic ())
      d
