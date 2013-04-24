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

       subroutine PARM_PAIRS_XLHS (DERIVS, NDERIV, AMAT11, NMAT11,
     1 PARAM_LIST, PARAM_L_SIZE, I12, N12B, MD12B)
       implicit none
       
       integer nderiv
       integer nmat11
       real DERIVS(NDERIV)  ! Vector of derivatives
       real AMAT11(NMAT11)  ! Normal matrix, upper triangle, blocked
       integer PARAM_L_SIZE      ! The size of the parameter pair list
       integer PARAM_LIST(PARAM_L_SIZE) ! A list of parameters which should be included in the normal matrix
       integer N12B                     ! Size of the blocking information
       integer I12(N12B)                ! Array containing informatio about the blocks.
       integer MD12B                    ! The step size of the blocking information
       
       integer param_l_pos          ! Current position in the parameter list
       integer DERV_POS, MAT_POS    ! Positions in the derivative vector and the normal matrix
       integer BLOCK_POS            ! Current position on the blocks
       integer BLOCK_DIM            ! the dimension of the current block 
       integer BLOCK_SIZE           ! The number of elements for the current block
       
C============ Called Functions ===========
       integer PAIRS_BLOCK_ADLHS
       
       DERV_POS = 1
       MAT_POS = 1
       param_l_pos = 1
       do BLOCK_POS = 1, N12B, MD12B      ! Work through the different blocks of the matrix
             BLOCK_DIM = I12(BLOCK_POS+1)             ! Get the dimenstions of this block
             BLOCK_SIZE = (BLOCK_DIM*(BLOCK_DIM+1))/2 ! Calculate the size of this block
             param_l_pos = param_l_pos + PAIRS_BLOCK_ADLHS(DERIVS(
     1       DERV_POS), NDERIV-(DERV_POS), AMAT11(MAT_POS), 
     2       BLOCK_SIZE, BLOCK_DIM, PARAM_LIST(param_l_pos), 
     3       PARAM_L_SIZE- (param_l_pos-1), DERV_POS) ! Add the derivatives to this block and move position in param_list to the next set of parameters.
             
             DERV_POS = DERV_POS + (BLOCK_DIM)        ! Move to the next point in the derivatives
             MAT_POS = MAT_POS + BLOCK_SIZE           ! Move to the next block
       end do
       end
            
       function PAIRS_BLOCK_ADLHS(derv, derv_size, mat_block, 
     1   mat_block_size, mat_block_dim, param_list, 
     2   param_list_length, first_row_pos)
       implicit none
       
       integer derv_size, mat_block_size, param_list_length ! The sizes of all the different arrays
       integer mat_block_dim        ! Dimension of the current block
       real derv(derv_size)         ! Derivative for this block
       real mat_block(mat_block_size) ! Normal matrix block
       integer param_list(param_list_length) !param_list for this block
       integer first_row_pos        ! Which derivative are we up to
       
       real const          ! Constant term
       integer param_l_pos ! Current position in the param list
       integer param_l_elem! Which elem were are up to
       integer mat_pos     ! Current position in the matrix
       integer mat_elem    ! Current position in the matrix temp
       integer row, column ! Current row and column in the this block
       integer PAIRS_BLOCK_ADLHS ! Return value
       
       param_l_pos = 1
       mat_pos = 1
       do row = 1,  mat_block_dim ! Loop over all the rows in the matrix.
             const = derv(row)    ! Get the constant term for this row.
             if (PARAM_LIST(param_l_pos) .lt. 0) then !if the size of the param list element is < 0 
C  Add in the whole row.
                  call add_in_row(const, derv(row), mat_block(mat_pos),
     1              mat_block_dim-(row-1))
                  mat_pos = mat_pos +  mat_block_dim-(row-1)    ! Move on to next row
                  param_l_pos = param_l_pos + 1                 ! Move on to next list of parameters in param_list
             else
C Add in some of the row
                   call param_list_add_in_row(const, derv(row), 
     1              mat_block(mat_pos), mat_block_dim-(row-1), 
     2              PARAM_LIST(param_l_pos+1), PARAM_LIST(param_l_pos),
     3              row + (first_row_pos-1))
                   mat_pos = mat_pos + (mat_block_dim -(row-1)) ! Move tht he next row in this block of the normal matrix
                   param_l_pos = param_l_pos + PARAM_LIST(param_l_pos)+1 ! Move to the next row of param lists
             end if
       end do
       PAIRS_BLOCK_ADLHS = param_l_pos-1  ! return the current position in the param list.
       return
       end
       
CODE FOR ADD_IN_ROW
      subroutine add_in_row(const, deriv, nmrow, row_size)
      implicit none
      
      integer row_size           ! The size of the row which should be the same for both the nm and the derivatives
      
      real const             ! The constant term for this row
      real deriv(row_size) ! The array of derivatives for this row.
      real nmrow(row_size) ! The array containing the normal matrix row.
      
      integer element        ! The element we are upto in this row.
      
      do element = 1, row_size
            nmrow(element) = nmrow(element) + const*deriv(element)
      end do
      end
      
CODE FOR PARAM_LIST_ADD_IN_ROW
      subroutine param_list_add_in_row(const, deriv, nmrow, row_size,
     1  params, params_size, row_index)
      implicit none
      
      integer row_size            ! The size of the normal matrix row passed
      integer params_size         ! The number of parameters passed.
      
      real const                  ! The constant term for this row
      real deriv(row_size)        ! The array of derivatives for this row.
      real nmrow(row_size)        ! The array containing the normal matrix row.
      integer params(params_size) ! The parameter links for this row.
      integer row_index           ! Which row in the whole normal matrix we are at. Index from 1
      integer element             ! The element in the paramlist which we are up to.
      
      integer row_element         ! Current element in the row
      
      nmrow(1) = nmrow(1) + const*deriv(1)      ! Add in the diagonal element
      do element = 1, params_size
            row_element = params(element)-(row_index-1)
            if (row_element .gt. row_size) exit ! If the row element is greater then this row's length then stop.
            nmrow(row_element) = nmrow(row_element) + 
     1       const*deriv(row_element)
      end do
      end
      
CODE FOR XADRHS
       subroutine XADRHS(WDF, DERIVS, RMAT11, NDERIV)
C--   ADD INTO THE R.H.S. OF THE NORMAL EQUATIONS
C      WDF  SQRT(W)*(/FO/ - /FC/)
       
       dimension DERIVS(NDERIV)
       dimension RMAT11(NDERIV)

       do I = 1, NDERIV
         RMAT11(I) = RMAT11(I) + DERIVS(I) * WDF
       end do

       return
       end

