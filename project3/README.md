# Molecular Dynamics

Molecular dynamics with Lennard-Jones potential. 

## Description

This program runs a molecular dynamics simulation using a Lennard-Jones potential.

## Instructions for use

Once the code has been compiled (see INSTALL.md) it is very easy to use. First create an input file named
'inp.txt' with the following format

---

NAtoms


X1 Y1 Z1 MASS1

X2 Y2 Z2 MASS2

X3 Y3 Z3 MASS3

... ... ... ...

---

Where NAtoms is the number of atoms of the system, Xi,Yi,Zi are the cartesian coordinates of the i-th atom, and MASSi is 
the atomic mass of the i-th atom.

For example:

---
2


0.0 0.0 0.0 39.948

0.0 0.0 4.0 39.948

---
 
The input file should be in the same directory as the executable file. Once it is ready execute the program using

./md



## Directory Structure

### Directory: `src/`

    The directory contains the source code: md.f90, md_module.f90


