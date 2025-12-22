module md_module
      implicit none
      contains
             integer function read_Natoms(input_file) result(Natoms)
              implicit none
             character(len=*), intent(in) :: input_file
             integer :: Natoms
             integer :: ios
             !open input_file
             open(10, file=input_file, status='old', action='read', iostat=ios)
             if (ios =/0) then
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
                if (ios =/ 0) then
                        write(*,*) 'Error opening file', input_file
                        stop
                endif

                !read coord
                read(10,*)
                do i=1,Natoms
                read(10,*) coord(i,1), coord(i,2), coord(i,3), mass(i)
                enddo

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

      !total energy function
      real*8 function E(T, V)
              implicit none

              real*8, intent(in) :: T, V

              E= T+V

      end function E 


end module md_module
