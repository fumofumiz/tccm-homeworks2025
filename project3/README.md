# Molecular Dynamics

## Description

## Instructions for use

Once the code has been compiled (see INSTALL.md) it is very easy to use. First create an input file named
'inp.txt' with the following format

---
NAtoms

x1 y1 z1 Mass1
x2 y2 z2 Mass2
x3 y3 z3 Mass3
... ... ... ...
---

Where NAtoms is the number of atoms of the system

For example:
---
2

0.0 0.0 0.0 39.948
0.0 0.0 4.0 39.948
---
 
The input file should be in the same directory as the executable file. 

## Directory Structure

### Directory: `src/`

    The directory contains the source code: md.f90, md_module.f90


