type arity = int;;
type variable = string;; (*The type of variable is a string*)
type symbol = string;; (*The type of symbol is a string*)
type pair = (symbol*arity);;
type signature = pair list;; (*Signature is a list of symbol, arity pairs.*)
type term = V of variable
	| Node of symbol*(term list)
	;;

(*Baiscally symbol here represents the name of the symbol. Arity of each symbol can be known by signature.*)
(*A term can be either V of variable or a Node of symbol, term list.*)
exception Impossible;;
exception NOT_UNIFIABLE;;
exception Invalid;;
exception InvalidInput;;

(*
So basically Signature is a set of Symbol*arity pairs.
*)

(*function issamesymbolname : val issamesymbolname : pair -> pair -> bool = <fun>
For two given symbol, arity pairs it returns a bool whether the symbol of both pairs is same or not.
Apply pattern matching on p1.
Apply pattern matching on p2. 
Compare first elements of both pairs, if both are equal return true else false.
*)
let issamesymbolname (p1:pair) (p2:pair) : bool =
	match p1 with
	(a,b) ->
			match p2 with
			(c,d) ->
				if a = c then true else false;
;;

(*function issamearity : val issamearity : pair -> pair -> bool = <fun>
For two given symbol, arity pairs it returns a bool whether the arity of both pairs is same or not.
Apply pattern matching on p1.
Apply pattern matching on p2. 
Compare second elements of both pairs, if both are equal return true else false.
*)
let issamearity (p1:pair) (p2:pair) : bool =
	match p1 with
	(a,b) ->
			match p2 with
			(c,d) ->
				if b = d then true else false;
;;

(*
function countinlist : val countinlist : pair list -> pair -> int = <fun>
for a given pair list and a pair, 
	it returns the total number of pairs in the list that contains the same symbol name as the given pair.
Apply pattern matching on the pair list.
	Base case : if list is empty , return 0;
	Induction Hypothesis : let the the count for a list l of size k is n = countinlist l m;
	Inductive step : let the size of the list 'ls' is k+1,
					Divide ls in two parts, a pair 'x' (first element of the list) and a list xs of size k.
					By induction hypothesis,
							The count for the list xs of size k is n= countinlist xs m.
						Now we only need to check the pair x, 
							if pair x has the same symbol name then the count will be 1+n otherwise n.
*)
let rec countinlist (l:pair list) (m:pair) : int = match l with
	| [] -> 0
	| x::xs -> if ( issamesymbolname x m ) then 1+(countinlist xs m)
			else countinlist xs m;
;;

(*This function finds the arity of a symbol from the given signature.
If that symbol does not present in the given signature, it returns -1 else returns the arity
val findarity : symbol -> signature -> arity = <fun>
*)
let rec findarity (s:symbol) (s1:signature): arity =
	match s1 with
	| [] -> -1
	| x::xs -> match x with
				(a,b) -> if a = s then b else
				findarity s xs
;;

(*
CONDITIONS FOR SIGNATURE : 
	input is as a list of (symbol, arity) pairs 
	A valid signature cannot have ("a", 0) and ("a", 1) together.
	A valid signature cannot have negative arity.
*)
(*
val check_sig : signature -> bool = <fun>
Base case : if sig is null, return true;
if sig is non-null, take first element of the set sig, (let it 'x')
	check the validity of x.
	if it is valid, go for the remaining part of sig, (i.e. check xs by considering xs as a separate signature)

*)
let rec check_sig (l:signature) : bool = match l with
	| [] -> true
	| x::xs -> if (countinlist l x) = 1 then
				begin
					match x with
					(a,b) -> if b >=0 then check_sig xs else false;
				end
			else false
;;

(*
Input : check_sig [("Anuj",-1)] ;;
Output : -: bool = false

Input : check_sig [("Anuj",2);("Anuj",3)] ;;
Output : -: bool = false

Input : check_sig [("Anuj",2);("Manoj",2);("Kumar",3)] ;;
Output : - : bool = true
*)

