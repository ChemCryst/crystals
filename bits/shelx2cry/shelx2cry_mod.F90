!> This module holds the different subroutines for shel2cry
!! 
module shelx2cry_mod

contains

!> Read a line of the res/inf file. If line is split using `=`, reconstruct the full line.
subroutine readline(shelxf_id, shelxline, iostatus)
use crystal_data_m
implicit none
integer, intent(in) :: shelxf_id !< res/ins file unit number
type(line_t), intent(out) :: shelxline !< Line read from res/ins file
integer, intent(out) :: iostatus !< status of the read
character(len=1024) :: buffer
character(len=:), allocatable :: linetemp
integer first, lens
integer, save :: line_number=1

    shelxline%line_number=line_number
    first=0
    do
        read(shelxf_id, '(a)', iostat=iostatus) buffer
        if(iostatus/=0) then
            shelxline%line=''
            shelxline%line_number=-1
            return
        end if
        line_number=line_number+1
        first=first+1
        if(first==1 .and. buffer(1:1)==' ') then ! cycle except if continuation line
            first=0
            cycle 
        end if
        if(allocated(shelxline%line)) then
            ! appending new text
            lens=len_trim(shelxline%line)
            allocate(character(len=lens) :: linetemp)
            linetemp=shelxline%line
            deallocate(shelxline%line)
            allocate(character(len=len(linetemp)+len_trim(buffer)+1) :: shelxline%line)
            shelxline%line=linetemp
            deallocate(linetemp)
            shelxline%line=trim(shelxline%line)//' '//trim(buffer)
        else        
            allocate(character(len=len_trim(buffer)) :: shelxline%line)
            shelxline%line=trim(buffer)
        end if

        if(shelxline%line(len_trim(shelxline%line):len_trim(shelxline%line))/='=') then
            ! end of line
            return
        else
            ! Continuation line present, appending next line...
            ! removing continuation symbol
            shelxline%line(len_trim(shelxline%line)-1:len_trim(shelxline%line))=' '
        end if
    end do

end subroutine

!> Process a line from the res/ins file. 
!! The subroutine is looking for shelx keywords and calling the adhoc subroutine.
subroutine call_shelxprocess(shelxline)
use shelx_keywords_dict_m
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline !< line from res/ins file
character(len=4) :: keyword
logical found

character(len=6) :: label
integer atomtype, iostatus
real, dimension(3) :: coordinates
real occupancy
real, dimension(6) :: aniso
real iso
type(dict_t) :: keywords2functions
procedure(shelx_dummy), pointer :: proc

    found=.false.
    keywords2functions=dict_t()

    if(len_trim(shelxline%line)<3) then
        return
    end if
    
    ! 4 letters keywords first
    if(len_trim(shelxline%line)>3) then
        keyword=to_upper(shelxline%line(1:4))
        call keywords2functions%getvalue( keyword, proc )
        if ( associated(proc) ) then
            call proc(shelxline)
            found=.true.
        end if
    end if
    
    ! 3 letters keywords 
    keyword=to_upper(shelxline%line(1:3))
    call keywords2functions%getvalue( keyword, proc )
    if ( associated(proc) ) then
        call proc(shelxline)
        found=.true.
    end if    

    if(found) return ! keyword found and processed
    
    ! there is something but it is not a keyword.
    ! Check for atoms:

    ! O1    4    0.560776    0.256941    0.101770    11.00000    0.07401    0.12846 0.04453   -0.00865    0.01598   -0.01300
    read(shelxline%line, *, iostat=iostatus) label, atomtype, coordinates, occupancy, aniso 
    if(iostatus==0) then
       call shelxl_atomaniso(label, atomtype, coordinates, occupancy, aniso, shelxline)
    end if

    ! try without aniso parameter
    if(iostatus/=0) then
        !H1N   2    0.426149    0.251251    0.038448    11.00000   -1.20000
        read(shelxline%line, *, iostat=iostatus) label, atomtype, coordinates, occupancy, iso 
        if(iostatus==0) then
           call shelxl_atomiso(label, atomtype, coordinates, occupancy, iso, shelxline)
        end if
    end if

    ! try with just the coordinates
    if(iostatus/=0) then
        !H1N   2    0.426149    0.251251    0.038448    11.00000   -1.20000
        read(shelxline%line, *, iostat=iostatus) label, atomtype, coordinates
        if(iostatus==0) then
           call shelxl_atomiso(label, atomtype, coordinates, 1.0, 0.05, shelxline)
        end if
    end if

    !if(.not. found) then
    !    print *, 'unknwon keyword ', line(1:min(4, len_trim(line))), ' on line ', line_number
    !end if

end subroutine

!> Write the crystals file
subroutine write_crystalfile()
use crystal_data_m
implicit none

    open(crystals_fileunit, file='crystalsinput.dat')

    ! process serial numbers 
    call get_shelx2crystals_serial

    call write_list1()

    call write_list31()

!    if(spacegroup%latt<0) then
!        centric='YES'
!    else
!        centric='NO '
!    end if
!    lattice=latticeletters(abs(spacegroup%latt))

    !call write_spacegroup()

    call write_list2()

    call write_list13()

    call write_composition()

    call write_list3()
    
    call write_list29()
    
    call write_list5()

    call write_list12()

    call write_list16()
    
    close(crystals_fileunit)
end subroutine

!> Algorithm to translate shelx labels into crystals serial code.
subroutine get_shelx2crystals_serial()
use crystal_data_m
implicit none
integer i, j, k, start, maxresidue, maxresiduelen, iostatus
character(len=128) :: label, residueformat, residuetext, serialtext
character(len=128) :: buffer
logical found
    
    print *, ''
    print *, 'Processing shelxl labels into crystals serials'

    ! shelx allows the same label in different residues. It's messing up the numerotation for crystals
    ! in this case, we will suffix the serial in crystals with the residue
    maxresidue=0
    do i=1, atomslist_index
        if(atomslist(i)%resi>maxresidue) then
            maxresidue=atomslist(i)%resi        
        end if
    end do   
    
    ! finding format to print residue
    maxresiduelen=0
    if(maxresidue>0) then
        write(buffer, '(I0)') maxresidue
        maxresiduelen=len_trim(buffer)
        write(residueformat, '("(I",I0,".",I0,")")') maxresiduelen, maxresiduelen
    end if
    residuetext=''

    do i=atomslist_index, 1, -1
        ! fetch and format residue, it will be appended as a suffix
        if(atomslist(i)%resi/=0) then
            write(residuetext, trim(residueformat)) atomslist(i)%resi
        end if

        label=atomslist(i)%label
        !print *, trim(label), atomslist(i)%resi
        ! fetch first number, anything before is ignored, atom type is get using sfac
        start=0
        do j=1, len_trim(label)
            if(iachar(label(j:j))>=48 .and. iachar(label(j:j))<=57) then ! [0-9]
                start=j
                exit
            end if
        end do
        
        if(start/=0) then
            ! fetch the serial number
            serialtext=''
            k=0
            
            do j=start, len_trim(label)
                if(iachar(label(j:j))>=48 .and. iachar(label(j:j))<=57) then ! [0-9]
                    k=k+1
                    serialtext(k:k)=label(j:j)
                else
                    ! no more number but a suffix not supported by crystals
                    ! if it is a symbol ignore it and hope for something after
                    if(iachar(label(j:j))<48 .or. iachar(label(j:j))>122) cycle
                    if(iachar(label(j:j))>57 .and. iachar(label(j:j))<65) cycle
                    if(iachar(label(j:j))>90 .and. iachar(label(j:j))<97) cycle
                    ! if a letter, append its number in alphabet instead
                    if(iachar(label(j:j))>=65 .and. iachar(label(j:j))<=90) then ! [A-Z]
                        k=k+1
                        write(serialtext(k:), '(I0)') iachar(label(j:j))-64
                        if(iachar(label(j:j))-64>10) k=k+1
                    end if
                end if
            end do
            buffer=trim(serialtext)//residuetext
            read(buffer, *) atomslist(i)%crystals_serial
        else
            ! default to 1 one serial is absent
            buffer='1'//trim(residuetext)
            read(buffer, *) atomslist(i)%crystals_serial
        end if
                        
        ! Most likely we have duplicates, lets fix that
        found=.true.
        do while(found)
            found=.false.
            do j=1, atomslist_index
                if(i/=j .and. atomslist(i)%crystals_serial==atomslist(j)%crystals_serial) then
                    if(atomslist(i)%sfac==atomslist(j)%sfac) then
                        ! identical serial, incrementing and starting search again
                        print *, '2 identical serial for ', trim(atomslist(i)%label), ':', atomslist(i)%crystals_serial, ' and ', &
                        &   trim(atomslist(j)%label), ':', atomslist(j)%crystals_serial
                        read(serialtext, *, iostat=iostatus) k
                        if(iostatus==0) then
                            k=k+1
                            write(serialtext, '(I0)') k
                        else
                            serialtext='1     '
                        end if                        
                        buffer=trim(serialtext)//residuetext
                        read(buffer, *) atomslist(i)%crystals_serial
                        print *, 'New serial for ', trim(atomslist(i)%label), ':', atomslist(i)%crystals_serial, ' and ', &
                        &   trim(atomslist(j)%label), ':', atomslist(j)%crystals_serial
                        found=.true.
                        exit
                    end if
                end if
            end do
        end do             
            
    end do

    ! We can still have duplicates, lets check again
    found=.true.
    duplicates:do while(found)
        found=.false.
        do i=1, atomslist_index
            do j=1, atomslist_index
                if(i/=j .and. atomslist(i)%crystals_serial==atomslist(j)%crystals_serial) then
                    if(atomslist(i)%sfac==atomslist(j)%sfac) then
                        print *, '2 identical serial for ', trim(atomslist(i)%label), ':', atomslist(i)%crystals_serial, ' and ', &
                        &   trim(atomslist(j)%label), ':', atomslist(j)%crystals_serial
                        !print *, atomslist(i)%sfac, atomslist(i)%crystals_serial
                        ! identical serial, looking for maxima and starting search again
                        atomslist(i)%crystals_serial=atomslist(i)%crystals_serial+1
                        found=.true.
                        cycle duplicates
                    end if
                end if
            end do
        end do
    end do duplicates

!do i=1, atomslist_index
!    print *, atomslist(i)%label, atomslist(i)%sfac, atomslist(i)%crystals_serial
!end do
end subroutine

!***********************************************************************************************************************************
!  M33INV  -  Compute the inverse of a 3x3 matrix.
!
!  A       = input 3x3 matrix to be inverted
!  AINV    = output 3x3 inverse of matrix A
!  OK_FLAG = (output) .TRUE. if the input matrix could be inverted, and .FALSE. if the input matrix is singular.
!***********************************************************************************************************************************
!> Compute the inverse of a 3x3 matrix.
SUBROUTINE M33INV (A, AINV, OK_FLAG)

IMPLICIT NONE

real, DIMENSION(3,3), INTENT(IN)  :: A
real, DIMENSION(3,3), INTENT(OUT) :: AINV
LOGICAL, INTENT(OUT) :: OK_FLAG

real, PARAMETER :: EPS = 1.0E-10
real :: DET
real, DIMENSION(3,3) :: COFACTOR


    DET =   A(1,1)*A(2,2)*A(3,3)  &
    &    - A(1,1)*A(2,3)*A(3,2)  &
    &    - A(1,2)*A(2,1)*A(3,3)  &
    &    + A(1,2)*A(2,3)*A(3,1)  &
    &    + A(1,3)*A(2,1)*A(3,2)  &
    &    - A(1,3)*A(2,2)*A(3,1)

    IF (ABS(DET) .LE. EPS) THEN
     AINV = 0.0D0
     OK_FLAG = .FALSE.
     RETURN
    END IF

    COFACTOR(1,1) = +(A(2,2)*A(3,3)-A(2,3)*A(3,2))
    COFACTOR(1,2) = -(A(2,1)*A(3,3)-A(2,3)*A(3,1))
    COFACTOR(1,3) = +(A(2,1)*A(3,2)-A(2,2)*A(3,1))
    COFACTOR(2,1) = -(A(1,2)*A(3,3)-A(1,3)*A(3,2))
    COFACTOR(2,2) = +(A(1,1)*A(3,3)-A(1,3)*A(3,1))
    COFACTOR(2,3) = -(A(1,1)*A(3,2)-A(1,2)*A(3,1))
    COFACTOR(3,1) = +(A(1,2)*A(2,3)-A(1,3)*A(2,2))
    COFACTOR(3,2) = -(A(1,1)*A(2,3)-A(1,3)*A(2,1))
    COFACTOR(3,3) = +(A(1,1)*A(2,2)-A(1,2)*A(2,1))

    AINV = TRANSPOSE(COFACTOR) / DET

    OK_FLAG = .TRUE.

    RETURN

