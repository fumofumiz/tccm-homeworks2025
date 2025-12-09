program main

        use omp_lib

        implicit none
        integer :: n,i,j,niter,seed,k,l,nmax
        real*8,allocatable :: a(:,:),b(:),b0(:),c(:)
        real*8 :: lambda,tcpustart,tcpuend,tgpustart,tgpuend,dd,tmp,rootdd,eps,error
         
        !Check that openMP sees the GPU
        !print *, "NUM DEVICES:", omp_get_num_devices()

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

        write(*,*)
        !Request convergence threshold 
        write(*,*) 'convergence threshold'
        read(*,*) eps
        write(*,*) eps

        write(*,*)
        !Request number of max iterations
        write(*,*) 'maximum number of iterations'
        read(*,*) nmax
        write(*,*) nmax

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

        write(*,*)
        write(*,*) '------------------- CPU ONLY FORTRAN FUNCTIONS ---------------------'
        
        allocate(c(n))
        niter=0
        error=1
        tcpustart=omp_get_wtime()
        do while(error.gt.eps)
           c=matmul(a,b)
           c=c/dsqrt(dot_product(c,b))
           error=dot_product(c-b,c-b)
           b=c           
           niter=niter+1
           if (niter.gt.nmax) then
                exit
           endif
        enddo
        tcpuend=omp_get_wtime()
        lambda = 0.d0
        lambda = dot_product(b,matmul(a,b))/dot_product(b,b) 
        
        write(*,*) 'lambda', lambda
        write(*,*) 'execution time cpu', tcpuend-tcpustart
        
        write(*,*)
        write(*,*) '------------------- GPU ---------------------'

        b=b0 
          
        !Check
        !write(*,*) 'b',b

        niter=0
        error=1
        tgpustart=omp_get_wtime()
        !$omp target data map(a,b,c,dd,error,rootdd)
        do while(error.gt.eps)

           !$omp target teams distribute parallel do
           do k=1,n
            c(k) = 0.d0
           enddo
           dd=0.d0
           error=0.d0

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

           !$omp target update from(dd)
           rootdd=dsqrt(dd)
           !$omp target update to(dd)

           !$omp target teams distribute parallel do 
           do k = 1,n
            c(k) = c(k)/rootdd
           enddo
          
           !$omp target teams distribute parallel do reduction(+:error)
           do k = 1,n
            error = error + (c(k)-b(k))**2
           enddo
           !$omp target update from(error)

           !$omp target teams distribute parallel do
           do k = 1,n
            b(k) = c(k)
           enddo

           niter=niter+1
           if (niter.gt.nmax) then
                exit
           endif

        enddo
        !$omp end target data

        !Check
        !write(*,*) 'c',c

        tgpuend=omp_get_wtime()
        lambda = 0.d0
        lambda = dot_product(b,matmul(a,b))/dot_product(b,b)

        write(*,*) 'lambda', lambda
        write(*,*) 'execution time gpu', tgpuend-tgpustart
         
        write(*,*) 
        write(*,*) '------------------- CPU ONLY EXPLICIT FUNCTION ---------------------'

        b=b0
        c=0.d0

        !Check 
        !write(*,*) a
       
        niter=0
        error=1
        tcpustart=omp_get_wtime()
        do while (error.gt.eps)
           c=0.d0
           dd=0.d0
           error=0.d0
           do k=1,n
            do l=1,n
             c(k)=c(k)+a(k,l)*b(l)
            enddo
           enddo
           do k=1,n
           dd=dd+c(k)*c(k)
           enddo
           c=c/dsqrt(dd)
           do k=1,n
            error=error+(c(k)-b(k))**2
           enddo
           b=c
           niter=niter+1
           if (niter.gt.nmax) then
                exit
           endif
        enddo
        tcpuend=omp_get_wtime()

        lambda = 0.d0
        lambda = dot_product(b,matmul(a,b))/dot_product(b,b)

        write(*,*) 'lambda', lambda
        write(*,*) 'execution time cpu', tcpuend-tcpustart

deallocate(a,b,c,b0)     
return 
end program main 


          
