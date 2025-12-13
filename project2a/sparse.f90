program main
    use sparse_matrix_mod
    implicit none

    type(sparse_matrix) :: A, B
    real*8, allocatable :: Cdense(:,:),Ad(:,:),Bd(:,:)
    integer :: n_mul, num_loop
    character(len=1) :: debug 
    character(len=200) :: fileA, fileB
    integer :: n, i
    real*8 :: t_start, t_end

    !ask for matrix A name
    write(*,*) "Insert name file matrix A"
    read(*,'(A)') fileA
    write(*,*) fileA

    !ask for matrix B name
    write(*,*) "Insert name file matrix B"
    read(*,'(A)') fileB
    write(*,*) fileB

    ! num_loop of multiplication
    write(*,*) 'Insert number of matrix-matrix multiplications performed'
    read(*,*) num_loop
    write(*,*) num_loop

    debug=0
    !ask for printing matrices or not
    write(*,*) 'Do you want to print the matrices? 0=No (default), non-zero-integer=Yes'
    read(*,*) debug
    write(*,*) debug

    ! read the files from subroutine
    call read_sparse_matrix(trim(fileA), A)
    call read_sparse_matrix(trim(fileB), B)

    if (debug.eq.'y') then 
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
    endif

    ! dimension check
    if (A%n /= B%n) stop

    n = A%n

    ! allocate resulting matrix
    allocate(Cdense(n,n))
    
    !multiplication
    write(*,*)
    write(*,*) '------------------ Sparse matrix multiplication ------------------'
    n_mul = 0

    call cpu_time(t_start)
    do i=1,num_loop
    call multiply_sparse(A, B, Cdense, n_mul)
    enddo
    call cpu_time(t_end)

    !check time
    write(*,*) 'Time for sparse multiplication', t_end-t_start

    !check result

    if (debug.eq.'y') then
     write(*,*) "Resulting matrix"
     do i = 1, n
        write(*,'(*(F12.6,1X))') Cdense(i,:)
     enddo
    endif

    write (*,*) 'number of multiplications'
    write(*,*) n_mul

    write(*,*)
    write(*,*) '------------------ Conversion to dense format and manual multiplication ------------------'

    allocate(Ad(n,n),Bd(n,n))
    
    call sparse_to_dense(A,Ad,n)
    call sparse_to_dense(B,Bd,n)

    !check conversion sparse-dense
    if (debug.eq.'y') then
    write(*,*) 'Dense A matrix' 
    do i=1,n
        write(*,*) Ad(i,:)
    enddo
    write(*,*) 'Dense B matrix'
    do i=1,n
        write(*,*) Bd(i,:)
    enddo
    endif
    
    !calculate time spent
    call cpu_time(t_start)
    do i=1,num_loop
    call matmul_manual(Ad,Bd,Cdense,n)
    enddo
    call cpu_time(t_end)

    !time spent print
    write(*,*) 'Time for manual multiplication', t_end-t_start

    !check results
    if (debug.eq.'y') then
    write(*,*) "Resulting matrix"
    do i = 1, n
        write(*,'(*(F12.6,1X))') Cdense(i,:)
    enddo 
    endif

    write(*,*) 
    write(*,*) '------------------ Multiplication with DGEMM ------------------'

    Cdense=0.d0
   
   call cpu_time(t_start) 
   do i=1, num_loop
   call dgemm('N','N',n,n,n,1.d0,Ad,n,Bd,n,0.d0,Cdense,n)
   enddo
   call cpu_time(t_end)

   write(*,*) 'Time for multiplication using DGEMM', t_end-t_start

    !check results
    if (debug.eq.'y') then
    write(*,*) "Resulting matrix"
    do i = 1, n
        write(*,'(*(F12.6,1X))') Cdense(i,:)
    enddo
    endif

 deallocate(Cdense)

end program main