END SUBROUTINE M33INV


!https://www.mpi-hd.mpg.de/personalhomes/globes/3x3/
!Joachim Kopp
!Efficient numerical diagonalization of hermitian 3x3 matrices
!Int. J. Mod. Phys. C 19 (2008) 523-548
!arXiv.org: physics/0610206
!* ----------------------------------------------------------------------------
!* Numerical diagonalization of 3x3 matrcies
!* Copyright (C) 2006  Joachim Kopp
!* ----------------------------------------------------------------------------
!* This library is free software; you can redistribute it and/or
!* modify it under the terms of the GNU Lesser General Public
!* License as published by the Free Software Foundation; either
!* version 2.1 of the License, or (at your option) any later version.
!*
!* This library is distributed in the hope that it will be useful,
!* but WITHOUT ANY WARRANTY; without even the implied warranty of
!* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
!* Lesser General Public License for more details.
!*
!* You should have received a copy of the GNU Lesser General Public
!* License along with this library; if not, write to the Free Software
!* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
!* ----------------------------------------------------------------------------

!> Calculates the eigenvalues of a symmetric 3x3 matrix A using Cardano's analytical algorithm.
!! See https://www.mpi-hd.mpg.de/personalhomes/globes/3x3/
!* ----------------------------------------------------------------------------
      SUBROUTINE DSYEVC3(A, W)
!* ----------------------------------------------------------------------------
!* Calculates the eigenvalues of a symmetric 3x3 matrix A using Cardano's
!* analytical algorithm.
!* Only the diagonal and upper triangular parts of A are accessed. The access
!* is read-only.
!* ----------------------------------------------------------------------------
!* Parameters:
!*   A: The symmetric input matrix
!*   W: Storage buffer for eigenvalues
!* ----------------------------------------------------------------------------
!*     .. Arguments ..
      DOUBLE PRECISION A(3,3)
      DOUBLE PRECISION W(3)

!*     .. Parameters ..
      DOUBLE PRECISION SQRT3
      PARAMETER        ( SQRT3 = 1.73205080756887729352744634151D0 )

!*     .. Local Variables ..
      DOUBLE PRECISION M, C1, C0
      DOUBLE PRECISION DE, DD, EE, FF
      DOUBLE PRECISION P, SQRTP, Q, C, S, PHI
  
!*     Determine coefficients of characteristic poynomial. We write
!*           | A   D   F  |
!*      A =  | D*  B   E  |
!*           | F*  E*  C  |
      DE    = A(1,2) * A(2,3)
      DD    = A(1,2)**2
      EE    = A(2,3)**2
      FF    = A(1,3)**2
      M     = A(1,1) + A(2,2) + A(3,3)
      C1    = ( A(1,1)*A(2,2) + A(1,1)*A(3,3) + A(2,2)*A(3,3) ) - (DD + EE + FF)
      C0    = A(3,3)*DD + A(1,1)*EE + A(2,2)*FF - A(1,1)*A(2,2)*A(3,3) - 2.0D0 * A(1,3)*DE

      P     = M**2 - 3.0D0 * C1
      Q     = M*(P - (3.0D0/2.0D0)*C1) - (27.0D0/2.0D0)*C0
      SQRTP = SQRT(ABS(P))

      PHI   = 27.0D0 * ( 0.25D0 * C1**2 * (P - C1) + C0 * (Q + (27.0D0/4.0D0)*C0) )
      PHI   = (1.0D0/3.0D0) * ATAN2(SQRT(ABS(PHI)), Q)

      C     = SQRTP * COS(PHI)
      S     = (1.0D0/SQRT3) * SQRTP * SIN(PHI)

      W(2) = (1.0D0/3.0D0) * (M - C)
      W(3) = W(2) + S
      W(1) = W(2) + C
      W(2) = W(2) - S

      END SUBROUTINE
!* End of subroutine DSYEVC3

!> Extract a res file from a cif file
subroutine extract_res_from_cif(shelx_filepath, found)
implicit  none
character(len=*), intent(in) :: shelx_filepath
logical, intent(out) :: found
character(len=len(shelx_filepath)+4) :: res_filepath
integer resid, cifid, iostatus
character(len=2048) :: buffer
integer :: data_number
character(len=4) :: data_number_text

    found=.false.
    cifid=815
    data_number=0
    open(unit=cifid,file=shelx_filepath, status='old')
    do
        read(cifid, '(a)', iostat=iostatus) buffer
        if(iostatus/=0) then
            return
        end if
        if(index(buffer, '_shelx_res_file')>0) then
            ! found a res file!
            found=.true.
            data_number=data_number+1
            read(cifid, '(a)', iostat=iostatus) buffer
            if(trim(buffer)/=';') then
                print *, 'unexpected line: ', trim(buffer)
                print *, 'I was expecting `;`'
                call abort()
            end if
            
            res_filepath=shelx_filepath
            write(data_number_text, '(I0)') data_number
            res_filepath(len_trim(res_filepath)-3:)=trim(data_number_text)//'.res'
            resid=816
            open(unit=resid,file=res_filepath)       
            do
                read(cifid, '(a)', iostat=iostatus) buffer
                if(iostatus/=0 .or. trim(buffer)==';') then
                    close(resid)
                    exit
                end if
                write(resid, '(a)') trim(buffer)
            end do
        end if

        if(index(buffer, '_shelx_hkl_file')>0) then
            ! found a hkl file!
            read(cifid, '(a)', iostat=iostatus) buffer
            if(trim(buffer)/=';') then
                print *, 'unexpected line: ', trim(buffer)
                print *, 'I was expecting `;`'
                call abort()
            end if
            
            res_filepath=shelx_filepath
            write(data_number_text, '(I0)') data_number
            res_filepath(len_trim(res_filepath)-3:)=trim(data_number_text)//'.hkl'
            resid=816
            open(unit=resid,file=res_filepath)       
            do
                read(cifid, '(a)', iostat=iostatus) buffer
                if(iostatus/=0 .or. trim(buffer)==';') then
                    close(resid)
                    exit
                end if
                write(resid, '(a)') trim(buffer)
            end do
        end if
        
    end do
end subroutine

!> Write list16 (restraints)
subroutine write_list16()
use crystal_data_m
implicit none
integer i, j, k, l, m, indexresi
integer :: serial1
logical found
character(len=1024) :: buffer1, buffer2, buffertemp
integer, dimension(:), allocatable :: residuelist, listtemp
character :: linecont

    allocate(residuelist(1024))
    residuelist=0
    indexresi=0
    do i=1, atomslist_index
        if(atomslist(i)%resi==0) cycle
        found=.false.
        do j=1, indexresi
            if(atomslist(i)%resi==residuelist(j)) then
                found=.true.
                exit
            end if
        end do
        if(.not. found) then
            indexresi=indexresi+1
            if(indexresi>size(residuelist)) then
                allocate(listtemp(size(residuelist)))
                listtemp=residuelist
                deallocate(residuelist)
                allocate(residuelist(size(listtemp)+1024))
                residuelist=0
                residuelist(1:size(listtemp))=listtemp
                deallocate(listtemp)
            end if
            residuelist(indexresi)=atomslist(i)%resi
        end if
    end do 
    if(indexresi==0) then
        deallocate(residuelist)
    else
        allocate(listtemp(indexresi))
        listtemp=residuelist(1:indexresi)
        deallocate(residuelist)
        allocate(residuelist(indexresi))
        residuelist=listtemp
        deallocate(listtemp)
    end if
        
    

    ! Restraints
    write(crystals_fileunit, '(a)') '\LIST 16'
    write(crystals_fileunit, '(a)') 'NO'
    write(crystals_fileunit, '(a)') 'REM   HREST   START (DO NOT REMOVE THIS LINE)' 
    write(crystals_fileunit, '(a)') 'REM   HREST   END (DO NOT REMOVE THIS LINE) '

!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
!*   MPLA
!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
    call write_list16_mpla()

!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
!*   DFIX/DANG
!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
    call write_list16_dfix()

!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
!*   SADI
!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
    call write_list16_sadi()

!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
!*   EADP
!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
    ! EADP O24 O25 O29 O28 O27 O26
    if(eadp_table_index>0) then
        print *, ''
        print *, 'Processing EADPs...'
    end if
    
    eadploop:do i=1, eadp_table_index
        print *, trim(eadp_table(i)%shelxline)
        write(crystals_fileunit, '(a, a)') '# ', eadp_table(i)%shelxline
        serial1=0
        do m=1, atomslist_index
            if(trim(eadp_table(i)%atoms(1))==trim(atomslist(m)%label)) then
                serial1=m
                exit
            end if
        end do
        if(serial1>0) then
            if(atomslist(serial1)%crystals_serial==-1) then
                print *, 'Error: Crystals serial not defined ', eadp_table(i)%atoms(1)
                call abort()
            end if
        else
            print *, 'Error: Crystals serial not defined ', eadp_table(i)%atoms(1)
            call abort()
        end if
        
        do j=2, size(eadp_table(i)%atoms)
            l=0
            do m=1, atomslist_index
                if(trim(eadp_table(i)%atoms(j))==trim(atomslist(m)%label)) then
                    l=m
                    exit
                end if
            end do
            if(l>0) then
                if(atomslist(l)%crystals_serial==-1) then
                    print *, 'Error: Crystals serial not defined ', eadp_table(i)%atoms(l)
                    call abort()
                end if
            else
                print *, 'Error: Crystals serial not defined ', eadp_table(i)%atoms(l)
                call abort()
            end if
            
            if(j==size(eadp_table(i)%atoms)) then 
                linecont=''
            else
                linecont=','
            end if
            if(j==2) then
                write(crystals_fileunit, '(a, a,"(",I0,")", " TO ", a,"(",I0,")", a)') &
                &   'U(IJ) 0.0, 0.001 =  ', &
                &   trim(sfac(atomslist(serial1)%sfac)), atomslist(serial1)%crystals_serial, &
                &   trim(sfac(atomslist(l)%sfac)), atomslist(l)%crystals_serial, &
                &   linecont
                write(*, '(a, a,"(",I0,")", " TO ", a,"(",I0,")", a)') &
                &   'U(IJ) 0.0, 0.001 =  ', &
                &   trim(sfac(atomslist(serial1)%sfac)), atomslist(serial1)%crystals_serial, &
                &   trim(sfac(atomslist(l)%sfac)), atomslist(l)%crystals_serial, &
                &   linecont
            else
                write(crystals_fileunit, '(a, a,"(",I0,")", " TO ", a,"(",I0,")", a)') &
                &   'CONT ', &
                &   trim(sfac(atomslist(serial1)%sfac)), atomslist(serial1)%crystals_serial, &
                &   trim(sfac(atomslist(l)%sfac)), atomslist(l)%crystals_serial, &
                &   linecont
                write(*, '(a, a,"(",I0,")", " TO ", a,"(",I0,")", a)') &
                &   'CONT ', &
                &   trim(sfac(atomslist(serial1)%sfac)), atomslist(serial1)%crystals_serial, &
                &   trim(sfac(atomslist(l)%sfac)), atomslist(l)%crystals_serial, &
                &   linecont
            end if
            
            serial1=l
        end do
    end do eadploop

