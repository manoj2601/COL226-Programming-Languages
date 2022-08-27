open Backend

let rec tableForm prog lexbuf = 
  let result = Parser.main Lexer.token lexbuf in
  match result with 
  | (Node(("EoF", 0), []), []) -> prog
  | _ -> (tableForm (prog@[result]) lexbuf)
;;
let table =
    let filename = Sys.argv.(1) in 
    let file = open_in filename in
    let lexbuf = Lexing.from_channel file in
    (tableForm [] lexbuf)
    ;;

let _ = 
  Printf.printf "?-"; flush stdout;
  let lexbuf = Lexing.from_channel stdin in
    while true do
      let result = Parser.main Lexer.token lexbuf in
        match result with 
        (Node(("halt",0),[]),[]) -> Printf.printf "\nexiting.\n";flush stdout; exit 0
        |(goal,[]) ->( 
          let r = solution table (goal, []) in
          Printf.printf "\n?-"; flush stdout;
        ) 
        | _-> Printf.printf "Invalid input goal\n";Printf.printf "\n?-"; flush stdout;
    done
;;