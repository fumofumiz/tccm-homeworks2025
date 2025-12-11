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
                 A%nnz= maxR-1 !considering the last row value (nnz +1) 

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


       
       subroutine multiply_sparse(A, B, Cdense, n_mul)
          implicit none

          type(sparse_matrix), intent(in)  :: A
          type(sparse_matrix), intent(in)  :: B
          real*8, intent(out) :: Cdense(:,:)
          integer, intent(inout) :: n_mul

          integer :: i, j, pA, pB
          integer :: n
          real*8 :: y

         ! check if matrices have the same dimensions
          n = A%n
          if (B%n /= n) stop "Dimension mismatch in multiply_sparse"

         !inizialization
    
         Cdense = 0.0d0
         n_mul=0

         ! for the multiplication, we consider the simmetry of the matrix B 
         ! (rows = columns)

         !since the columns in the same row are increasing in number, 
         !if the column value of A is less than the column value of B, stop the program,
         !otherwise, if the value of the two columns is the same, do the multiplication

         ! multiplication
         do j = 1, n        !rows of B
            do i = 1, n    !rows of A
               y = 0.0d0    !parameter that contains the multiplication result

            do pA = A%R(i), A%R(i+1)-1   !vector R of A
                do pB = B%R(j), B%R(j+1)-1    ! vector R of B
                  !  if (A%C(pA) .lt. B%C(pB)) then
                   !    exit
                   ! end if
                    if (A%C(pA) == B%C(pB)) then
                        y = y + A%V(pA) * B%V(pB)
                        n_mul= n_mul + 1 
                    end if
                 end do
             end do

            Cdense(i,j) = y
         end do
     end do
    
      end subroutine multiply_sparse

      subroutine sparse_to_dense(A,D,n)

          implicit none

          type(sparse_matrix), intent(in)  :: A 
          integer :: n,rowstart,rowend,i,j               !A matrix dimension
          real*8, intent(out) :: D(n,n)

          !A%R(n+1)=A%R(n+1)+1                           !If the last entry of the R vector is nnz uncomment
           D=0.d0
           do i=1,A%n
                rowstart=A%R(i)
                rowend=A%R(i+1)
                do j=rowstart,rowend-1
                  D(i,A%C(j))=A%V(j)
                enddo
           enddo

       end subroutine

       subroutine matmul_manual(A,B,C,N)

        implicit none
        integer, intent(in) :: N
        real*8, intent(in) :: A(N,N),B(N,N)
        real*8, intent(out) :: C(N,N)
        integer :: i,j,k

        do j=1,N
           do i=1,N
              C(i,j) = 0.d0
              do k = 1,N
                 C(i,j) = C(i,j) + A(i,k)*B(k,j)
              enddo
            enddo
         enddo

        end subroutine matmul_manual
             

end module sparse_matrix_mod


