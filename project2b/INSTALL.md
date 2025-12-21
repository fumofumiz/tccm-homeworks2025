## Requirements

To compile and run the program correctly the library NVHPC is required. On CINECA it is sufficient to load a module using the following command

module load nvhpc/

## Compilation

To compile the program move the source code to your favorite directory and run the command 

nvfortran -mp=gpu -gpu=cc70 main.f90 -o main

## Test

To check that the program works you can follow the instructions for use in the README.md and use the example input, you should get the example output 
(or a similar one). 