(*
val wfterm : signature -> term -> bool = <fun>
val checkinglist : signature -> term list -> bool = <fun>

input form : A signature and a term
output form : boolean

it returns true if the term is well formed.
Conditions of being a well formed term :
1. If the term is V of variable, it is well formed.
2. If the term is a Node,
	i. If the arity of the symbol is non-negative.
	ii. If the arity of the symbol is same as the length of the given term list in the Node.
	iii. All the terms of the term list are also well formed.


Steps to find : pattern matching
1. If term is a variable -> true
2. if term is a node ->	
		if arity is equal to the length of the term list, check for all terms of the term list to be well formed.
*)

let rec wfterm (sign:signature) (t:term) : bool=
	match t with
	| V a -> true
	| Node (sym,lis) -> 
						let a = (findarity sym sign) in
						if (a <> List.length lis) then false else (checkinglist sign lis);

	and checkinglist (sign:signature) (lis:term list) =
	match lis with
	| [] -> true
	| x::xs -> if(wfterm sign x) then (checkinglist sign xs) else false
;;

(*
Input : wfterm [("Anuj",2);("Kumar",1)] (Node("Anuj",[Node("Anuj",[V("X");V("X")]);Node("Anuj",[V("X");Node("Kumar",[V("Y")])])])) ;;
Output : - : bool = true

Input : wfterm [("Anuj",2);("Kumar",1)] (Node("Anuj",[Node("Anuj",[Node("India",[]);Node("India",[])]);Node("Anuj",[Node("India",[]);Node("Kumar",[V"Nepal"])])])) ;;
Output : - : bool = false

Input : wfterm [("Anuj",2);("Kumar",1);("India",0)] (Node("Anuj",[Node("Anuj",[Node("India",[]);Node("India",[])]);Node("Anuj",[Node("India",[]);Node("Kumar",[V"Nepal"])])])) ;;
Output : - : bool = true
*)

(*
val ht : term -> int = <fun>
val listfill : term list -> int list -> int list = <fun>
Here we assume that height of a V of Variable or a Node with 0 arity is 0.

Use of inbuilt function : List.fold_left
If the term is Node then Call the function recursively on each term of the term list. Add 1 to the maximum height of the the term list.
*)
let rec ht (t:term): int = match t with
	| V a -> 0
	| Node (sym,tl) -> let len = (List.length tl) in
						if (len = 0) then 0 else
						let temp = [] in
						let l = listfill tl temp in
						1 + List.fold_left (fun a b -> if a>b then a else b) 0 l

	and listfill (tl:term list) (l:int list) =
		match tl with
		| [] -> l
		| x::xs -> 
					listfill xs l@[(ht x)]
;;



(*
Input : ht (Node("Anuj",[Node("Anuj",[V("X");V("X")]);Node("Anuj",[V("X");Node("Kumar",[V("Y")])])])) ;;
Output : -: int = 3

Input : ht (Node("Anuj",[Node("Anuj",[Node("India",[]);Node("India",[])]);Node("Anuj",[Node("India",[]);Node("Kumar",[V"Nepal"])])])) ;;
Output : -: int = 3
*)

(*
val size : term -> int = <fun>
val listfill : term list -> int list -> int list = <fun>


Use of inbuilt function : List.fold_left
If the term is Node then Call the function recursively on each term of the term list. Add 1 to the summation of the all sizes of the list of the the term list.
*)
let rec size (t:term):int = match t with
	| V a -> 1
	| Node (sym,tl) -> let len = (List.length tl) in
						if (len = 0) then 1 else
						let temp = [] in
						let l = listfill tl temp in
						List.fold_left (fun a b -> a+b) 1 l

	and listfill (tl:term list) (l:int list) =
		match tl with
		| [] -> l
		| x::xs -> 
					listfill xs l@[(size x)]
;;


(*
Input : size (Node("Anuj",[Node("Anuj",[V("X");V("X")]);Node("Anuj",[V("X");Node("Kumar",[V("Y")])])])) ;;
Output : - : int = 8

Input : size (Node("Anuj",[Node("Anuj",[Node("India",[]);Node("India",[])]);Node("Anuj",[Node("India",[]);Node("Kumar",[V"Nepal"])])])) ;;
Output : - : int = 8
*)


(* 
let rec union (l1: variable list) (l2:variable) : variable list =
	if (findinlist l2 l1) then l1
				else l1@[l2]
;; *)

