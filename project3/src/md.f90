program main
         
        use md_module

        implicit none
         
        real*8, allocatable :: coord(:,3),mass(:),distance(:,:) ! Input coordinates, masses 
        integer :: Natoms                                       ! Input number of atoms
        character(len=200) :: input_file                        ! Input file
        real*8 :: eps,sigma                                     ! Lennard-Jones parameters
        integer :: ios ! Input output error 
        integer :: i
        real*8, allocatable :: velocity(:,3),acc(:,3) ! Dynamics arrays
        character :: debug ! Debug option
        real*8 :: dt ! Dynamics parameters: time step
        integer :: nsteps ! Dynamics parameters: number of steps
        real*8 :: Kinetic,Potential,Total ! Energies

        !---- Parameters ----

        ! 1 Angstrom = 0.1 nm

        ! Lennard-Jones potential parameters

        eps = 0.997 ! kJ/mol
        sigma = 0.3405 ! In nanometers, 3.405 Angstrom 

        ! Debug option
        
        debug='y'
          
        ! Input dynamics parameters
        dt = 0.02                        ! In picoseconds 
        nsteps = 1000
                
        !---- Read input and compute distances ----

        input_file = 'inp.txt'
        Natoms = read_Natoms(input_file)
        allocate(coord(Natoms,3),mass(Natoms),distance(Natoms,Natoms))
        call read_molecule(input_file,Natoms,coord,mass)
        call compute_distances(Natoms,coord,distance)

        ! Checking that the input is correctly read and the distances are correct 
        if (debug.eq.'y') then
         
         write(*,*) '---- Input checking ----'
         write(*,*) 'Number of atoms', Natoms
         write(*,*) 
         write(*,*) 'Coordinates and mass'
         do i=1,Natoms
                 write(*,*) coord(i,:), mass(i)
         enddo
         write(*,*) 
         write(*,*) 'Distance matrix'
         write(*,*)
         do i=1,Natoms
                 write(*,*) d(i,:)
         enddo
        
        endif 

        ! Initialize velocity and compute energies and accelerations
        allocate(velocity(Natoms,3),acc(Natoms,3))
        v = 0.d0
        Kinetic = T(Natoms,velocity,mass)
        Potential = V(eps,sigma,Natoms,distance)
        Total = Kinetic + Potential
        call compute_acc(Natoms,coord,mass,distance,acc)

        if (debug.eq.'y') then

         write(*,*) '---- Functions checking ----'
         write(*,*)
         write(*,*) 'Kinetic energy:', Kinetic, 'Potential energy:', Potential, 'Total energy:', Total
         write(*,*) 
         write(*,*) 'Accelerations'
         do i=1,Natoms
                write(*,*) acc(i,:)
         enddo
         write(*,*)

        endif 

        ! Writing output file
        open(1,file='out.txt',iostat=ios) 
        
        ! Checking for errors
        if (ios.ne.0) then
                write(*,*) 'Error in writing the file'
        endif

        ! Writing zero step
        write(1,*) Natoms
        write(1,*) 'Kinetic energy:', Kinetic, 'Potential energy:', Potential, 'Total energy:', Total, 'Time (ps):', 0.d0
        do i=1,Natoms
         write(1,*) 'Ar', coord(i,:)*10.d0 ! Coordinates in angstrom
        enddo 

        !---- Verlet algorithm ----

        do i=1,nsteps

         coord = coord + v*dt + acc*((dt)**2)*0.5d0        ! Update positions
         v = v + 0.5d0*acc*dt                              ! Update velocities step 1
         call compute_acc(Natoms,coord,mass,distance,acc)  ! Update accelerations
         v = v + 0.5d0*acc*dt                              ! Update velocities step 2

         ! Now we that we have the new positions and velocities we compute new distances, kinetic, potential and total energy. 
         distance = compute_distances(Natoms,coord,distance)       
         Kinetic=T(Natoms,velocity,mass)
         Potential=V(eps,sigma,Natoms,distance)
         Total=Kinetic + Potential

         ! Write new coordinates on the output file every 10 steps
         if (mod(i,10).eq.0) then
                write(1,*) Natoms
                write(1,*) 'Kinetic energy:', Kinetic, 'Potential energy:', Potential, 'Total energy:', Total, 'Time:', dt*i,'Conservation:' !TODO: add conservation
                do i=1,Natoms
                 write(1,*) 'Ar', coord(i,:)*10.d0 ! Coordinates in angstrom
                enddo

         endif

        enddo

        close(1)

end program
