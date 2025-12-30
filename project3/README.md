# Molecular Dynamics

Molecular dynamics with Lennard-Jones potential. 

## Description

This program runs a molecular dynamics simulation using a Lennard-Jones potential. For two atoms the this potential takes the form 

$$ V(r)= 4 \epsilon \left(\left(\frac{\sigma}{r}\right)^{12} - \left(\frac{\sigma}{r}\right)^{6}\right)  $$

where r is the distance between two atoms and $\sigma$ and $\epsilon$ are two parameters that depend on the kind of atoms which are given as input. The total potential energy is computed by summing up each pairwise contribution of the form of the N atoms. The acceleration at each step is calculated from the gradient of the potential

$$ a = -\nabla V $$

The equation of motion are then integrated using the Verlet algorithm. For each $n$ from $1$ to $nsteps$ the new positions and velocities are given by

$$ r^{(n+1)} = r^{(n)}+ v^{(n)}\Delta t + \frac{1}{2} a^{(n)}\Delta t ^2 $$

$$ v^{(n+1)} = v^{(n)}+\frac{1}{2}\left(a^{(n)}+a^{(n+1)} \right) $$

Two parameters are needed to run the Verlet algorithm: the time step $dt$ and the total number of steps $nsteps$. The velocity is initialized to zero.

## Instructions for use

Once the code has been compiled (see INSTALL.md) it is very easy to use. First create an input file named
'inp.txt' with the following format

```
NAtoms

X1 Y1 Z1 MASS1
X2 Y2 Z2 MASS2
X3 Y3 Z3 MASS3
... ... ... ...
```
where NAtoms is the number of atoms of the system, Xi, Yi, Zi are the cartesian coordinates of the i-th atom, and MASSi is 
the atomic mass of the i-th atom. For example the input contained in the `test/` directory is the following
```
2

0.0 0.0 0.0 39.948
0.0 0.0 4.0 39.948
```
The input file should be in the same directory as the executable file. Once it is ready execute the program using
```
./md
```
Several input parameters will be asked from standard input. First the $\epsilon$ parameter of the Lennard-Jones potential
```
Epsilon (kJ/mol):
0.997
  0.99700000000000000
```
Then the sigma parameter
```
Sigma (Angstrom):
3.405
   3.4049999999999998
```
The time step of the Verlet algorithm
```
Time step (ps)
0.02
   2.0000000000000000E-002
```
The number of steps for the propagation
```
Number of steps
1000
        1000
```
Debug option
```
Debug? (y/n)
n
 n
```
if the debug option is set to 'y' then a more verbose output file will be created containing the velocities, accelerations and distances at each step. Moreover these quantities will be printed on standard output for the initial conditions. 

## Directory Structure

### Directory `src/`

This directory contains the source code: md.f90, md_module.f90.

#### Main program: `md.f90`

The main program is organized

### Test