(*
val findinlist : variable -> variable list -> bool = <fun>
For a given variable 'x' and a given variable list 'l2', it returns a boolean value
if l2 is empty, returns false
if first element of the list is same as given variable, return true, else call recursively the function on the remaining list.
*)
let rec findinlist (x:variable) (l2:variable list) : bool =
	match l2 with
	| []-> false
	| y::yx -> if x=y then true else findinlist x yx
;;

(*
val vars : term -> variable list = <fun>
val listfill : term list -> variable list -> variable list = <fun>

It returns the set of variables in the term.
*)
let rec vars (t:term) = match t with
	| V a -> [a]
	| Node (sym,tl) ->  let len = (List.length tl) in
						if (len = 0) then [] else
						let temp = [] in
						let l = listfill tl temp in
						List.fold_left (fun a b -> if findinlist b a then a else a@[b]) [] l
	
	and listfill (tl:term list) (l:variable list) : variable list =
		match tl with
		| [] -> l
		| x::xs -> 
					listfill xs (l@(vars x))
;;

(*
Input : vars (Node("Anuj",[Node("Anuj",[V("X");V("X")]);Node("Anuj",[V("X");Node("Kumar",[V("Y")])])])) ;;
Output : - : variable list = ["X"; "Y"]

Input : vars (Node("Anuj",[Node("Anuj",[Node("India",[]);Node("India",[])]);Node("Anuj",[Node("India",[]);Node("Kumar",[V"Nepal"])])])) ;;
Output - : variable list = ["Nepal"]
*)

(*substitution is the type of (variable*term) list.*)
type substitution = (variable*term) list;;

(*
val isvarinsub : variable -> substitution -> bool = <fun>

For a given v:variable and s:substitution, it returns a boolean value.
If list is empty, returns false
If the variable of the given substitution element is same as the given variable v, returns true else check for the remaining list.
*)
let rec isvarinsub (v:variable) (s:substitution) : bool =
	match s with
	| [] -> false
	| x::xs -> match x with
			| (a,b) -> if a = v then true else isvarinsub v xs
;;

(*
val termforvar : variable -> substitution -> term = <fun>
For a given v:variable and s:substitution, it returns a term.
If list is empty, raise InvalidInput.
If the variable of the given substitution element is same as the given variable v, returns the term else check for the remaining list.
*)
let rec termforvar (v:variable) (s:substitution) : term =
	match s with
	| [] -> raise InvalidInput
	| x::xs -> match x with
				| (a,b) -> if a = v then b else termforvar v xs;
;;


(*
val subst : term -> substitution -> term = <fun>
val helper : term list -> substitution -> term list = <fun>

For a given t:term and s:substitution, it returns the term with applied substitution.
if the given term is a variable, we check whether the given variable is in the substitution or not,
			if yes, then return that term else return the same V of variable;
if the given term is a Node, we create a new term list that consists of all the substituted terms of the corresponding term list.
		and return a new Node with the same symbol and new list.
*)
let rec subst (t:term) (s:substitution) : term =
	match t with
	| V (x) -> if (isvarinsub x s) then (termforvar x s) else V (x);
	| Node (sym, tl) -> let list = helper tl s in
						let t = Node (sym, list) in
						t
	and helper (tl:term list) (s:substitution) : term list =
	match tl with
	| [] -> []
	| x::xs -> (subst x s)::(helper xs s)
;;

(*
Input : subst (Node("Anuj",[Node("Anuj",[V("X");V("X")]);Node("Anuj",[V("X");Node("Kumar",[V("Y")])])])) [("X",Node("India",[]));("Y",V("Nepal"))] ;;
Output : - : term = Node("Anuj",[Node("Anuj",[Node("India",[]);Node("India",[])]);Node("Anuj",[Node("India",[]);Node("Kumar",[V"Nepal"])])])
*)
(* type substitution = (variable*term) list;; *)

(*
return the first element of a tuple.
*)
let firstelement p =
	match p with
	| (a,b) -> a
;;

(*
return the second element of a tuple.
*)
let secelement p =
	match p with
	| (a,b) -> b
;;

