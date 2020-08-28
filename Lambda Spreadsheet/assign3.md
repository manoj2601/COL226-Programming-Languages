## Assignment 3: Parser for Spreadsheet language
Read the description file common to assignments 2-4

In Assignment 3: you need to specify the structure of formulas as a yacc grammar, and call the appropriate operations that will be provided to you as a module.  Your implementation will be modular, in that you should be able to define your parser and create the interpreter framework irrespective of the actual implementation of the backend functions.  You may assume the types of the backend functions.

Informal Syntax



Informally the grammar of our spreadsheet formula language is:

1. An instruction has a head and a body. The head consists of a cell indexing the output destination of the formula, and the body consists of an expression  being evaluated with respect to the spreadsheet. The head and the body are separated by an assignment sign (:=)
2. A formula ends with a semicolon (;)
3. The arguments of a function are either indices, ranges, constants or expressions using mathematical operations
4. An index is a pair of integers.  General format for an index I of a cell is [i, j]   Examples are [0,0], [3,4], …
5. A range consists of two indices standing for the top left index and the right bottom index. General format for an range R of cells is ( I : I ) with an example being ( [ 5, 6] : [100, 6] )

The formulas provided to you are one on each line. The general format of a formula is given below:



### Type 1 formula (unary operations on a range of cells)

I := FUNC  R  ;



### Type 2 formula (binary operations on ranges)

I := FUNC R R ;

I := FUNC  C R ;

I := FUNC R C ;

I := FUNC  I R ;

I := FUNC R I ;




## Backend



You may assume there exists a module in OCaml with the following functions. 

1. full_count: sheet -> range -> index -> sheet : Fills count of valid entries in the given range into the specified cell
2. row_count: sheet -> range -> index -> sheet : Fills count of valid entries per row in the given range into the column starting from the specified cell
3. col_count: sheet -> range -> index -> sheet : Fills count of valid entries per column in the given range into the row starting from the specified cell.


4. full_sum: sheet -> range -> index -> sheet : Fills the sum of entries of cells in the given range into the specified cell
5. row_sum: sheet -> range -> index -> sheet : Fills the sum of entries of cells per row in the given range into the column starting from the specified cell
6. col_sum: sheet -> range -> index -> sheet : Fills the sum of entries of cells per column in the given range into the row starting from the specified cell


7. full_avg: sheet -> range -> index -> sheet : Fills the average of entries of cells in the given range into the specified cell
8. row_avg: sheet -> range -> index -> sheet : Fills the average of entries of cells per row in the given range into the column starting from the specified cell
9. col_avg: sheet -> range -> index -> sheet :  Fills the sum of entries of cells per column in the given range into the row starting from the specified cell


10. full_min: sheet -> range -> index -> sheet : Fills the min of entries of cells in the given range into the specified cell
11. row_min: sheet -> range -> index -> sheet : Fills the min of entries of cells per row in the given range into the column starting from the specified cell
12. col_min: sheet -> range -> index -> sheet : Fills the min of entries of cells per column in the given range into the row starting from the specified cell


13. full_max: sheet -> range -> index -> sheet : Fills the max of entries of cells in the given range into the specified cell
14. row_max: sheet -> range -> index -> sheet : Fills the max of entries of cells per row in the given range into the column starting from the specified cell
15. col_max: sheet -> range -> index -> sheet : Fills the max of entries of cells per column in the given range into the row starting from the specified cell


16. add_const: sheet -> range -> float -> index -> sheet : adds a constant to the contents of each cell in the selected cell range
17. subt_const: sheet -> range -> float -> index -> sheet : subtracts a constant from the contents of each cell in the selected cell range
18. mult_const: sheet -> range -> float -> index -> sheet : multiplies the contents of each cell in the selected cell range by a constant.
19. div_const: sheet -> range -> float -> index -> sheet : divides the contents of each cell in the selected cell range by a constant.


20. add_range: sheet -> range -> range -> index -> sheet : adds the cell contents for each corresponding pair of cells in two selected cell ranges
21. subt_range: sheet -> range -> range -> index -> sheet : performs a subtraction on the cell contents for each corresponding pair if cells in two selected cell ranges
22. mult_range: sheet -> range -> range -> index -> sheet : multiplies the cell contents for each corresponding pair of cells in two selected cell ranges
23. div_range: sheet -> range -> range -> index -> sheet : performs a division on the cell contents for each corresponding pair  of cells in two selected cell ranges

