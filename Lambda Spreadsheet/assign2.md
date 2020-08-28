# Assignment 2: Lexical Analysis for Spreadsheet Assignment
## Read the resource file describing assignments 2-4. 

In Assignment 2: you only need to provide the lex specifications, and so do not need to concern yourself with the meaning and implementation of the operations and how they are used.


You need to write clear specifications of the OCaml functions which you implement, and document your code.




Tokens for OCamllex would be, but not limited to:

1. Float constants (with optional sign, no redundant initial zeroes before the decimal point or unnecessary trailing zeroes after the decimal point)
2. Parenthesis — ( and )
3. Brackets — [ and ]
4. Comma — ,
5. Colon —  :
6. Indices I — [ i , j ]
7. Ranges R — ( I : I )
8. Unary operators: SUM, AVG, MIN, MAX, COUNT, etc. (see below)
9. Binary operators: ADD (addition), SUBT (subtraction), MULT (multiplication), DIV (division)
10. Assignment operator  :=
11. Formula termination  ; (semicolon) 
The function operations can be one of the following:



Type 1 (unary operations on ranges of cells):

1. COUNT
2. ROWCOUNT
3. COLCOUNT
4. SUM
5. ROWSUM
6. COLSUM
7. AVG
8. ROWAVG
9. COLAVG
10. MIN
11. ROWMIN
12. COLMIN
13. MAX
14. ROWMAX
15. COLMAX
Type 2 (binary operations on ranges of cells):

1. ADD
2. SUBT
3. MULT
4. DIV