(*
return the ith element of a generic list.
*)
let rec ithelement (i:int) l = (*ith element of the list*)
	match l with
	| [] -> raise Invalid
	| x::xs -> if i=0 then x else ithelement (i-1) xs
;;

(* let rec updatesubs (p:(variable*term)) (sub:substitution) : substitution =
	match sub with
	| (var, t)::xs -> (match t with
					| V a -> if (a = (firstelement p)) then (var, secelement p) :: updatesubs p xs
							else (var, t) :: updatesubs p xs
					| Node (sym, tl) -> (var, Node (sym, (updatelist tl p))) :: updatesubs p xs;)
	| [] -> []
	and updatelist (tl:term list) (p:(variable*term)) : term list =
		match tl with
		| [] -> [];
		| x::xs -> match x with
				| V a -> if (a = (firstelement p)) then (secelement p) :: (updatelist xs p) else V a :: updatelist xs p
				| Node (sym, t) -> Node (sym, (updatelist t p)) :: updatelist xs p
;;  *)

(*let rec compositionhelper (s1: substitution) (s2: substitution) : substitution =
	match s1 with
	| [] -> []
	| x::xs -> match x with
				| (var, t) -> (var, subst t s2) :: compositionhelper xs s2
;; *)

(* let rec compositionhelper2 (s1:substitution) (s2:substitution) : substitution =
	let s = ref (compositionhelper s1 s2) in
	for i=0 to ((List.length s2) -1) do
		match (ithelement i s2) with
		| (var, t) -> if ((isvarinsub var !s) <> true) then s := (!s)@[(var, t)];
	done;
!s;; *)


(*
val composition : substitution list -> substitution = <fun>
val compositionhelper2 : substitution -> substitution -> substitution = <fun>
val compositionhelper : substitution -> substitution -> substitution = <fun>
val generalizationsubs : substitution -> substitution = <fun>

composition function takes a substitution list as an argument and return the composition of all the substitions.
pattern matching of subs
if subs is empty -> return empty list.
else create a mutable list ret that is empty initially.
for each substitution given in the list
	compose ret with the all substitutions serially by calling compositionhelper2 function.
remove all identity substitutes from ret by calling generalizationsubs and return the substitution ret.

compositionhelper2 : it takes two substitution s1 and s2 and returns their substitution s1s2.
it first create a mutable substitution 's' and that contains all the (variable*(substituted terms with s2)) pairs of s1.
	append s by adding substitutes that are not in s1 but in s2.

compositionhelper it substitutes s2 on each term of the pairs of s1 and returns the updated s1.

generalizationsubs : it takes a substitution as input and returns a substitutions after removing the identity substitutes of the input.
*)
let rec composition (subs: substitution list) : substitution =
	match subs with
	| [] -> []
	| x::xs ->
				let ret = ref [] in
				for i=0 to ((List.length subs) -1) do
					ret := compositionhelper2 (!ret) (ithelement i subs)
				done;

	generalizationsubs !ret

	and compositionhelper2 (s1:substitution) (s2:substitution) : substitution =
		let s = ref (compositionhelper s1 s2) in
		for i=0 to ((List.length s2) -1) do
			match (ithelement i s2) with
			| (var, t) -> if ((isvarinsub var !s) <> true) then s := (!s)@[(var, t)];
		done;
	!s
	and compositionhelper (s1: substitution) (s2: substitution) : substitution =
		match s1 with
		| [] -> []
		| x::xs -> match x with
				| (var, t) -> (var, subst t s2) :: compositionhelper xs s2

	and generalizationsubs (sub: substitution): substitution =
	match sub with
	| [] -> []
	| x::xs -> match x with
			| (var, t) -> if t <> V (var) then (var, t) :: generalizationsubs xs
							 else generalizationsubs xs
;;


(*
Input : composition [ [ ("x", Node ("f", [V ("a")])); ("y", Node("g", [V ("b"); V ("z")])); ("z", V ("x"))]; [("x", V ("w")); ("y", Node ("h", [V ("z")])); ("z", V ("a"))] ];;
Output : - : substitution = [("x", Node ("f", [V "a"])); ("y", Node ("g", [V "b"; V "a"])); ("z", V "w")]
*)

