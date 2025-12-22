program main

        implicit none
         
        real*8, allocatable :: coord(:,3),mass(:),distance(:,:) !input
        integer :: Natoms                                       !input
        integer :: ios
        real*8, allocatable :: r(:),v(:),a(:) !dynamics vectors
        character :: debug
        real*8 :: t,dt !time and time step



        !---- Verlet algorithm ----

        allocate(v(Natoms))

        ! Input parameters
        t=0.d0
        dt=0.02
        nsteps=1000

        !Initialize velocity
        v=0.d0

        !Algorithm

        open(1,file='output',iostat=ios) 

        do i=1,nsteps

         r = r + v*t + a*((dt)**2)*0.5d0
         v = v + 0.5d0*a*dt
         call compute_acc(Natoms,coord,mass,distance,a)
         v = v + 0.5d0*a*dt

         if (nsteps%10.eq.0) then

                write(*,*) 'Kinetic energy:', K, 'Potential energy:', V, 'Total energy:', E, 'Time:', t,'Conservation:' !TODO: add conservation
                

         endif
         
        enddo

        close(1)

end program