!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
!*   RIGU
!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
    ! RIGU N2 C7 C8 C9 C10 C6 C5 C4 C3 C2 C1 N1 C12
    if(rigu_table_index>0) then
        print *, ''
        print *, 'Processing RIGUs...'
    end if
    
    riguloop:do i=1, rigu_table_index
        print *, trim(rigu_table(i)%shelxline)
        write(crystals_fileunit, '(a, a)') '# ', rigu_table(i)%shelxline
        serial1=0
        do m=1, atomslist_index
            if(trim(rigu_table(i)%atoms(1))==trim(atomslist(m)%label)) then
                serial1=m
                exit
            end if
        end do
        if(serial1>0) then
            if(atomslist(serial1)%crystals_serial==-1) then
                print *, 'Error: Crystals serial not defined ', rigu_table(i)%atoms(1)
                call abort()
            end if
        else
            print *, 'Error: Crystals serial not defined ', rigu_table(i)%atoms(1)
            call abort()
        end if
        
        do j=2, size(rigu_table(i)%atoms)
            l=0
            do m=1, atomslist_index
                if(trim(rigu_table(i)%atoms(j))==trim(atomslist(m)%label)) then
                    l=m
                    exit
                end if
            end do
            if(l>0) then
                if(atomslist(l)%crystals_serial==-1) then
                    print *, 'Error: Crystals serial not defined ', rigu_table(i)%atoms(l)
                    call abort()
                end if
            else
                print *, 'Error: Crystals serial not defined ', rigu_table(i)%atoms(l)
                call abort()
            end if
            
            write(crystals_fileunit, '(a, a,"(",I0,")", " TO ", a,"(",I0,")")') &
            &   'RIGU 0.0, 0.001 =  ', &
            &   trim(sfac(atomslist(serial1)%sfac)), atomslist(serial1)%crystals_serial, &
            &   trim(sfac(atomslist(l)%sfac)), atomslist(l)%crystals_serial
            write(*, '(a, a,"(",I0,")", " TO ", a,"(",I0,")")') &
            &   'RIGU 0.0, 0.001 =  ', &
            &   trim(sfac(atomslist(serial1)%sfac)), atomslist(serial1)%crystals_serial, &
            &   trim(sfac(atomslist(l)%sfac)), atomslist(l)%crystals_serial
            
            serial1=l
        end do
    end do riguloop
        
!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
!*   SAME
!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
    if(same_processing/=-1) then
        print *, 'Error: Something went seriously wrong. A SAME instruction is on going ', same_processing
    end if

    do i=1, same_table_index
        buffer1=''
        buffer2=''
        ! get crystals serial for list of atoms
        serial1=0
        do j=1, size(same_table(i)%list1)
            do k=1, atomslist_index
                if(trim(same_table(i)%list1(j))==trim(atomslist(k)%label)) then
                    write(buffertemp, '(a, "(",I0,")")') trim(sfac(atomslist(k)%sfac)), atomslist(k)%crystals_serial
                    buffer1=trim(buffer1)//' '//trim(buffertemp)
                end if
                if(trim(same_table(i)%list2(j))==trim(atomslist(k)%label)) then
                    write(buffertemp, '(a, "(",I0,")")') trim(sfac(atomslist(k)%sfac)), atomslist(k)%crystals_serial
                    buffer2=trim(buffer2)//' '//trim(buffertemp)
                end if
            end do
        end do
        
        write(crystals_fileunit, '(a,a)') '# ', same_table(i)%shelxline
        write(buffertemp, '("(a, ",I0,a,")")') size(same_table(i)%list1), 'a'
        write(crystals_fileunit, trim(buffertemp)) '# ', same_table(i)%list1
        write(crystals_fileunit, trim(buffertemp)) '# ', same_table(i)%list2
        write(crystals_fileunit, '(a)') 'SAME '
        write(crystals_fileunit, '(a,a,a)') 'CONT ',trim(buffer1), ' AND'
        write(crystals_fileunit, '(a,a)') 'CONT ',trim(buffer2)
        !print *, trim(same_table(i)%shelxline)
        !print *, size(same_table(i)%list1), same_table(i)%list1
        !print *, trim(buffer1)
        !print *, size(same_table(i)%list2), same_table(i)%list2
        !print *, trim(buffer2)
    end do

!        write(crystals_fileunit, '(a, 1X, F0.5, ",", F0.5, " = ", a,"(",I0,")", " TO ", a,"(",I0,")")') &
    
    write(crystals_fileunit, '(a)') 'END'
    write(crystals_fileunit, '(a)') '# Remove space after hash to activate next line'
    write(crystals_fileunit, '(a)') '# USE LAST'

end subroutine

!> Reformat sginfo space group to crystals notation
function reformat_spacegroup(spacegroup_arg) result(formatted_group)
implicit none
character(len=*), intent(in) :: spacegroup_arg
character(len=1024) spacegroup
character(len=:), allocatable :: formatted_group
integer i, j
character, dimension(12), parameter :: letters=&
&   (/'a', 'b', 'c', 'd', 'n', 'm', 'A', 'B', 'C', 'D', 'N', 'M'/)

    spacegroup=trim(spacegroup_arg)

    ! (1) Second character must be a space
    if(spacegroup(2:2)/=' ') then
        spacegroup(2:)=' '//spacegroup(2:)
    end if

    ! (2) Any opening brackets must be removed.
    ! (3) Any closing brackets become spaces, unless followed by '/'
    i=index(spacegroup, '(')
    do while(i>0)
        spacegroup=spacegroup(1:i-1)//spacegroup(i+1:)
        i=index(spacegroup, '(')
    end do
    i=index(spacegroup, ')')
    do while(i>0)
        if(spacegroup(i+1:i+1)/='/') then
            spacegroup(i:i)=' '
        else
            spacegroup=spacegroup(1:i-1)//spacegroup(i+1:)
        end if
        i=index(spacegroup, ')')
    end do    

    ! (4) There is always a space after a, b, c, d, n or m
    do i=1, size(letters)
        j=3
        do while(j<=len_trim(spacegroup))
            if(spacegroup(j:j)==letters(i) .and. &
            &   spacegroup(j+1:j+1)/=' ') then
                spacegroup=spacegroup(1:j)//' '//spacegroup(j+1:)
                j=3
                cycle
            end if
            j=j+1
        end do
    end do

    ! (5) There is always a space before 6
    j=3
    do while(j<=len_trim(spacegroup))
        if(spacegroup(j:j)=='6' .and. &
        &   spacegroup(j-1:j-1)/=' ') then
            spacegroup=spacegroup(1:j-1)//' '//spacegroup(j:)
            j=3
            cycle
        end if
        j=j+1
    end do

    ! (6a) Adjacent numbers always have #1>#2.
    ! (6b) Always a space after a number, unless another number or /
    j=3
    do while(j<=len_trim(spacegroup))
        if(iachar(spacegroup(j:j))>=48 .and. iachar(spacegroup(j:j))<=57) then
            ! We have a number
            if(iachar(spacegroup(j+1:j+1))>=48 .and. iachar(spacegroup(j+1:j+1))<=57) then
                ! followed by another number
                if(iachar(spacegroup(j:j))<=iachar(spacegroup(j+1:j+1))) then
                    spacegroup=spacegroup(1:j)//' '//spacegroup(j+1:)
                    j=3
                    cycle
                end if
            else if(spacegroup(j+1:j+1)/=' ' .and. spacegroup(j+1:j+1)/='/') then
                spacegroup=spacegroup(1:j)//' '//spacegroup(j+1:)
                j=3
                cycle        
            end if
        end if
        j=j+1
    end do

    ! (7) There is always a space before -, and one digit after.
    j=3
    do while(j<=len_trim(spacegroup))
        if(spacegroup(j:j)=='-') then
            if(spacegroup(j-1:j-1)/=' ') then
                spacegroup=spacegroup(1:j)//' '//spacegroup(j+1:)
                j=3
                cycle
            end if
        end if
        j=j+1
    end do
    j=3
    do while(j<=len_trim(spacegroup))
        if(spacegroup(j:j)=='-') then
            if(spacegroup(j+2:j+2)/=' ') then
                spacegroup=spacegroup(1:j+1)//' '//spacegroup(j+2:)
                j=3
                cycle
            end if
        end if
        j=j+1
    end do

    allocate(character(len=len_trim(spacegroup)) :: formatted_group)
    formatted_group=trim(spacegroup)

end function

!> Write list 1 (unit cell parameters) to file. 
! process list1
!\LIST 1
! REAL A= B= C= ALPHA= BETA= GAMMA=
! END
subroutine write_list1()
use crystal_data_m
implicit none
integer i

    if(list1index>0) then
        write(crystals_fileunit, '(a)') '\LIST 1'
        do i=1, list1index
            write(crystals_fileunit, '(a)') trim(list1(i))
        end do
        write(crystals_fileunit, '(a)') 'END'
    end if

end subroutine

!> write list 31 (esds on cell parameters) to file.
subroutine write_list31()
use crystal_data_m
implicit none
integer i

    if(trim(list31(1))/='') then
        do i=1, size(list31)
            if(trim(list31(i))=='') exit
            write(crystals_fileunit, '(a)') trim(list31(i))
        end do
    end if

end subroutine

!> Write space group command
subroutine write_spacegroup()
use crystal_data_m
implicit none

    spacegroup%symbol=reformat_spacegroup(trim(spacegroup%symbol))

    write(crystals_fileunit, '(a)') '\SPACEGROUP'
    write(crystals_fileunit, '(a,1X,a)') 'SYMBOL', trim(spacegroup%symbol)
    write(crystals_fileunit, '(a)') 'END'

end subroutine

!> write list13 (experiment setup)
subroutine write_list13()
use crystal_data_m
implicit none
integer i

    ! process list13
    ! \LIST 13
    ! CRYSTAL FRIEDELPAIRS= TWINNED= SPREAD=
    ! DIFFRACTION GEOMETRY= RADIATION=
    ! CONDITIONS WAVELENGTH= THETA(1)= THETA(2)= CONSTANTS . .
    ! MATRIX R(1)= R(2)= R(3)= . . . R(9)=
    ! TWO H= K= L= THETA= OMEGA= CHI= PHI= KAPPA= PSI=
    ! THREE H= K= L= THETA= OMEGA= CHI= PHI= KAPPA= PSI=
    ! REAL COMPONENTS= H= K= L= ANGLES=
    ! RECIPROCAL COMPONENTS= H= K= L= ANGLES=
    ! AXIS H= K= L=
    if(list13index>0) then
        write(crystals_fileunit, '(a)') '\LIST 13'
        do i=1, list13index
            write(crystals_fileunit, '(a)') trim(list13(i))
        end do
        write(crystals_fileunit, '(a)') 'END'
    end if

end subroutine

!> write chemical composition
subroutine write_composition()
use crystal_data_m
implicit none
integer i

    ! composition
    if(trim(composition(1))/='') then
        do i=1, 5
            write(crystals_fileunit, '(a)') trim(composition(i))
        end do
    end if

end subroutine

