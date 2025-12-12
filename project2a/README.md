# Sparse Matrix Multiplication in Fortran

@mainpage

Computes a matrix–matrix product with symmetric sparse matrices.

---

## Description

This Fortran program loads two sparse matrices and multiplies them using different
methods:

- **`n`**
**`n`**

and reports performance metrics,
scaling behavior, and fill-in of the resulting matrix.

---

## Directory Structure

### `sparse_module.f90`

This file defines a module that provides the `sparse_matrix` data structure and
routines for handling sparse matrices.

---

### Derived Type: `sparse_matrix`

The `sparse_matrix` type describes a matrix stored in sparse format and consists
of the following components:

- **`n`**  
  Integer specifying the dimension of the matrix.

- **`R`**  
  Integer array of size `n+1`.  
  The first element is always `R(1)`. Each subsequent element stores the
  cumulative number of non-zero elements per row, with `R(n+1)` equal to the
  total number of non-zero entries.

- **`C`**  
  Integer array whose size equals the number of non-zero elements.  
  It stores the column indices corresponding to the non-zero entries.

- **`V`**  
  Double-precision array whose size equals the number of non-zero elements.  
  It stores the values of the non-zero entries.

---

### Subroutine `read_sparse_matrix`

This subroutine reads a sparse matrix from an input file and stores it in a
`sparse_matrix` data structure.

**Input argument:**
- **`filename`**  
  Name of the input file.

**Output argument:**
- **`A`**  
  Sparse matrix stored in a `sparse_matrix` data structure.

**Local variables:**
- **`maxR`**  
  Integer specifying the maximum value of the `R` array, corresponding to the
  length of the `C` and `V` arrays.
- **`iostat`**  
  Status flag used to check whether the input file is opened and read correctly.

---

### Subroutine `multiply_sparse`

This subroutine multiplies two symmetric matrices of the same dimension, stored
in sparse format, and stores the result in a dense matrix. The multiplication
counts the total number of scalar multiplications performed.

**Input arguments:**
- **`A`**  
  First symmetric matrix in sparse format.
- **`B`**  
  Second symmetric matrix in sparse format.

**Output arguments:**
- **`Cdense`**  
  Dense matrix containing the result of the multiplication. Its size is the
  same as that of the input matrices.
- **`n_mul`**  
  Integer specifying the number of scalar multiplications performed during the
  computation.

**Local variables:**
- **`i`**  
  Integer index used to iterate over the rows of matrix `A`.
- **`j`**  
  Integer index used to iterate over the rows (and columns, due to symmetry) of
  matrix `B`.
- **`pA`**  
  Integer index used to scan the non-zero elements of the current row of matrix
  `A`.
- **`pB`**  
  Integer index used to scan the non-zero elements of the current row of matrix
  `B`.
- **`n`**  
  Dimension of the input matrices. Used to check that the dimensions are equal.
- **`y`**  
  Double-precision variable that accumulates the result of the inner
  multiplication loop for a single entry of the output matrix.

---

### Subroutine `sparse_to_dense(A,D,n)`

This subroutine converts a matrix in `sparse_matrix` into standard format. 

**Input arguments:**
 - **`A`**
   Matrix given in the `sparse_matrix` data format. 

 - **`n`**
   Dimension of the matrix A and D.

**Output arguments:**
 - **`D`**
   Matrix in standard (dense) format.

**Local variables:**
 -**`rowstart`**
  
 -**`rowend`**

 -**`i,j`**
---

### Subroutine `manual_matmul(A,B,C,N)`

This subroutine multiplies two matrices of dimension (N,N). The multiplication is done 

**Input arguments:**
 -**`A`**
  Dimension of matrix A.

 -**`B`**
  Dimension of matrix B.

 -**`N`**
  Dimension of matrices A,B.

**Output arguments:**

 -**`C`**
  Matrix of dimension N.

**Local variables:**
  
 -**`i,j,k`**
  Indexes for loop.

---

### Algorithm Description

The subroutine first checks whether the two input matrices have the same
dimension. The output matrix `Cdense` and the multiplication counter `n_mul`
are then initialized to zero.

For each pair of rows of matrices `A` and `B`, the algorithm scans their
non-zero elements. Whenever matching column indices are found, the
corresponding values are multiplied and accumulated in the variable `y`. Each
multiplication increments the counter `n_mul`.

Finally, the accumulated value `y` is stored in the dense result matrix
`Cdense`.

--- 

###
