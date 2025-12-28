program main
         
        use md_module

        implicit none
         
        real*8, allocatable :: coord(:,:),mass(:),distance(:,:) ! Input coordinates, masses 
        integer :: Natoms                                       ! Input number of atoms
        character(len=200) :: input_file                        ! Input file
        real*8 :: eps,sigma                                     ! Lennard-Jones parameters
        integer :: ios ! Input output error 
        integer :: i,j,k,l
        real*8, allocatable :: velocity(:,:),acc(:,:) ! Dynamics arrays
        character :: debug ! Debug option
        real*8 :: dt ! Dynamics parameters: time step
        integer :: nsteps ! Dynamics parameters: number of steps
        real*8 :: Kinetic,Potential,Total ! Energies

        
        write(*,*) '---- Parameters ----'
        write(*,*) 

        ! 1 Angstrom = 0.1 nm

        ! Lennard-Jones potential parameters
        
        write(*,*) 'Epsilon (kJ/mol):'
        read(*,*) eps
        write(*,*) eps
        write(*,*)

        ! Example: eps = 0.997d0  kJ/mol

        write(*,*) 'Sigma (Angstrom):'
        read(*,*) sigma
        write(*,*) sigma
        write(*,*) 

        sigma = sigma * 0.1d0

        !sigma = 0.3405d0 in nanometers, 3.405 in Angstrom 

        ! Input dynamics parameters

        write(*,*) 'Time step (ps)'
        read(*,*) dt
        write(*,*) dt

        ! Example: dt = 0.02d0    

        write(*,*) 'Number of steps'
        read(*,*) nsteps
        write(*,*) nsteps
        
        ! Example: nsteps = 1000

        ! Debug option

        debug='n'
        write(*,*) 'Debug? (y/n)'
        read(*,*) debug
        write(*,*) debug
                
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
         write(*,*) 'Coordinates (nm) and mass (g/mol)'
         do i=1,Natoms
                 write(*,*) coord(i,:), mass(i)
         enddo
         write(*,*) 
         write(*,*) 'Distance matrix (nm)'
         write(*,*)
         do i=1,Natoms
                 write(*,*) distance(i,:)
         enddo
        
        endif 

        ! Initialize velocity and compute energies and accelerations
        allocate(velocity(Natoms,3),acc(Natoms,3))
        velocity = 0.d0
        Kinetic = T(Natoms,velocity,mass)
        Potential = V(eps,sigma,Natoms,distance)
        Total = Kinetic + Potential
        call compute_acc(sigma,eps,Natoms,coord,mass,distance,acc)

        if (debug.eq.'y') then

         write(*,*) 
         write(*,*) '---- Functions checking ----'
         write(*,*)
         write(*,*) 'Kinetic energy (kJ/mol):', Kinetic, & 
                  'Potential energy (kJ/mol):', Potential, &
                  'Total energy (kJ/mol):', Total
         write(*,*) 
         write(*,*) 'Accelerations (nm/ps)'
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
        write(1,*) 'Kinetic energy (kJ/mol):', Kinetic, &
                 'Potential energy (kJ/mol):', Potential, &
                 'Total energy (kJ/mol):', Total, 'Time (ps):', 0.d0
        do i=1,Natoms
         write(1,*) 'Ar', coord(i,:)*10.d0 ! Coordinates in angstrom
        enddo 
        write(1,*) 

        ! Debug 
        if (debug.eq.'y') then
                write(1,*) 'Accelerations (nm/ps)'
                do j=1,Natoms
                write(1,*) acc(j,:)
                write(1,*) 
                enddo
                write(1,*) 'Velocity (nm/ps)'
                do j=1,Natoms
                write(1,*) velocity(j,:)
                enddo
                write(1,*) 
                write(1,*) 'Distance matrix (nm)'
                write(1,*)
                do j=1,Natoms
                 write(1,*) distance(j,:)
                enddo            
                write(1,*) 
        endif

        !---- Verlet algorithm ----

        do i=1,nsteps
         coord = coord + velocity*dt + acc*((dt)**2)*0.5d0        ! Update positions
         velocity = velocity + 0.5d0*acc*dt                              ! Update velocities step 1
         call compute_distances(Natoms,coord,distance)
         call compute_acc(sigma,eps,Natoms,coord,mass,distance,acc)  ! Update accelerations
         velocity = velocity + 0.5d0*acc*dt                              ! Update velocities step 2

         ! Now we that we have the new positions,distances and velocities we compute kinetic, potential and total energy. 
         Kinetic=T(Natoms,velocity,mass)
         Potential=V(eps,sigma,Natoms,distance)
         Total=Kinetic + Potential

         ! Debug, write at each step
         if (debug.eq.'y') then

                write(1,*) Natoms
                write(1,*) 'Kinetic energy (kJ/mol):', Kinetic, &
                        'Potential energy (kJ/mol):', Potential, &
                        'Total energy (kJ/mol):', Total, 'Time:', dt*i
                do j=1,Natoms
                 write(1,*) 'Ar', coord(j,:)*10.d0 ! Coordinates in angstrom
                enddo
                write(1,*)
                if (debug.eq.'y') then
                write(1,*) 'Accelerations (nm/ps)'
                do j=1,Natoms
                write(1,*) acc(j,:)
                enddo
                write(1,*)
                write(1,*) 'Velocity (nm/ps)'
                do j=1,Natoms
                write(1,*) velocity(j,:)
                enddo
                write(1,*)
                write(1,*) 'Distance matrix (nm)'
                write(1,*)
                do j=1,Natoms
                 write(1,*) distance(j,:)
                enddo
                write(1,*)
                endif

         ! Write new coordinates on the output file every 10 steps
         elseif (mod(i,10).eq.0) then
                write(1,*) Natoms
                write(1,*) 'Kinetic energy (kJ/mol):', Kinetic, &
                        'Potential energy (kJ/mol):', Potential, &
                        'Total energy (kJ/mol):', Total, 'Time (ps):', dt*i
                !TODO: add conservation
                do j=1,Natoms
                 write(1,*) 'Ar', coord(j,:)*10.d0 ! Coordinates in angstrom
                enddo
                write(1,*)
         endif

        enddo
        

        close(1)

end program
