program main 
        implicit none
        integer :: n,i,j
        real*8,allocatable :: a(:,:)
        
        write(*,*) 'dimension of the matrix'
        read(*,*) n
        allocate(a(n,n))
        a=0.0d0
        do i=1,n-1
           j=i+1
           a(i,j) = 1.0d0
           a(j,i) = 1.0d0
        enddo 

        do i=1,n
        write(*,*) a(i,:)
        enddo

deallocate(a)     
return 
end program main 