!> Write list5 (atom parameters)
subroutine write_list5()
use crystal_data_m
implicit none
integer i
real occ
integer flag, atompart, fvar_index

    ! atom list
    !#LIST     5
    !READ NATOM =     24, NLAYER =    0, NELEMENT =    0, NBATCH =    0
    !OVERALL   10.013602  0.050000  0.050000  1.000000  0.000000      156.0803375
    !
    !ATOM CU            1.   1.000000         0.   0.500000  -0.297919   0.250000
    !CON U[11]=   0.052972   0.024222   0.052116   0.000000  -0.004649   0.000000
    !CON SPARE=  0.50          0   26279939          1                     0
    !
    !ATOM H            81.   1.000000         1.   0.465536   0.338532   0.388114
    !CON U[11]=   0.050000   0.000000   0.000000   0.000000   0.000000   0.000000
    !CON SPARE=  1.00          0    8388609          1                     0
    !
    ! ATOM TYPE=C,SERIAL=4,OCC=1,U[ISO]=0,X=0.027,Y=0.384,Z=0.725,
    ! CONT U[11]=0.075,U[22]=0.048,U[33]=.069
    ! CONT U[23]=-.007,U[13]=.043,U[12]=-.001
    if(atomslist_index>0) then
        write(crystals_fileunit, '(a)') '\LIST 5'
        write(crystals_fileunit, '("READ NATOM = ",I0,", NLAYER = ",I0,'// &
        &   '", NELEMENT = ",I0,", NBATCH = ",I0)') &
        &   atomslist_index, 0, 0, 0
        do i=1, atomslist_index
            ! extracting occupancy from sof
            if(atomslist(i)%sof>=10.0 .and. atomslist(i)%sof<20.0) then
                ! fixed occupancy
                occ=atomslist(i)%sof-10.0
                !list12index=list12index+1
                !write(list12(list12index), '("FIX ",a,"(",I0,", occ)")') &
                !&   trim(sfac(atomslist(i)%sfac)), shelx2crystals_serial(i)%crystals_serial
            else if(abs(atomslist(i)%sof)>=20.0) then
                ! occupancy depends on a free variable
                fvar_index=int(abs(atomslist(i)%sof)/10.0)
                if(fvar_index>size(fvar) .or. fvar_index<=0) then
                    print *, 'Error: Free variable missing for sof=', atomslist(i)%sof
                    write(*, '("Line ", I0, ": ", a)') atomslist(i)%line_number, trim(atomslist(i)%shelxline)
                    occ=1.0
                else                               
                    occ=abs(atomslist(i)%sof)-fvar_index*10.0
                    if(atomslist(i)%sof>0) then
                        occ=occ*fvar(fvar_index)
                    else
                        occ=occ*(1.0-fvar(fvar_index))
                    end if
                    ! restraints done automatically using parts later. See below
                end if
            else if(atomslist(i)%sof<0.0) then
                print *, "don't know what to do with a sof between -20.0 < sof < 0.0"
                stop
            else            
                occ=atomslist(i)%sof
            end if
            if(atomslist(i)%iso/=0.0) then
                flag=1
            else
                flag=0
            end if
            if(atomslist(i)%crystals_serial==-1) then
                print *, 'Error: crystals serial not defined'
                call abort()
            end if
            
            write(crystals_fileunit, '(a,1X,a)') '# ', trim(atomslist(i)%shelxline)
            write(crystals_fileunit, '("ATOM TYPE=", a, ", SERIAL=",I0, ", OCC=",F0.5, ", FLAG=", I0)')  &
            &   trim(sfac(atomslist(i)%sfac)), atomslist(i)%crystals_serial, occ, flag
            if(any(atomslist(i)%aniso/=0.0)) then
                write(crystals_fileunit, '("CONT X=",F0.5, ", Y=",F0.5, ", Z=", F0.5)') &
                &   atomslist(i)%coordinates
                write(crystals_fileunit, '("CONT U[11]=", F0.5,", U[22]=", F0.5,", U[33]=", F0.5)') &
                &   atomslist(i)%aniso(1:3)
                write(crystals_fileunit, '("CONT U[23]=", F0.5,", U[13]=", F0.5,", U[12]=", F0.5)') &
                &   atomslist(i)%aniso(4:6)
            else
                write(crystals_fileunit, '("CONT U[11]=",F0.5, ", X=",F0.5, ", Y=",F0.5, ", Z=", F0.5)') &
                &   abs(atomslist(i)%iso), atomslist(i)%coordinates        
            end if
            if(atomslist(i)%resi>0) then
                write(crystals_fileunit, '("CONT RESIDUE=",I0)') atomslist(i)%resi
            end if
            ! We are not using shelx part instruction, part is constructed from the free variable
            ! In shelx part is only used for connectivity
            !if(atomslist(i)%part>0) then
            !    write(crystals_fileunit, '("CONT PART=",I0)') atomslist(i)%part+1000
            !end if
            ! if using free variable, setting parts:
            if(abs(atomslist(i)%sof)>=20.0) then
                if(atomslist(i)%sof>0.0) then
                    flag=1
                else
                    flag=2
                end if
                atompart=(int(abs(atomslist(i)%sof)/10.0)-1)*1000+flag
                write(crystals_fileunit, '("CONT PART=",I0)') atompart
            end if
        end do
        write(crystals_fileunit, '(a)') 'END'
    end if

end subroutine

!> Write list12 (constraints)
subroutine write_list12()
use crystal_data_m
implicit none
integer i

    if(list12index>0) then
        write(crystals_fileunit, '(a)') '\LIST 12'
        do i=1, list12index
            write(crystals_fileunit, '(a)') list12(i)
        end do
        write(crystals_fileunit, '(a)') 'END'
    end if

end subroutine

!> write list2 (space group and symmetry)
subroutine write_list2()
use crystal_data_m
use iso_c_binding
use sginfo_mod
implicit none
type(T_sginfo) :: sginfo
type(T_RTMx) :: NewSMx
type(T_RTMx), dimension(:), pointer :: lsmx
type(T_LatticeInfo), pointer :: LatticeInfo
type(T_TabSgName), pointer :: TabSgName
character(kind=C_char), dimension(:), allocatable :: xyz
integer error, i, j
character(len=1024) :: buffer, spacegroupsymbol
type(c_ptr) :: xyzptr
!> lattice translations, code and shelx number
type(T_LatticeTranslation), dimension(:), allocatable :: LatticeTranslation

    call InitSgInfo(SgInfo)
    error=MemoryInit(SgInfo)
    if(error/=0) then
        print *, 'Error Cannot allocate memory'
        call abort()
    end if
    
    ! Adding symmetry operators
    do i=1, spacegroup%symmindex
        buffer=adjustl(spacegroup%symm(i))
        allocate(xyz(len_trim(buffer)+1))
        do j=1, size(xyz)-1
            xyz(j)=buffer(j:j)
        end do
        xyz(size(xyz))=C_NULL_CHAR
        error=ParseSymXYZ(xyz, NewSMx, nint(sginfo_stbf))
        deallocate(xyz)
        if(error/=0) then
            print *, 'Error: Cannot recognize symmetry operator ', trim(buffer)
            call abort()
        end if
        
        error=Add2ListSeitzMx(SgInfo, NewSMx)
        if(error/=0) then
            print *, 'Error in Add2ListSeitzMx'
            call abort()
        end if
    end do

     call LatticeTranslation_init(LatticeTranslation)
    ! Adding lattice symmetry
    if(spacegroup%latt/=0) then
        i=LatticeTranslation(abs(spacegroup%latt))%nTrVector
        NewSMx%R=0
        NewSMx%R(1)=1
        NewSMx%R(5)=1
        NewSMx%R(9)=1
        !print *, 'latt ', spacegroup%latt, i
        do j=1, i
            NewSMx%T=LatticeTranslation(abs(spacegroup%latt))%TrVector(:,j)
            error=Add2ListSeitzMx(SgInfo, NewSMx)
        end do
    end if
    
    ! adding inversion centre
    if(spacegroup%latt>0) then
        error=AddInversion2ListSeitzMx(SgInfo)
        if(error/=0) then
            print *, 'Error in AddInversion2ListSeitzMx'
            call abort()
        end if
    end if
    
    ! All done!
    error=CompleteSgInfo(SgInfo)
    if(error/=0) then
        print *, 'Error in CompleteSgInfo'
        call abort()
    end if

    !print *, 'Hall Symbol ', SgInfo%HallSymbol
    !call C_F_POINTER(SgInfo%LatticeInfo, LatticeInfo)

    !print *, 'Lattice code ', LatticeInfo%Code

    !print *, 'Crystal system ', XS_name(SgInfo%XtalSystem)

    if(c_associated(SgInfo%LatticeInfo)) then
        call C_F_POINTER(SgInfo%LatticeInfo, LatticeInfo)
    else
        print *, 'Error: LatticeInfo not associated'
        call abort()
    end if

    write(crystals_fileunit, '(a)') '\LIST 2'
    write(crystals_fileunit, '(a, I0, a, a)') 'CELL NSYM=', SgInfo%nlist, ', LATTICE=', LatticeInfo%Code
    if(SgInfo%Centric==0) then
        write(crystals_fileunit, '(a)') 'CONT CENTRIC=NO'
    else
        write(crystals_fileunit, '(a)') 'CONT CENTRIC=YES'
    end if
    
    if(C_associated(SgInfo%ListSeitzMx)) then
        call C_F_POINTER(SgInfo%ListSeitzMx, lsmx, (/ SgInfo%nlist /) )
        do i=1, SgInfo%nlist
            xyzptr=RTMx2XYZ(lsmx(i), 1, nint(sginfo_stbf), 0, 1, 0, ", ")
            call C_F_string_ptr(xyzptr, buffer)
            write(crystals_fileunit, '(a, a)') 'SYMM ', trim(buffer)        
        end do
    else
        print *, 'Error: No summetry operators in SgInfo%ListSeitzMx'
        call abort()
    end if
    
    if(C_associated(SgInfo%TabSgName)) then
        call C_F_POINTER(SgInfo%TabSgName, TabSgName)
        call C_F_string_ptr(TabSgName%SgLabels, buffer)
        if(trim(buffer)/='') then
            i=index(buffer, '=')
            if(i>0) then
                spacegroupsymbol=buffer(i+1:)
                i=index(spacegroupsymbol, '=')
                if(i>0) then
                    spacegroupsymbol=spacegroupsymbol(:i-1)
                end if
            else
                spacegroupsymbol=buffer
            end if
                
            ! replace `_` with ` `
            do i=1, len_trim(spacegroupsymbol)
                if(spacegroupsymbol(i:i)=='_') then
                    spacegroupsymbol(i:i)=' '
                end if
            end do
        write(crystals_fileunit, '(a, a)') 'SPACEGROUP ', trim(spacegroupsymbol)    
        end if
    else
        print *, 'Warning: Uknown space group!!'
        print *, 'Hall Symbol ', SgInfo%HallSymbol
        print *, 'Resulting input file won''t work'
    end if
    write(crystals_fileunit, '(a, a)') 'CLASS ', trim(XS_name(SgInfo%XtalSystem))  
    
    write(crystals_fileunit, '(a)') 'END'
    
    ! process list2
    ! \LIST 2
    ! CELL NSYM= 2, LATTICE = B
    ! SYM X, Y, Z
    ! SYM X, Y + 1/2,  - Z
    ! SPACEGROUP B 1 1 2/B
    ! CLASS MONOCLINIC
    ! END

end subroutine

!> write list3 (atomic scattering factors)
subroutine write_list3()
use crystal_data_m
implicit none
integer i, j

    if(any(sfac_long/=0.0)) then

    ! process list3
    ! \LIST 3
    ! READ 2
    ! SCATT C    0    0
    ! CONT  1.93019  12.7188  1.87812  28.6498  1.57415  0.59645
    ! CONT  0.37108  65.0337  0.24637
    ! SCATT S 0.35 0.86  7.18742  1.43280  5.88671  0.02865
    ! CONT               5.15858  22.1101  1.64403  55.4561
    ! CONT              -3.87732
    ! END
    
        write(crystals_fileunit, '(a)') '\LIST 3 '
        write(crystals_fileunit, '(a, 1X, I0)') 'READ', sfac_index
        
        do i=1, sfac_index
            !print *, i, trim(sfac(i))
            write(crystals_fileunit, '(a, a, 2F12.6)') 'SCATT ', trim(sfac(i)), sfac_long(10,i), sfac_long(11,i)
            write(crystals_fileunit, '(a, 4F12.6)') 'CONT ', sfac_long(1:4,i)
            write(crystals_fileunit, '(a, 4F12.6)') 'CONT ', sfac_long(5:8,i)
            write(crystals_fileunit, '(a, F12.6)') 'CONT ', sfac_long(9,i)
        end do    
        write(crystals_fileunit, '(a)') 'END'
        
    end if
    
    if(allocated(disp_table)) then
    
        !\generaledit 3
        !LOCATE RECORDTYPE=101
        !top
        !next
        !next
        !TRANSFER TO OFFSET=1 FROM 1.01
        !TRANSFER TO OFFSET=2 FROM 2.03
        !write
        !end
        
        write(crystals_fileunit, '(a)') '\GENERALEDIT 3 '
        write(crystals_fileunit, '(a)') 'LOCATE RECORDTYPE=101'
        write(crystals_fileunit, '(a)') 'TOP'
    
        do i=1, size(sfac)
            if(sfac(i)=='') exit
            if(i/=1) write(crystals_fileunit, '(a)') 'NEXT'
            
            do j=1, size(disp_table)
                if(sfac(i)==disp_table(j)%atom) then
                    write(crystals_fileunit, '(a,a)') '# ', trim(disp_table(j)%shelxline)
                    if(disp_table(j)%values(1)/=0.0) then
                        write(crystals_fileunit, '(a, f15.5)') 'TRANSFER TO OFFSET=1 FROM ', disp_table(j)%values(1)
                    end if
                    if(disp_table(j)%values(2)/=0.0) then
                        write(crystals_fileunit, '(a, f15.5)') 'TRANSFER TO OFFSET=2 FROM ', disp_table(j)%values(2)
                    end if
                    exit
                end if
            end do
        end do
        
        write(crystals_fileunit, '(a)') 'WRITE'
        write(crystals_fileunit, '(a)') 'END'
    end if                   
            
    
    
