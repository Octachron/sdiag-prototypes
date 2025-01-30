let reference_1 ={|{
  "metadata" :
    { "version" : [1, 0], "downward_compatible" : true, "valid" : ["Full"]},
  "error" :
    {
      "kind" : ["Report_error"],
      "main" :
        {
          "msg" :
            [["Box", ["HV"], 0,
               [["Text", "This application of the functor "],
                 ["Tag", ["Inline_code"], [["Text", "F"]]],
                 ["Text", " is ill-typed."], ["Simple_break", 1, 0],
                 ["Text", "These arguments:"], ["Simple_break", 1, 2],
                 ["Box", ["B"], 0,
                   [["Tag", ["Preservation"], [["Text", "$S2"]]],
                     ["Simple_break", 1, 0],
                     ["Tag", ["Preservation"], [["Text", "()"]]]]],
                 ["Simple_break", 1, 0],
                 ["Text", "do not match these parameters:"],
                 ["Simple_break", 1, 2],
                 ["Box", ["B"], 0,
                   [["Tag", ["Insertion"], [["Text", "(X : $T1)"]]],
                     ["Simple_break", 1, 0],
                     ["Tag", ["Preservation"], [["Text", "(Y : ...)"]]],
                     ["Simple_break", 1, 0],
                     ["Tag", ["Preservation"], [["Text", "()"]]],
                     ["Simple_break", 1, 0], ["Text", "-> ..."]]]]]],
          "loc" :
            {
              "file" : "err.ml",
              "start_line" : 2,
              "stop_line" : 2,
              "characters" : [11, 33]
            }
        },
      "sub" :
        [{
           "msg" :
             [["Tab_break", 0, 0],
               ["Tbox",
                 [["Tag", ["Insertion"], [["Text", "1. "]]], ["Set_tab"],
                   ["Box", ["HV"], 2,
                     [["Text",
                        "An argument appears to be missing with module type"],
                       ["Simple_break", 1, 2],
                       ["Box", ["B"], 0,
                         [["Text", "$T1"], ["Simple_break", 1, 0],
                           ["Text", "="], ["Simple_break", 1, 0],
                           ["Box", ["B"], 2,
                             [["Box", ["HV"], 2,
                                [["Text", "sig"], ["Simple_break", 1, 0],
                                  ["Box", ["B"], 2,
                                    [["Box", ["HV"], 2, [["Text", "type x"]]]]],
                                  ["Simple_break", 1, -2], ["Text", "end"]]]]]]]]]]]]
         },
          {
            "msg" :
              [["Tab_break", 0, 0],
                ["Tbox",
                  [["Tag", ["Preservation"], [["Text", "2. "]]], ["Set_tab"],
                    ["Box", ["HV"], 2,
                      [["Text",
                         "Module $S2 matches the expected module type"]]]]]]
          },
          {
            "msg" :
              [["Tab_break", 0, 0],
                ["Tbox",
                  [["Tag", ["Preservation"], [["Text", "3. "]]], ["Set_tab"],
                    ["Box", ["HV"], 2,
                      [["Text", "Module () matches the expected module type"]]]]]]
          }]
    }
}
|}

let ref2 = {|{
  "metadata" :
    { "version" : [1, 0], "downward_compatible" : true, "valid" : ["Full"]},
  "error" :
    {
      "kind" : ["Report_error"],
      "main" :
        {
          "msg" :
            [["Box", ["B"], 0,
               [["Box", ["B"], 2,
                  [["Text",
                     "This variant expression is expected to have type"],
                    ["Simple_break", 1, 0],
                    ["Tag", ["Inline_code"],
                      [["Box", ["B"], 0, [["Text", "exn"]]]]]]],
                 ["Simple_break", 1, 0],
                 ["Text", "There is no constructor "],
                 ["Tag", ["Inline_code"], [["Text", "No_found"]]],
                 ["Text", " within type "],
                 ["Tag", ["Inline_code"], [["Text", "exn"]]]]],
              ["Flush", false], ["Newline"],
              ["Box", ["B"], 0,
                [["Tag", ["Hint"], [["Text", "Hint"]]],
                  ["Text", ": Did you mean "],
                  ["Tag", ["Inline_code"], [["Text", "Not_found"]]],
                  ["Text", "?"]]]],
          "loc" :
            {
              "file" : "serr.ml",
              "start_line" : 1,
              "stop_line" : 1,
              "characters" : [14, 22]
            }
        }
    }
}
|}

let json x = Yojson.Safe.from_string x


let test x = match Reader.Diagnostic.compiler_of_yojson (json x) with
  | _ -> Format.eprintf "OK@."; true
  | exception Ppx_yojson_conv_lib.Yojson_conv.Of_yojson_error(Failure reason, _) ->
    Format.eprintf "Failure %s@." reason; false
let () =
  if test ref2 && test reference_1 then exit 0 else exit 2
