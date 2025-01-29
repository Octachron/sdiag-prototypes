let reference ={|
{
  "metadata" :
    { "version" : [1, 0], "downward_compatible" : true, "valid" : "Full"},
  "error" :
    {
      "kind" : "Report_error",
      "main" :
        {
          "msg" :
            [["Box", "HV", 0,
               [["Text", "This application of the functor "],
                 ["Tag", "Inline_code", [["Text", "F"]]],
                 ["Text", " is ill-typed."], ["Simple_break", 1, 0],
                 ["Text", "These arguments:"], ["Simple_break", 1, 2],
                 ["Box", "B", 0,
                   [["Tag", "Preservation", [["Text", "$S2"]]],
                     ["Simple_break", 1, 0],
                     ["Tag", "Preservation", [["Text", "()"]]]]],
                 ["Simple_break", 1, 0],
                 ["Text", "do not match these parameters:"],
                 ["Simple_break", 1, 2],
                 ["Box", "B", 0,
                   [["Tag", "Insertion", [["Text", "(X : $T1)"]]],
                     ["Simple_break", 1, 0],
                     ["Tag", "Preservation", [["Text", "(Y : ...)"]]],
                     ["Simple_break", 1, 0],
                     ["Tag", "Preservation", [["Text", "()"]]],
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
                 [["Tag", "Insertion", [["Text", "1. "]]], "Set_tab",
                   ["Box", "HV", 2,
                     [["Text",
                        "An argument appears to be missing with module type"],
                       ["Simple_break", 1, 2],
                       ["Box", "B", 0,
                         [["Text", "$T1"], ["Simple_break", 1, 0],
                           ["Text", "="], ["Simple_break", 1, 0],
                           ["Box", "B", 2,
                             [["Box", "HV", 2,
                                [["Text", "sig"], ["Simple_break", 1, 0],
                                  ["Box", "B", 2,
                                    [["Box", "HV", 2, [["Text", "type x"]]]]],
                                  ["Simple_break", 1, -2], ["Text", "end"]]]]]]]]]]]]
         },
          {
            "msg" :
              [["Tab_break", 0, 0],
                ["Tbox",
                  [["Tag", "Preservation", [["Text", "2. "]]], "Set_tab",
                    ["Box", "HV", 2,
                      [["Text",
                         "Module $S2 matches the expected module type"]]]]]]
          },
          {
            "msg" :
              [["Tab_break", 0, 0],
                ["Tbox",
                  [["Tag", "Preservation", [["Text", "3. "]]], "Set_tab",
                    ["Box", "HV", 2,
                      [["Text", "Module () matches the expected module type"]]]]]]
          }]
    }
}
|}

let json = Yojson.Safe.from_string reference

let _ = match Reader.Diagnostic.compiler_of_yojson json with
  | _ -> Format.eprintf "OK@."
  | exception _ -> Format.eprintf "Error parsing reference file@."; exit 2
