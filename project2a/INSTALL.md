## Requirements

To compile the program correctly the library BLAS is required. On CINECA it is sufficient to load a module using the following command

module load netlib-lapack/3.9.1--gcc--10.2.0

## Compilation

To compile the program move the source code to your favorite directory and run the command 

gfortran  module_sparse.f90 sparse.f90 -o sparse -lblas

## Checking that everything works

To check that everything works copy the test directory in the same one as the executable

sparse < test/input 

you should get printed on your terminal an output which is the same as the one in test/output.
