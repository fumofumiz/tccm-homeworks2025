subroutine matmul_manual(A,B,C,N)
        implicit none 
        integer, intent(in) :: N 
        real*8, intent(in) :: A(N,N),B(N,N)
        real*8, intent(out) :: C(N,N)
        integer :: i,j,k
       
        do j=1,N
           do i=1,N
              C(i,j) = 0.d0 
              do k = 1,N
                 C(i,j) = C(i,j) + A(i,k)*B(k,j)
              enddo 
            enddo 
         enddo 

end subroutine matmul_manual
