type vector = float list
type matrix = float list list

exception InvalidInput
exception UnequalVectorSize
exception UnequalMatrixShape
exception IncompatibleMatrixShape
exception SingularMatrix

let rec vdim (v:vector): int =  (*returns the dimension of the given vector*)
	match v with 
	| x::xs -> 1+vdim xs
	| _ -> 0;;

let rec mkzerov (n:int): vector = (*given a dimension n > 0, returns the zero vector of that dimension*)
	if(n < 0) then raise InvalidInput
	else 
	match (n:int) with
	| 1 -> [0.0]
	| _ -> 0.0 :: mkzerov (n-1)
;;

let rec iszerov (v:vector): bool = (* checks if a given vector is a  zero vector*)
	match v with
	| [] -> true
	| x::xs ->  match x with 
		| 0.0 -> iszerov xs
		| _ -> false
;;

let rec addv (v1:vector) (v2:vector): vector = (* adds two vectors v1 and v2 (of the same dimension)*)
	if (vdim v1 <> vdim v2) then raise UnequalVectorSize
	else
	match v1, v2 with
	| x :: xs , y :: ys -> x+.y :: addv xs ys 
	| _ -> []
;;

let rec scalarmultv (c:float) (v:vector): vector = 
	match v with
	| x :: xs -> c *. x :: scalarmultv c xs
	| _ -> []
;;

let rec dotprodv (v1:vector) (v2:vector): float =
	if (vdim v1 <> vdim v2) then raise UnequalVectorSize
	else
	match v1, v2 with
	| x :: xs, y :: ys -> x *. y +. dotprodv xs ys
	| _ -> 0.0
;;
(*crossprodv is on the bottom*)	
(*VECTOR ENDS*)

	
let rec mdimrow (m:matrix) (a:int): int = (*Helper function of mdim*)
	match m with
	| x::xs -> mdimrow xs (a+1)
	| _ -> a
;;

let rec mdim (m:matrix): int*int =
	match m with
	| x :: xs -> 
		 ((mdimrow m 0) , (vdim x))
	| _ -> (0 , 0)
;;


let rec mkzerom (m_:int) (n_:int): matrix =
	if m_ < 0 then raise InvalidInput
	else if n_ < 0 then raise InvalidInput
	else 
	match m_ with 
	| 1 -> [mkzerov n_]
	| _ -> mkzerov n_ :: mkzerom (m_-1) n_
;;



let rec iszerom (m:matrix): bool =
	match m with
	| [] -> true
	| x::xs -> match (iszerov x) with
		| true -> iszerom xs
		| false -> false
;;

let rec mkunitmhelper (m: matrix) : matrix = (*it will add 0 to the 1st index of all rows*)
	match m with
	| x::xs -> (0.0 :: x) :: mkunitmhelper xs
	| [] -> []
;;


let rec mkunitm (m_:int): matrix =
	if(m_<1) then raise InvalidInput
	else
	match m_ with
	| 1 -> [[1.0]]
	| _ -> 
		match mkunitm (m_-1); with 
		| x::xs ->(1.0 :: mkzerov (m_-1)) :: mkunitmhelper (mkunitm (m_-1))
		| _ -> []
;;

let rec getnthv (v:vector) (i:int) : float = (*return element with nth index in the vector*)
	match v,i with
	| x :: xs, 0 -> x
	| x :: xs, _ -> getnthv xs (i-1)
	| [], _ -> 0.0
;;

let rec isunitmhelper (m:matrix) (i:int): bool = (*helper function for isunitm*)
	match m with
	| x::xs -> 
		if(getnthv x i = 1.0) then isunitmhelper xs (i+1)
		else false
	| _ -> true
;;
let rec isunitm (m:matrix): bool =
	match mdim m with 
	| (a, b) -> if(a <> b ) then raise UnequalMatrixShape
			else isunitmhelper m 0
;;

let rec addm (m1:matrix) (m2:matrix): matrix =
	if(mdim m1 <> mdim m2) then raise UnequalMatrixShape
	else	
	match m1, m2 with
	| x::xs, y::ys -> (addv x y) :: addm xs ys
	| _, _ -> []
;;

let rec scalarmultm (c:float) (m:matrix): matrix = 
	match m with
	| x::xs -> (scalarmultv c x) ::	(scalarmultm c xs)
	| _ -> []
;;


let rec multmhelper (v:vector) (m:matrix): vector = (*2nd helper function of multm*)
	match m with
	| x::xs -> (dotprodv v x) :: multmhelper v xs
	| _ -> []
;;
	
let rec multmhelperII (m1:matrix) (m2:matrix): matrix = (*1st helper function of multm*)
	match m1 with 
	| x::xs -> multmhelper x m2 :: multmhelperII xs m2
	| _ -> [];;



let rec transhelperII (v:vector) : matrix = (*second helper function for transm*)
	match v with
	| x::xs -> [x] :: transhelperII xs
	| _ -> []
;;

