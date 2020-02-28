!> This module holds the different subroutines for shel2cry \ingroup shelx2cry
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
    integer first, lens, i
    integer, save :: line_number = 1

    shelxline%line_number = line_number
    first = 0
    do
      read (shelxf_id, '(a)', iostat=iostatus) buffer
      if (iostatus /= 0) then
        shelxline%line = ''
        shelxline%line_number = -1
        return
      end if
      line_number = line_number+1
      first = first+1
      if (first == 1 .and. buffer(1:1) == ' ') then ! cycle except if continuation line
        first = 0
        cycle
      end if
      if (allocated(shelxline%line)) then
        ! appending new text
        lens = len_trim(shelxline%line)
        allocate (character(len=lens) :: linetemp)
        linetemp = shelxline%line
        deallocate (shelxline%line)
        allocate (character(len=len(linetemp)+len_trim(buffer)+1) :: shelxline%line)
        shelxline%line = linetemp
        deallocate (linetemp)
        shelxline%line = trim(shelxline%line)//' '//trim(buffer)
      else
        allocate (character(len=len_trim(buffer)) :: shelxline%line)
        shelxline%line = trim(buffer)
      end if

      if (shelxline%line(len_trim(shelxline%line):len_trim(shelxline%line)) /= '=') then
        ! end of line
        exit
      else
        ! Continuation line present, appending next line...
        ! removing continuation symbol
        shelxline%line(len_trim(shelxline%line)-1:len_trim(shelxline%line)) = ' '
      end if
    end do

    ! looking for a comment at end of the line. That does not seem very standard...
    i = index(shelxline%line, '!')
    if (i > 0) then
      shelxline%line = shelxline%line(1:i-1)
    end if

    ! some files use ',' as a separator instead of a space
    if (index(to_upper_fun(shelxline%line), 'SYMM') == 0 .and. &
    &   index(to_upper_fun(shelxline%line), 'EQIV') == 0) then
      do i = 1, len_trim(shelxline%line)
        if (shelxline%line(i:i) == ',') then
          shelxline%line(i:i) = ' '
        end if
      end do
    end if
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

    character(len=lenlabel) :: label
    integer atomtype, iostatus
    real, dimension(3) :: coordinates
    real occupancy
    real, dimension(6) :: aniso
    real iso
    type(dict_t) :: keywords2functions
    procedure(shelx_dummy), pointer :: proc

    found = .false.
    keywords2functions = dict_t()

    if (len_trim(shelxline%line) < 3) then
      return
    end if

    ! 4 letters keywords first
    if (len_trim(shelxline%line) > 3) then
      keyword = shelxline%line(1:4)
      call to_upper(keyword)
      call keywords2functions%getvalue(keyword, proc)
      if (associated(proc)) then
        call proc(shelxline)
        found = .true.
      end if
    end if

    ! 3 letters keywords
    keyword = shelxline%line(1:3)//' '
    call to_upper(keyword)
    call keywords2functions%getvalue(keyword, proc)
    if (associated(proc)) then
      call proc(shelxline)
      found = .true.
    end if

    if (found) return ! keyword found and processed

    ! there is something but it is not a keyword.
    ! Check for atoms:

    ! O1    4    0.560776    0.256941    0.101770    11.00000    0.07401    0.12846 0.04453   -0.00865    0.01598   -0.01300
    read (shelxline%line, *, iostat=iostatus) label, atomtype, coordinates, occupancy, aniso
    if (iostatus == 0) then
      call shelxl_atomaniso(label, atomtype, coordinates, occupancy, aniso, shelxline)
    end if

    ! try without aniso parameter
    if (iostatus /= 0) then
      !H1N   2    0.426149    0.251251    0.038448    11.00000   -1.20000
      read (shelxline%line, *, iostat=iostatus) label, atomtype, coordinates, occupancy, iso
      if (iostatus == 0) then
        call shelxl_atomiso(label, atomtype, coordinates, occupancy, iso, shelxline)
      end if
    end if

    ! try with just the coordinates
    if (iostatus /= 0) then
      !H1N   2    0.426149    0.251251    0.038448    11.00000   -1.20000
      read (shelxline%line, *, iostat=iostatus) label, atomtype, coordinates
      if (iostatus == 0) then
        call shelxl_atomiso(label, atomtype, coordinates, 100.0, 0.05, shelxline)
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

    print *, 'Reading of res file done'

    ! process serial numbers
    call get_shelx2crystals_serial

    write (*, *) 'Processing Unit cell'
    call write_list1()
    call write_list31()

!    if(spacegroup%latt<0) then
!        centric='YES'
!    else
!        centric='NO '
!    end if
!    lattice=latticeletters(abs(spacegroup%latt))

    !call write_spacegroup()

    write (*, *) 'Processing space group and symmetry'
    call write_list2()

    ! converting eqiv text to matrices (depends on list 2)
    call convert_eqiv()

    write (*, *) 'Processing experimental set up'
    call write_list13()

    write (*, *) 'Processing chemical composition'
    call write_composition()

    write (*, *) 'Processing scattering factors'
    call write_list3()
    call write_list29()

    write (*, *) 'Processing weighting scheme'
    call write_list4()

    write (*, *) 'Processing reflections filters'
    call write_list28()

    write (*, *) 'Processing atomic model'
    call write_list5()

    write (*, *) 'Processing constraints'
    call write_list12()

    write (*, *) 'Processing restraints'
    call write_list16()

    write (crystals_fileunit, '(a)') '\LIST 23'
    write (crystals_fileunit, '(a)') 'MODIFY ANOM=Y'
    write (crystals_fileunit, '(a)') 'MINIMI NSING=    0 F-SQ=Y RESTR=Y REFLEC=Y'
    write (crystals_fileunit, '(a)') 'END'

  end subroutine

!> Algorithm to translate shelx labels into crystals serial code.
  subroutine get_shelx2crystals_serial()
    use crystal_data_m
    implicit none
    integer i, j, k, start, maxresidue, maxresiduelen
    character(len=128) :: label, residueformat, residuetext, serialtext
    character(len=128) :: buffer, line
    logical found
    type crystals_resi_t
      integer :: crystals_resi
      type(resi_t) :: shelx_resi
    end type

    write (log_unit, '(a)') ''
    write (log_unit, '(a)') 'Processing shelxl labels into crystals serials'

    ! shelx allows the same label in different residues. It's messing up the numerotation for crystals
    ! in this case, we will suffix the serial in crystals with the residue index

    ! first generating an integer numeration of residues
    maxresidue = 0
    do i = 1, resi_list_index
      maxresidue = max(maxresidue, resi_list(i)%number)
    end do
    do i = 1, resi_list_index
      if (resi_list(i)%number > 0) then
        resi_list(i)%crystals_residue = resi_list(i)%number
      else
        maxresidue = maxresidue+1
        resi_list(i)%crystals_residue = maxresidue
      end if
    end do

    ! finding format to print residue
    maxresiduelen = 0
    if (maxresidue > 0) then
      write (buffer, '(I0)') maxresidue
      maxresiduelen = len_trim(buffer)
      write (residueformat, '("(I",I0,".",I0,")")') maxresiduelen, maxresiduelen
    end if
    residuetext = ''

    do i = atomslist_index, 1, -1
      ! fetch and format residue, it will be appended as a suffix
      if (atomslist(i)%resi%is_set()) then
        do j = 1, resi_list_index
          if (atomslist(i)%resi == resi_list(j)) then
            k = resi_list(j)%crystals_residue
            exit
          end if
        end do
        write (residuetext, trim(residueformat)) k
      end if

      label = atomslist(i)%label
      !print *, trim(label), atomslist(i)%resi
      ! fetch first number, anything before is ignored, atom type is get using sfac
      start = 0
      do j = 1, len_trim(label)
        if (iachar(label(j:j)) >= 48 .and. iachar(label(j:j)) <= 57) then ! [0-9]
          start = j
          exit
        end if
      end do

      serialtext = ''
      if (start /= 0) then
        ! fetch the serial number
        k = 0

        do j = start, len_trim(label)
          if (iachar(label(j:j)) >= 48 .and. iachar(label(j:j)) <= 57) then ! [0-9]
            k = k+1
            serialtext(k:k) = label(j:j)
          else
            ! no more number but a suffix not supported by crystals
            ! if it is a symbol ignore it and hope for something after
            if (iachar(label(j:j)) < 48 .or. iachar(label(j:j)) > 122) cycle
            if (iachar(label(j:j)) > 57 .and. iachar(label(j:j)) < 65) cycle
            if (iachar(label(j:j)) > 90 .and. iachar(label(j:j)) < 97) cycle
            ! if a letter, append its number in alphabet instead
            if (iachar(label(j:j)) >= 65 .and. iachar(label(j:j)) <= 90) then ! [A-Z]
              k = k+1
              !print *, trim(label), ' ', trim(serialtext), ' ', iachar(label(j:j))-64
              write (serialtext(k:), '(I0)') iachar(label(j:j))-64
              if (iachar(label(j:j))-64 > 10) k = k+1
            end if
          end if
        end do
        buffer = trim(serialtext)//residuetext
        read (buffer, *) atomslist(i)%crystals_serial
        !print *, trim(buffer), atomslist(i)%crystals_serial
      else
        ! default to 1 one serial is absent
        buffer = '1'//trim(residuetext)
        read (buffer, *) atomslist(i)%crystals_serial
      end if

      ! Most likely we have duplicates, lets fix that
      found = .true.
      k = 0
      do while (found)
        found = .false.
        do j = 1, atomslist_index
          if (i /= j .and. atomslist(i)%crystals_serial == atomslist(j)%crystals_serial) then
            if (atomslist(i)%sfac == atomslist(j)%sfac) then
              ! identical serial, prefixing current serial
              k = k+1
              write (buffer, '(I0,a,a)') k, trim(serialtext), trim(residuetext)
              read (buffer, *) atomslist(i)%crystals_serial
              found = .true.
              exit
            end if
          end if
        end do
      end do

    end do

    ! We can still have duplicates, lets check again
    found = .true.
    duplicates: do while (found)
      found = .false.
      do i = 1, atomslist_index
        do j = 1, atomslist_index
          if (i /= j .and. atomslist(i)%crystals_serial == atomslist(j)%crystals_serial) then
            if (atomslist(i)%sfac == atomslist(j)%sfac) then
              write (buffer, *) atomslist(i)%crystals_serial
              read (buffer(1:1), *) k
              k = k+1
              write (buffer, '(I0,a)') k, buffer(2:len_trim(buffer))
              read (buffer, *) atomslist(i)%crystals_serial
              found = .true.
              cycle duplicates
            end if
          end if
        end do
      end do
    end do duplicates

    write (log_unit, '(a)') 'Table of converted serial numbers'
    write (log_unit, '(4(" | ",a8,1X,a8))') 'Shelx', 'Crystals', 'Shelx', 'Crystals', 'Shelx', 'Crystals', 'Shelx', 'Crystals'
    line = ''
    do i = 1, atomslist_index
      write (buffer, '(a,"_",I0)') trim(atomslist(i)%label), atomslist(i)%resi%number
      write (buffer, '(a8,1X,I8)') trim(buffer), atomslist(i)%crystals_serial
      line = trim(line)//' | '//trim(buffer)
      if (mod(i, 4) == 0) then
        write (log_unit, '(a)') trim(line)
        line = ''
      end if
    end do
    write (log_unit, '(a)') trim(line)

    write (log_unit, '(a)') 'Done'

  end subroutine

