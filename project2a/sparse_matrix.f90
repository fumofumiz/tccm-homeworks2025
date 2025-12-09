! creation of module sparse matrix

 module sparse_matrix_mod
         implicit none

         type :: sparse_matrix
                 integer :: n !dimension
                 integer :: nnz !number of nonzeros
                 integer, allocatable :: R(:) !row pointer
                 integer, allocatable :: C(:) !column indices
                 real*8, allocatable :: V(:) !values
         end type sparse_matrix

   contains


           subroutine read_sparse_matrix(filename,A)
                   character(len=*), intent(in) :: filename
                   type(sparse_matrix), intent(out) :: A
                   integer :: ios, i, maxR

                  !open file
                 open(10,file=filename, status='old', action='read', iostat=ios)
                 if (ios /= 0) then 
                        write(*,*) "Error opening file:", filename
                       stop
                  endif

                 !read dimension
                 read(10, *, iostat=ios) A%n
                 if (ios /= 0) stop "Error opening N"

                !allocate and read R (R dimension is n+1)
               allocate(A%R(A%n+1))
               read(10, *, iostat=ios) A%R
               if (ios /= 0) stop "Error reading R"
               
                 !determine nnz, the largest value of R is nnz
                 maxR=0 
                 do i=1, A%n+1
                    if (A%R(i) .gt. maxR) maxR = A%R(i)
                 enddo
                 A%nnz= maxR

                !allocate C and read C
                allocate(A%C(A%nnz))
                allocate(A%V(A%nnz))

                read(10,*, iostat=ios) A%C
                if(ios /= 0) stop "Error reading C"

                !allocate V and read V

              
                read(10,*,iostat=ios) A%V
                if (ios /=0) stop "Error reading V"
                
                close(10)

                end subroutine read_sparse_matrix

                end module sparse_matrix_mod


   program  main

           use sparse_matrix_mod
           implicit none

           type(sparse_matrix) :: A
           character(len=200) :: fname
           integer :: i, nmul

           write(*,*) "Enter sparse matrix file name"
           read(*,'(A)') fname

           call read_sparse_matrix(trim(fname),A)

           write(*,*) "N=", A%n
           write(*,*) "nnz=", A%nnz
           write(*,*) "First 10 values of R:"
           do i =1, min(10, A%n+1)
              write(*,*) A%R(i)
           enddo
           write(*,*) "First 10 values of C vector"
           do i=1, min(10, A%nnz)
              write(*,*) A%C(i)
           enddo

end program main