let rec transmhelper (m:matrix) (v:vector) : matrix = (*first helper function for transm*)
	match m, v with
	| x::xs, y::ys -> (y::x) :: (transmhelper xs ys) 
	| _, _ -> transhelperII v
;;
let rec transm (m:matrix): matrix = 
	match m with
	| x::xs -> transmhelper (transm xs ) x 
	| _ -> []
;;

let rec mdimcol (m:matrix) : int =
	match m with
	|x::xs -> vdim x
	| _ -> 0;;

let rec multm (m1:matrix) (m2:matrix): matrix =
	if(mdimcol m1 <> mdimrow m2 0) then raise IncompatibleMatrixShape
	else
	multmhelperII m1 (transm m2)
;;

let rec removenth (v:vector) (n:int) : vector =  (*helper function of detm*)
	if ( n = 0) then
		match v with 
		| x :: xs -> xs
		| _ -> []
	else	
		match v with
		| x::xs -> x :: removenth xs (n-1)
		| _ -> []
;;
  
let rec removecol (m:matrix) (n:int): matrix = (*helper function of detm*)
	match m with
	| x::xs -> removenth x n :: removecol xs n
	| _ -> []
;;

let rec multhelperII (m1:matrix) (v:vector) = (*helper function of detm*)
	     let rec
     		oddlocal m1 v i = 
		match v with
    		 | x :: xs ->  (x *. (detm1 (removecol m1 i;) ) ) +. (evenlocal m1 xs (i+1) )
		 | _ -> 0.0
	    and
	     evenlocal m1 v i = match v with
	    |   [] -> 0.0
	    | 	x :: xs -> ((-1.0) *. ( x*.detm1 (removecol m1 i;) )) +.( oddlocal m1 xs (i+1))
  in
   oddlocal m1 v 0;
    
and detm1 (m:matrix): float = (*helper function of detm*)
	match m with
	| x::xs -> multhelperII xs x
	| _ -> 1.0
;;


let rec detm (m:matrix): float =
	if( mdimcol m <> (mdimrow m 0) ) then raise UnequalMatrixShape
	else	
	detm1 m
;;
let rec removerow (m:matrix) (n:int): matrix = (*helper function of cofactm*)
	if (n = 0) then
		match m with 
		| x::xs -> xs
		| _ -> []
	else
		match m with
		| x::xs -> x :: removerow xs (n-1) 
		| _ -> []
;;

let rec cofacthelperII (m1:matrix) (v:vector) (row:int) = (*helper function of cofactm*)
	     let rec
     		oddlocal m1 v i = 
		match v with
    		 | x :: xs ->  (detm1 (removecol m1 i;) )  :: (evenlocal m1 xs (i+1) )
		 | _ -> []
	    and
	     evenlocal m1 v i = match v with
	    |   [] -> []
	    | 	x :: xs -> (-1.0) *. ( detm1 (removecol m1 i;) ) :: ( oddlocal m1 xs (i+1))
  in
	if(row mod 2 = 0) then
   oddlocal m1 v 0
	else evenlocal m1 v 0;
	and detm1 (m:matrix): float =
	match m with
	| x::xs -> multhelperII xs x
	| _ -> 1.0
;;

let rec cofactrow (m:matrix) (i:int) (v:vector) : vector =
	match m with
	| x::xs -> cofacthelperII (removerow m i;) x i
	| [] -> []
;;

let rec cofactm (m1:matrix) (m:matrix) (i:int): matrix = 
	match m with
	| x::xs -> cofactrow m1 i x :: cofactm m1 xs (i+1)
	| _ -> []
;;

let rec transcofact (m:matrix) : matrix =
	transm (cofactm m m 0);;



let rec invm (m:matrix): matrix = 
	if( (detm m) = 0.0) then raise SingularMatrix
	else
	scalarmultm ( (1.0)/.(detm m) )  (transcofact m)
;;
	

let rec printvector (v: vector) =
	match v with
	| x::xs -> print_float x; print_string " "; printvector xs
	| _ -> print_string "\n";;

let rec printmatrix (m: matrix) = 
	match m with
	| x::xs -> 	
		printvector x; printmatrix xs
	| _ -> print_string "\n"
;;
   
let rec crossprodv (v1:vector) (v2:vector): vector = (*it is of vector type function*)
	if( vdim v1 <> vdim v2) then raise UnequalVectorSize
	else
	match v1 with
	|x::xs -> ( (detm [[1.0; 0.0; 0.0]; v1; v2] ) ::( (detm [[0.0; 1.0; 0.0]; v1; v2] ) :: ( detm [[0.0; 0.0; 1.0]; v1; v2] :: [] )) )
	| _ -> raise UnequalVectorSize
;;

let v1 = [1.0; 2.0; 3.0];;
let v2 = [5.0; 7.0; 8.0];;
(*addv v1 (0.0::v2);;*)
(*printvector (crossprodv v1 v2);;*)
(*let rec a =*)
(*	match a with*)
(*	| (x, y) -> print_int x; print_int y*)
(*	| _ -> print_int 12;;*)