!***********************************************************************************************************************************
!  M33INV  -  Compute the inverse of a 3x3 matrix.
!
!  A       = input 3x3 matrix to be inverted
!  AINV    = output 3x3 inverse of matrix A
!  OK_FLAG = (output) .TRUE. if the input matrix could be inverted, and .FALSE. if the input matrix is singular.
!***********************************************************************************************************************************
!> Compute the inverse of a 3x3 matrix.
  SUBROUTINE M33INV(A, AINV, OK_FLAG)

    IMPLICIT NONE

    real, DIMENSION(3, 3), INTENT(IN)  :: A
    real, DIMENSION(3, 3), INTENT(OUT) :: AINV
    LOGICAL, INTENT(OUT) :: OK_FLAG

    real, PARAMETER :: EPS = 1.0E-10
    real :: DET
    real, DIMENSION(3, 3) :: COFACTOR

    DET = A(1, 1)*A(2, 2)*A(3, 3)  &
    &    -A(1, 1)*A(2, 3)*A(3, 2)  &
    &    -A(1, 2)*A(2, 1)*A(3, 3)  &
    &    +A(1, 2)*A(2, 3)*A(3, 1)  &
    &    +A(1, 3)*A(2, 1)*A(3, 2)  &
    &    -A(1, 3)*A(2, 2)*A(3, 1)

    IF (ABS(DET) .LE. EPS) THEN
      AINV = 0.0D0
      OK_FLAG = .FALSE.
      RETURN
    END IF

    COFACTOR(1, 1) = +(A(2, 2)*A(3, 3)-A(2, 3)*A(3, 2))
    COFACTOR(1, 2) = -(A(2, 1)*A(3, 3)-A(2, 3)*A(3, 1))
    COFACTOR(1, 3) = +(A(2, 1)*A(3, 2)-A(2, 2)*A(3, 1))
    COFACTOR(2, 1) = -(A(1, 2)*A(3, 3)-A(1, 3)*A(3, 2))
    COFACTOR(2, 2) = +(A(1, 1)*A(3, 3)-A(1, 3)*A(3, 1))
    COFACTOR(2, 3) = -(A(1, 1)*A(3, 2)-A(1, 2)*A(3, 1))
    COFACTOR(3, 1) = +(A(1, 2)*A(2, 3)-A(1, 3)*A(2, 2))
    COFACTOR(3, 2) = -(A(1, 1)*A(2, 3)-A(1, 3)*A(2, 1))
    COFACTOR(3, 3) = +(A(1, 1)*A(2, 2)-A(1, 2)*A(2, 1))

    AINV = TRANSPOSE(COFACTOR)/DET

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
    DOUBLE PRECISION A(3, 3)
    DOUBLE PRECISION W(3)

!*     .. Parameters ..
    DOUBLE PRECISION SQRT3
    PARAMETER(SQRT3=1.73205080756887729352744634151D0)

!*     .. Local Variables ..
    DOUBLE PRECISION M, C1, C0
    DOUBLE PRECISION DE, DD, EE, FF
    DOUBLE PRECISION P, SQRTP, Q, C, S, PHI

!*     Determine coefficients of characteristic poynomial. We write
!*           | A   D   F  |
!*      A =  | D*  B   E  |
!*           | F*  E*  C  |
    DE = A(1, 2)*A(2, 3)
    DD = A(1, 2)**2
    EE = A(2, 3)**2
    FF = A(1, 3)**2
    M = A(1, 1)+A(2, 2)+A(3, 3)
    C1 = (A(1, 1)*A(2, 2)+A(1, 1)*A(3, 3)+A(2, 2)*A(3, 3))-(DD+EE+FF)
    C0 = A(3, 3)*DD+A(1, 1)*EE+A(2, 2)*FF-A(1, 1)*A(2, 2)*A(3, 3)-2.0D0*A(1, 3)*DE

    P = M**2-3.0D0*C1
    Q = M*(P-(3.0D0/2.0D0)*C1)-(27.0D0/2.0D0)*C0
    SQRTP = SQRT(ABS(P))

    PHI = 27.0D0*(0.25D0*C1**2*(P-C1)+C0*(Q+(27.0D0/4.0D0)*C0))
    PHI = (1.0D0/3.0D0)*ATAN2(SQRT(ABS(PHI)), Q)

    C = SQRTP*COS(PHI)
    S = (1.0D0/SQRT3)*SQRTP*SIN(PHI)

    W(2) = (1.0D0/3.0D0)*(M-C)
    W(3) = W(2)+S
    W(1) = W(2)+C
    W(2) = W(2)-S

  END SUBROUTINE
!* End of subroutine DSYEVC3

!> Write list16 (restraints)
  subroutine write_list16()
    use crystal_data_m
    implicit none
    integer i, j, k
    character :: linecont
    type(atom_shelx_t) :: first, next
    character(len=lenlabel), dimension(:), allocatable :: splitbuffer
    character(len=:), dimension(:), allocatable :: broadcast
    character(len=:), allocatable :: stripline, errormsg

    ! Restraints
    write (crystals_fileunit, '(a)') '\LIST 16'
    write (crystals_fileunit, '(a)') 'NO'
    write (crystals_fileunit, '(a)') 'REM   HREST   START (DO NOT REMOVE THIS LINE)'
    write (crystals_fileunit, '(a)') 'REM   HREST   END (DO NOT REMOVE THIS LINE) '

!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
!*   flat
!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
    call write_list16_flat()

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
    if (eadp_table_index > 0) then
      write (log_unit, '(a)') ''
      write (log_unit, '(a)') 'Processing EADPs...'
    end if

    eadploop: do i = 1, eadp_table_index
      write (log_unit, '(a)') trim(eadp_table(i)%shelxline)
      write (crystals_fileunit, '(a, a)') '# ', trim(eadp_table(i)%shelxline)

      call explicit_atoms(eadp_table(i)%shelxline, stripline, errormsg)
      if (allocated(errormsg)) then
        write (log_unit, *) trim(errormsg)
        write (log_unit, '("Line ", I0, ": ", a)') flat_table(i)%line_number, trim(flat_table(i)%shelxline)
        summary%error_no = summary%error_no+1
      end if
      call broadcast_shelx_cmd(stripline, broadcast)

      do j = 1, size(broadcast)
        call deduplicates(broadcast(j), stripline)
        call to_upper(stripline)
        call explode(stripline, lenlabel, splitbuffer)

        do k = 2, size(splitbuffer)-1
          first = atom_shelx_t(splitbuffer(k))
          next = atom_shelx_t(splitbuffer(k+1))

          if (k == size(splitbuffer)-1) then
            linecont = ''
          else
            linecont = ','
          end if
          if (k == 2) then
            write (crystals_fileunit, '(a, a, " TO ", a, a)') &
            &   'U(IJ) 0.0, 0.001 =  ', &
            &   first%crystals_label(), &
            &   next%crystals_label(), &
            &   linecont
            write (log_unit, '(a, a, " TO ", a, a)') &
            &   'U(IJ) 0.0, 0.001 =  ', &
            &   first%crystals_label(), &
            &   next%crystals_label(), &
            &   linecont
          else
            write (crystals_fileunit, '(a, a, " TO ", a, a)') &
            &   'CONT ', &
            &   first%crystals_label(), &
            &   next%crystals_label(), &
            &   linecont
            write (log_unit, '(a, a, " TO ", a, a)') &
            &   'CONT ', &
            &   first%crystals_label(), &
            &   next%crystals_label(), &
            &   linecont
          end if
        end do
      end do
    end do eadploop

!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
!*   RIGU
!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
    ! RIGU N2 C7 C8 C9 C10 C6 C5 C4 C3 C2 C1 N1 C12
    call write_list16_rigu()

!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
!*   ISOR
!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
    ! ISOR [0.1] [0.2] O24 O25 O29 O28 O27 O26
    call write_list16_isor()

!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
!*   SAME
!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
    call write_list16_same()

    write (crystals_fileunit, '(a)') 'END'
    write (crystals_fileunit, '(a)') '# Remove space after hash to activate next line'
    write (crystals_fileunit, '(a)') '# USE LAST'

  end subroutine

!> Reformat sginfo space group to crystals notation
  function reformat_spacegroup(spacegroup_arg) result(formatted_group)
    implicit none
    character(len=*), intent(in) :: spacegroup_arg
    character(len=1024) spacegroup
    character(len=:), allocatable :: formatted_group
    integer i, j
    character, dimension(12), parameter :: letters =&
    &   (/'a', 'b', 'c', 'd', 'n', 'm', 'A', 'B', 'C', 'D', 'N', 'M'/)

    spacegroup = trim(spacegroup_arg)

    ! (1) Second character must be a space
    if (spacegroup(2:2) /= ' ') then
      spacegroup(2:) = ' '//spacegroup(2:)
    end if

    ! (2) Any opening brackets must be removed.
    ! (3) Any closing brackets become spaces, unless followed by '/'
    i = index(spacegroup, '(')
    do while (i > 0)
      spacegroup = spacegroup(1:i-1)//spacegroup(i+1:)
      i = index(spacegroup, '(')
    end do
    i = index(spacegroup, ')')
    do while (i > 0)
      if (spacegroup(i+1:i+1) /= '/') then
        spacegroup(i:i) = ' '
      else
        spacegroup = spacegroup(1:i-1)//spacegroup(i+1:)
      end if
      i = index(spacegroup, ')')
    end do

    ! (4) There is always a space after a, b, c, d, n or m
    do i = 1, size(letters)
      j = 3
      do while (j <= len_trim(spacegroup))
        if (spacegroup(j:j) == letters(i) .and. &
        &   spacegroup(j+1:j+1) /= ' ') then
          spacegroup = spacegroup(1:j)//' '//spacegroup(j+1:)
          j = 3
          cycle
        end if
        j = j+1
      end do
    end do

    ! (5) There is always a space before 6
    j = 3
    do while (j <= len_trim(spacegroup))
      if (spacegroup(j:j) == '6' .and. &
      &   spacegroup(j-1:j-1) /= ' ') then
        spacegroup = spacegroup(1:j-1)//' '//spacegroup(j:)
        j = 3
        cycle
      end if
      j = j+1
    end do

    ! (6a) Adjacent numbers always have #1>#2.
    ! (6b) Always a space after a number, unless another number or /
    j = 3
    do while (j <= len_trim(spacegroup))
      if (iachar(spacegroup(j:j)) >= 48 .and. iachar(spacegroup(j:j)) <= 57) then
        ! We have a number
        if (iachar(spacegroup(j+1:j+1)) >= 48 .and. iachar(spacegroup(j+1:j+1)) <= 57) then
          ! followed by another number
          if (iachar(spacegroup(j:j)) <= iachar(spacegroup(j+1:j+1))) then
            spacegroup = spacegroup(1:j)//' '//spacegroup(j+1:)
            j = 3
            cycle
          end if
        else if (spacegroup(j+1:j+1) /= ' ' .and. spacegroup(j+1:j+1) /= '/') then
          spacegroup = spacegroup(1:j)//' '//spacegroup(j+1:)
          j = 3
          cycle
        end if
      end if
      j = j+1
    end do

    ! (7) There is always a space before -, and one digit after.
    j = 3
    do while (j <= len_trim(spacegroup))
      if (spacegroup(j:j) == '-') then
        if (spacegroup(j-1:j-1) /= ' ') then
          spacegroup = spacegroup(1:j)//' '//spacegroup(j+1:)
          j = 3
          cycle
        end if
      end if
      j = j+1
    end do
    j = 3
    do while (j <= len_trim(spacegroup))
      if (spacegroup(j:j) == '-') then
        if (spacegroup(j+2:j+2) /= ' ') then
          spacegroup = spacegroup(1:j+1)//' '//spacegroup(j+2:)
          j = 3
          cycle
        end if
      end if
      j = j+1
    end do

    allocate (character(len=len_trim(spacegroup)) :: formatted_group)
    formatted_group = trim(spacegroup)

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

    if (list1index > 0) then
      write (crystals_fileunit, '(a)') '\LIST 1'
      do i = 1, list1index
        write (crystals_fileunit, '(a)') trim(list1(i))
      end do
      write (crystals_fileunit, '(a)') 'END'
    end if

  end subroutine

