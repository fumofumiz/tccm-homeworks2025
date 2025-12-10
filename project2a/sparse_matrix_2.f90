

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
           do i =1, min(13, A%n+1)
              write(*,*) A%R(i)
           enddo
           write(*,*) "First 10 values of C vector"
           do i=1, min(10, A%nnz)
              write(*,*) A%C(i)
           enddo

end program main