(*
val mguhelper : term -> term -> substitution -> substitution = <fun>

It is the helper function of mgu.
it takes t1, t2 terms and sub substitutions as arguments and returns a substitution that is mgu of t1 and t2.
first we apply the given sub on both terms t1 and t2.
if the updated t1 (t11) and updated t2 (t21) are same then return sub else pattern match t11 with
	I. if t11 is a variable (let x), two possibilities arise :
		1. if t21 is also a variable (let y)
				if the any of both variables are already present in the given substitution sub it raise Impossible exception because it is not possible.
				create a pair p of the variable x and the term V of y, and return the composition of the list [(given sub) ; [p]];
		2. if t21 is a Node (sym, tl)
				if variable x is already present in the given substitution, raise Impossible.
				if the variable x is present in t21, raise NOT_UNIFIABLE
				create a pair p of x and the given Node (sym, tl);
				return the composition [sub;[p]];
	II. if t21 is a Node (sym, tl), two possibilities arise : 
		1. if t21 is a variable (let y)
				if variable y is already present in the given substitution, raise Impossible.
				if the variable y is present in t11, raise NOT_UNIFIABLE
				create a pair p of y and the given Node (sym, tl);
				return the composition [sub;[p]];

		2. if t21 is also a Node (sym2, tl2)
				if the symbols of both nodes are not same, raise NOT_UNIFIABLE
				if the length of both term lists tl and tl2 are not same, raise NOT_UNIFIABLE
				Now create a mutable substitution ret and initilize it with sub.
				interate both lists tl and tl2 and update ret with mguhelper (ith element of tl) (ith element of tl2) (previous value of ret)
				finally return the substitution ret.

val isvarinterm : variable -> term -> bool = <fun>
It is the helper function of mguhelper.
it takes a variable v and term t in arguments, returns a boolean value.
if v is present in the term t, return true
else return false.
*)
let rec mguhelper (t1:term) (t2:term) (sub:substitution):substitution =
	let t11 = subst t1 sub in
	let t21 = subst t2 sub in
	if t11 <> t21 then begin
	match t11 with
	| V x -> 
			(match t21 with
			| V y -> 
			if x <> y then begin
				if (isvarinsub x sub || isvarinsub y sub) then raise Impossible;
				let p = (x, V y) in
				composition [sub;[p]];
				end
			else sub
			| Node (sym, tl) -> if(isvarinsub x sub) then raise Impossible;
								let p = (x, Node (sym, tl)) in
								if (isvarinterm x t21) then raise NOT_UNIFIABLE;
								composition [sub;[p]];)
	| Node (sym, tl) -> 
			(match t21 with
			| V y -> if (isvarinsub y sub) then raise Impossible;
					let p  = (y, Node (sym, tl)) in
					if (isvarinterm y t11) then raise NOT_UNIFIABLE;
					composition [sub;[p]];
			| Node (sym2, tl2) -> if (sym <> sym2) then raise NOT_UNIFIABLE;
								  if (List.length tl <> List.length tl2) then raise NOT_UNIFIABLE;
								  let ret = ref sub in
								  for i=0 to (List.length tl) -1 do
								  	ret := mguhelper (ithelement i tl) (ithelement i tl2) (!ret);
								done;
								(!ret);
							)
	end
	else sub
	and isvarinterm (v:variable) (t:term) : bool =
		match t with
	| V a -> if v = a then true else false;
	| Node (sym, tl) -> 
			 let isgot = ref false in 
			 for i=0 to (List.length tl-1) do
			 	let a = ithelement i tl in
			 	if (isvarinterm v a) then isgot := true;
			 	done;
			 	if (!isgot = true) then true else false
;;

(*
	val mgu : term -> term -> substitution = <fun>

	It takes two terms t1 and t2 and returns the mgu of both terms.
	It calls mguhelper with these two terms and an identity substitution.
*)
let mgu (t1:term) (t2:term) : substitution =
	mguhelper t1 t2 [];
;;

