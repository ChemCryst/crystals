C $Log: not supported by cvs2svn $
C Revision 1.8  2005/05/12 13:38:26  stefan
C 1. Improved the code for the accumalation of the LHS and should run correctly
C
C Revision 1.7  2005/03/08 12:50:48  stefan
C 1. Rewrote the accumalation routine for the LHS but also rewrote it for the param_list method so that it now handles a blocked normal matrix.
C Needs more testing but to the best of my knowledge works perfectly.
C
C Revision 1.6  2005/02/09 15:59:36  stefan
C 1. Mistakenly I have been adding the diagonal elements in twice when doing the paramlist refinment. Fixed now.
C
C Revision 1.5  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:11  rich
C New CRYSTALS repository
C
C Revision 1.4  2004/11/18 16:30:59  stefan
C 1. Added the subroutine PAIR_XDLHS which used a pair list to accume the normal matrix.
C
C Revision 1.3  2004/09/30 15:52:56  rich
C Uh-oh. SFLS reorganised quite a lot.
C
C Revision 1.2  2001/02/26 10:24:12  richard
C Added changelog to top of file


CODE FOR XADLHS
      subroutine XADLHS (DERIVS,NDERIV, AMAT11, NMAT11, I12,N12B,
     1   MD12B)
      implicit none
C--ADD THE DERIVATIVES INTO THE L.H.S. OF THE NORMAL MATRIX
      integer N12B, MD12B, NDERIV, NMAT11
      real DERIVS(NDERIV)  ! Vector of derivatives
      real AMAT11(NMAT11)  ! Normal matrix, upper triangle, blocked
       
      integer I12(N12B) ! Info about block numbers & sizes in AMAT11
      integer SIZE, I, MNR, IBL
      integer BLOCKSTART
      
      BLOCKSTART = 1
      IBL = 1
      do I = 1, N12B, MD12B   ! Work through each block
             MNR = I12(I+1)                             ! Get the dimenstions of this block
             SIZE = (MNR*(MNR+1))/2                     ! Calculate the size of this block
             call ADLHSBLOCK(DERIVS(IBL), NDERIV-(IBL-1),
     1        AMAT11(BLOCKSTART), SIZE, MNR)            ! Add the derivatives to this block
             BLOCKSTART = BLOCKSTART + SIZE             ! Move on to the next block
            IBL = MNR + IBL                             ! Move on to the start of the needed derivatives
      end do
      return
      end
    
CODE FOR ADLHSBLOCK
       subroutine ADLHSBLOCK(DERIVS, NDERIV, MATBLOCK, BLOCKSIZE, 
     1 BLOCKdimension)
       implicit none
       integer, intent(in) :: BLOCKSIZE           ! Size of the current block
       integer, intent(in) :: NDERIV              ! Size of the derivative matrix
       real, dimension(NDERIV), intent(in) :: DERIVS        ! Matrix of from the appropriate point on wards
       real, dimension(BLOCKSIZE), intent(inout) :: MATBLOCK    ! Normal matrix block
       integer, intent(in) ::   BLOCKdimension
       integer i, j ! Size of the dimension of the block
       integer   ROW       ! Counters
        
       do ROW=1, BLOCKdimension    ! Loop over all the rows of the block
            ! calculation of the two indices
            ! the serie for i is 1 1+blockdimension 1+blockdimension-1 1+2*blockdimension-3 1+3*blockdimension-6 ...
            ! given blockdimension=10:
            !     1 11 20 28 35 41 ...
            ! U(n+1) = U(n) + blockdimension - n (n = row -1)
            ! => U(n) = 0.5 n (2blockdimension - n + 1)
            i = ((row-1)*(2*blockdimension-row+2))/2+1
            j = i + blockdimension - row
            
            MATBLOCK(i:j) = MATBLOCK(i:j)+DERIVS(ROW)*
     1          derivs(row:BLOCKdimension)
       end do
       end

