POWER METHOD 

DESCRIPTION
The program computes using the power method the first eigenvalue of a symmetric matrix filled as the following

        do i=1,n-1
           j=i+1
           a(i,j) = 1.0d0
           a(j,i) = 1.0d0
        enddo

The dimension, the convergence threshold and the maximum number of iterations are provided as input and the program outputs the eigenvalue and the execution time. 

Three implementations are provided:
1. CPU version, using FORTRAN functions
2. GPU version, using OpenMP to accelerate the matrix-vector multiplication
3. CPU version, using the non parallelized GPU code

For each the program provides the eigenvalue and the execution time separately. 

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

The input file has to be called 'input' in order to use the program'

INPUT PARAMETERS 

Program input (from standard input)
integer :: n #Dimension of the matrix a(n,n)
real :: eps #Convergence threshold
integer :: nmax #Number of maximum iterations of the power method 

PROGRAM VARIABLES

OUTPUT FORMAT




