# POWER METHOD

## DESCRIPTION
The program computes the first eigenvalue of a symmetric matrix using the power method. This is done using three implementations:

- **1.** CPU version, using FORTRAN functions `matmul` and `dot_product`.
- **2.** GPU version, using OpenMP to accelerate matrix-vector multiplication.
- **3.** CPU version, using the non parallelized GPU code.

The execution time is computed each time and printed in the output. The objective is to compare the execution time on GPU and CPU.

The symmetric matrix is filled as follows

do i=1,n-1

do   j=i+1

   a(i,j) = 1.0d0

   a(j,i) = 1.0d0

enddo

enddo.

The dimension **n** is given by input.

DISCLAIMER: The program is specifically thought to be run on CINECA G100 machine. It could be run probably on other systems with some slight modifications in the compilation and usage phase.

## INSTRUCTIONS FOR USE

Once the program is installed (see INSTALL.md) an input file is needed. The input file should be named 'input' and have the following structure

integer :: n, Dimension of the matrix a(n,n)

real :: eps, Convergence threshold

integer :: nmax, Maximum number of iterations of the power method

For example given the input file

---

25000
0.01
10000

---

the program will compute the first eigenvalue of a (25000,25000) matrix using a convergence threshold of 0.001 with a maximum number of iterations of 100. The previous input can be found in the results directory and is called input_25k.

Once the input file is ready the program can be run by submitting the submit.sh bash script

sbatch submit.sh

Once the job stops you should find a file named 'output' in your directory.

The previous input example should give as output the following

---

 dimension of the matrix
        25000

 convergence threshold
   1.0000000000000000E-003

 maximum number of iterations
          100

 ------------------- CPU ONLY FORTRAN FUNCTIONS ---------------------

 lambda    1.962707695494011

 execution time cpu    59.26391196250916

 ------------------- GPU ---------------------

 lambda    1.962707695494017

 execution time gpu    2.916820049285889

 ------------------- CPU ONLY EXPLICIT FUNCTION ---------------------

 lambda    1.962707695494009

 execution time cpu    595.1535840034485

---

This output can be found in the results directory with the name 'output_25k'.

## POWER METHOD ALGORITHM

The power method algorithm starts with a random b normalized vector and a (n,n)
symmetric matrix A then a while loop does the following

1. compute c = A*b
2. normalize c
3. compute the squared error ||c-b||**2
4. set b = c
5. stop when error is less than threshold or when the number of iterations
   is greater then nmax

For each of the implementations the algorithm is the same.

### CPU IMPLEMENTATION

The first CPU implementation uses the fortran functions

- 'matmul' for matrix-vector multiplication.

- 'dot_product' for computing the squared norm and error.

- 'dsqrt' for computing the norm from it's square.

The power method algorithm is then implemented naively.

### GPU IMPLEMENTATION

The GPU version uses OpenMP to parallelize the code. In this case the power
method algorithm is implemented as follows.

First a target data region is created using the command

!$omp target data map(A,b,c,dd,error,rootdd)

this ensures that the there are no unnecessary data transfers between the GPU
and the CPU.

Inside the target data region a while do loop does the following

1. reset vector c = 0.d0 on the GPU

2. matrix-vector product c = A*b on the GPU

3. computation of the vector squared norm using a reduction on the GPU

4. the squared norm is transfered to the CPU

5. the CPU computes the norm from it's square using the dsqrt fortran function

6. the norm is then transfered to GPU

7. normalization of c on the GPU

8. computation of the error ||c-b||**2 using a parallel reduction on the GPU

9. transfer of the error value to the CPU

10. update of vector b on the GPU

11. On the CPU the condition (number of iterations > maximum allowed number) is tested ifthe result is negative the condition (error < threshold) is tested if this is also negative the loops goes to 1. If any of the results is positive the loop stop.


Each of the operations executed on the GPU is done by explicit (nested if necessary) do loops.
To distribute the workload of a do loop on the GPU the following command is used

!$omp target teams distribute parallel do

If a reduction after the do loop is needed, the command

!$omp target teams distribute parallel do reduction(+:)

is used instead. The keyword reduction(+:) ensures that the reduction
will be done by summing up the stored values on each thread. This is
specifically the case of the dot product.

The error and the norm are transfered to the CPU because respectevily the condition is tested on it and the dsqrt function doesn't work on the GPU.

After the while loop the line

!$omp end target data

marks the end of the target data region.

### EXPLICIT CPU IMPLEMENTATION

A second CPU implementation uses the same algorithm for the GPU but without parallelization.

###
~
~
