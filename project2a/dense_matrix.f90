program  main

           use sparse_matrix_mod
           implicit none

           type(sparse_matrix) :: A
           character(len=200) :: fname
           integer :: i,j,n,rowend,rowstart,delta
           real*8, allocatable :: D(:,:)
                

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
           
           n=A%n
           A%R(n+1)=A%R(n+1)+1
           allocate(D(A%n,A%n))
           D=0.d0
           do i=1,A%n
                rowstart=A%R(i)
                rowend=A%R(i+1)
                do j=rowstart,rowend-1
                  D(i,A%C(j))=A%V(j)
                enddo
           enddo
               
           do i=1,A%n
            write(*,*) 'riga',i,'è', D(i,:)
           enddo

           

end program main


!The subroutine converse a sparse matrix into a dense matrix
           
!Subroutine matrix multiplication           


