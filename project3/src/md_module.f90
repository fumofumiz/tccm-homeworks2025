module md_module

      implicit none

      contains

             integer function read_Natoms(input_file) result(Natoms)
              implicit none
             character(len=*), intent(in) :: input_file
             integer :: ios
             !open input_file
             open(10, file=input_file, status='old', action='read', iostat=ios)
             if (ios.ne.0) then
                     write(*,*) 'Error opening file', input_file
                     stop
             endif
             
             !read Natoms
             read(10,*) Natoms
             
             close(10)
 
             end function read_Natoms


        subroutine read_molecule(input_file, Natoms, coord, mass)
                implicit none
                character(len=*), intent(in) :: input_file
                integer, intent (in) :: Natoms
                real*8, intent(out):: coord(Natoms, 3)
                real*8, intent(out) :: mass(Natoms)
                integer :: i, ios

                open(10, file= input_file, status='old', action='read', iostat=ios)
                if (ios.ne.0) then
                        write(*,*) 'Error opening file', input_file
                        stop
                endif

                !read coord
                read(10,*)
                do i=1,Natoms
                read(10,*) coord(i,1), coord(i,2), coord(i,3), mass(i)
                enddo

                coord = coord * 0.1d0
                close(10)
       
        end subroutine read_molecule


        subroutine compute_distances(Natoms, coord, distance)
                implicit none
                integer, intent(in) :: Natoms
                real*8, intent(in) :: coord(Natoms,3)
                real*8, intent(out) :: distance(Natoms, Natoms)
                real*8 :: x, y, z
                integer :: i,j

                do i=1, Natoms
                   do j=1, Natoms
                      x= (coord(i,1)-coord(j,1))**2
                      y= (coord(i,2)-coord(j,2))**2
                      z= (coord(i,3) - coord(j,3))**2

                      distance(i,j)= sqrt(x + y + z)

                   enddo
                 enddo
       end subroutine compute_distances


      !kinetic energy function
      real*8 function T(Natoms, velocity, mass)
      implicit none

      integer, intent(in) :: Natoms
      real*8, intent(in) :: velocity(Natoms,3)
      real*8, intent(in) :: mass(Natoms)
      integer :: i 
      real*8 :: v


      T= 0.d0
      do i = 1, Natoms
         v= velocity(i,1)**2 + velocity(i,2)**2 + velocity(i,3)**2
         T= T+ mass(i) * v
      enddo

      T= 0.5d0 * T
     
      end function T 
-!-------------------------------------------------------------------------
!Function to compute the total potential energy
!-------------------------------------------------------------------------
!function which take as input epsilon, sigma, the number of atoms
!and the array of distances and computes the total potential energy
!using the Lennard-Jones potential       

real*8 function V(eps,sigma,Natoms,distance)                
              implicit none
              integer,intent(in) :: Natoms                         !number of atoms in the system
              real*8,intent(in) :: eps,sigma                       !LJ parameters: eps = depth of the potential well
                                                                   !sigma = distance at which the potential is zero 
              real*8,intent(in) :: distance(Natoms,Natoms)         !matrix of interatomic distances rij
              integer :: i,j-
              real*8 :: rij                                        !distances between atoms i and j

              V=0.d0                                               !initialize total potential energy

              do i=1,Natoms-1                                      !loop over first atom of the pair
              do j=i+1,Natoms                                      !loop over second atom (avoid double counting)
                    rij=distance(i,j)                              !extract the interatomic distance of the pair
                    V=V+4.d0*eps*((sigma/rij)**12-(sigma/rij)**6)  !adding LJ potential 
                  enddo
              enddo

        end function V 

      !total energy function
      real*8 function E(T, V)
              implicit none

              real*8, intent(in) :: T, V

              E= T+V

      end function E 

!--------------------------------------------------------------------------
!Subroutine to compute atomic acceleratios 
!--------------------------------------------------------------------------
!subroutine which computes the acceleration vector for each atom and 
!stores it in a double precision array

       subroutine compute_acc(sigma,eps,Natoms,coord,mass,distance,acc)
              implicit none

              integer,intent(in) :: Natoms                                           !Number of atoms
              real*8,intent(in) :: coord(Natoms,3)                                   !cartesian coordinates of atoms 
              real*8,intent(in) :: distance(Natoms,Natoms)                           !matrix of interatomic distances rij
              real*8,intent(in) :: mass(Natoms)                                      !atomic masses 
              real*8,intent(in) :: sigma,eps                                         !Lennard-Jones parameters
              real*8,intent(out) :: acc(Natoms,3)                                    !output accelerations for each atom 

              integer :: i,j                                    
              real*8 :: rij,u

              acc=0.d0                                                               !initialize accelerations to zero 

              do i=1,Natoms                                     
                 do j=1,Natoms
                    if (i.ne.j) then                                                  !exclude self-interactions
                            rij=distance(i,j)                                         !distance between atom i and j
                            u=(24.d0*eps/rij)*((sigma/rij)**6-2.d0*(sigma/rij)**12)
                            acc(i,1)=acc(i,1)-u*(coord(i,1)-coord(j,1))/rij
                            acc(i,2)=acc(i,2)-u*(coord(i,2)-coord(j,2))/rij
                            acc(i,3)=acc(i,3)-u*(coord(i,3)-coord(j,3))/rij
                     endif
                  enddo
                  acc(i,:)=acc(i,:)/mass(i)
               enddo

               end subroutine compute_acc

end module md_module
