To compile the program

module load nvhpc

To submit the job to cineca use

./submit.sh




POWER METHOD 

DESCRIPTION
The program computes the first eigenvalue of a symmetric matrix using the power method.
Two implementation are provided:
1. CPU version
2. GPU version, using OpenMP to accelerate the matrix-vector multiplication

Execution time is measured separately for the CPU and GPU implementation.

SYNTAX 

compilation:
nvfortran -mp=gpu -gpu=cc70 main.f90 -o main

execution (local):
./main

execution (with SLURM):
sbatch submit.sh

INPUT PARAMETERS 

Program input (from standard input)
integer :: n #Dimension of the matrix a(n,n)
integer :: niter #Number of iterations of the Power Method 

Program variables 

 

