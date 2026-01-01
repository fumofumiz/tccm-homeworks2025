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
-------
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

---

## Directory Structure

### Directory `src/`

This directory contains the source code: md.f90, md_module.f90.

#### Main program: `md.f90`

The main program is organized

### Test  

### Module `md_module.f90`

This file is a fortran module that provides the routines needed.

---
### Function `read_Natoms`(input_file)

This function reads the number of atoms of a molecule from an input file and stores it in a
variable, Natoms.

**Input argument:**
- **`input_file`**  
  Name of the input file.

**Output argument:**
- **`Natoms`**  
  Number of atoms present in the molecule, it is the first number present in the input file.

**Local variables:**
- **`ios`**  
  Status flag used to check whether the input file is opened and read correctly.


### Subroutine `read_molecule`(input_file, Natoms, coord, mass)

This subroutine reads the coordinates of the atoms present in the molecule from an 
input file and stores it in a 2- dimensional array coord(Natoms,3). It also reads from input
The mass of each atom and stores it in a 1-dimensional array, mass(Natoms).

**Input argument:**
- **`input_file`**  
  Name of the input file.
- **`Natoms`**  
  Number of atoms present in the molecule.

**Output argument:**
- **`coord(Natoms,3)`**  
  2-dimensional array where the coordinates of the molecule are stored.
- **`mass(Natoms)`**
 1-dimensional array where the mass of each atom is stored.

**Local variables:**
- **`ios`**  
  Status flag used to check whether the input file is opened and read correctly.


### Subroutine `compute_distances`(Natoms, coord, mass)

This subroutine computes the distance between two atoms. 

For each pair of atoms \( i \) and \( j \), the distance is computed using the
Euclidean distance formula in three-dimensional space:

$$ d_{ij} = \sqrt{(x_i - x_j)^2 + (y_i - y_j)^2 + (z_i - z_j)^2} $$

The algorithm loops over all atom pairs, computes the squared differences 
between their Cartesian coordinates along the x, y and z directions, sums them, 
and finally applies the square root to obtain the distance between each pair of atoms. 

**Input argument:**
- **`Natoms`**  
  Number of atoms present in the molecule.

- **`coord(Natoms,3)`** 
 2-dimensional array where the coordinates of the molecule are stored.

**Output argument:**
- **`distance(Natoms, Natoms)`**  
  2-dimensional array where the distance between atoms is stored.

**Local variables:**
- **`x,y,z`**  
   Temporary variables used to store squared differences along x,y and z.


### Function `V(eps, sigma, Natoms, distance)`

### Input arguments

- **eps**  
  Depth of the Lennard–Jones potential well.

- **sigma**  
  Distance at which the Lennard–Jones potential is zero.

- **Natoms**  
  Number of atoms in the system.

- **distance**  
  Matrix containing the interatomic distances \( r_{ij} \).

### Output

- **V**  
  Scalar containing the total potential energy.


### Function T(Natoms, velocity, mass)

This function computes the kinetic energy of a molecule.
The kinetic energy is calculated using the following mathematical formula:

$$ T = \frac{1}{2} \sum_{i=1}^{Natoms} m_i v_i^2 $$

where $m_i$ is the mass of the i-th atom and $v_i^2$ is the squared magnitude of its velocity vector.

The algorithm loops over all atoms in the system, computes the squared velocity
magnitude for each atom as the sum of the squares of its Cartesian velocity
components, multiplies it by the corresponding atomic mass, and accumulates 
the result. Finally, the total sum is divided by 2. 

**Input argument:**
- **`Natoms`**  
  Number of atoms present in the molecule.
- **`velocity(Natoms,3)`**  
  2-dimensional array where the velocity components of each atom are stored.
- **`mass(Natoms)`**  
  1-dimensional array where the mass of each atom is stored.

**Output argument:**
- **`T`**  
  Total kinetic energy of the molecule.

**Local variables:**
- **`v`**  
  Temporary variable used to store the squared velocity magnitude of each atom.

### Function E(T, V)

This function computes the total energy of the system as the sum of
kinetic and potential energy.

**Input argument:**
- **`T`**  
  Total kinetic energy of the system.
- **`velocity(Natoms,3)`**  
  Total potential energy of the system.

**Output argument:**
- **`E`**  
  Total energy of the system.

### Subroutine `compute_acc(sigma, eps, Natoms, coord, mass, distance, acc)`

### Input arguments

- **sigma**  
  Distance at which the Lennard–Jones potential is zero.

- **eps**  
  Depth of the Lennard–Jones potential well.

- **Natoms**  
  Number of atoms.

- **coord**  
  Array containing the Cartesian coordinates of the atoms.

- **mass**  
  Array containing the atomic masses.

- **distance**  
  Matrix of interatomic distances $r_{ij}$.

### Output 

- **acc**  
  Array containing the accelerations of the atoms.


