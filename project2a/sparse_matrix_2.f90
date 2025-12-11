program main
    use sparse_matrix_mod
    implicit none

    type(sparse_matrix) :: A, B
    real*8, allocatable :: Cdense(:,:)
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

    ! dimension check
    if (A%n /= B%n) stop

    n = A%n

    ! allocate resulting matrix
    allocate(Cdense(n,n))

    !multiplication
    n_mul = 0
    call multiply_sparse(A, B, Cdense, n_mul)

    !check result
    print *, ""
    print *, "---------------------------------------"
    print *, "   RESULT MULTIPLICATION A *B "
    print *, "---------------------------------------"
    print *, "number of multiplications", n_mul
    print *, ""

    write(*,*) "Matrice risultato Cdense:"
    do i = 1, n
        write(*,'(100(ES12.4))') Cdense(i,:)
    end do

 deallocate(Cdense)

end program main