end subroutine

!> write list29 (atomic scattering factors)
subroutine write_list29()
use crystal_data_m
implicit none
integer i

    if(all(sfac_long==0.0)) then
        return
    end if
    
    write(crystals_fileunit, '(a)') '\LIST 29 '
    write(crystals_fileunit, '(a, 1X, I0)') 'READ', sfac_index
    
    do i=1, sfac_index
        ! warning units in shelx file is for the unit cell, crystals wants in the asymetric unit (to be fixed)
        write(crystals_fileunit, '(a, a, 1X, a, F0.3)') 'ELEMENT ', trim(sfac(i)), 'NUM=', sfac_units(i)
        if(sfac_long(12,i)/=0.0) then
            write(crystals_fileunit, '(a, F12.6)') 'CONT MUA=', sfac_long(12,i)
        end if
        if(sfac_long(13,i)/=0.0) then
            write(crystals_fileunit, '(a, F12.6)') 'CONT COVALENT=', sfac_long(13,i)
        end if
        if(sfac_long(14,i)/=0.0) then
            write(crystals_fileunit, '(a, F12.6)') 'CONT WEIGHT=', sfac_long(14,i)
        end if
    end do    
    write(crystals_fileunit, '(a)') 'END'
    
    ! process list29
    !  ELEMENT TYPE= COVALENT= VANDERWAALS= IONIC= NUMBER= MUA= WEIGHT= COLOUR=
    ! \LIST 29
    ! READ NELEMENT=4
    ! ELEMENT MO NUM=0 .5
    ! ELEMENT S NUM=2
    ! ELEMENT O NUM=3
    ! ELEMENT C NUM=10
    ! END
end subroutine

!> Parse the atom parameters when adps are present.
subroutine shelxl_atomaniso(label, atomtype, coordinates, sof, aniso, shelxline)
use crystal_data_m
implicit none
character(len=*), intent(in) :: label !< shelxl label
integer, intent(in) :: atomtype !< atom type as integer (position in sfac)
real, dimension(:), intent(in) :: coordinates !< atomic coordinates
real, intent(in) :: sof !< site occupation factor (sof) from shelx
real, dimension(6), intent(in) :: aniso !< adps U11 U22 U33 U23 U13 U12
type(line_t) :: shelxline
integer i
 
    if(.not. allocated(atomslist)) then
        allocate(atomslist(1024))
        atomslist_index=0
        atomslist%label=''
        atomslist%sfac=0
        do i=1, size(atomslist)
            atomslist(i)%coordinates=0.0
            atomslist(i)%aniso=0.0
        end do
        atomslist%iso=0.0
        atomslist%sof=0.0
        atomslist%resi=0
        atomslist%part=0
        atomslist%shelxline=''
        atomslist%crystals_serial=-1
    end if

    atomslist_index=atomslist_index+1
    atomslist(atomslist_index)%label=to_upper(label)
    atomslist(atomslist_index)%sfac=atomtype
    atomslist(atomslist_index)%coordinates=coordinates
    atomslist(atomslist_index)%aniso=aniso
    if(part>0 .and. part_sof/=-1.0) then
        ! We are working on a res file, this values should be the same as the one reported on each atom
        if(abs(sof-part_sof)>0.01) then
            print *, 'Error: res file not consistent'
            print *, '       sof from part should be the same of the atom one'
            write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        end if
    end if
    atomslist(atomslist_index)%sof=sof
    atomslist(atomslist_index)%resi=residue
    atomslist(atomslist_index)%part=part
    atomslist(atomslist_index)%shelxline=shelxline%line
    atomslist(atomslist_index)%line_number=shelxline%line_number
    
    if(same_processing>=0) then
        ! same instruction found before, adding this atom to the list
        if(same_processing<size(same_table(same_table_index)%list2)) then
            if(trim(sfac(atomslist(atomslist_index)%sfac))/='H' .and. &
            &   trim(sfac(atomslist(atomslist_index)%sfac))/='D') then
                same_processing=same_processing+1
                same_table(same_table_index)%list2(same_processing)=atomslist(atomslist_index)%label
            end if
            
            if(same_processing==size(same_table(same_table_index)%list2)) then
                ! all done
                same_processing=-1
            end if
        end if
    end if
    
end subroutine

!> Parse the atom parameters when adps are not present but isotropic temperature factor.
subroutine shelxl_atomiso(label, atomtype, coordinates, sof, iso, shelxline)
use crystal_data_m
implicit none
character(len=*), intent(in) :: label!< shelxl label
integer, intent(in) :: atomtype !< atom type as integer (position in sfac)
real, dimension(:), intent(in) :: coordinates !< atomic coordinates
real, intent(in) :: sof !< site occupation factor (sof) from shelx
real, intent(in) :: iso !< isotropic temperature factor
integer i, j, k
type(line_t) :: shelxline
real, dimension(3,3) :: orthogonalisation, uij, metric, rmetric
double precision, dimension(3,3) :: temp
double precision, dimension(3) :: eigv
real, dimension(6) :: unitcellradian
real rgamma
logical ok_flag
type(atom_t), dimension(:), allocatable :: templist

    unitcellradian(1:3)=unitcell(1:3)
    unitcellradian(4:6)=unitcell(4:6)*2.0*3.14159/360.0

    rgamma=acos((cos(unitcellradian(4))*cos(unitcellradian(5))-cos(unitcellradian(6)))/&
    &   (sin(unitcellradian(4))*sin(unitcellradian(5))))
    orthogonalisation=0.0
    orthogonalisation(1,1) = unitcellradian(1)*sin(unitcellradian(5))*sin(rgamma)
    orthogonalisation(2,1) = -unitcellradian(1)*sin(unitcellradian(5))*cos(rgamma)
    orthogonalisation(2,2) = unitcellradian(2)*sin(unitcellradian(4))
    orthogonalisation(3,1) = unitcellradian(1)*cos(unitcellradian(5))
    orthogonalisation(3,2) = unitcellradian(2)*cos(unitcellradian(4))
    orthogonalisation(3,3) = unitcellradian(3)
    metric = matmul(transpose(orthogonalisation), orthogonalisation)
    call m33inv(metric, rmetric, ok_flag)
     
    if(.not. allocated(atomslist)) then
        allocate(atomslist(1024))
        atomslist_index=0
        atomslist%label=''
        atomslist%sfac=0
        do i=1, size(atomslist)
            atomslist(i)%coordinates=0.0
            atomslist(i)%aniso=0.0
        end do
        atomslist%iso=0.0
        atomslist%sof=0.0
        atomslist%resi=0
        atomslist%part=0
        atomslist%shelxline=''
    end if

    atomslist_index=atomslist_index+1
    if(atomslist_index>size(atomslist)) then
        allocate(templist(size(atomslist)))
        templist=atomslist
        deallocate(atomslist)
        allocate(atomslist(size(templist)+1024))
        atomslist(1:size(templist))=templist

        atomslist(size(templist)+1:)%label=''
        atomslist(size(templist)+1:)%sfac=0
        do i=size(templist)+1, size(atomslist)
            atomslist(i)%coordinates=0.0
            atomslist(i)%aniso=0.0
        end do
        atomslist(size(templist)+1:)%iso=0.0
        atomslist(size(templist)+1:)%sof=0.0
        atomslist(size(templist)+1:)%resi=0
        atomslist(size(templist)+1:)%part=0
        atomslist(size(templist)+1:)%shelxline=''   
        deallocate(templist)     
    end if
    
    atomslist(atomslist_index)%label=to_upper(label)
    atomslist(atomslist_index)%sfac=atomtype
    atomslist(atomslist_index)%coordinates=coordinates
    if(iso<0.0) then
        ! If an isotropic U is given as -T, where T is in the range 
        ! 0.5 < T < 5, it is fixed at T times the Ueq of the previous 
        ! atom not constrained in this way
        print *, 'Warning: isotropic thermal parameter depends on previous atom'
        print *, '         Thermal parameter will be fixed at current value'
        write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        do i=atomslist_index-1, 1, -1
            if(atomslist(i)%iso>0.0) then
                atomslist(atomslist_index)%iso=atomslist(i)%iso*iso
                exit
            else if(any(atomslist(i)%aniso/=0.0)) then
                ! anisotropic displacements, need to calculate Ueq first
                uij(1,1)=atomslist(i)%aniso(1)
                uij(2,2)=atomslist(i)%aniso(2)
                uij(3,3)=atomslist(i)%aniso(3)
                uij(2,3)=atomslist(i)%aniso(4)
                uij(3,2)=atomslist(i)%aniso(4)
                uij(1,3)=atomslist(i)%aniso(5)
                uij(3,1)=atomslist(i)%aniso(5)
                uij(1,2)=atomslist(i)%aniso(6)
                uij(2,1)=atomslist(i)%aniso(6)
                do j=1, 3
                    do k=1, 3
                        uij(k,j)=uij(k,j)*sqrt(rmetric(j,j)*rmetric(k,k))
                    end do
                end do
                temp=matmul(orthogonalisation, matmul(uij, transpose(orthogonalisation)))
                call DSYEVC3(temp, eigv)
                atomslist(atomslist_index)%iso=1.0/3.0*sum(eigv)*iso
                exit
            end if
        end do
    else
        if(iso>=20) then   
            ! proportional to fvar
            j=2
            do while(j*10<=iso)
                j=j+1
            end do
            atomslist(atomslist_index)%iso=(iso-(j-1)*10)*fvar(j-1)
        else if(iso>=10) then
            atomslist(atomslist_index)%iso=iso-10.0
        else
            atomslist(atomslist_index)%iso=iso
        end if
    end if  
    if(part>0 .and. part_sof/=-1.0) then
        ! We are working on a res file, this values should be the same as the one reported on each atom
        if(abs(sof-part_sof)>0.01) then
            print *, 'Error: res file not consistent'
            print *, '       sof from part should be the same of the atom one'
            write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        end if
    end if
    atomslist(atomslist_index)%sof=sof
    atomslist(atomslist_index)%resi=residue
    atomslist(atomslist_index)%part=part
    atomslist(atomslist_index)%shelxline=shelxline%line
    atomslist(atomslist_index)%line_number=shelxline%line_number

end subroutine

