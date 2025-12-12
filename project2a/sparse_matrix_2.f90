program main
    use sparse_matrix_mod
    implicit none

    type(sparse_matrix) :: A, B
    real*8, allocatable :: Cdense(:,:),Ad(:,:),Bd(:,:)
    integer :: n_mul
    character(len=200) :: fileA, fileB
    integer :: n, i

    ! file names
    write(*,*) "Insert name file matrix A"
    read(*,'(A)') fileA

    write(*,*) "Insert name file matrix B"
    read(*,'(A)') fileB

    ! read the files from subroutine
    call read_sparse_matrix(trim(fileA), A)
    call read_sparse_matrix(trim(fileB), B)

    !
    !check matrix A
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

    !check matrix B
    write(*,*) "N=", B%n
           write(*,*) "nnz=", B%nnz
           write(*,*) "First 10 values of R:"
           do i =1, min(13, B%n+1)
              write(*,*) B%R(i)
           enddo
           write(*,*) "First 10 values of C vector"
           do i=1, min(10, B%nnz)
              write(*,*) B%C(i)
           enddo

    ! dimension check
    if (A%n /= B%n) stop

    n = A%n

    ! allocate resulting matrix
    allocate(Cdense(n,n))

    write(*,*)
    write(*,*) '------------------ Sparse matrix multiplication ------------------'
    !multiplication
    n_mul = 0
    call multiply_sparse(A, B, Cdense, n_mul)

    !check result
   

    write(*,*) "Resulting matrix"
    do i = 1, n
        write(*,'(*(F12.6,1X))') Cdense(i,:)
    enddo
    
    write (*,*) 'number of multiplications'
    write(*,*) n_mul

    write(*,*)
    write(*,*) '------------------ Conversion to dense format and manual multiplication ------------------'

    allocate(Ad(n,n),Bd(n,n))
    
    call sparse_to_dense(A,Ad,n)
    call sparse_to_dense(B,Bd,n)

    write(*,*) 'Matrice A densa' 
    do i=1,n
        write(*,*) Ad(i,:)
    enddo

    write(*,*) 'Matrice B densa'
    do i=1,n
        write(*,*) Bd(i,:)
    enddo

    call matmul_manual(Ad,Bd,Cdense,n)

    write(*,*) "Resulting matrix"
    do i = 1, n
        write(*,'(*(F12.6,1X))') Cdense(i,:)
    enddo 

    write(*,*) 
    write(*,*) '------------------ Multiplication with DGEMM ------------------'

    Cdense=0.d0

   call dgemm('N','N',n,n,n,1.d0,Ad,n,Bd,n,0.d0,Cdense,n)

    write(*,*) "Resulting matrix"
    do i = 1, n
        write(*,'(*(F12.6,1X))') Cdense(i,:)
    enddo

 deallocate(Cdense)

end program main