(*
Input : mgu (Node("Dipen",[Node("Anuj",[V("X");V("X")]);Node("Anuj",[V("Z");Node("Kumar",[V("Y")])]);Node("Nishant",[])])) (Node("Dipen",[Node("Anuj",[V("X");V("Y")]);Node("Anuj",[Node("Kumar",[V("Y")]);V("W")]);Node("Nishant",[])])) ;;
Output : - : substitution = [("W", Node ("Kumar", [V "Y"])); ("Z", Node ("Kumar", [V "Y"])); ("X", V "Y")]


Input : mgu (Node ("P", [Node ("a", []); V ("x"); Node ("f", [Node ("g", [V "y"])]) ] ) ) (Node ("P", [V ("z"); Node("f", [V "z"]); Node("f", [V "w"])]) ) ;;
Output : - : substitution = [("z", Node ("a", [])); ("x", Node ("f", [Node ("a", [])])); ("w", Node ("g", [V "y"]))]

Input : mgu (Node ("Q", [Node ("f", [Node ("a", [])]); Node ("g", [V "x"] )]) ) (Node ("Q", [V "y"; V "y"]));;
Output : Exception: NOT_UNIFIABLE.

Input : mgu (Node ("Q", [V "x"; V "x"])) (Node ("Q", [V "y"; Node ("f", [V "y"])]));;
Output : Exception: NOT_UNIFIABLE.

Input : mgu (Node ("Manoj", [V "x"; V "y"; V "z"] )) (Node ("Ranjana", [V "z"; V "y"; V "x"] ));;
Output : Exception: NOT_UNIFIABLE.

Input : let t1 = Node("red",[Node("green",[]);Node("blue",[]); V("yellow")]);;
	let t2 = Node("red",[Node("green",[]);Node("blue",[])]);;
	mgu t1 t2;;
Output : NOT_UNIFIABLE.

Input : let k1 = Node("red",[Node("green",[]);Node("blue",[]); V("yellow")]);;
	let k2 = Node("red",[Node("green",[]);Node("blue",[Node("white",[])]); Node("pink",[V("yellow")])]);;
	mgu k1 k2;;
Output : Exception: NOT_UNIFIABLE.

Input : let k1 = Node("red",[Node("green",[]);Node("blue",[]); V("yellow")]);;
	let k2 = Node("red",[Node("green",[]);Node("blue",[]); Node("pink",[V("yellow")])]);;
	mgu k1 k2;;
Output : Exception: NOT_UNIFIABLE.

Input : let t1 = Node("ankit",[ Node("niki",[V("babu")]) ; V("mama") ;Node("chiky",[V("chachi")]) ]);;
	let t2 = Node("ankit",[ Node("niki",[Node("papa",[V("mumma")])]) ;V("chachi"); Node("chiky",[V("dada")])]);;
	mgu t1 t2;;
Output : - : substitution = [("babu", Node ("papa", [V "mumma"])); ("mama", V "dada"); ("chachi", V "dada")]
	EXPLANATION:
	let m = mgu t1 t2;;
	Input : subst t1 m;; 
	Output : - : term = Node ("ankit", [Node ("niki", [Node ("papa", [V "mumma"])]); V "dada"; Node ("chiky", [V "dada"])])
	Input : subst t2 m;;
	Output : - : term = Node ("ankit", [Node ("niki", [Node ("papa", [V "mumma"])]); V "dada"; Node ("chiky", [V "dada"])])

Input : let t1 = Node ("+", [V "x"; V "y"]);;
		let t2 = Node ("+", [V "z"; V "z"]);;
		let m = mgu t1 t2;;
Output :  m : substitution = [("x", V "z"); ("y", V "z")]
	EXPLANATION:
		subst t1 m;;	- : term = Node ("+", [V "z"; V "z"])
		subst t2 m;;	- : term = Node ("+", [V "z"; V "z"])

Input : let t1 = Node ("f", [V "x"; V "y"]);
		mgu t1 t1;;
Output : - : substitution = []

Input : let s1 = [("x", Node ("f", [Node ("a", [])])); ("y", Node ("g", [Node ("b", []); V "z"]))];;
		let s2 = ["z" , Node ("a", [])];;
		composition [s1; s2];;
Output :- : substitution =
		[("x", Node ("f", [Node ("a", [])]));
		 ("y", Node ("g", [Node ("b", []); Node ("a", [])])); ("z", Node ("a", []))]
*)