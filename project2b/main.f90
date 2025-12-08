program main 
        implicit none
        integer :: n,i,j,niter
        real*8,allocatable :: a(:,:),b(:)
        
        !Request dimension of the matrix, allocate it, and fill it
        write(*,*) 'dimension of the matrix'
        read(*,*) n
        allocate(a(n,n))
        a=0.0d0
        do i=1,n-1
           j=i+1
           a(i,j) = 1.0d0
           a(j,i) = 1.0d0
        enddo 

        !Request number of iterations'
        write(*,*) 'number of iterations'
        read(*,*) niter

        !Check 
        do i=1,n
        write(*,*) a(i,:)
        enddo
        
        !Generate random vector
        allocate (b(n))

        do i=1,niter
                
        enddo

deallocate(a)     
return 
end program main 
