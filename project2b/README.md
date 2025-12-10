POWER METHOD 

DESCRIPTION
The program computes the first eigenvalue of a symmetric matrix using the power method.
Three different implementation are provided:
1. CPU version, using FORTRAN functions <matmul> and <dot_product>
2. GPU version, using OpenMP to accelerate matrix-vector multiplication 
3. CPU version, using the non parallelized GPU code  
The objective is to compare the execution time of CPU and GPU which are computed separately in the implementations.

The symmetric matrix is filled as the following
        do i=1,n-1
           j=i+1
           a(i,j) = 1.0d0
           a(j,i) = 1.0d0
        enddo

REQUIREMENTS

In order to compile and run the code the program needs the nvhpc module.

PORTING DESCRIPTION

SYNTAX 

compilation:

nvfortran -mp=gpu -gpu=cc70 main.f90 -o main

execution (local):

./main

execution (with SLURM):

sbatch submit.sh

PROGRAM STRUCTURE 
INPUT PARAMETERS 
Program input (from standard input)
integer :: n #Dimension of the matrix a(n,n)
real :: eps #Convergence threshold
integer :: nmax #Number of maximum iterations of the power method 

INITIAL VECTOR 
A random vector b is generated and normalized to unit length.

POWER METHOD OVERVIEW 
Each version of the Power Method performs the following iterative steps:
1. compute c= a*b
2. normalize c
3. compute an error measure ||c-b||**2
4. set b = c 
5. stop when error less than eps or when niter greater then nmax

CPU IMPLEMENTATION 
The CPU version uses:
- matmul(a,b) for matrix-vector multiplication
- dot_product for both normalization and error estimation

GPU IMPLEMENTATION
DATA MAPPING
A target data region transfers and retains:
- the matrix a 
- vectors b and c
- auxiliary scalars (dd,error,rootdd)
GPU KERNELS
The following operations are executed on the GPU 
- reset vector c
- matrix-vector product c=a*b
- computation of the vector norm using a parallel reduction
- normalization of c
- computation of the convergence error using a parallel reduction 
- update of vector b
CPU - GPU SYNCHRONIZATION 
only scalar values (dd and error) are exchanged with the CPU:
- after computing the norm (to compute the square root) 
- after computing the error (to test convergence) 

EXPLICIT CPU IMPLEMENTATION (Manual loops)
A second CPU version reprodudes the algorithm using explicit nested loops rather than 
matmul and dot_product.

OUTPUT 
The program prints:
- the dominant eigenvalue obtained via the Rayleigh quotient 
- the number of iterations performed 
- the execution time of each implementation (CPU intrinsic,GPU,explicit CPU)


###############C'è da mettere l'esempio di input e output 