!> write list 31 (esds on cell parameters) to file.
  subroutine write_list31()
    use crystal_data_m
    implicit none
    integer i

    if (trim(list31(1)) /= '') then
      do i = 1, size(list31)
        if (trim(list31(i)) == '') exit
        write (crystals_fileunit, '(a)') trim(list31(i))
      end do
    end if

  end subroutine

!> write list 4 (weighting scheme) to file.
  subroutine write_list4()
    use crystal_data_m
    implicit none

    if (any(list4 /= 0.0)) then
      write (crystals_fileunit, '(a)') '#LIST 4'
      write (crystals_fileunit, '(a)') 'SCHEME 16 NPARAM= 6 TYPE=CHOOSE'
      write (crystals_fileunit, '(a)') 'CONT WEIGHT=   2.0000000 MAX=  10000.0000 ROBUST=N'
      write (crystals_fileunit, '(a)') 'CONT DUNITZ=N TOLER=      6.0000 DS1=      1.0000'
      write (crystals_fileunit, '(a)') 'CONT DS2=      1.0000 REWT=      1.0000'
      write (crystals_fileunit, '(a,6F13.6)') 'PARAM', list4
    end if
  end subroutine

!> Write space group command
  subroutine write_spacegroup()
    use crystal_data_m
    implicit none

    spacegroup%symbol = reformat_spacegroup(trim(spacegroup%symbol))

    write (crystals_fileunit, '(a)') '\SPACEGROUP'
    write (crystals_fileunit, '(a,1X,a)') 'SYMBOL', trim(spacegroup%symbol)
    write (crystals_fileunit, '(a)') 'END'

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
    if (list13index > 0) then
      write (crystals_fileunit, '(a)') '\LIST 13'
      do i = 1, list13index
        write (crystals_fileunit, '(a)') trim(list13(i))
      end do
      write (crystals_fileunit, '(a)') 'END'
    end if

  end subroutine

!> write chemical composition
  subroutine write_composition()
    use crystal_data_m
    implicit none
    integer i

    ! composition
    if (trim(composition(1)) /= '') then
      do i = 1, 5
        write (crystals_fileunit, '(a)') trim(composition(i))
      end do
    end if

  end subroutine

!> Write list5 (atom parameters)
  subroutine write_list5()
    use crystal_data_m
    use sginfo_mod
    implicit none
    integer i, j, k, l
    real occ, d
    integer flag, atompart, fvar_index
    real, dimension(3) :: diffxyz
    type(T_LatticeTranslation), dimension(:), allocatable :: LatticeTranslations
    real, dimension(3) :: LatticeTranslation

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
    if (atomslist_index > 0) then
      write (crystals_fileunit, '(a)') '\LIST 5'
      write (crystals_fileunit, '("READ NATOM = ",I0,", NLAYER = ",I0,'// &
      &   '", NELEMENT = ",I0,", NBATCH = ",I0)') &
      &   atomslist_index, 0, 0, 0

      call LatticeTranslation_init(LatticeTranslations)
      do i = 1, atomslist_index ! loop over atoms
        atomslist(i)%multiplicity = 0
        ! calculate multiplicity
        do l = 1, LatticeTranslations(abs(spacegroup%latt))%nTrVector ! lopp over lattice translation
          LatticeTranslation = LatticeTranslations(abs(spacegroup%latt))%TrVector(:, l)/sginfo_stbf
          do j = 1, size(spacegroup%ListSeitzMx) ! loop over symmetry oprators
            diffxyz = abs(atomslist(i)%coordinates- &
            &   matmul(real(spacegroup%ListSeitzMx(j)%R), atomslist(i)%coordinates)- &
            &   real(spacegroup%ListSeitzMx(j)%T)/sginfo_stbf-LatticeTranslation)
            do k = 1, 3 ! keep difference in range 0,1
              do while (diffxyz(k) >= 1.0)
                diffxyz(k) = diffxyz(k)-1.0
              end do
            end do
            if (all(diffxyz < 1e-3)) then
              atomslist(i)%multiplicity = atomslist(i)%multiplicity+1
            end if
          end do ! end loop over symmetry operators
          if (spacegroup%centric == -1) then
            do j = 1, size(spacegroup%ListSeitzMx) ! loop over symmetry oprators
              diffxyz = abs(atomslist(i)%coordinates- &
              &   matmul(real(-1*spacegroup%ListSeitzMx(j)%R), atomslist(i)%coordinates)- &
              &   real(spacegroup%ListSeitzMx(j)%T)/sginfo_stbf-LatticeTranslation)
              do k = 1, 3 ! keep difference in range 0,1
                do while (diffxyz(k) >= 1.0)
                  diffxyz(k) = diffxyz(k)-1.0
                end do
              end do
              if (all(diffxyz < 1e-3)) then
                atomslist(i)%multiplicity = atomslist(i)%multiplicity+1
              end if
            end do ! end loop over symmetry operators
          end if
        end do ! end loop over lattice translation

        ! extracting occupancy from sof
        if (atomslist(i)%sof >= 100.0) then     ! No occupancy was found - set it to unity
          occ = 1.0
        else if (atomslist(i)%sof >= 10.0 .and. atomslist(i)%sof < 20.0) then
          ! fixed occupancy
          occ = atomslist(i)%sof-10.0
          !list12index=list12index+1
          !write(list12(list12index), '("FIX ",a,"(",I0,", occ)")') &
          !&   trim(sfac(atomslist(i)%sfac)), shelx2crystals_serial(i)%crystals_serial
        else if (abs(atomslist(i)%sof) >= 20.0) then
          ! occupancy depends on a free variable
          fvar_index = int(abs(atomslist(i)%sof)/10.0)
          if (fvar_index > size(fvar) .or. fvar_index <= 0) then
            write (*, '(2a)') 'Error: Free variable missing for sof=', atomslist(i)%sof
            write (*, '("Line ", I0, ": ", a)') atomslist(i)%line_number, trim(atomslist(i)%shelxline)
            write (log_unit, '(2a)') 'Error: Free variable missing for sof=', atomslist(i)%sof
            write (log_unit, '("Line ", I0, ": ", a)') atomslist(i)%line_number, trim(atomslist(i)%shelxline)
            summary%error_no = summary%error_no+1
            occ = 1.0
          else
            occ = abs(atomslist(i)%sof)-fvar_index*10.0
            if (atomslist(i)%sof > 0) then
              occ = occ*fvar(fvar_index)
            else
              occ = occ*(1.0-fvar(fvar_index))
            end if
            ! restraints done automatically using parts later. See below
          end if
        else if (atomslist(i)%sof < 0.0) then
          write (log_unit, '(a)') "don't know what to do with a sof between -20.0 < sof < 0.0"
          stop
        else
          occ = atomslist(i)%sof
        end if
        if (atomslist(i)%sof < 100.0) then 
          occ = occ*real(atomslist(i)%multiplicity)
        end if

        ! a check for consistency of sof
        ! 11.000, 21.000, 31.000 then site symmetry multiplicity should be 1
        ! it is just a warning, that would only refine well if multiplicity is taking into account in a free variable
        ! so in the end the chemical occupancy is fine
        d = real(nint((atomslist(i)%sof-1.0)/10.0), kind(d))
        if (atomslist(i)%multiplicity > 1 .and. abs(abs(atomslist(i)%sof-d*10.0)-1.0) < 0.01e-3) then
          write (log_unit, '("Line ", I0, ": ", a)') atomslist(i)%line_number, trim(atomslist(i)%shelxline)
          write (log_unit, '(a)') 'Warning: double check s.o.f'
          write (log_unit, '(a, I0)') '         Atom sit on special position with multiplicty ', atomslist(i)%multiplicity
          write (log_unit, '(a, I0)') '         but s.o.f is 1.0'
        end if

        if (atomslist(i)%iso /= 0.0) then
          flag = 1
        else
          flag = 0
        end if
        if (atomslist(i)%crystals_serial == -1) then
          write (*, '(a)') 'Error: crystals serial not defined'
          call abort()
        end if

        write (crystals_fileunit, '(a,1X,a)') '# ', trim(atomslist(i)%shelxline)
        write (crystals_fileunit, '("ATOM TYPE=", a, ", SERIAL=",I0, ", OCC=",F0.5, ", FLAG=", I0)')  &
        &   trim(sfac(atomslist(i)%sfac)), atomslist(i)%crystals_serial, occ, flag
        if (any(atomslist(i)%aniso /= 0.0)) then
          write (crystals_fileunit, '("CONT X=",F0.5, ", Y=",F0.5, ", Z=", F0.5)') &
          &   atomslist(i)%coordinates
          write (crystals_fileunit, '("CONT U[11]=", F0.5,", U[22]=", F0.5,", U[33]=", F0.5)') &
          &   atomslist(i)%aniso(1:3)
          write (crystals_fileunit, '("CONT U[23]=", F0.5,", U[13]=", F0.5,", U[12]=", F0.5)') &
          &   atomslist(i)%aniso(4:6)
        else
          write (crystals_fileunit, '("CONT U[11]=",F0.5, ", X=",F0.5, ", Y=",F0.5, ", Z=", F0.5)') &
          &   abs(atomslist(i)%iso), atomslist(i)%coordinates
        end if
        if (atomslist(i)%resi%number > 0) then
          write (crystals_fileunit, '("CONT RESIDUE=",I0)') atomslist(i)%resi%number
        end if
        ! We are not using shelx part instruction, part is constructed from the free variable
        ! In shelx part is only used for connectivity
        !if(atomslist(i)%part>0) then
        !    write(crystals_fileunit, '("CONT PART=",I0)') atomslist(i)%part+1000
        !end if
        ! if using free variable, setting parts:
        if (abs(atomslist(i)%sof) >= 20.0) then
          if (atomslist(i)%sof > 0.0) then
            flag = 1
          else
            flag = 2
          end if
          atompart = (int(abs(atomslist(i)%sof)/10.0)-1)*1000+flag
          write (crystals_fileunit, '("CONT PART=",I0)') atompart
        end if
      end do ! end loop over atoms coordinates
      write (crystals_fileunit, '(a)') 'END'
    end if

  end subroutine