!> Write mpla restraints to list16 section 
subroutine write_list16_mpla()
use crystal_data_m
implicit none
integer, dimension(:), allocatable :: serials
character(len=6) :: atom
character(len=1024) :: buffer1, buffertemp
logical found
integer i, j, k, l, indexresi, resi1
integer :: serial1
character(len=12) :: label
integer, dimension(:), allocatable :: residuelist

    ! PLANAR 0.01 N(1) C(3) 
    if(mpla_table_index>0) then
        print *, ''
        print *, 'Processing MPLASs...'
    end if
    ! DISTANCE 1.000000 , 0.050000 = N(1) TO C(3) 
    do i=1, mpla_table_index
        print *, trim(mpla_table(i)%shelxline)
        
        found=.false.
        do j=1, size(mpla_table(i)%atoms)
            if(index(mpla_table(i)%atoms(j), '_*')>0) then
                print *, 'Warning: ignoring MPLA '
                print *, '_* syntax not supported'
                found=.true.
                exit
            end if
        end do
        if(found) cycle
        
        write(crystals_fileunit, '(a, a)') '# ', mpla_table(i)%shelxline
        
        if(mpla_table(i)%residue==-99) then
            ! No residue used in MPLA card name
            if(allocated(serials)) deallocate(serials)
            allocate(serials(size(mpla_table(i)%atoms)))
            serials=0
            
            do j=1, size(mpla_table(i)%atoms)
                ! ICE on gfortran 61 when using associate
                atom=mpla_table(i)%atoms(j)
                !associate( atom => mpla_table(i)%atoms(j) )
                    resi1=0
                    indexresi=index(atom, '_')
                    if(indexresi>0) then
                        if(atom(indexresi+1:indexresi+1)=='-') then
                            ! previous residue
                            print *, 'Residue - in atom with MPLA without _*'
                            print *, 'Not implemented'
                            call abort()
                        else if(atom(indexresi+1:indexresi+1)=='+') then
                            ! next residue
                            print *, 'Residue + in atom with MPLA without _*'
                            print *, 'Not implemented'
                            call abort()
                        else if(iachar(atom(indexresi+1:indexresi+1))>=48 .and. &
                        &   iachar(atom(indexresi+1:indexresi+1))<=57) then
                            ! residue number
                            read(atom(indexresi+1:), *) resi1
                        else
                            ! residue name
                            print *, 'Residue name in atom with MPLA_*'
                            print *, 'Not implemented'
                            call abort()
                        end if
                        label=atom(1:indexresi-1)
                    else
                        label=atom
                    end if
                !end associate
                serial1=0
                do k=1, atomslist_index
                    if(trim(label)==trim(atomslist(k)%label) .and. resi1==atomslist(k)%resi) then
                        serial1=k
                        exit
                    end if
                end do
            
                if(serial1==0) then
                    print *, mpla_table(i)%atoms(j)
                    print *, serial1
                    print *, 'Error: check your res file. I cannot find the atom'
                    call abort()
                end if
                
                if(atomslist(serial1)%crystals_serial==-1) then
                    print *, 'Error: Crystals serial not defined'
                    call abort()
                end if
                serials(j)=serial1
            end do
                        
            ! good to go
            buffertemp='PLANAR 0.05'
             do k=1, size(serials)
                write(buffer1, '(a,"(",I0,")")') &
                &   trim(sfac(atomslist(serials(k))%sfac)), atomslist(serials(k))%crystals_serial
                buffertemp=trim(buffertemp)//' '//trim(buffer1)
            end do
            write(crystals_fileunit, '(a)') trim(buffertemp)                           
            write(*, '(a)') trim(buffertemp)                           


        else if(mpla_table(i)%residue==-98) then
            ! mpla applied to a named residues
            do j=1, size(residue_names)
                if(trim(residue_names(j))/=trim(mpla_table(i)%namedresidue)) cycle
                
                if(allocated(serials)) deallocate(serials)
                allocate(serials(size(mpla_table(i)%atoms)))
                serials=0
                
                do k=1, size(mpla_table(i)%atoms)
                    ! ICE on gfortran 61 when using associate
                    atom=mpla_table(i)%atoms(k)
                    !associate( atom => mpla_table(i)%atoms(k) )
                        resi1=j
                        indexresi=index(atom, '_')
                        if(indexresi>0) then
                            if(atom(indexresi+1:indexresi+1)=='-') then
                                ! previous residue
                                resi1=j-1                        
                            else if(atom(indexresi+1:indexresi+1)=='+') then
                                ! next residue
                                resi1=j+1
                            else if(iachar(atom(indexresi+1:indexresi+1))>=48 .and. &
                            &   iachar(atom(indexresi+1:indexresi+1))<=57) then
                                ! residue number
                                read(atom(indexresi+1:), *) resi1
                            else
                                ! residue name
                                print *, 'Residue name in atom with MPLA_*'
                                print *, 'Not implemented'
                                call abort()
                            end if
                            label=atom(1:indexresi-1)
                        else
                            label=atom
                        end if
                    !end associate
                    serial1=0
                    do l=1, atomslist_index
                        if(trim(label)==trim(atomslist(l)%label) .and. resi1==atomslist(l)%resi) then
                            serial1=l
                            exit
                        end if
                    end do

                    if(serial1==0) then
                        cycle
                    end if
                    
                    if(atomslist(serial1)%crystals_serial==-1) then
                        print *, 'Error: Crystals serial not defined'
                        call abort()
                    end if
                    serials(k)=serial1
                end do
                            
                ! good to go
                buffertemp='PLANAR 0.05'
                 do k=1, size(serials)
                    write(buffer1, '(a,"(",I0,")")') &
                    &   trim(sfac(atomslist(serials(k))%sfac)), atomslist(serials(k))%crystals_serial
                    buffertemp=trim(buffertemp)//' '//trim(buffer1)
                end do
                write(crystals_fileunit, '(a)') trim(buffertemp)                           
                write(*, '(a)') trim(buffertemp)
            end do

        else if(mpla_table(i)%residue==-1) then
            ! dfix applied to all residues
            do j=1, size(residuelist)
                
                do k=1, size(mpla_table(i)%atoms)
                    ! ICE on gfortran 61 when using associate
                    atom=mpla_table(i)%atoms(k)
                    !associate( atom => mpla_table(i)%atoms(k) )
                        resi1=j
                        indexresi=index(atom, '_')
                        if(indexresi>0) then
                            if(atom(indexresi+1:indexresi+1)=='-') then
                                ! previous residue
                                if(j==1) cycle
                                resi1=residuelist(j-1)
                            else if(atom(indexresi+1:indexresi+1)=='+') then
                                ! next residue
                                if(j==size(residuelist)) cycle
                                resi1=residuelist(j+1)
                            else if(iachar(atom(indexresi+1:indexresi+1))>=48 .and. &
                            &   iachar(atom(indexresi+1:indexresi+1))<=57) then
                                ! residue number
                                read(atom(indexresi+1:), *) resi1
                            else
                                ! residue name
                                print *, 'Residue name in atom with MPLA_*'
                                print *, 'Not implemented'
                                call abort()
                            end if
                            label=atom(1:indexresi-1)
                        else
                            label=atom
                        end if
                    !end associate
                    serial1=0
                    do l=1, atomslist_index
                        if(trim(label)==trim(atomslist(l)%label) .and. resi1==atomslist(l)%resi) then
                            serial1=l
                            exit
                        end if
                    end do

                    if(serial1==0) then
                        cycle
                    end if
                    
                    if(atomslist(serial1)%crystals_serial==-1) then
                        print *, 'Error: Crystals serial not defined'
                        call abort()
                    end if
                    serials(k)=serial1
                end do
                            
                ! good to go
                buffertemp='PLANAR 0.05'
                 do k=1, size(serials)
                    write(buffer1, '(a,"(",I0,")")') &
                    &   trim(sfac(atomslist(serials(k))%sfac)), atomslist(serials(k))%crystals_serial
                    buffertemp=trim(buffertemp)//' '//trim(buffer1)
                end do
                write(crystals_fileunit, '(a)') trim(buffertemp)                           
                write(*, '(a)') trim(buffertemp)  

            end do
        else
            ! look for specific residue
            resi1=mpla_table(i)%residue
            do k=1, size(mpla_table(i)%atoms)
                ! ICE on gfortran 61 when using associate
                atom=mpla_table(i)%atoms(k)
                !associate( atom => mpla_table(i)%atoms(k) )
                    indexresi=index(atom, '_')
                    if(indexresi>0) then 
                        if(atom(indexresi+1:indexresi+1)=='-') then
                            ! previous residue
                            print *, 'previous residue in atom with MPLA_x'
                            print *, 'Not implemented'
                            call abort()
                        else if(atom(indexresi+1:indexresi+1)=='+') then
                            ! next residue
                            print *, 'next residue in atom with MPLA_x'
                            print *, 'Not implemented'
                            call abort()
                        else if(iachar(atom(indexresi+1:indexresi+1))>=48 .and. &
                        &   iachar(atom(indexresi+1:indexresi+1))<=57) then
                            ! residue number
                            print *, 'Residue number in atom with MPLA_x'
                            print *, 'Not implemented'
                            call abort()
                        else
                            ! residue name
                            print *, 'Residue name in atom with MPLA_x'
                            print *, 'Not implemented'
                            call abort()
                        end if
                        label=atom(1:indexresi-1)
                    else
                        label=atom
                    end if
                !end associate
                serial1=0
                do l=1, atomslist_index
                    if(trim(label)==trim(atomslist(l)%label) .and. resi1==atomslist(l)%resi) then
                        serial1=l
                        exit
                    end if
                end do

                if(serial1==0) then
                    cycle
                end if
                
                if(atomslist(serial1)%crystals_serial==-1) then
                    print *, 'Error: Crystals serial not defined'
                    call abort()
                end if
                serials(k)=serial1
            end do                    
                
            buffertemp='PLANAR 0.05'
             do k=1, size(serials)
                write(buffer1, '(a,"(",I0,")")') &
                &   trim(sfac(atomslist(serials(k))%sfac)), atomslist(serials(k))%crystals_serial
                buffertemp=trim(buffertemp)//' '//trim(buffer1)
            end do
            write(crystals_fileunit, '(a)') trim(buffertemp)                           
            write(*, '(a)') trim(buffertemp)  

        end if
                    
    end do
end subroutine

