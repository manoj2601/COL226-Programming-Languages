# Assignment 4: Integrating the earlier assignments into a simple spreadsheet
In Assignment 4: you will implement the backend, type-check the operations, and integrate the entire work.

You will need to check that the operations on rows, columns and ranges (especially  in type 2 operations)  are of consistent dimensions (two ranges being added should be of the same size).

You need to write clear specifications of the OCaml functions which you implement, and document your code.



## Backend



In order to evaluate the above functions, you might want to implement the following in OCaml:
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