!> Write list12 (constraints)
  subroutine write_list12()
    use crystal_data_m
    implicit none
    integer i

    if (list12index > 0) then
      write (crystals_fileunit, '(a)') '\LIST 12'
      do i = 1, list12index
        write (crystals_fileunit, '(a)') list12(i)
      end do
      write (crystals_fileunit, '(a)') 'END'
    end if

  end subroutine

  subroutine convert_eqiv()
    use iso_c_binding
    use sginfo_mod
    use crystal_data_m
    implicit none
    integer ierror, i, j, k, l
    type(T_sginfo) :: sginfo
    type(T_RTMx) :: NewSMx
    character(kind=C_char), dimension(:), allocatable :: xyz
    real, dimension(3) :: t, LatticeTranslation
    type(T_LatticeTranslation), dimension(:), allocatable :: LatticeTranslations

    call InitSgInfo(SgInfo)
    ierror = MemoryInit(SgInfo)
    if (ierror /= 0) then
      write (*, '(a)') 'Error Cannot allocate memory'
      call abort()
    end if

    call LatticeTranslation_init(LatticeTranslations)

    ! Adding symmetry operators
    do i = 1, eqiv_list_index
      allocate (xyz(len_trim(eqiv_list(i)%text)+1))
      do j = 1, size(xyz)-1
        xyz(j) = eqiv_list(i)%text(j:j)
      end do
      xyz(size(xyz)) = C_NULL_CHAR
      ierror = ParseSymXYZnornd(xyz, NewSMx, nint(sginfo_stbf))
      deallocate (xyz)
      if (ierror /= 0) then
        write (*, '(a, a)') 'Error: Cannot recognize symmetry operator ', eqiv_list(i)%text
        eqiv_list(i)%rotation = -1
        eqiv_list(i)%translation = -1
      end if
      eqiv_list(i)%rotation = transpose(reshape(NewSMx%R, (/3, 3/))) ! Fortran is column major, hence transpose
      eqiv_list(i)%translation = NewSMx%T/sginfo_stbf

      do l = 1, LatticeTranslations(abs(spacegroup%latt))%nTrVector ! lopp over lattice translation
        LatticeTranslation = LatticeTranslations(abs(spacegroup%latt))%TrVector(:, l)/sginfo_stbf
        do j = 1, size(spacegroup%ListSeitzMx) ! loop over symmetry oprators
          if (all(abs(eqiv_list(i)%rotation-real(spacegroup%ListSeitzMx(j)%R)) < 0.01)) then
            t = abs(eqiv_list(i)%translation-real(spacegroup%ListSeitzMx(j)%T)/sginfo_stbf-LatticeTranslation)
            do k = 1, 3
              do while (t(k) >= 1.0)
                t(k) = t(k)-1.0
              end do
              do while (t(k) < 0.0)
                t(k) = t(k)+1.0
              end do
            end do

            if (all(t < 0.01)) then
              eqiv_list(i)%S = j
              eqiv_list(i)%L = l
              eqiv_list(i)%crystals_translation = eqiv_list(i)%translation- &
              &  real(spacegroup%ListSeitzMx(j)%T)/sginfo_stbf+LatticeTranslation
            end if

          else if (all(abs(eqiv_list(i)%rotation+real(spacegroup%ListSeitzMx(j)%R)) < 0.01)) then
            t = abs(eqiv_list(i)%translation-real(spacegroup%ListSeitzMx(j)%T)/sginfo_stbf-LatticeTranslation)
            do k = 1, 3
              do while (t(k) > 1.0)
                t(k) = t(k)-1.0
              end do
              do while (t(k) < 0.0)
                t(k) = t(k)+1.0
              end do
            end do

            if (all(t < 0.01)) then
              eqiv_list(i)%S = -j
              eqiv_list(i)%L = l
              eqiv_list(i)%crystals_translation = eqiv_list(i)%translation- &
              &  real(spacegroup%ListSeitzMx(j)%T)/sginfo_stbf+LatticeTranslation
            end if

          end if
        end do
      end do
    end do

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
    error = MemoryInit(SgInfo)
    if (error /= 0) then
      write (*, '(a)') 'Error Cannot allocate memory'
      call abort()
    end if

    ! Adding symmetry operators
    do i = 1, spacegroup%symmindex
      buffer = adjustl(spacegroup%symm(i))
      allocate (xyz(len_trim(buffer)+1))
      do j = 1, size(xyz)-1
        xyz(j) = buffer(j:j)
      end do
      xyz(size(xyz)) = C_NULL_CHAR
      error = ParseSymXYZ(xyz, NewSMx, nint(sginfo_stbf))
      deallocate (xyz)
      if (error /= 0) then
        write (*, '(2a)') 'Error: Cannot recognize symmetry operator ', trim(buffer)
        call abort()
      end if

      error = Add2ListSeitzMx(SgInfo, NewSMx)
      if (error /= 0) then
        write (*, '(a)') 'Error in Add2ListSeitzMx'
        call abort()
      end if
    end do

    call LatticeTranslation_init(LatticeTranslation)
    ! Adding lattice symmetry
    if (spacegroup%latt /= 0) then
      i = LatticeTranslation(abs(spacegroup%latt))%nTrVector
      NewSMx%R = 0
      NewSMx%R(1) = 1
      NewSMx%R(5) = 1
      NewSMx%R(9) = 1
      !print *, 'latt ', spacegroup%latt, i
      do j = 1, i
        NewSMx%T = LatticeTranslation(abs(spacegroup%latt))%TrVector(:, j)
        error = Add2ListSeitzMx(SgInfo, NewSMx)
      end do
    end if

    ! adding inversion centre
    if (spacegroup%latt > 0) then
      error = AddInversion2ListSeitzMx(SgInfo)
      if (error /= 0) then
        write (*, '(a)') 'Error in AddInversion2ListSeitzMx'
        call abort()
      end if
    end if

    ! All done!
    error = CompleteSgInfo(SgInfo)
    if (error /= 0) then
      write (*, '(a)') 'Error in CompleteSgInfo'
      call abort()
    end if

    !print *, 'Hall Symbol ', SgInfo%HallSymbol
    !call C_F_POINTER(SgInfo%LatticeInfo, LatticeInfo)

    !print *, 'Lattice code ', LatticeInfo%Code

    !print *, 'Crystal system ', XS_name(SgInfo%XtalSystem)

    if (c_associated(SgInfo%LatticeInfo)) then
      call C_F_POINTER(SgInfo%LatticeInfo, LatticeInfo)
    else
      write (*, '(a)') 'Error: LatticeInfo not associated'
      call abort()
    end if

    write (crystals_fileunit, '(a)') '\LIST 2'
    write (crystals_fileunit, '(a, I0, a, a)') 'CELL NSYM=', SgInfo%nlist, ', LATTICE=', LatticeInfo%Code
    spacegroup%centric = SgInfo%Centric
    if (SgInfo%Centric == 0) then
      write (crystals_fileunit, '(a)') 'CONT CENTRIC=NO'
    else
      write (crystals_fileunit, '(a)') 'CONT CENTRIC=YES'
    end if

    if (C_associated(SgInfo%ListSeitzMx)) then
      call C_F_POINTER(SgInfo%ListSeitzMx, lsmx, (/SgInfo%nlist/))
      allocate (spacegroup%ListSeitzMx(SgInfo%nlist))
      do i = 1, SgInfo%nlist
        spacegroup%ListSeitzMx(i)%R = transpose(reshape(lsmx(i)%R, (/3, 3/)))
        spacegroup%ListSeitzMx(i)%T = lsmx(i)%T
        xyzptr = RTMx2XYZ(lsmx(i), 1, nint(sginfo_stbf), 0, 1, 0, ", ")
        call C_F_string_ptr(xyzptr, buffer)
        write (crystals_fileunit, '(a, a)') 'SYMM ', trim(buffer)
      end do
    else
      write (*, '(a)') 'Error: No summetry operators in SgInfo%ListSeitzMx'
      call abort()
    end if

    if (C_associated(SgInfo%TabSgName)) then
      call C_F_POINTER(SgInfo%TabSgName, TabSgName)
      call C_F_string_ptr(TabSgName%SgLabels, buffer)
      if (trim(buffer) /= '') then
        i = index(buffer, '=')
        if (i > 0) then
          spacegroupsymbol = buffer(i+1:)
          i = index(spacegroupsymbol, '=')
          if (i > 0) then
            spacegroupsymbol = spacegroupsymbol(:i-1)
          end if
        else
          spacegroupsymbol = buffer
        end if

        ! replace `_` with ` `
        do i = 1, len_trim(spacegroupsymbol)
          if (spacegroupsymbol(i:i) == '_') then
            spacegroupsymbol(i:i) = ' '
          end if
        end do
        write (crystals_fileunit, '(a, a)') 'SPACEGROUP ', trim(spacegroupsymbol)
      end if
    else
      write (log_unit, '(a)') 'Warning: Uknown space group!!'
      write (log_unit, '(2a)') 'Hall Symbol ', SgInfo%HallSymbol
      write (log_unit, '(a)') 'Resulting input file won''t work'
    end if
    write (crystals_fileunit, '(a, a)') 'CLASS ', trim(XS_name(SgInfo%XtalSystem))
    write (crystals_fileunit, '(a)') 'END'

    write (crystals_fileunit, '(a,i4)') '# SGinfo PG code#: ', SgInfo%PointGroup/396
    i = LG_Code_from_PG_Index(SgInfo%PointGroup/396)
    write (crystals_fileunit, '(a,i4)') '# CRYSTALS LG code#: ', i
    write (crystals_fileunit, '(a,i2)') '\FLIMIT ', i
    write (crystals_fileunit, '(a)') 'END'

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

    if (any(sfac_long /= 0.0)) then

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

      write (crystals_fileunit, '(a)') '\LIST 3 '
      write (crystals_fileunit, '(a, 1X, I0)') 'READ', sfac_index

      do i = 1, sfac_index
        !print *, i, trim(sfac(i))
        write (crystals_fileunit, '(a, a, 2F12.6)') 'SCATT ', trim(sfac(i)), sfac_long(10, i), sfac_long(11, i)
        write (crystals_fileunit, '(a, 4F12.6)') 'CONT ', sfac_long(1:4, i)
        write (crystals_fileunit, '(a, 4F12.6)') 'CONT ', sfac_long(5:8, i)
        write (crystals_fileunit, '(a, F12.6)') 'CONT ', sfac_long(9, i)
      end do
      write (crystals_fileunit, '(a)') 'END'

    end if

    if (allocated(disp_table)) then

      !\generaledit 3
      !LOCATE RECORDTYPE=101
      !top
      !next
      !next
      !TRANSFER TO OFFSET=1 FROM 1.01
      !TRANSFER TO OFFSET=2 FROM 2.03
      !write
      !end

      write (crystals_fileunit, '(a)') '\GENERALEDIT 3 '
      write (crystals_fileunit, '(a)') 'LOCATE RECORDTYPE=101'
      write (crystals_fileunit, '(a)') 'TOP'

      do i = 1, size(sfac)
        if (sfac(i) == '') exit
        if (i /= 1) write (crystals_fileunit, '(a)') 'NEXT'

        do j = 1, size(disp_table)
          if (sfac(i) == disp_table(j)%atom) then
            write (crystals_fileunit, '(a,a)') '# ', trim(disp_table(j)%shelxline)
            if (disp_table(j)%values(1) /= 0.0) then
              write (crystals_fileunit, '(a, f15.5)') 'TRANSFER TO OFFSET=1 FROM ', disp_table(j)%values(1)
            end if
            if (disp_table(j)%values(2) /= 0.0) then
              write (crystals_fileunit, '(a, f15.5)') 'TRANSFER TO OFFSET=2 FROM ', disp_table(j)%values(2)
            end if
            exit
          end if
        end do
      end do

      write (crystals_fileunit, '(a)') 'WRITE'
      write (crystals_fileunit, '(a)') 'END'
    end if

  end subroutine

