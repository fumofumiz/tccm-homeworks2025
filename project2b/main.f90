program main 
        use omp_lib
        implicit none
        integer :: n,i,j,niter,seed,k,l
        real*8,allocatable :: a(:,:),b(:),b0(:),c(:)
        real*8 :: lambda,tcpustart,tcpuend,tgpustart,tgpuend,dd,tmp,rootdd
         
        !Check that openMP sees the GPU
        print *, "NUM DEVICES:", omp_get_num_devices()

        !Request dimension of the matrix, allocate it, and fill it
        write(*,*) 'dimension of the matrix'
        read(*,*) n
        write(*,*) n
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
        write(*,*) niter
        !Check 
        !do i=1,n
        !write(*,*) a(i,:)
        !enddo
        
        !Generate random vector
        allocate (b(n),b0(n))
        call random_number(b)

        !Check 
        !write(*,*) 'random vector',b

        b=b/dsqrt(dot_product(b,b))     
        b0=b
        tcpustart=omp_get_wtime()
        do i=1,niter
           b=matmul(a,b)
           b=b/dsqrt(dot_product(b,b))           
        enddo
        tcpuend=omp_get_wtime()
        lambda = 0.d0
        lambda = dot_product(b,matmul(a,b))/dot_product(b,b) 
        
        write(*,*) 'lambda', lambda
        
        b=b0 
        dd=0.d0
        allocate(c(n))
        c=0.d0
        write(*,*) 'b',b
        tgpustart=omp_get_wtime()
        !$omp target data map(a,b,c,dd,rootdd)
        do i=1,niter
           !$omp target teams distribute parallel do
           do k=1,n
            c(k) = 0.d0
           enddo
           dd=0.d0
           !$omp target teams distribute parallel do
           do k=1,n
            do l=1,n
             c(k)=c(k)+a(k,l)*b(l)  
            enddo
           enddo
           !$omp target teams distribute parallel do reduction(+:dd)
           do k=1,n
           dd=dd+c(k)*c(k)
           enddo
           rootdd=dsqrt(dd)
           !$omp target teams distribute parallel do
           do k = 1,n
            c(k) = c(k)/rootdd
            b(k) = c(k)
           enddo
        enddo
         !$omp end target data
        write(*,*) 'c',c 
        tgpuend=omp_get_wtime()
        lambda = 0.d0
        lambda = dot_product(b,matmul(a,b))/dot_product(b,b)

        write(*,*) 'lambda', lambda
        write(*,*) 'execution time cpu', tcpuend-tcpustart
        write(*,*) 'execution time gpu', tgpuend-tgpustart

        write(*,*) '----------------------------- CPU ONLY -------------------------------------'

        b=b0
        c=0.d0
        write(*,*) a
        do i=1,niter
           c=0.d0
           dd=0.d0
           do k=1,n
            do l=1,n
             c(k)=c(k)+a(k,l)*b(l)
            enddo
           enddo
           do k=1,n
           dd=dd+c(k)*c(k)
           enddo
           c=c/dsqrt(dd)
           b=c
        enddo
         lambda = 0.d0
        lambda = dot_product(b,matmul(a,b))/dot_product(b,b)

        write(*,*) 'lambda', lambda

deallocate(a,b,c,b0)     
return 
end program main 


          