!> Write dfix restraints to list16 section 
subroutine write_list16_dfix()
use crystal_data_m
implicit none
integer i, j, k, indexresi, resi1, resi2
integer :: serial1, serial2
character(len=12) :: label
integer, dimension(:), allocatable :: residuelist


    if(dfix_table_index>0) then
        print *, ''
        print *, 'Processing DFIXs...'
    end if
    ! DISTANCE 1.000000 , 0.050000 = N(1) TO C(3) 
    do i=1, dfix_table_index
        print *, trim(dfix_table(i)%shelxline)
        if(index(dfix_table(i)%atom1, '_*')>0) then
            print *, 'Warning: ignoring DFIX between ', trim(dfix_table(i)%atom1), ' and ', trim(dfix_table(i)%atom2)
            print *, '_* syntax not supported'
            cycle
        end if
        if(index(dfix_table(i)%atom2, '_*')>0) then
            print *, 'Warning: ignoring DFIX between ', trim(dfix_table(i)%atom1), ' and ', trim(dfix_table(i)%atom2)
            print *, '_* syntax not supported'
            cycle
        end if

        if(dfix_table(i)%distance<0.0) then
            print *, 'Warning: Anti bumping in DFIX not supported '
            write(*, '("Line ", I0, ": ", a)') dfix_table(i)%line_number, trim(dfix_table(i)%shelxline)
            cycle
        end if
        
        write(crystals_fileunit, '(a, a)') '# ', dfix_table(i)%shelxline
        
        if(dfix_table(i)%residue==-99) then
            ! No residue used in DFIX card            
            resi1=0
            indexresi=index(dfix_table(i)%atom1, '_')
            if(indexresi>0) then
                if(dfix_table(i)%atom1(indexresi+1:indexresi+1)=='-') then
                    ! previous residue
                    print *, 'Residue - in atom with DFIX without _*'
                    print *, 'Not implemented'
                    call abort()
                else if(dfix_table(i)%atom1(indexresi+1:indexresi+1)=='+') then
                    ! next residue
                    print *, 'Residue - in atom with DFIX without _*'
                    print *, 'Not implemented'
                    call abort()
                else if(iachar(dfix_table(i)%atom1(indexresi+1:indexresi+1))>=48 .and. &
                &   iachar(dfix_table(i)%atom1(indexresi+1:indexresi+1))<=57) then
                    ! residue number
                    read(dfix_table(i)%atom1(indexresi+1:), *) resi1
                else
                    ! residue name
                    print *, 'Residue name in atom with DFIX_*'
                    print *, 'Not implemented'
                    call abort()
                end if
                label=dfix_table(i)%atom1(1:indexresi-1)
            else
                label=dfix_table(i)%atom1
            end if
            serial1=0
            do k=1, atomslist_index
                if(trim(label)==trim(atomslist(k)%label)) then
                    serial1=k
                    exit
                end if
            end do
            
            resi2=0
            indexresi=index(dfix_table(i)%atom2, '_')
            if(indexresi>0) then
                if(dfix_table(i)%atom2(indexresi+1:indexresi+1)=='-') then
                    ! previous residue
                    print *, 'Residue - in atom with DFIX without _*'
                    print *, 'Not implemented'
                    call abort()
                else if(dfix_table(i)%atom2(indexresi+1:indexresi+1)=='+') then
                    ! next residue
                    print *, 'Residue - in atom with DFIX without _*'
                    print *, 'Not implemented'
                    call abort()
                else if(iachar(dfix_table(i)%atom2(indexresi+1:indexresi+1))>=48 .and. &
                &   iachar(dfix_table(i)%atom2(indexresi+1:indexresi+1))<=57) then
                    ! residue number
                    read(dfix_table(i)%atom2(indexresi+1:), *) resi2
                else
                    ! residue name
                    print *, 'Residue name in atom with DFIX_*'
                    print *, 'Not implemented'
                    call abort()
                end if
                label=dfix_table(i)%atom2(1:indexresi-1)
            else
                label=dfix_table(i)%atom2
            end if
            serial2=0
            do k=1, atomslist_index
                if(trim(label)==trim(atomslist(k)%label)) then
                    serial2=k
                    exit
                end if
            end do

            if(serial1==0 .or. serial2==0) then
                print *, dfix_table(i)%atom1, dfix_table(i)%atom2
                print *, serial1, serial2
                print *, 'Error: check your res file. I cannot find the atom'
                call abort()
            end if
                        
            ! good to go
            if(atomslist(serial1)%crystals_serial==-1 .or. atomslist(serial2)%crystals_serial==-1) then
                print *, 'Error: Crystals serial not defined'
                call abort()
            end if
            write(crystals_fileunit, '(a, 1X, F0.5, ",", F0.5, " = ", a,"(",I0,")", " TO ", a,"(",I0,")")') &
            &   'DISTANCE', dfix_table(i)%distance, dfix_table(i)%esd, &
            &   trim(sfac(atomslist(serial1)%sfac)), atomslist(serial1)%crystals_serial, &
            &   trim(sfac(atomslist(serial2)%sfac)), atomslist(serial2)%crystals_serial
            write(*, '(a, 1X, F0.5, ",", F0.5, " = ", a,"(",I0,")", " TO ", a,"(",I0,")")') &
            &   'DISTANCE', dfix_table(i)%distance, dfix_table(i)%esd, &
            &   trim(sfac(atomslist(serial1)%sfac)), atomslist(serial1)%crystals_serial, &
            &   trim(sfac(atomslist(serial2)%sfac)), atomslist(serial2)%crystals_serial
        else if(dfix_table(i)%residue==-98) then
            ! dfix applied to a named residues
            do j=1, size(residue_names)
                if(trim(residue_names(j))/=trim(dfix_table(i)%namedresidue)) cycle
                
                resi1=j
                indexresi=index(dfix_table(i)%atom1, '_')
                if(indexresi>0) then
                    if(dfix_table(i)%atom1(indexresi+1:indexresi+1)=='-') then
                        ! previous residue
                        resi1=j-1                        
                    else if(dfix_table(i)%atom1(indexresi+1:indexresi+1)=='+') then
                        ! next residue
                        resi1=j+1
                    else if(iachar(dfix_table(i)%atom1(indexresi+1:indexresi+1))>=48 .and. &
                    &   iachar(dfix_table(i)%atom1(indexresi+1:indexresi+1))<=57) then
                        ! residue number
                        read(dfix_table(i)%atom1(indexresi+1:), *) resi1
                    else
                        ! residue name
                        print *, 'Residue name in atom with DFIX_*'
                        print *, 'Not implemented'
                        call abort()
                    end if
                    label=dfix_table(i)%atom1(1:indexresi-1)
                else
                    label=dfix_table(i)%atom1
                end if
                serial1=0
                do k=1, atomslist_index
                    if(trim(label)==trim(atomslist(k)%label) .and. resi1==atomslist(k)%resi) then
                        serial1=k
                        exit
                    end if
                end do
                
                resi2=j
                indexresi=index(dfix_table(i)%atom2, '_')
                if(indexresi>0) then
                    if(dfix_table(i)%atom2(indexresi+1:indexresi+1)=='-') then
                        ! previous residue
                        resi2=j-1
                    else if(dfix_table(i)%atom2(indexresi+1:indexresi+1)=='+') then
                        ! next residue
                        resi2=j+1
                    else if(iachar(dfix_table(i)%atom2(indexresi+1:indexresi+1))>=48 .and. &
                    &   iachar(dfix_table(i)%atom2(indexresi+1:indexresi+1))<=57) then
                        ! residue number
                        read(dfix_table(i)%atom2(indexresi+1:), *) resi2
                    else
                        ! residue name
                        print *, 'Residue name in atom with DFIX_*'
                        print *, 'Not implemented'
                        call abort()
                    end if
                    label=dfix_table(i)%atom2(1:indexresi-1)
                else
                    label=dfix_table(i)%atom2
                end if
                serial2=0
                do k=1, atomslist_index
                    if(trim(label)==trim(atomslist(k)%label) .and. resi2==atomslist(k)%resi) then
                        serial2=k
                        exit
                    end if
                end do
                                                        
                if(serial1==0 .or. serial2==0) then
                    if(serial1==0) then
                        print *, 'Warning: ', trim(dfix_table(i)%atom1), ' is missing in RESI ', j, ' ', trim(residue_names(j))
                    end if
                    if(serial2==0) then
                        print *, 'Warning: ', trim(dfix_table(i)%atom1), ' is missing in RESI ', j, ' ', trim(residue_names(j))
                    end if
                else
                
                    if(atomslist(serial1)%crystals_serial==-1 .or. atomslist(serial2)%crystals_serial==-1) then
                        print *, 'Error: Crystals serial not defined'
                        call abort()
                    end if
                    write(crystals_fileunit, '(a, 1X, F0.5, ",", F0.5, " = ", a,"(",I0,")", " TO ", a,"(",I0,")")') &
                    &   'DISTANCE', dfix_table(i)%distance, dfix_table(i)%esd, &
                    &   trim(sfac(atomslist(serial1)%sfac)), atomslist(serial1)%crystals_serial, &
                    &   trim(sfac(atomslist(serial2)%sfac)), atomslist(serial2)%crystals_serial
                    write(*, '(a, 1X, F0.5, ",", F0.5, " = ", a,"(",I0,")", " TO ", a,"(",I0,")")') &
                    &   'DISTANCE', dfix_table(i)%distance, dfix_table(i)%esd, &
                    &   trim(sfac(atomslist(serial1)%sfac)), atomslist(serial1)%crystals_serial, &
                    &   trim(sfac(atomslist(serial2)%sfac)), atomslist(serial2)%crystals_serial
                end if
            end do
        else if(dfix_table(i)%residue==-1) then
            ! dfix applied to all residues
            do j=1, size(residuelist)
                
                resi1=residuelist(j)
                indexresi=index(dfix_table(i)%atom1, '_')
                if(indexresi>0) then
                    if(dfix_table(i)%atom1(indexresi+1:indexresi+1)=='-') then
                        ! previous residue
                        if(j==1) cycle
                        resi1=residuelist(j-1)
                    else if(dfix_table(i)%atom1(indexresi+1:indexresi+1)=='+') then
                        ! next residue
                        if(j==size(residuelist)) cycle
                        resi1=residuelist(j+1)
                    else if(iachar(dfix_table(i)%atom1(indexresi+1:indexresi+1))>=48 .and. &
                    &   iachar(dfix_table(i)%atom1(indexresi+1:indexresi+1))<=57) then
                        ! residue number
                        read(dfix_table(i)%atom1(indexresi+1:), *) resi1
                    else
                        ! residue name
                        print *, 'Residue name in atom with DFIX_*'
                        print *, 'Not implemented'
                        call abort()
                    end if
                    label=dfix_table(i)%atom1(1:indexresi-1)
                else
                    label=dfix_table(i)%atom1
                end if
                serial1=0
                do k=1, atomslist_index
                    if(trim(label)==trim(atomslist(k)%label) .and. resi1==atomslist(k)%resi) then
                        serial1=k
                        exit
                    end if
                end do
                
                resi2=residuelist(j)
                indexresi=index(dfix_table(i)%atom2, '_')
                if(indexresi>0) then
                    if(dfix_table(i)%atom2(indexresi+1:indexresi+1)=='-') then
                        ! previous residue
                        resi2=residuelist(j)-1
                    else if(dfix_table(i)%atom2(indexresi+1:indexresi+1)=='+') then
                        ! next residue
                        resi2=residuelist(j)+1
                    else if(iachar(dfix_table(i)%atom2(indexresi+1:indexresi+1))>=48 .and. &
                    &   iachar(dfix_table(i)%atom2(indexresi+1:indexresi+1))<=57) then
                        ! residue number
                        read(dfix_table(i)%atom2(indexresi+1:), *) resi2
                    else
                        ! residue name
                        print *, 'Residue name in atom with DFIX_*'
                        print *, 'Not implemented'
                        call abort()
                    end if
                    label=dfix_table(i)%atom2(1:indexresi-1)
                else
                    label=dfix_table(i)%atom2
                end if
                serial2=0
                do k=1, atomslist_index
                    if(trim(label)==trim(atomslist(k)%label) .and. resi2==atomslist(k)%resi) then
                        serial2=k
                        exit
                    end if
                end do
                                                        
                if(serial1/=0 .and. serial2/=0) then
                    if(atomslist(serial1)%crystals_serial==-1 .or. atomslist(serial2)%crystals_serial==-1) then
                        print *, 'Error: Crystals serial not defined'
                        call abort()
                    end if
                    write(crystals_fileunit, '(a, 1X, F0.5, ",", F0.5, " = ", a,"(",I0,")", " TO ", a,"(",I0,")")') &
                    &   'DISTANCE', dfix_table(i)%distance, dfix_table(i)%esd, &
                    &   trim(sfac(atomslist(serial1)%sfac)), atomslist(serial1)%crystals_serial, &
                    &   trim(sfac(atomslist(serial2)%sfac)), atomslist(serial2)%crystals_serial
                    write(*, '(a, 1X, F0.5, ",", F0.5, " = ", a,"(",I0,")", " TO ", a,"(",I0,")")') &
                    &   'DISTANCE', dfix_table(i)%distance, dfix_table(i)%esd, &
                    &   trim(sfac(atomslist(serial1)%sfac)), atomslist(serial1)%crystals_serial, &
                    &   trim(sfac(atomslist(serial2)%sfac)), atomslist(serial2)%crystals_serial
                end if
            end do
        else
            ! looking for a specific residue
            indexresi=index(dfix_table(i)%atom1, '_')
            if(indexresi>0) then
                print *, 'Residue name in atom is not yet implemented'
                call abort()
            end if
            indexresi=index(dfix_table(i)%atom2, '_')
            if(indexresi>0) then
                print *, 'Residue name in atom is not yet implemented'
                call abort()
            end if
            
            serial1=0
            serial2=0
            do j=1, atomslist_index
                if(trim(atomslist(j)%label)==trim(dfix_table(i)%atom1) .and. &
                &   atomslist(j)%resi==dfix_table(i)%residue) then
                    serial1=j
                end if
                if(trim(atomslist(j)%label)==trim(dfix_table(i)%atom2) .and. &
                &   atomslist(j)%resi==dfix_table(i)%residue) then
                    serial2=j
                end if
                
                if(serial1/=0 .and. serial2/=0) then
                    write(crystals_fileunit, '(a, 1X, F0.5, ",", F0.5, " = ", a,"(",I0,")", " TO ", a,"(",I0,")")') &
                    &   'DISTANCE', dfix_table(i)%distance, dfix_table(i)%esd, &
                    &   trim(sfac(atomslist(serial1)%sfac)), atomslist(serial1)%crystals_serial, &
                    &   trim(sfac(atomslist(serial2)%sfac)), atomslist(serial2)%crystals_serial
                    write(*, '(a, 1X, F0.5, ",", F0.5, " = ", a,"(",I0,")", " TO ", a,"(",I0,")")') &
                    &   'DISTANCE', dfix_table(i)%distance, dfix_table(i)%esd, &
                    &   trim(sfac(atomslist(serial1)%sfac)), atomslist(serial1)%crystals_serial, &
                    &   trim(sfac(atomslist(serial2)%sfac)), atomslist(serial2)%crystals_serial
                    serial1=0
                    serial2=0
                end if
            end do
        end if
                    
    end do