!> write list29 (atomic scattering factors)
  subroutine write_list29()
    use crystal_data_m
    implicit none
    integer i

    if (all(sfac_long == 0.0)) then
      return
    end if

    write (crystals_fileunit, '(a)') '\LIST 29 '
    write (crystals_fileunit, '(a, 1X, I0)') 'READ', sfac_index

    do i = 1, sfac_index
      ! warning units in shelx file is for the unit cell, crystals wants in the asymetric unit (to be fixed)
      write (crystals_fileunit, '(a, a, 1X, a, F0.3)') 'ELEMENT ', trim(sfac(i)), 'NUM=', sfac_units(i)
      if (sfac_long(12, i) /= 0.0) then
        write (crystals_fileunit, '(a, F12.6)') 'CONT MUA=', sfac_long(12, i)
      end if
      if (sfac_long(13, i) /= 0.0) then
        write (crystals_fileunit, '(a, F12.6)') 'CONT COVALENT=', sfac_long(13, i)
      end if
      if (sfac_long(14, i) /= 0.0) then
        write (crystals_fileunit, '(a, F12.6)') 'CONT WEIGHT=', sfac_long(14, i)
      end if
    end do
    write (crystals_fileunit, '(a)') 'END'

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
    type(line_t), intent(in) :: shelxline !< Current line of the res file
    integer i

    if (.not. allocated(atomslist)) then
      allocate (atomslist(1024))
    end if

    atomslist_index = atomslist_index+1
    atomslist(atomslist_index)%label = label
    call to_upper(atomslist(atomslist_index)%label)
    atomslist(atomslist_index)%sfac = atomtype
    atomslist(atomslist_index)%coordinates = coordinates
    do i = 1, 3
      if (atomslist(atomslist_index)%coordinates(i) > 9.0) then
        atomslist(atomslist_index)%coordinates(i) = atomslist(atomslist_index)%coordinates(i)-10.0
      end if
    end do
    atomslist(atomslist_index)%aniso = aniso
    if (part > 0 .and. part_sof /= -1.0) then
      ! We are working on a res file, this values should be the same as the one reported on each atom
      if (abs(sof-part_sof) > 0.01) then
        write (*, '(a)') 'Error: res file not consistent'
        write (*, '(a)') '       sof from part should be the same of the atom one'
        write (*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        write (log_unit, '(a)') 'Error: res file not consistent'
        write (log_unit, '(a)') '       sof from part should be the same of the atom one'
        write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no = summary%error_no+1
      end if
    end if
    atomslist(atomslist_index)%sof = sof
    if (current_resi_index > 0) then
      atomslist(atomslist_index)%resi = resi_list(current_resi_index)
    else
      call atomslist(atomslist_index)%resi%init()
    end if
    atomslist(atomslist_index)%part = part
    atomslist(atomslist_index)%shelxline = shelxline%line
    atomslist(atomslist_index)%line_number = shelxline%line_number

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
    type(line_t), intent(in) :: shelxline !< Current line of the res file
    integer i, j, k
    real, dimension(3, 3) :: orthogonalisation, uij, metric, rmetric
    double precision, dimension(3, 3) :: temp
    double precision, dimension(3) :: eigv
    real, dimension(6) :: unitcellradian
    real rgamma
    logical ok_flag
    type(atom_t), dimension(:), allocatable :: templist

    unitcellradian(1:3) = unitcell(1:3)
    unitcellradian(4:6) = unitcell(4:6)*2.0*3.14159/360.0

    rgamma = acos((cos(unitcellradian(4))*cos(unitcellradian(5))-cos(unitcellradian(6)))/&
    &   (sin(unitcellradian(4))*sin(unitcellradian(5))))
    orthogonalisation = 0.0
    orthogonalisation(1, 1) = unitcellradian(1)*sin(unitcellradian(5))*sin(rgamma)
    orthogonalisation(2, 1) = -unitcellradian(1)*sin(unitcellradian(5))*cos(rgamma)
    orthogonalisation(2, 2) = unitcellradian(2)*sin(unitcellradian(4))
    orthogonalisation(3, 1) = unitcellradian(1)*cos(unitcellradian(5))
    orthogonalisation(3, 2) = unitcellradian(2)*cos(unitcellradian(4))
    orthogonalisation(3, 3) = unitcellradian(3)
    metric = matmul(transpose(orthogonalisation), orthogonalisation)
    call m33inv(metric, rmetric, ok_flag)

    if (.not. allocated(atomslist)) then
      allocate (atomslist(1024))
    end if

    atomslist_index = atomslist_index+1
    if (atomslist_index > size(atomslist)) then
      call move_alloc(atomslist, templist)
      allocate (atomslist(size(templist)+1024))
      atomslist(1:size(templist)) = templist
      deallocate (templist)
    end if

    atomslist(atomslist_index)%label = label
    call to_upper(atomslist(atomslist_index)%label)
    atomslist(atomslist_index)%sfac = atomtype
    atomslist(atomslist_index)%coordinates = coordinates
    do i = 1, 3
      if (atomslist(atomslist_index)%coordinates(i) > 9.0) then
        atomslist(atomslist_index)%coordinates(i) = atomslist(atomslist_index)%coordinates(i)-10.0
      end if
    end do
    if (iso < 0.0) then
      ! If an isotropic U is given as -T, where T is in the range
      ! 0.5 < T < 5, it is fixed at T times the Ueq of the previous
      ! atom not constrained in this way
      write (log_unit, '(a)') 'Warning: isotropic thermal parameter depends on previous atom'
      write (log_unit, '(a)') '         Thermal parameter will be fixed at current value'
      write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
      do i = atomslist_index-1, 1, -1
        if (atomslist(i)%iso > 0.0) then
          atomslist(atomslist_index)%iso = atomslist(i)%iso*iso
          exit
        else if (any(atomslist(i)%aniso /= 0.0)) then
          ! anisotropic displacements, need to calculate Ueq first
          uij(1, 1) = atomslist(i)%aniso(1)
          uij(2, 2) = atomslist(i)%aniso(2)
          uij(3, 3) = atomslist(i)%aniso(3)
          uij(2, 3) = atomslist(i)%aniso(4)
          uij(3, 2) = atomslist(i)%aniso(4)
          uij(1, 3) = atomslist(i)%aniso(5)
          uij(3, 1) = atomslist(i)%aniso(5)
          uij(1, 2) = atomslist(i)%aniso(6)
          uij(2, 1) = atomslist(i)%aniso(6)
          do j = 1, 3
            do k = 1, 3
              uij(k, j) = uij(k, j)*sqrt(rmetric(j, j)*rmetric(k, k))
            end do
          end do
          temp = matmul(orthogonalisation, matmul(uij, transpose(orthogonalisation)))
          call DSYEVC3(temp, eigv)
          atomslist(atomslist_index)%iso = 1.0/3.0*sum(eigv)*iso
          exit
        end if
      end do
    else
      if (iso >= 20) then
        ! proportional to fvar
        j = 2
        do while (j*10 <= iso)
          j = j+1
        end do
        atomslist(atomslist_index)%iso = (iso-(j-1)*10)*fvar(j-1)
      else if (iso >= 10) then
        atomslist(atomslist_index)%iso = iso-10.0
      else
        atomslist(atomslist_index)%iso = iso
      end if
    end if
    if (part > 0 .and. part_sof /= -1.0) then
      ! We are working on a res file, this values should be the same as the one reported on each atom
      if (abs(sof-part_sof) > 0.01) then
        write (*, '(a)') 'Error: res file not consistent'
        write (*, '(a)') '       sof from part should be the same of the atom one'
        write (*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        write (log_unit, '(a)') 'Error: res file not consistent'
        write (log_unit, '(a)') '       sof from part should be the same of the atom one'
        write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no = summary%error_no+1
      end if
    end if
    atomslist(atomslist_index)%sof = sof
    if (current_resi_index > 0) then
      atomslist(atomslist_index)%resi = resi_list(current_resi_index)
    else
      call atomslist(atomslist_index)%resi%init()
    end if
    atomslist(atomslist_index)%part = part
    atomslist(atomslist_index)%shelxline = shelxline%line
    atomslist(atomslist_index)%line_number = shelxline%line_number

  end subroutine

!> Write flat restraints to list16 section
  subroutine write_list16_flat()
    use crystal_data_m
    implicit none
    character(len=128), dimension(:), allocatable :: serials
    type(atom_shelx_t) :: atom_shelx
    character(len=1024) :: buffertemp
    integer i, j, k, l
    character(len=:), allocatable :: stripline, errormsg
    real esd
    character(len=lenlabel), dimension(:), allocatable :: splitbuffer
    integer start, iostatus
    character(len=:), dimension(:), allocatable :: broadcast

    ! PLANAR 0.01 N(1) C(3)
    if (flat_table_index > 0) then
      write (log_unit, '(a)') ''
      write (log_unit, '(a)') 'Processing FLATs...'
    end if
    ! DISTANCE 1.000000 , 0.050000 = N(1) TO C(3)

    flat_loop: do i = 1, flat_table_index

      if (len_trim(flat_table(i)%shelxline) < 5) then
        write (*, *) 'Error: Empty FLAT'
        write (*, '("Line ", I0, ": ", a)') flat_table(i)%line_number, trim(flat_table(i)%shelxline)
        write (log_unit, *) 'Error: Empty FLAT'
        write (log_unit, '("Line ", I0, ": ", a)') flat_table(i)%line_number, trim(flat_table(i)%shelxline)
        summary%error_no = summary%error_no+1
        return
      end if

      call explicit_atoms(flat_table(i)%shelxline, stripline, errormsg)
      if (allocated(errormsg)) then
        write (log_unit, *) trim(errormsg)
        write (log_unit, '("Line ", I0, ": ", a)') flat_table(i)%line_number, trim(flat_table(i)%shelxline)
        summary%error_no = summary%error_no+1
      end if

      call broadcast_shelx_cmd(trim(stripline), broadcast)

      do j = 1, size(broadcast)
        call deduplicates(broadcast(j), stripline)
        call to_upper(stripline)
        call explode(stripline, lenlabel, splitbuffer)

        ! second element is the esd of atoms (optional)
        read (splitbuffer(2), *, iostat=iostatus) esd
        if (iostatus /= 0) then
          esd = 0.1
          start = 2
        else
          start = 3
          if (size(splitbuffer)-start < 3) then
            write (log_unit, *) "Error: Can't fit a plane with less than 4 atoms"
            write (log_unit, '("Line ", I0, ": ", a)') flat_table(i)%line_number, flat_table(i)%shelxline
            write (*, *) "Error: Can't fit a plane with less than 4 atoms"
            write (*, '("Line ", I0, ": ", a)') flat_table(i)%line_number, flat_table(i)%shelxline
            summary%error_no = summary%error_no+1
            return
          end if
        end if

        flat_table(i)%esd = esd

        write (log_unit, '(a)') trim(flat_table(i)%shelxline)
        write (crystals_fileunit, '(a, a)') '# ', trim(flat_table(i)%shelxline)

        if (allocated(serials)) deallocate (serials)
        allocate (serials(size(splitbuffer)))
        serials = ''
        do k = start, size(splitbuffer)
          atom_shelx = atom_shelx_t(splitbuffer(k))
          write (serials(k), '(a)') atom_shelx%crystals_label()

          if (atom_shelx%previous) then
            ! previous residue
            write (log_unit, '(a)') 'Warning: Residue - in atom with FLAT without _*'
            write (log_unit, '(a)') '         Not implemented'
            cycle flat_loop
          else if (atom_shelx%after) then
            ! next residue
            write (log_unit, '(a)') 'Warning: Residue + in atom with FLAT without _*'
            write (log_unit, '(a)') '         Not implemented'
            cycle flat_loop
          else if (atom_shelx%resi%alias /= '') then
            ! residue name
            write (log_unit, '(a)') 'Warning: Residue name in atom with FLAT_*'
            write (log_unit, '(a)') '         Not implemented, restraint has been ignored'
            cycle flat_loop
          end if

          if (serials(k) == '') then
            write (*, '(a)') trim(flat_table(i)%shelxline)
            write (*, '(a)') trim(broadcast(j))
            write (*, '(a)') splitbuffer(k)
            write (*, '(a)') 'Error: check your res file. I cannot find the atom'
            call abort()
          end if
        end do

        ! good to go
        write (buffertemp, '(a, F7.5, 1X)') 'PLANAR ', flat_table(i)%esd
        do l = start, size(serials)
          buffertemp = trim(buffertemp)//' '//serials(l)
          if (len_trim(buffertemp) > 72) then
            write (crystals_fileunit, '(a)') trim(buffertemp)
            write (log_unit, '(a)') trim(buffertemp)
            buffertemp = 'CONT'
          end if
        end do
        write (crystals_fileunit, '(a)') trim(buffertemp)
        write (log_unit, '(a)') trim(buffertemp)

      end do

    end do flat_loop
  end subroutine

!> Write dfix restraints to list16 section
  subroutine write_list16_dfix()
    use crystal_data_m
    implicit none
    integer i, j, k
    integer :: start
    type(atom_shelx_t) :: atom1, atom2
    character(len=:), allocatable :: errormsg
    character(len=lenlabel), dimension(:), allocatable :: splitbuffer
    character(len=:), dimension(:), allocatable :: broadcast
    character(len=:), allocatable :: stripline

    if (dfix_table_index > 0) then
      write (log_unit, '(a)') ''
      write (log_unit, '(a)') 'Processing DFIXs/DANGs...'
    end if

    ! DISTANCE 1.000000 , 0.050000 = N(1) TO C(3)
    dfix_loop: do i = 1, dfix_table_index
      write (log_unit, '(a)') trim(dfix_table(i)%shelxline)

      if (dfix_table(i)%distance < 0.0) then
        write (log_unit, '(a)') 'Warning: Anti bumping in DFIX not supported '
        write (log_unit, '("Line ", I0, ": ", a)') dfix_table(i)%line_number, trim(dfix_table(i)%shelxline)
        cycle
      end if

      write (crystals_fileunit, '(a, a)') '# ', trim(dfix_table(i)%shelxline)

      call explicit_atoms(dfix_table(i)%shelxline, stripline, errormsg)
      if (allocated(errormsg)) then
        write (log_unit, *) trim(errormsg)
        write (log_unit, '("Line ", I0, ": ", a)') dfix_table(i)%line_number, trim(dfix_table(i)%shelxline)
        summary%error_no = summary%error_no+1
      end if

      call broadcast_shelx_cmd(trim(stripline), broadcast)

      do j = 1, size(broadcast)
        call deduplicates(broadcast(j), stripline)
        call to_upper(stripline)
        call explode(stripline, lenlabel, splitbuffer)

        start = 2
        do while (ichar(splitbuffer(start) (1:1)) < 65 .or. ichar(splitbuffer(start) (1:1)) > 90)
          start = start+1
        end do

        do k = start, size(splitbuffer), 2
          atom1 = atom_shelx_t(splitbuffer(k))
          atom2 = atom_shelx_t(splitbuffer(k+1))

          if (atom1%crystals_label() == '' .or. atom2%crystals_label() == '') then
            write (*, '(2a)') dfix_table(i)%atom1, dfix_table(i)%atom2
            write (*, '(a)') 'Error: check your res file. I cannot find the atom'
            call abort()
          end if

          write (crystals_fileunit, '(a, 1X, F0.5, ",", F0.5, " = ", a," TO ", a)') &
          &   'DISTANCE', dfix_table(i)%distance, dfix_table(i)%esd, &
          &   atom1%crystals_label(), &
          &   atom2%crystals_label()
          write (log_unit, '(a, 1X, F0.5, ",", F0.5, " = ", a, " TO ", a)') &
          &   'DISTANCE', dfix_table(i)%distance, dfix_table(i)%esd, &
          &   atom1%crystals_label(), &
          &   atom2%crystals_label()
        end do
      end do

    end do dfix_loop

  end subroutine

!> Write sadi restraints to list16 section
  subroutine write_list16_sadi()
    use crystal_data_m
    implicit none
    integer, dimension(:), allocatable :: serials
    type(atom_shelx_t) :: atom
    integer i, j, k, l, start
    character :: linecont
    character(len=256), dimension(2) :: buffer
    character(len=lenlabel), dimension(:), allocatable :: splitbuffer
    character(len=:), dimension(:), allocatable :: broadcast
    character(len=:), allocatable :: stripline, errormsg

    ! DISTANCE 0.000000 , 0.050000 = MEAN N(1) TO C(3), ...
    if (sadi_table_index > 0) then
      write (log_unit, '(a)') ''
      write (log_unit, '(a)') 'Processing SADIs...'
      if (allocated(serials)) deallocate (serials)
      allocate (serials(2))
      serials = 0
    end if

    sadi_loop: do i = 1, sadi_table_index
      write (log_unit, '(a)') trim(sadi_table(i)%shelxline)

      write (crystals_fileunit, '(a, a)') '# ', trim(sadi_table(i)%shelxline)
      write (crystals_fileunit, '(a, 1X, F0.5, a)') &
      &   'DISTANCE 0.0, ', sadi_table(i)%esd, ' = MEAN '
      write (log_unit, '(a, 1X, F0.5, a)') &
      &   'DISTANCE 0.0, ', sadi_table(i)%esd, ' = MEAN '
      linecont = ','

      call explicit_atoms(sadi_table(i)%shelxline, stripline, errormsg)
      if (allocated(errormsg)) then
        write (log_unit, *) trim(errormsg)
        write (log_unit, '("Line ", I0, ": ", a)') dfix_table(i)%line_number, trim(dfix_table(i)%shelxline)
        summary%error_no = summary%error_no+1
      end if

      call broadcast_shelx_cmd(trim(stripline), broadcast)

      do j = 1, size(broadcast)
        call deduplicates(broadcast(j), stripline)
        call to_upper(stripline)
        call explode(stripline, lenlabel, splitbuffer)

        start = 2
        do while (ichar(splitbuffer(start) (1:1)) < 65 .or. ichar(splitbuffer(start) (1:1)) > 90)
          start = start+1
        end do

        do k = start, size(splitbuffer), 2
          do l = 1, 2
            atom = atom_shelx_t(splitbuffer(k+l-1))

            if (atom%crystals_label() == '') then
              write (log_unit, '(I0, 1X, a, a)') j, sadi_table(i)%shelxline
              write (log_unit, '(3a)') 'Warning: ', splitbuffer(k+l-1), ' is missing in res file '
              cycle sadi_loop
            end if

            buffer(l) = atom%crystals_label()
          end do

          if (j == size(broadcast) .and. k == size(splitbuffer)-1) then
            linecont = ''
          end if

          write (crystals_fileunit, '(a,a,a,a, a)') &
          &   'CONT ', &
          &   trim(buffer(1)), ' TO ', &
          &   trim(buffer(2)), &
          &   linecont
          write (log_unit, '(a,a,a,a, a)') &
          &   'CONT ', &
          &   trim(buffer(1)), ' TO ', &
          &   trim(buffer(2)), &
          &   linecont
        end do
      end do
    end do sadi_loop
  end subroutine

!> Write isor restraints to list16 section
  subroutine write_list16_isor()
    use crystal_data_m
    implicit none
    character(len=1024) :: buffertemp
    integer i, j, k
    character(len=:), allocatable :: stripline, errormsg
    real esd1, esd2
    character(len=lenlabel), dimension(:), allocatable :: splitbuffer
    integer start, iostatus
    type(atom_shelx_t) :: atom
    character(len=:), dimension(:), allocatable :: broadcast

    ! ISOR 0.01 0.02 N(1) C(3)
    if (isor_table_index > 0) then
      write (log_unit, '(a)') ''
      write (log_unit, '(a)') 'Processing ISORs...'
    end if

    isor_loop: do i = 1, isor_table_index
      write (crystals_fileunit, '(a,a )') '# ', trim(isor_table(i)%shelxline)
      write (log_unit, '(a)') trim(isor_table(i)%shelxline)

      if (len_trim(isor_table(i)%shelxline) < 5) then
        write (*, *) 'Error: Empty ISOR'
        write (*, '("Line ", I0, ": ", a)') isor_table(i)%line_number, trim(isor_table(i)%shelxline)
        write (log_unit, *) 'Error: Empty ISOR'
        write (log_unit, '("Line ", I0, ": ", a)') isor_table(i)%line_number, trim(isor_table(i)%shelxline)
        summary%error_no = summary%error_no+1
        return
      end if

      call explicit_atoms(isor_table(i)%shelxline, stripline, errormsg)
      if (allocated(errormsg)) then
        write (log_unit, *) trim(errormsg)
        write (log_unit, '("Line ", I0, ": ", a)') isor_table(i)%line_number, trim(isor_table(i)%shelxline)
        summary%error_no = summary%error_no+1
      end if

      call broadcast_shelx_cmd(trim(stripline), broadcast)

      do j = 1, size(broadcast)
        call deduplicates(broadcast(j), stripline)
        call to_upper(stripline)
        call explode(stripline, lenlabel, splitbuffer)

        ! first element is shelx instruction
        ! second element is the esd of atoms (optional)
        read (splitbuffer(2), *, iostat=iostatus) esd1
        if (iostatus /= 0) then
          esd1 = 0.1
          start = 2
        else
          start = 3
        end if

        ! third element is the esd of terminal atoms (optional)
        read (splitbuffer(3), *, iostat=iostatus) esd2
        if (iostatus /= 0) then
          esd2 = 0.2
        else
          start = start+1
          write (log_unit, '(a)') 'Warning: [st] esd in ISOR not supported, using [s] instead'
        end if

        write (buffertemp, '(a, F7.5, 1X)') 'UQISO ', esd1

        do k = start, size(splitbuffer)
          atom = atom_shelx_t(splitbuffer(k))

          if (atom%crystals_label() == '') then
            write (*, '("Line ", I0, ": ", a)') isor_table(i)%line_number, trim(isor_table(i)%shelxline)
            write (*, '(a)') 'Error: check your res file. I cannot find the atom ', trim(splitbuffer(k))
            write (log_unit, '("Line ", I0, ": ", a)') isor_table(i)%line_number, trim(isor_table(i)%shelxline)
            write (log_unit, '(a)') 'Error: check your res file. I cannot find the atom ', trim(splitbuffer(k))
            cycle
          end if

          ! good to go
          buffertemp = trim(buffertemp)//' '//atom%crystals_label()
          if (len_trim(buffertemp) > 72) then
            write (crystals_fileunit, '(a)') trim(buffertemp)
            write (log_unit, '(a)') trim(buffertemp)
            buffertemp = 'CONT '
          end if
        end do
        write (crystals_fileunit, '(a)') trim(buffertemp)
        write (log_unit, '(a)') trim(buffertemp)
      end do

    end do isor_loop
  end subroutine

!> Write same restraints to list16 section
  subroutine write_list16_same()
    use crystal_data_m, only: lenlabel, same_table, same_table_index, atomslist
    use crystal_data_m, only: crystals_fileunit, log_unit, sfac, atomslist_index
    use crystal_data_m, only: explicit_atoms, deduplicates
    use crystal_data_m, only: to_upper, explode, summary
    use crystal_data_m, only: resi_t, atom_shelx_t, resilist_from_class
    implicit none
    character(len=1024) :: buffertemp
    integer i, j, k, l
    character(len=:), allocatable :: stripline, errormsg
    real esd1, esd2
    character(len=lenlabel), dimension(:), allocatable :: splitbuffer
    integer start, iostatus
    type(atom_shelx_t) :: keyword, atom
    character(len=:), dimension(:), allocatable :: broadcast

    ! SAME 0.01 0.1 C(17)  C(18) AND C(14)  C(15)
    if (same_table_index > 0) then
      write (log_unit, '(a)') ''
      write (log_unit, '(a)') 'Processing SAMEs...'
    end if

    same_loop: do i = 1, same_table_index

      if (len_trim(same_table(i)%shelxline) < 5) then
        write (log_unit, *) 'Error: Empty SAME'
        write (log_unit, '("Line ", I0, ": ", a)') same_table(i)%line_number, trim(same_table(i)%shelxline)
        write (*, *) 'Error: Empty SAME'
        write (*, '("Line ", I0, ": ", a)') same_table(i)%line_number, trim(same_table(i)%shelxline)
        summary%error_no = summary%error_no+1
        return
      end if

      call explicit_atoms(same_table(i)%shelxline, stripline, errormsg)
      if (allocated(errormsg)) then
        write (log_unit, *) trim(errormsg)
        write (log_unit, '("Line ", I0, ": ", a)') same_table(i)%line_number, trim(same_table(i)%shelxline)
        write (*, *) trim(errormsg)
        write (*, '("Line ", I0, ": ", a)') same_table(i)%line_number, trim(same_table(i)%shelxline)
        summary%error_no = summary%error_no+1
        cycle
      end if

      call deduplicates(stripline)
      call explode(stripline, lenlabel, splitbuffer)
      keyword = atom_shelx_t(splitbuffer(1))

      if (keyword%resi_all) then
        write (log_unit, *) 'Error: Cannot apply all residues to SAME instruction'
        write (log_unit, '("Line ", I0, ": ", a)') same_table(i)%line_number, trim(same_table(i)%shelxline)
        write (*, *) 'Error: Cannot apply all residues to SAME instruction'
        write (*, '("Line ", I0, ": ", a)') same_table(i)%line_number, trim(same_table(i)%shelxline)
        summary%error_no = summary%error_no+1
        cycle
      end if

      if (keyword%resi%is_set()) then
        call broadcast_shelx_cmd(trim(stripline), broadcast, override=.true.)
      else
        if (allocated(broadcast)) deallocate (broadcast)
        allocate (character(len=len_trim(stripline)) :: broadcast(1))
        broadcast(1) = trim(stripline)
      end if

      ! first element is shelx instruction
      ! second element is the esd of atoms (optional)
      read (splitbuffer(2), *, iostat=iostatus) esd1
      if (iostatus /= 0) then
        esd1 = 0.1
        start = 2
      else
        start = 3
      end if

      ! third element is the esd of terminal atoms (optional)
      read (splitbuffer(3), *, iostat=iostatus) esd2
      if (iostatus /= 0) then
        esd2 = 0.2
      else
        start = start+1
        write (log_unit, '(a)') 'Warning: [st] esd in ISOR not supported, using [s] instead'
      end if

      same_table(i)%esd1 = esd1
      same_table(i)%esd2 = esd2

      ! now that we have the list of the reference atoms,
      ! lets make the list of atoms to which the restraint is applied to
      allocate (same_table(i)%list_to(size(splitbuffer)-start+1))
      same_table(i)%list_to = 0
      ! find the starting point in the atom list
      l = 0
      do j = 1, atomslist_index
        if (atomslist(j)%line_number > same_table(i)%line_number) then
          ! This is the atom declaration just after the same instruction in the ins file
          l = j
          exit
        end if
      end do

      j = 0
      do
        if (atomslist(l)%sfac == 0) then
          write (log_unit, *) 'Error: Invalid atom type ', atomslist(l)%line_number, ': ', &
          & trim(atomslist(l)%shelxline), ' ', atomslist(l)%sfac
          write (log_unit, '("Line ", I0, ": ", a)') same_table(i)%line_number, trim(same_table(i)%shelxline)
          write (*, *) 'Error: Invalid atom type ', atomslist(l)%line_number, ': ', &
          & trim(atomslist(l)%shelxline), ' ', atomslist(l)%sfac
          write (*, '("Line ", I0, ": ", a)') same_table(i)%line_number, trim(same_table(i)%shelxline)
          summary%error_no = summary%error_no+1
          cycle same_loop
        end if

        if (trim(sfac(atomslist(l)%sfac)) /= 'H' .and. &
        &   trim(sfac(atomslist(l)%sfac)) /= 'D') then
          j = j+1
          same_table(i)%list_to(j) = l
          if (j == size(same_table(i)%list_to)) then
            exit
          end if
        end if
        l = l+1
        if (l > atomslist_index) then
          write (log_unit, *) 'Error: Invalid SAME restraint. No more atom to add '
          write (log_unit, '("Line ", I0, ": ", a)') same_table(i)%line_number, trim(same_table(i)%shelxline)
          write (*, *) 'Error: Invalid SAME restraint. No more atom to add '
          write (*, '("Line ", I0, ": ", a)') same_table(i)%line_number, trim(same_table(i)%shelxline)
          summary%error_no = summary%error_no+1
          cycle same_loop
        end if
      end do

      write (crystals_fileunit, '(a, a)') '# ', trim(same_table(i)%shelxline)
      write (log_unit, '(a, a)') '# ', trim(same_table(i)%shelxline)

      do j = 1, size(broadcast)
        call deduplicates(broadcast(j), stripline)
        call to_upper(stripline)
        call explode(stripline, lenlabel, splitbuffer)

        write (buffertemp, '(a, F7.5, 1X)') 'SAME ', same_table(i)%esd1

        do k = start, size(splitbuffer)
          atom = atom_shelx_t(splitbuffer(k))

          if (atom%crystals_label() == '') then
            write (*, '(a)') atom%text
            write (*, '(a)') splitbuffer(k)
            write (*, '(a)') 'Error: check your res file. I cannot find the atom'
            call abort()
          end if

          buffertemp = trim(buffertemp)//' '//atom%crystals_label()

          if (len_trim(buffertemp) > 72) then
            write (crystals_fileunit, '(a)') trim(buffertemp)
            write (log_unit, '(a)') trim(buffertemp)
            buffertemp = 'CONT '
          end if
        end do
        write (crystals_fileunit, '(a)') trim(buffertemp)
        write (log_unit, '(a)') trim(buffertemp)

        write (buffertemp, '(a)') 'CONT AND '
        do k = 1, size(same_table(i)%list_to)
          buffertemp = trim(buffertemp)//' '//atomslist(same_table(i)%list_to(k))%crystals_label()
          if (len_trim(buffertemp) > 72) then
            write (crystals_fileunit, '(a)') trim(buffertemp)
            write (log_unit, '(a)') trim(buffertemp)
            buffertemp = 'CONT '
          end if
        end do
        write (crystals_fileunit, '(a)') trim(buffertemp)
        write (log_unit, '(a)') trim(buffertemp)

      end do

    end do same_loop
  end subroutine

!> Write list28 (filter reflections)
!! Insert default filters to be consistent with processing from within crystals
!! add omit and resolution limits
!! djw Remove low resolution limit - should be done by instrument
  subroutine write_list28()
    use crystal_data_m
    implicit none
    integer i
    real limith, limitl

    limith = -1.0
    limitl = -1.0
    if (omitlist%shel(1) >= 0) then
      limitl = 1.0/(4.0*omitlist%shel(1)**2)
      limith = 1.0/(4.0*omitlist%shel(2)**2)
    end if
    if (omitlist%twotheta > 0.0) then
      limith = max(limith, (sin(omitlist%twotheta*3.14159/360.0)/wavelength)**2)
    end if

    write (crystals_fileunit, '(a)') '\LIST 28'
    write (crystals_fileunit, '(a)') 'MINIMA'
    if (limitl > -1.0) then
      write (crystals_fileunit, '(a, F0.3)') 'CONT SINTH/L**2  =  ', limitl
    end if
    write (crystals_fileunit, '(a)') 'CONT    RATIO    =  -3.00000'
    write (crystals_fileunit, '(a)') 'CONT    SQRTW    =   0.00000'

    if (limith > -1.0) then
      write (crystals_fileunit, '(a, F0.3)') 'MAXIMA SINTH/L**2 = ', limith
    end if

    if (omitlist%index > 0) then
      write (crystals_fileunit, '(a, I0)') 'READ NOMIS = ', omitlist%index
      do i = 1, omitlist%index
        write (crystals_fileunit, '(a, 3(I0, " "))') 'OMIT ', omitlist%hkl(i, :)
      end do
    end if

    write (crystals_fileunit, '(a)') 'END'
  end subroutine

!> Write hkl file
  subroutine write_hkl(hklfile_path)
    use crystal_data_m, only: hklf, crystals_fileunit
    implicit none
    character(len=*), intent(in) :: hklfile_path
    integer i
! The backslash character causes problem in doxygen, using the following workaround instead
    character(len=1), parameter :: backslash = char(92) !< the back slash character

!# read in reflections
!#CLOSE HKLI
!#OPEN HKLI  "datafile.hkl"
!#HKLI
!READ F'S=FSQ NCOEF=6 TYPE=FIXED CHECK=NO
!INPUT H K L /FO/ SIGMA(/FO/) /Fc/
!FORMAT (3F4.0, 3F10.0)
!MATRIX 1 0 0    0 1 0  0 0 1
!STORE NCOEF=7
!OUTP INDI /FO/ SIG RATIO CORR SERI /Fc/
!END
!#CLOSE HKLI
!#SCRIPT XPROC6


! The following removes path before filename - we need the path if we are to process the hkl file from
! a different folder.
!    i = max(index(hklfile_path, "/", .true.), index(hklfile_path, backslash, .true.))
     i = 0

    write (crystals_fileunit, '(a)') '# read in reflections'
    write (crystals_fileunit, '(a)') '#CLOSE HKLI'
    write (crystals_fileunit, '(a,a,a)') '#OPEN HKLI  "', trim(hklfile_path(i+1:)), '"'
    write (crystals_fileunit, '(a)') '#HKLI'
    write (crystals_fileunit, '(a)') "READ F'S=FSQ NCOEF=5 TYPE=FIXED CHECK=NO"
    write (crystals_fileunit, '(a)') 'INPUT H K L /FO/ SIGMA(/FO/) '
    write (crystals_fileunit, '(a)') 'FORMAT (3F4.0, 2F8.0)'
    write (crystals_fileunit, '(a, 9(F0.3," "))') 'MATRIX ', transpose(hklf%transform)
    write (crystals_fileunit, '(a)') 'STORE NCOEF=7'
    write (crystals_fileunit, '(a)') 'OUTP INDI /FO/ SIG RATIO CORR SERI /Fc/'
    write (crystals_fileunit, '(a)') 'END'
    write (crystals_fileunit, '(a)') '#CLOSE HKLI'
    write (crystals_fileunit, '(a)') '#SCRIPT XPROC6'

  end subroutine

!> Take a shelx instruction and broadcast all the residues if present
  subroutine broadcast_shelx_cmd(text, broadcast, override)
    use crystal_data_m
    implicit none
    character(len=*), intent(in) ::text !< input shelx instruction
    character(len=:), dimension(:), allocatable, intent(out) :: broadcast !< list of individual shelx instruction
    logical, intent(in), optional :: override
    character(len=lenlabel), dimension(:), allocatable :: splitbuffer
    character(len=:), allocatable :: stripline
    type(atom_shelx_t) :: keyword
    character(len=lenlabel) :: buffer
    integer i, j, k, l
    integer, dimension(:), allocatable :: classlist
    logical override_flag

    if (present(override)) then
      if (override) then
        override_flag = .true.
      else
        override_flag = .false.
      end if
    else
      override_flag = .false.
    end if

    call deduplicates(text, stripline)
    call to_upper(stripline)
    call explode(stripline, lenlabel, splitbuffer)

    keyword = atom_shelx_t(splitbuffer(1))

    if (keyword%previous .or. keyword%after) then
      write (log_unit, *) "Error: This residue name does not make sense"
      write (log_unit, '("Line: ", a)') trim(text)
      write (*, *) "Error: This residue name does not make sense"
      write (*, '("Line: ", a)') trim(text)
      summary%error_no = summary%error_no+1
      allocate (character(len=2*len(text)) :: broadcast(0))
      return
    end if

    if (keyword%resi_all) then
      allocate (character(len=2*len(text)) :: broadcast(resi_list_index))
      do i = 1, resi_list_index
        broadcast(i) = keyword%label
        do j = 2, size(splitbuffer)
          l = index(splitbuffer(j), '_')
          if (l > 1) then
            if (override_flag) then
              write (buffer, '(a,"_",I0)') trim(splitbuffer(j) (1:l-1)), resi_list(i)%number
              broadcast(i) = trim(broadcast(i))//' '//buffer
            else
              broadcast(i) = trim(broadcast(i))//' '//splitbuffer(j)
            end if
          else
            if (resi_list(i)%number /= 0) then
              write (buffer, '(a,"_",I0)') trim(splitbuffer(j)), resi_list(i)%number
              broadcast(i) = trim(broadcast(i))//' '//buffer
            else if (resi_list(i)%class /= '') then
              broadcast(i) = trim(broadcast(i))//' '//trim(splitbuffer(j))//'_'//resi_list(i)%class
            else
              broadcast(i) = trim(broadcast(i))//' '//trim(splitbuffer(j))//'_'//resi_list(i)%alias
            end if
          end if
        end do
      end do
    else if (keyword%resi%is_set()) then
      if (keyword%resi%class /= '') then
        classlist = resilist_from_class(keyword%resi%class)
        allocate (character(len=2*len(text)) :: broadcast(size(classlist)))
        do j = 1, size(classlist)
          broadcast(j) = keyword%label
          do k = 2, size(splitbuffer)
            l = index(splitbuffer(j), '_')
            if (l > 1) then
              if (override_flag) then
                write (buffer, '(a,"_",I0)') trim(splitbuffer(k) (1:l-1)), classlist(j)
                broadcast(j) = trim(broadcast(j))//' '//buffer
              else
                broadcast(j) = trim(broadcast(j))//' '//splitbuffer(k)
              end if
            else
              if (ichar(splitbuffer(k) (1:1)) > 64 .and. ichar(splitbuffer(k) (1:1)) < 91) then
                write (buffer, '(a,"_",I0)') trim(splitbuffer(k)), classlist(j)
                broadcast(j) = trim(broadcast(j))//' '//buffer
              else
                broadcast(j) = trim(broadcast(j))//' '//splitbuffer(k)
              end if
            end if
          end do
        end do
      else if (keyword%resi%number /= 0) then
        allocate (character(len=2*len(text)) :: broadcast(1))
        broadcast(1) = keyword%label
        do j = 2, size(splitbuffer)
          l = index(splitbuffer(j), '_')
          if (l > 1) then
            if (override_flag) then
              write (buffer, '(a,"_",I0)') trim(splitbuffer(j) (1:l-1)), keyword%resi%number
              broadcast(1) = trim(broadcast(1))//' '//buffer
            else
              broadcast(1) = trim(broadcast(1))//' '//splitbuffer(j)
            end if
          else
            if (ichar(splitbuffer(j) (1:1)) > 64 .and. ichar(splitbuffer(j) (1:1)) < 91) then
              write (buffer, '(a,"_",I0)') trim(splitbuffer(j)), keyword%resi%number
              broadcast(1) = trim(broadcast(1))//' '//buffer
            else
              broadcast(1) = trim(broadcast(1))//' '//trim(splitbuffer(j))
            end if
          end if
        end do
      else
        allocate (character(len=2*len(text)) :: broadcast(0))
        print *, 'Hummm broadcast failing'
        call abort()
      end if
    else
      allocate (character(len=2*len(text)) :: broadcast(1))
      broadcast(1) = text
    end if

  end subroutine

  !> Write RIGU restraints to crystals file
  subroutine write_list16_rigu()
    use crystal_data_m, only: lenlabel, rigu_table, rigu_table_index
    use crystal_data_m, only: crystals_fileunit, log_unit
    use crystal_data_m, only: explicit_atoms, deduplicates
    use crystal_data_m, only: to_upper, explode, summary
    use crystal_data_m, only: resi_t, atom_shelx_t, resilist_from_class
    implicit none
    character(len=1024) :: buffertemp
    integer i, j, k, l
    character(len=:), allocatable :: stripline, errormsg
    real esd12, esd13
    character(len=128), dimension(:), allocatable :: serials
    character(len=lenlabel), dimension(:), allocatable :: splitbuffer
    integer start, iostatus
    type(atom_shelx_t) :: atom_shelx
    character(len=:), dimension(:), allocatable :: broadcast

    if (rigu_table_index > 0) then
      write (log_unit, '(a)') ''
      write (log_unit, '(a)') 'Processing RIGUs...'
    end if

    rigu_loop: do i = 1, rigu_table_index

      call explicit_atoms(rigu_table(i)%shelxline, stripline, errormsg)
      if (allocated(errormsg)) then
        write (log_unit, *) trim(errormsg)
        write (log_unit, '("Line ", I0, ": ", a)') rigu_table(i)%line_number, trim(rigu_table(i)%shelxline)
        summary%error_no = summary%error_no+1
      end if

      call broadcast_shelx_cmd(trim(stripline), broadcast)

      do j = 1, size(broadcast)
        call deduplicates(broadcast(j), stripline)
        call to_upper(stripline)
        call explode(stripline, lenlabel, splitbuffer)

        if (j == 1) then
          ! second element is the esd of 1,2 distances (optional)
          if (size(splitbuffer) > 1) then
            read (splitbuffer(2), *, iostat=iostatus) esd12
            if (iostatus /= 0) then
              esd12 = 0.004
              start = 2
            else
              start = 3
            end if

            ! third element is the esd of 1,3 distances (optional)
            if (size(splitbuffer) > 2) then
              read (splitbuffer(3), *, iostat=iostatus) esd13
              if (iostatus /= 0) then
                esd13 = 0.004
              else
                start = start+1
              end if
            else
              esd13 = 0.004
              start = 3
            end if
          else
            esd12 = 0.004
            esd13 = 0.004
            start = 2
          end if

          rigu_table(i)%esd12 = esd12
          rigu_table(i)%esd13 = esd13
        end if

        if (start > size(splitbuffer)) then
          write (log_unit, '(a)') 'Warning: Empty RIGU. Not implemented'
          write (log_unit, '("Line ", I0, ": ", a)') rigu_table(i)%line_number, trim(rigu_table(i)%shelxline)
          write (*, '(a)') 'Warning: Empty RIGU. Not implemented'
          write (*, '("Line ", I0, ": ", a)') rigu_table(i)%line_number, trim(rigu_table(i)%shelxline)
          cycle rigu_loop
        end if

        write (log_unit, '(a)') trim(rigu_table(i)%shelxline)
        write (crystals_fileunit, '(a, a)') '# ', trim(rigu_table(i)%shelxline)

        if (allocated(serials)) deallocate (serials)
        allocate (serials(size(splitbuffer)-start+1))
        serials = ''
        do k = start, size(splitbuffer)
          atom_shelx = atom_shelx_t(splitbuffer(k))

          if (atom_shelx%crystals_label() == '') then
            write (*, '(a)') trim(rigu_table(i)%shelxline)
            write (*, '(a)') trim(broadcast(j))
            write (*, '(a)') splitbuffer(k)
            write (*, '(a)') 'Error: check your res file. I cannot find the atom'
            call abort()
          end if

          serials(k-start+1) = atom_shelx%crystals_label()
        end do

        ! good to go
        write (buffertemp, '(a, F7.5, 1X, F7.5)') 'XRIGU ', rigu_table(i)%esd12, rigu_table(i)%esd13
        do l = 1, size(serials)
          buffertemp = trim(buffertemp)//' '//serials(l)
          if (len_trim(buffertemp) > 72) then
            write (crystals_fileunit, '(a)') trim(buffertemp)
            write (log_unit, '(a)') trim(buffertemp)
            buffertemp = 'CONT'
          end if
        end do
        write (crystals_fileunit, '(a)') trim(buffertemp)
        write (log_unit, '(a)') trim(buffertemp)
      end do ! loop broadcast
    end do rigu_loop
  end subroutine
end module
