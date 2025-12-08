program main 
        implicit none
        integer :: n,i,j,niter
        real*8,allocatable :: a(:,:),b(:)
        real*8 :: lambda,time
         
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

        !Request number of iterations
        write(*,*) 'number of iterations'
        read(*,*) niter

        !Check 
        do i=1,n
        write(*,*) a(i,:)
        enddo
        
        !Generate random vector
        allocate (b(n))
        call random_number(b)
        write(*,*) 'random vector',b
        
        b=b/dsqrt(dot_product(b,b))     
        do i=1,niter
           b=matmul(a,b)
           b=b/dsqrt(dot_product(b,b))           
        enddo
       
        lambda = 0.d0
        lambda = dot_product(b,matmul(a,b))/dot_product(b,b) 
        
        write(*,*) 'lambda', lambda

        !$omp target data map(a,b)
        !$omp target teams distribute parallel do
        do i=1,niter
           b=matmul(a,b)
           b=b/dsqrt(dot_product(b,b))
        enddo
        !$omp end target teams distribute parallel do   
        !$omp end target data

        lambda = 0.d0
        lambda = dot_product(b,matmul(a,b))/dot_product(b,b)

        write(*,*) 'lambda', lambda

deallocate(a,b)     
return 
end program main 


          