end subroutine

!> Write sadi restraints to list16 section 
subroutine write_list16_sadi()
use crystal_data_m
implicit none
integer, dimension(:), allocatable :: serials
character(len=6) :: atom
integer i, j, k, l, m, indexresi, resi1
integer :: serial1
character(len=12) :: label
character :: linecont
integer, dimension(:), allocatable :: residuelist


    ! DISTANCE 0.000000 , 0.050000 = MEAN N(1) TO C(3), ...
    if(sadi_table_index>0) then
        print *, ''
        print *, 'Processing SADIs...'
        if(allocated(serials)) deallocate(serials)
        allocate(serials(2))
        serials=0
    end if
    sadiloop:do i=1, sadi_table_index
        print *, trim(sadi_table(i)%shelxline)
        
        write(crystals_fileunit, '(a, a)') '# ', sadi_table(i)%shelxline
        write(crystals_fileunit, '(a, 1X, F0.5, a)') &
        &   'DISTANCE 0.0, ', sadi_table(i)%esd, ' = MEAN ' 
        write(*, '(a, 1X, F0.5, a)') &
        &   'DISTANCE 0.0, ', sadi_table(i)%esd, ' = MEAN ' 
                
        sadipairs:do j=1, ubound(sadi_table(i)%atom_pairs, 2)
            if(j==ubound(sadi_table(i)%atom_pairs, 2)) then
                linecont=''
            else
                linecont=','
            end if
            
            do k=1, 2
                if(index(sadi_table(i)%atom_pairs(k,j), '_*')>0) then
                    print *, 'Warning: ignoring DFIX between ', trim(sadi_table(i)%atom_pairs(1,j)), &
                    &   ' and ', trim(sadi_table(i)%atom_pairs(2,j))
                    print *, '_* syntax not supported'
                    cycle
                end if
            end do
                    
            if(sadi_table(i)%residue==-99) then
                ! No residue used in SADI card 
                do k=1, 2           
                    resi1=0
                    ! ICE on gfortran 61 when using associate
                    atom=sadi_table(i)%atom_pairs(k,j)
                    !associate( atom => sadi_table(i)%atom_pairs(k,j) )
                        indexresi=index(atom, '_')
                        if(indexresi>0) then
                            if(atom(indexresi+1:indexresi+1)=='-') then
                                ! previous residue
                                print *, 'Residue - in atom with SADI without _*'
                                print *, 'Not implemented'
                                call abort()
                            else if(atom(indexresi+1:indexresi+1)=='+') then
                                ! next residue
                                print *, 'Residue - in atom with SADI without _*'
                                print *, 'Not implemented'
                                call abort()
                            else if(iachar(atom(indexresi+1:indexresi+1))>=48 .and. &
                            &   iachar(atom(indexresi+1:indexresi+1))<=57) then
                                ! residue number
                                read(atom(indexresi+1:), *) resi1
                            else
                                ! residue name
                                print *, 'Residue name in atom with SADI_*'
                                print *, 'Not implemented'
                                call abort()
                            end if
                            label=atom(1:indexresi-1)
                        else
                            label=atom
                        end if
                        serial1=0
                        do l=1, atomslist_index
                            if(trim(label)==trim(atomslist(l)%label) .and. resi1==atomslist(l)%resi) then
                                serial1=l
                                exit
                            end if
                        end do
                        if(serial1==0) then
                            print *, j, sadi_table(i)%atom_pairs(:,j)
                            print *, 'Warning: ', trim(atom), ' is missing in res file '
                            cycle sadipairs
                        end if                        
                        
                        serials(k)=serial1
                        if(atomslist(serial1)%crystals_serial==-1) then
                            print *, 'Error: Crystals serial not defined'
                            call abort()
                        end if
                    !end associate
                end do
                                       
                write(crystals_fileunit, '(a, a,"(",I0,")", " TO ", a,"(",I0,")",a)') &
                &   'CONT ', &
                &   trim(sfac(atomslist(serials(1))%sfac)), atomslist(serials(1))%crystals_serial, &
                &   trim(sfac(atomslist(serials(2))%sfac)), atomslist(serials(2))%crystals_serial, &
                &   linecont
                write(*, '(a, a,"(",I0,")", " TO ", a,"(",I0,")",a)') &
                &   'CONT ', &
                &   trim(sfac(atomslist(serials(1))%sfac)), atomslist(serials(1))%crystals_serial, &
                &   trim(sfac(atomslist(serials(2))%sfac)), atomslist(serials(2))%crystals_serial, &
                &   linecont
            else if(sadi_table(i)%residue==-98) then
                ! dfix applied to a named residues
                do k=1, size(residue_names)
                    if(trim(residue_names(k))/=trim(dfix_table(i)%namedresidue)) cycle

                    do l=1, 2           
                        resi1=k
                        atom=sadi_table(i)%atom_pairs(l,j)
                        !associate( atom => sadi_table(i)%atom_pairs(l,j) )
                            indexresi=index(atom, '_')
                            if(indexresi>0) then
                                if(atom(indexresi+1:indexresi+1)=='-') then
                                    ! previous residue
                                    resi1=j-1     
                                else if(atom(indexresi+1:indexresi+1)=='+') then
                                    ! next residue
                                    resi1=j+1 
                                else if(iachar(atom(indexresi+1:indexresi+1))>=48 .and. &
                                &   iachar(atom(indexresi+1:indexresi+1))<=57) then
                                    ! residue number
                                    read(atom(indexresi+1:), *) resi1
                                else
                                    ! residue name
                                    print *, 'Residue name in atom with SADI_*'
                                    print *, 'Not implemented'
                                    call abort()
                                end if
                                label=atom(1:indexresi-1)
                            else
                                label=atom
                            end if
                            serial1=0
                            do m=1, atomslist_index
                                if(trim(label)==trim(atomslist(m)%label) .and. resi1==atomslist(m)%resi) then
                                    serial1=m
                                    exit
                                end if
                            end do
                            serials(l)=serial1
                            if(atomslist(serial1)%crystals_serial==-1) then
                                print *, 'Error: Crystals serial not defined'
                                call abort()
                            end if
                        !end associate
                    end do
                                           
                    write(crystals_fileunit, '(a, a,"(",I0,")", " TO ", a,"(",I0,")", a)') &
                    &   'CONT ', &
                    &   trim(sfac(atomslist(serials(1))%sfac)), atomslist(serials(1))%crystals_serial, &
                    &   trim(sfac(atomslist(serials(2))%sfac)), atomslist(serials(2))%crystals_serial, &
                    &   linecont
                    write(*, '(a, a,"(",I0,")", " TO ", a,"(",I0,")", a)') &
                    &   'CONT ', &
                    &   trim(sfac(atomslist(serials(1))%sfac)), atomslist(serials(1))%crystals_serial, &
                    &   trim(sfac(atomslist(serials(2))%sfac)), atomslist(serials(2))%crystals_serial, &
                    &   linecont

                end do
            else if(sadi_table(i)%residue==-1) then
                ! dfix applied to all residues
                do k=1, size(residuelist)
                    
                    do l=1, 2           
                        resi1=residuelist(k)
                        atom=sadi_table(i)%atom_pairs(l,j)
                        !associate( atom => sadi_table(i)%atom_pairs(l,j) )
                            indexresi=index(atom, '_')
                            if(indexresi>0) then
                                if(atom(indexresi+1:indexresi+1)=='-') then
                                    ! previous residue
                                    if(k==1) cycle
                                    resi1=residuelist(k-1)
                                else if(atom(indexresi+1:indexresi+1)=='+') then
                                    ! next residue
                                    if(k==size(residuelist)) cycle
                                    resi1=residuelist(k+1)
                                else if(iachar(atom(indexresi+1:indexresi+1))>=48 .and. &
                                &   iachar(atom(indexresi+1:indexresi+1))<=57) then
                                    ! residue number
                                    read(atom(indexresi+1:), *) resi1
                                else
                                    ! residue name
                                    print *, 'Residue name in atom with SADI_*'
                                    print *, 'Not implemented'
                                    call abort()
                                end if
                                label=atom(1:indexresi-1)
                            else
                                label=atom
                            end if
                            serial1=0
                            do m=1, atomslist_index
                                if(trim(label)==trim(atomslist(m)%label) .and. resi1==atomslist(m)%resi) then
                                    serial1=m
                                    exit
                                end if
                            end do
                            serials(l)=serial1
                            if(atomslist(serial1)%crystals_serial==-1) then
                                print *, 'Error: Crystals serial not defined'
                                call abort()
                            end if
                        !end associate
                    end do
                                           
                    write(crystals_fileunit, '(a, a,"(",I0,")", " TO ", a,"(",I0,")", a)') &
                    &   'CONT ', &
                    &   trim(sfac(atomslist(serials(1))%sfac)), atomslist(serials(1))%crystals_serial, &
                    &   trim(sfac(atomslist(serials(2))%sfac)), atomslist(serials(2))%crystals_serial, &
                    &   linecont
                    write(*, '(a, a,"(",I0,")", " TO ", a,"(",I0,")", a)') &
                    &   'CONT ', &
                    &   trim(sfac(atomslist(serials(1))%sfac)), atomslist(serials(1))%crystals_serial, &
                    &   trim(sfac(atomslist(serials(2))%sfac)), atomslist(serials(2))%crystals_serial, &
                    &   linecont
                end do
            else
                do k=1, 2           
                    atom=sadi_table(i)%atom_pairs(k,j)
                    !associate( atom => sadi_table(i)%atom_pairs(k,j) )
                        indexresi=index(atom, '_')
                        if(indexresi>0) then
                            print *, 'Residues in atom with SADI_x'
                            print *, 'Not implemented'
                            call abort()
                        else
                            label=atom
                        end if
                        serial1=0
                        do l=1, atomslist_index
                            if(trim(label)==trim(atomslist(l)%label) .and. sadi_table(i)%residue==atomslist(l)%resi) then
                                serial1=l
                                exit
                            end if
                        end do
                        serials(k)=serial1
                        if(atomslist(serial1)%crystals_serial==-1) then
                            print *, 'Error: Crystals serial not defined'
                            call abort()
                        end if
                    !end associate
                end do
                                       
                write(crystals_fileunit, '(a, a,"(",I0,")", " TO ", a,"(",I0,")", a)') &
                &   'CONT ', &
                &   trim(sfac(atomslist(serials(1))%sfac)), atomslist(serials(1))%crystals_serial, &
                &   trim(sfac(atomslist(serials(2))%sfac)), atomslist(serials(2))%crystals_serial, &
                &   linecont
                write(*, '(a, a,"(",I0,")", " TO ", a,"(",I0,")", a)') &
                &   'CONT ', &
                &   trim(sfac(atomslist(serials(1))%sfac)), atomslist(serials(1))%crystals_serial, &
                &   trim(sfac(atomslist(serials(2))%sfac)), atomslist(serials(2))%crystals_serial, &
                &   linecont
            end if
        end do sadipairs
    end do sadiloop
end subroutine

end module
