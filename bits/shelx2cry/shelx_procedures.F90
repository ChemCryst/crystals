!> This module list the subroutine processing each keyword of a res file \ingroup shelx2cry
module shelx_procedures_m
  integer, parameter, private :: debug = 0
contains

!> Keyword not yet supprted by crystals
  subroutine shelx_unsupported(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline
    integer i, found
    character(len=4) :: tag

    tag = shelxline%line(1:4)
    call to_upper(tag)

    write (log_unit, '(a,a,a)') 'Warning: `', trim(tag), '` Not supported '
    write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)

    found = 0
    do i = 1, shelx_unsupported_list_index
      if (shelx_unsupported_list(i)%tag == shelxline%line(1:4)) then
        found = i
        exit
      end if
    end do

    if (found > 0) then
      shelx_unsupported_list(found)%num = shelx_unsupported_list(found)%num+1
    else
      shelx_unsupported_list_index = shelx_unsupported_list_index+1
      shelx_unsupported_list(shelx_unsupported_list_index)%tag = tag
      shelx_unsupported_list(shelx_unsupported_list_index)%num = 1
    end if

  end subroutine

!> Deprecated keywords not used in shelx anymore
  subroutine shelx_deprecated(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline

    ! deprecated keywords
    write (log_unit, '(a)') 'Warning: Keywords `TIME`, `HOPE` and `MOLE` are deprecated in shelx and therefore ignored'
    write (log_unit, '(a,I0,a, a)') 'Line ', shelxline%line_number, ': ', trim(shelxline%line)

  end subroutine

!> Silently ignored keywords. Those are irrelevant for the structure
  subroutine shelx_ignored(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline

    if (debug > 0) then
      write (log_unit, *) 'Notice: Ignored keyword '
      write (log_unit, *) shelxline%line_number, trim(shelxline%line)
    end if

  end subroutine

!> Parse ABIN keyword. It is ignored but the user is warned that the structure has been squeezed
  subroutine shelx_abin(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline

    write (log_unit, *) 'Warning: Structure has been SQUEEZED '
    write (log_unit, *) shelxline%line_number, trim(shelxline%line)
    info_table_index = info_table_index+1
    info_table(info_table_index)%shelxline = trim(shelxline%line)
    info_table(info_table_index)%line_number = shelxline%line_number
    info_table(info_table_index)%text = 'Warning: Structure has been SQUEEZED '

  end subroutine

!> Parse HKLF keyword. It is ignored but the user is warned that the structure has been TWINNED if HKLF 5 is found
  subroutine shelx_hklf(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline
    character(len=512) :: buffer
    character(len=:), allocatable :: stripline
    character(len=lenlabel), dimension(:), allocatable :: splitbuffer
    integer i, hklfcode
    real s
    real, dimension(9) :: transform
    logical transforml

    s = 1.0
    transform = 0.0
    transform(1) = 1.0
    transform(5) = 1.0
    transform(9) = 1.0
    transforml = .false.

    buffer = shelxline%line(5:len(shelxline%line))
    buffer = adjustl(buffer)

    if (len_trim(buffer) == 0) then
      return
    end if

    call deduplicates(trim(buffer), stripline)
    call explode(stripline, lenlabel, splitbuffer)

    ! trying to make sense of the hklf instruction
    read (splitbuffer(1), *) hklfcode
    if (size(splitbuffer) == 1) then
      ! all good, nothing to do
    else if (size(splitbuffer) == 2) then
      ! First is the hklf code, then it is a scale factor:
      ! the scale factor S multiplies both Fo² and σ(Fo²)
      read (splitbuffer(2), *) s
      transforml = .true.
    else if (size(splitbuffer) == 10) then
      ! First is the hklf code, then a transformation matrix:
      do i = 1, 9
        read (splitbuffer(i+1), *) transform(i)
      end do
      transforml = .true.
    else if (size(splitbuffer) == 11) then
      ! First is the hklf code, then a scale factor, then a transformation matrix:
      read (splitbuffer(2), *) s
      do i = 1, 9
        read (splitbuffer(i+2), *) transform(i)
      end do
      transforml = .true.
    else
      write (log_unit, *) 'Error: Unsupported combination of arguments in HKLF'
      write (log_unit, '("shelxline ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
    end if

    if (hklfcode < 1 .or. hklfcode > 6) then
      write (log_unit, *) 'Error: Invalid HKLF code '
      write (log_unit, *) shelxline%line_number, trim(shelxline%line)
      summary%error_no = summary%error_no+1
      return
    end if

    if (hklfcode == 5) then ! twin refinement expecting hklf 5 file later, issuing a warning
      write (log_unit, *) 'Warning: Structure is TWINNED and HKLF 5 has been used '
      write (log_unit, *) shelxline%line_number, trim(shelxline%line)
      info_table_index = info_table_index+1
      info_table(info_table_index)%shelxline = trim(shelxline%line)
      info_table(info_table_index)%line_number = shelxline%line_number
      info_table(info_table_index)%text = 'Warning: Structure is TWINNED and HKLF 5 has been used'
    end if

    hklf%code = hklfcode
    hklf%transform = transpose(reshape(transform, (/3, 3/)))
    hklf%scale = 0.0

    if (transforml) then
      ! check that the determinant is positive
      if (m33det(reshape(transform, (/3, 3/))) <= 0) then ! matrix is transposed but the determinant is unaffected.
        transforml = .true.
        write (log_unit, *) 'Error: The transformation matrix from HKLF is invalid (determinant<=0)'
        write (log_unit, '("shelxline ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no = summary%error_no+1
      end if
    end if

  contains

    !***********************************************************************************************************************************
    !  M33DET  -  Compute the determinant of a 3x3 matrix.
    !***********************************************************************************************************************************
    !> Return the determinant of a 3x3 matrix
    function m33det(a) result(det)
      implicit none
      real, dimension(3, 3), intent(in)  :: a
      real :: det

      det = a(1, 1)*a(2, 2)*a(3, 3) &
            -a(1, 1)*a(2, 3)*a(3, 2) &
            -a(1, 2)*a(2, 1)*a(3, 3) &
            +a(1, 2)*a(2, 3)*a(3, 1) &
            +a(1, 3)*a(2, 1)*a(3, 2) &
            -a(1, 3)*a(2, 2)*a(3, 1)

      return
    end function m33det

  end subroutine

!> Parse the TITL keyword. Extract the space group name
  subroutine shelx_titl(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline
    integer start

    ! extract space group
    start = index(shelxline%line, 'in ')
    if (start == 0) then
      spacegroup%symbol = 'Unknown'
      !write(log_unit,*) 'Error: Space group not specified in TITL'
      !write(log_unit, '("shelxline ", I0, ": ", a)') line_number, trim(shelxline)
      !stop
    end if

    spacegroup%symbol = shelxline%line(start+3:)

  end subroutine

!> Parse the DFIX and DANG keyword. Restrain bond distances
  subroutine shelx_dfix(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline
    integer i, linepos, start, iostatus
    type(resi_t) :: dfix_residue
    type(atom_shelx_t) :: keyword
    real distance, esd
    character(len=lenlabel), dimension(:), allocatable :: splitbuffer
    character(len=:), allocatable :: stripline
    character(len=512) :: errormsg

    ! parsing more complicated on this one as we don't know the number of parameters
    linepos = 5 ! First 4 is DFIX or DANG

    if (len_trim(shelxline%line) < 5) then
      write (log_unit, *) 'Error: Empty DFIX or DANG'
      write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
      summary%error_no = summary%error_no+1
      return
    end if

    call deduplicates(shelxline%line, stripline)
    call to_upper(stripline)
    call explode(stripline, lenlabel, splitbuffer)
    keyword = atom_shelx_t(splitbuffer(1))
    dfix_residue = keyword%resi

    ! first element is the distance
    read (splitbuffer(2), *, iostat=iostatus, iomsg=errormsg) distance
    if (iostatus /= 0) then
      write (log_unit, *) 'Error: Expected a number but got ', trim(splitbuffer(2))
      write (log_unit, *) errormsg
      write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
      summary%error_no = summary%error_no+1
      return
    end if

    if (distance > 15.0) then
      write (log_unit, *) 'Error: Distance should between 0.0 and 15.0 but got ', trim(splitbuffer(1))
      write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
      summary%error_no = summary%error_no+1
      return
    end if

    ! Second element could be the esd
    read (splitbuffer(3), *, iostat=iostatus) esd
    if (iostatus /= 0) then
      ! no esd, use default
      if (shelxline%line(1:4) == 'DFIX') then
        esd = 0.02
      else
        esd = 0.04
      end if
      start = 3
    else
      start = 4
    end if

    do i = start, size(splitbuffer), 2
      if ((i+1) > size(splitbuffer)) then
        write (log_unit, *) 'Error: Missing a label in DFIX'
        write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        write (log_unit, *) repeat(' ', 5+4+len_trim(shelxline%line)), '^'
        summary%error_no = summary%error_no+1
        return
      end if

      dfix_table_index = dfix_table_index+1
      dfix_table(dfix_table_index)%distance = distance
      dfix_table(dfix_table_index)%esd = esd
      call to_upper(splitbuffer(i), dfix_table(dfix_table_index)%atom1)
      call to_upper(splitbuffer(i+1), dfix_table(dfix_table_index)%atom2)
      dfix_table(dfix_table_index)%shelxline = trim(shelxline%line)
      dfix_table(dfix_table_index)%line_number = shelxline%line_number
      dfix_table(dfix_table_index)%residue = dfix_residue
    end do

  end subroutine

!> Parse the FLAT keyword. Restrain Plane
  subroutine shelx_flat(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline

    if (len_trim(shelxline%line) < 5) then
      write (log_unit, *) 'Error: Empty FLAT'
      write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
      summary%error_no = summary%error_no+1
      return
    end if

    ! doing processing later, we don't know the atom list yet

    flat_table_index = flat_table_index+1
    flat_table(flat_table_index)%shelxline = trim(shelxline%line)
    flat_table(flat_table_index)%line_number = shelxline%line_number

  end subroutine

!> Parse the SADI keyword. Restrain bond distances to be equal to each others
  subroutine shelx_sadi(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline
    integer i, j, linepos, start, iostatus
    real esd
    character(len=lenlabel), dimension(:), allocatable :: splitbuffer
    character(len=:), allocatable :: stripline
    type(atom_shelx_t) :: sadi_residue

    ! parsing more complicated on this one as we don't know the number of parameters
    linepos = 5 ! First 4 is DFIX

    if (len_trim(shelxline%line) < 5) then
      write (log_unit, *) 'Error: Empty SADI'
      write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
      summary%error_no = summary%error_no+1
      return
    end if

    i = index(shelxline%line, ' ')

    call deduplicates(shelxline%line, stripline)
    call to_upper(stripline)
    call explode(stripline, lenlabel, splitbuffer)

    sadi_residue = atom_shelx_t(splitbuffer(1))

    ! first element is the esd
    read (splitbuffer(2), *, iostat=iostatus) esd
    if (iostatus == 0) then
      start = 3
    else
      ! no esd, use default
      esd = 0.02
      start = 2
    end if

    sadi_table_index = sadi_table_index+1
    sadi_table(sadi_table_index)%esd = esd
    sadi_table(sadi_table_index)%shelxline = trim(shelxline%line)
    sadi_table(sadi_table_index)%line_number = shelxline%line_number
    sadi_table(sadi_table_index)%residue = sadi_residue

    do j = 1, size(splitbuffer)
      if (trim(splitbuffer(j)) == '') exit
    end do
    if (mod(j-start, 2) /= 0) then
      ! odd number of atoms
      write (log_unit, *) 'Error: Missing a label in SADI'
      write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
      summary%error_no = summary%error_no+1
      return
    end if

  end subroutine

!> Pars the CELL keyword. Extract the unit cell parameter and wavelength
  subroutine shelx_cell(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline
    character dummy
    integer iostatus, wave

    !CELL 1.54187 14.8113 13.1910 14.8119 90 98.158 90
    read (shelxline%line, *, iostat=iostatus) dummy, wavelength, unitcell
    if (iostatus /= 0) then
      write (*, *) 'Error: Syntax error'
      write (*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
      summary%error_no = summary%error_no+1
      call abort()
    end if
    list1index = list1index+1
    write (list1(list1index), '(a5,1X,6(F0.5,1X))') 'REAL ', unitcell
    list13index = list13index+1
    write (list13(list13index), '(a,F0.5)') 'COND WAVE= ', wavelength

    radiation = 'xrays'  !default to X-rays unless NEUT or ELEC keyword found.
!    write(123,*) 'Lambda = ', wavelength, target, radiation
      wave = nint(100.*wavelength)
!      write(123,*)' Wave=', wave 
      if(wave .eq. 154) then
            target = 'copper'
            radiation = 'xrays'
      else if (wave .eq. 134) then
            target = 'gallium'
            radiation = 'xrays'
      else if (wave .eq. 71) then
            target = 'molybdenum'
            radiation = 'xrays'
      else if (wave .eq. 56) then
            target = 'silver'
            radiation = 'xrays'
      else if (wave .le. 10) then
            target = 'none'
            radiation = 'electrons'
      end if
!      write(123,*) 'target=', wave, target, '  ', radiation
    list13index = list13index+1
    write (list13(list13index), '(a,a)') 'DIFF  RADIATION= ', radiation


  end subroutine

!> Parse the ZERR keyword. Extract the esds on the unit cell parameters
  subroutine shelx_zerr(shelxline)
    use crystal_data_m
    implicit none
    double precision, parameter :: dtr = 0.01745329252d0
    double precision, parameter :: amult = 0.000001d0
    type(line_t), intent(in) :: shelxline
    double precision, dimension(7) :: esds
    integer iostatus, i
    character(len=256) :: iomessage
    character(len=:), allocatable :: stripline
    character(len=lenlabel), dimension(:), allocatable :: splitbuffer

    call deduplicates(trim(shelxline%line), stripline)
    call explode(stripline, lenlabel, splitbuffer)

    if (size(splitbuffer) < 7) then
      ! invalid shelxl command
      write (*, *) 'Error: Syntax error. '
      write (*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
      summary%error_no = summary%error_no+1
      call abort()
    end if

    do i = size(splitbuffer), size(splitbuffer)-5, -1 ! starting from the end in case Z is missing
      read (splitbuffer(i), *, iostat=iostatus, iomsg=iomessage) esds(i-size(splitbuffer)+size(esds))
      if (iostatus /= 0) then
        write (*, *) 'Error while reading esd ', trim(splitbuffer(i))
        write (*, *) trim(iomessage)
        write (*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no = summary%error_no+1
        call abort()
      end if
    end do

    ! CRYSTALS stores variances, not esds. 
    ! In addition it applies a default multiplier of 0.000001 to input values, so we need to divide by this before output.
    ! Furthermore, the angle variances need to be in radians^2.
    
    
    write (list31(1), '(a)') '\LIST 31'
    write (list31(2), '(a)') 'AMULT 0.000001'  ! Make this multiplier explicit, in case the default ever changes.
    write (list31(3), '("MATRIX V(11)=",F0.5, ", V(22)=",F0.5, ", V(33)=",F0.5)') (esds(2:4)**2)/amult
    write (list31(4), '("CONT V(44)=",F0.5, ", V(55)=",F0.5, ", V(66)=",F0.5)') ((esds(5:7)*DTR)**2)/amult
    write (list31(5), '(a)') 'END'

  end subroutine

!> Parse the FVAR keyword. Extract the overall scale parameter and free variable
  subroutine shelx_fvar(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline
    real, dimension(1024) :: temp ! should be more than enough
    integer iostatus, i
    real, dimension(:), allocatable :: fvartemp

    temp = 0.0
    read (shelxline%line(5:), *, iostat=iostatus) temp
    if (temp(1024) /= 0.0) then
      write (*, *) 'More than 1024 free variable?!?!'
      call abort()
    end if
    do i = 1024, 1, -1
      if (temp(i) /= 0.0) exit
    end do
    if (.not. allocated(fvar)) then
      allocate (fvar(i))
      fvar = temp(1:i)
    else
      allocate (fvartemp(size(fvar)))
      fvartemp = fvar
      deallocate (fvar)
      allocate (fvar(i+size(fvartemp)))
      fvar(1:size(fvartemp)) = fvartemp
      fvar(size(fvartemp)+1:) = temp(1:i)
    end if

  end subroutine


!> Parse the NEUT keyword. Find the radiation type
  subroutine shelx_neut(shelxline)
    use crystal_data_m, only: radiation, line_t, list13index, list13
    implicit none
    type(line_t), intent(in) :: shelxline
    integer i, j
!    write(123,*)'list13index=',list13index
    if (list13index.ge.1) then
      do i=1,list13index
!       write(123,*)i, list13(i)
        if(list13(i)(1:4) .eq. 'DIFF' ) then
        j=i
        exit
       endif
      enddo
    else
      j = 1     
    endif
    radiation = 'neutrons'
    write (list13(j), '(a,a)') 'DIFF  RADIATION= ', radiation
  end subroutine

!> Parse the ELEC keyword. Find the radiation type(Guess that GMS calls it ELEC)
  subroutine shelx_elec(shelxline)
    use crystal_data_m, only: radiation, line_t, list13index, list13
    implicit none
    type(line_t), intent(in) :: shelxline
    integer i, j
!    write(123,*)'list13index=',list13index
    if (list13index.ge.1) then
      do i=1,list13index
!       write(123,*)i, list13(i)
       if(list13(i)(1:4) .eq. 'DIFF' ) then
         j=i
         exit
       endif
      enddo
    else
      j = 1     
    endif
    radiation = 'electrons'
    write (list13(j), '(a,a)') 'DIFF  RADIATION= ', radiation
  end subroutine


!> Parse the SFAC keyword. Extract the atoms type use in the file.
  subroutine shelx_sfac(shelxline)
    use crystal_data_m, only: sfac, sfac_index, line_t, to_upper, sfac_long, summary
    implicit none
    type(line_t), intent(in) :: shelxline
    integer i, j, code, iostatus
    character(len=3) :: buffer
    real, dimension(14) :: longsfac

    i = 5
    !write(log_unit, *) trim(shelxline%line)
    do while (i <= len_trim(shelxline%line))
      if (shelxline%line(i:i) == ' ') then
        i = i+1
        cycle
      end if

      buffer = ''
      j = 0
      do while (shelxline%line(i:i) /= ' ')
        code = iachar(shelxline%line(i:i))
        if (.not. ((code >= 65 .and. code <= 90) .or. (code >= 97 .and. code <= 122))) then
          ! long sfac maybe?
          ! SFAC E a1 b1 a2 b2 a3 b3 a4 b4 c f' f" mu r wt
          read (shelxline%line(i:), *, iostat=iostatus) longsfac
          if (iostatus /= 0) then
            write (*, *) 'Error: Syntax error'
            write (*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
            summary%error_no = summary%error_no+1
            call abort()
          end if
          sfac_long(:, sfac_index) = longsfac
          !write(log_unit, '(I3, 14F6.2)') sfac_index, longsfac
          return
        else
          j = j+1
          buffer(j:j) = shelxline%line(i:i)
          i = i+1
          if (i > len_trim(shelxline%line)) exit
        end if
      end do
      sfac_index = sfac_index+1
      !write(log_unit, *) sfac_index, to_upper(buffer)
      call to_upper(buffer, sfac(sfac_index))
    end do

  end subroutine

!> Parse the DISP keyword. Extract the atoms type use in the file.
  subroutine shelx_disp(shelxline)
    use crystal_data_m, only: disp_table, line_t, to_upper, deduplicates, explode, summary
    use crystal_data_m, only: sfac_index, sfac
    implicit none
    type(line_t), intent(in) :: shelxline
    integer i, j
    character(len=:), allocatable :: stripped
    character(len=len_trim(shelxline%line)), dimension(:), allocatable :: exploded

    if (sfac_index == 0) then
      write (*, *) 'Error: SFAC card missing before DISP'
      write (*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
      summary%error_no = summary%error_no+1
      call abort()
    end if

    if (.not. allocated(disp_table)) then
      ! DISP always appear after all the SFAC cards, so it is safe to allocate here
      allocate (disp_table(sfac_index))
      do i = 1, sfac_index
        disp_table(i)%atom = ''
        disp_table(i)%shelxline = ''
        disp_table(i)%line_number = 0
        disp_table(i)%values = 0.0
      end do
    end if

    call deduplicates(shelxline%line, stripped)
    call explode(stripped, len_trim(shelxline%line), exploded)

    do i = 1, sfac_index
      if (trim(sfac(i)) == trim(exploded(2))) then
        disp_table(i)%atom = trim(exploded(2))
        disp_table(i)%values = 0.0
        disp_table(i)%shelxline = trim(shelxline%line)
        disp_table(i)%line_number = shelxline%line_number
        do j = 3, size(exploded)
          read (exploded(j), *) disp_table(i)%values(j-2)
        end do
        exit
      end if
    end do

  end subroutine

!> Parse the UNIT keyword. Extract the number of each atomic elements.
!! Write the corresponding `composition` command for crystals
  subroutine shelx_unit(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline
    integer i, j, k, code, iostatus
    character(len=12) :: buffer
    !SFAC C H N O
    !UNIT 116 184 8 8
    !
    ! \COMPOSITION
    ! CONTENT C 6 H 5 N O 2.5 CL
    ! SCATTERING CRSCP:SCATT.DAT
    ! PROPERTIES CRSCP:PROPERTIES.DAT
    ! END

    k = 0

    i = 5
    do while (i <= len_trim(shelxline%line))
      if (shelxline%line(i:i) == ' ') then
        i = i+1
        cycle
      end if

      buffer = ''
      j = 0
      do while (shelxline%line(i:i) /= ' ')
        read (buffer, '(I1)', iostat=iostatus) code
        if (iostatus /= 0 .and. shelxline%line(i:i) /= '.') then
          write (*, *) 'Wrong input in UNIT'
          call abort()
        end if
        j = j+1
        buffer(j:j) = shelxline%line(i:i)
        i = i+1
        if (i > len_trim(shelxline%line)) exit
      end do
      k = k+1
      read (buffer, *, iostat=iostatus) sfac_units(k)
    end do

    composition(1) = '\COMPOSITION'
    !CONTENT C 6 H 5 N O 2.5 CL
    composition(2) = 'CONTENT '
    do i = 1, k
      if (abs(nint(sfac_units(i))-sfac_units(i)) < 0.01) then
        write (buffer, '(I0)') nint(sfac_units(i))
      else
        write (buffer, '(F0.2)') sfac_units(i)
      end if
      composition(2) = trim(composition(2))//' '//trim(sfac(i))//' '//trim(buffer)
    end do
    ! SCATTERING CRSCP:SCATT.DAT
!    write(123,*) 'radiation type= ', radiation
    if (radiation .eq. 'electrons') then
      composition(3) = 'SCATTERING CRYSDIR:script/escatt.dat'
    else if (radiation .eq. 'neutrons') then
      composition(3) = 'SCATTERING CRYSDIR:script/nscatt.dat'
    else
      composition(3) = 'SCATTERING CRYSDIR:script/scatt.dat'
    end if    
    ! PROPERTIES CRSCP:PROPERTIES.DAT
    composition(4) = 'PROPERTIES CRYSDIR:script/propwin.dat'
    ! END
    composition(5) = 'END'

  end subroutine

!> Parse the LATT keyword. Extract the lattice type.
  subroutine shelx_latt(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline

    read (shelxline%line(5:), *) spacegroup%latt

  end subroutine

!> Parse the SYMM keyword. Extract the symmetry operators as text.
  subroutine shelx_symm(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline

    spacegroup%symmindex = spacegroup%symmindex+1
    read (shelxline%line(5:), '(a)') spacegroup%symm(spacegroup%symmindex)

  end subroutine

!> Parse the EQIV keyword. Extract the symmetry operators as text.
  subroutine shelx_eqiv(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline
    integer i, num, ierror
    character(len=len(shelxline%line)) :: buffer, errormsg

    buffer = adjustl(shelxline%line(5:))

    !search and check for the number
    i = index(buffer, ' ')
    if (i > 2) then
      if (buffer(1:1) == '$') then
        read (buffer(2:i), *, iostat=ierror, iomsg=errormsg) num
      else
        ierror = -1
      end if
    else
      ierror = -1
    end if

    if (ierror /= 0) then
      write (log_unit, '(a,a)') 'Error: invalid index in EQIV: ', trim(buffer(1:i))
      write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
      return
    end if

    eqiv_list_index = eqiv_list_index+1
    eqiv_list(eqiv_list_index)%index = num
    eqiv_list(eqiv_list_index)%text = trim(adjustl(buffer(i:)))

  end subroutine

!> Parse RESI keyword. Change the current residue to the new value found.
  subroutine shelx_resi(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline
    integer ierror
    character(len=4) :: resi_class
    integer :: i, resi_number
    character(len=128) :: resi_alias
    character(len=:), allocatable :: stripline
    character(len=lenlabel), dimension(:), allocatable :: splitbuffer

    !read(shelxline%line(5:), *) residue
    ! RESI class[ ] number[0] alias
    resi_class = ''
    resi_number = 0
    resi_alias = ''

    call deduplicates(shelxline%line, stripline)
    call explode(stripline, lenlabel, splitbuffer)

    if (size(splitbuffer) < 2) then
      write (*, *) 'Error: RESI instruction '
      write (*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
      return
    end if

    ! is it an alias or a number ?
    if (iachar(splitbuffer(2) (1:1)) > 47 .and. iachar(splitbuffer(2) (1:1)) < 58) then ! 0-9
      read (splitbuffer(2), *, iostat=ierror) resi_number
      if (ierror /= 0) then
        write (*, *) 'Error: invalid resi number ', trim(splitbuffer(2))
        write (*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        return
      end if
    else
      resi_alias = splitbuffer(2)
    end if

    if (resi_alias /= '') then
      if (size(splitbuffer) > 2) then ! not an alias but a class
        if (len_trim(resi_alias) > len(resi_class)) then
          write (*, *) 'Error: invalid class name', trim(resi_alias)
          write (*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
          return
        else
          resi_class = resi_alias(1:4)
          resi_alias = ''
        end if

        if (size(splitbuffer) == 3) then
          resi_alias = splitbuffer(3)
        else
          read (splitbuffer(3), *, iostat=ierror) resi_number
          if (ierror /= 0) then
            write (*, *) 'Error: invalid resi number ', trim(splitbuffer(3))
            write (*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
            return
          end if
          resi_alias = splitbuffer(4)
        end if
      end if
    end if

    do i = 1, resi_list_index
      if (resi_list(i)%class == resi_class .and. &
      & resi_list(i)%number == resi_number .and. &
      & resi_list(i)%alias == resi_alias) then
        write (*, *) 'Error: RESI already used at line ', resi_list(i)%shelx_line_number
        write (*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        current_resi_index = i
        return
      end if
    end do

    if (resi_class /= '' .or. resi_number /= 0 .or. resi_alias /= '') then
      resi_list_index = resi_list_index+1
      resi_list(resi_list_index)%class = resi_class
      resi_list(resi_list_index)%number = resi_number
      resi_list(resi_list_index)%alias = resi_alias
      resi_list(resi_list_index)%shelx_line_number = shelxline%line_number
      current_resi_index = resi_list_index
    else
      current_resi_index = 0
    end if
  end subroutine

!> Parse PART keyword. Change the current part to the new value found.<br />
!! This instruction is not used in crystals, parts are recovered from the use of free variables in occupancy.
  subroutine shelx_part(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline
    integer iostatus

    read (shelxline%line(5:), *, iostat=iostatus) part, part_sof
    if (iostatus /= 0) then
      read (shelxline%line(5:), *, iostat=iostatus) part
      part_sof = -1.0
      if (iostatus /= 0) then
        part = 0
        write (log_unit, *) 'Error: syntax error in PART instruction'
        write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no = summary%error_no+1
      end if
    end if

    if (part < 0) then
      part = -part
      write (log_unit, *) 'Error: Suppression of special position constraints not supported'
      write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
      summary%error_no = summary%error_no+1
    end if

  end subroutine

!> Parse SAME keyword.
  subroutine shelx_same(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline
    type(resi_t) :: same_residue
    type(atom_shelx_t) :: keyword
    integer i

    if (len_trim(shelxline%line) < 5) then
      write (log_unit, *) 'Error: Empty SAME'
      write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
      summary%error_no = summary%error_no+1
      return
    end if

    i = index(shelxline%line, ' ')
    keyword = atom_shelx_t(shelxline%line)
    same_residue = keyword%resi

    same_table_index = same_table_index+1
    same_table(same_table_index)%shelxline = trim(shelxline%line)
    same_table(same_table_index)%line_number = shelxline%line_number
    same_table(same_table_index)%esd1 = 0.0
    same_table(same_table_index)%esd2 = 0.0
  end subroutine

!> Parse the EADP keyword. Restrain Plane
  subroutine shelx_eadp(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline
    integer start, iostatus
    integer :: numatom
    character(len=lenlabel), dimension(:), allocatable :: splitbuffer
    character(len=:), allocatable :: stripline
    type(atom_shelx_t) :: keyword

    write (log_unit, *) 'Warning: EADP implemented as a restraint'
    write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)

    if (len_trim(shelxline%line) < 5) then
      write (log_unit, *) 'Error: Empty EADP'
      write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
      summary%error_no = summary%error_no+1
      return
    end if

    if (index(shelxline%line, '<') > 0 .or. index(shelxline%line, '>') > 0) then
      write (log_unit, *) 'Error: < or > is not implemented'
      write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
      summary%error_no = summary%error_no+1
      return
    end if

    call deduplicates(shelxline%line, stripline)
    call to_upper(stripline)
    call explode(stripline, lenlabel, splitbuffer)
    keyword = atom_shelx_t(splitbuffer(1))

    ! first element is the number of atoms (optional)
    read (splitbuffer(2), *, iostat=iostatus) numatom
    if (iostatus /= 0) then
      numatom = -1
      start = 1
    else
      start = 2
      if (numatom < 2) then
        write (log_unit, *) "Error: 2 atoms needed at least for EADP"
        write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no = summary%error_no+1
        return
      end if
    end if

    !print *, splitbuffer
    eadp_table_index = eadp_table_index+1
    allocate (eadp_table(eadp_table_index)%atoms(size(splitbuffer)-start))
    call to_upper(splitbuffer(start+1:size(splitbuffer)), eadp_table(eadp_table_index)%atoms)
    eadp_table(eadp_table_index)%shelxline = trim(shelxline%line)
    eadp_table(eadp_table_index)%line_number = shelxline%line_number
    eadp_table(eadp_table_index)%residue = keyword%resi

  end subroutine

!> Parse the RIGU keyword. Restrain Plane
  subroutine shelx_rigu(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline

    rigu_table_index = rigu_table_index+1
    rigu_table(rigu_table_index)%shelxline = trim(shelxline%line)
    rigu_table(rigu_table_index)%line_number = shelxline%line_number

  end subroutine

!> Parse the END keyword. Set the_end to true.
  subroutine shelx_end(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline

    the_end = .true.

  end subroutine

!> Parse the ISOR keyword. Restrain to isotropic
  subroutine shelx_isor(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline

    if (len_trim(shelxline%line) < 5) then
      write (log_unit, *) 'Error: Empty ISOR'
      write (log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
      summary%error_no = summary%error_no+1
      return
    end if

    isor_table_index = isor_table_index+1
    isor_table(isor_table_index)%shelxline = trim(shelxline%line)
    isor_table(isor_table_index)%line_number = shelxline%line_number
    isor_table(isor_table_index)%esd1 = 0.0
    isor_table(isor_table_index)%esd2 = 0.0

  end subroutine

!> Parse the SHEL keyword.
  subroutine shelx_shel(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline
    integer iostatus
    character(len=256) :: errormsg

    read (shelxline%line(5:), *, iostat=iostatus, iomsg=errormsg) omitlist%shel
    if (iostatus < 0) then
      write (*, *) 'Error: wrongly formatted SHEL command'
      write (*, *) trim(errormsg)
      write (*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
    else if (iostatus > 0) then
      write (*, *) 'Error while reading SHEL command:'
      write (*, *) trim(errormsg)
      write (*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
      call abort
    end if
  end subroutine

!> Parse the OMIT keyword.
  subroutine shelx_omit(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline
    character(len=512) :: buffer
    integer i, j, k
    character(len=16), dimension(3) :: buffer3
    integer, dimension(:, :), allocatable :: tmp

    ! check what we have, 3 hkl indices or 2 values.
    buffer3 = ''
    j = 0
    k = 0
    buffer = adjustl(shelxline%line(6:)) !first 5 char are "OMIT "
    i = 1
    do while (i <= len_trim(buffer))
      if (.not. isanumber(buffer(i:i))) then
        i = i+1
        cycle
      else
        k = 1
        j = j+1
        if (j > 3) then
          print *, 'Omit invalid'
          call abort()
        end if
        do while (i <= len_trim(buffer))
          if (isanumber(buffer(i:i))) then
            buffer3(j) (k:k) = buffer(i:i)
            k = k+1
            i = i+1
          else
            exit
          end if
        end do
      end if
    end do

    if (j == 2) then
      read (buffer3(2), *) omitlist%twotheta
    else if (j == 3) then
      if (.not. allocated(omitlist%hkl)) then
        allocate (omitlist%hkl(1024, 3))
        omitlist%index = 0
        omitlist%hkl = 0
      else
        if (omitlist%index == ubound(omitlist%hkl, 1)) then
          ! array too small, increasing...
          call move_alloc(omitlist%hkl, tmp)
          allocate (omitlist%hkl(ubound(tmp, 1)+1024, 3))
          omitlist%hkl(1:ubound(tmp, 1), :) = tmp
          omitlist%hkl(ubound(tmp, 1)+1:, :) = 0
          deallocate (tmp)
        end if
      end if

      omitlist%index = omitlist%index+1
      read (buffer3, *) omitlist%hkl(omitlist%index, :)
    end if

  contains

    logical function isanumber(c)
      implicit none
      character, intent(in) :: c
      character, dimension(13), parameter :: numbers = (/'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '-', '+'/)
      integer i

      isanumber = .false.
      do i = 1, size(numbers)
        if (numbers(i) == c) then
          isanumber = .true.
          return
        end if
      end do

    end function
  end subroutine

!> Parse the WGHT keyword.
  subroutine shelx_wght(shelxline)
    use crystal_data_m
    implicit none
    type(line_t), intent(in) :: shelxline
    character(len=:), allocatable :: stripline
    character(len=lenlabel), dimension(:), allocatable :: splitbuffer
    integer iostatus
    character(len=256) :: errormsg
    integer i

    ! load default values
    list4 = (/0.1, 0.0, 0.0, 0.0, 0.0, 1.0/3.0/)

    call deduplicates(trim(shelxline%line), stripline)
    call explode(stripline, lenlabel, splitbuffer)

    do i = 2, size(splitbuffer)
      read (splitbuffer(i), *, iostat=iostatus, iomsg=errormsg) list4(i-1)
      if (iostatus /= 0) then
        write (*, *) 'Error: wrongly formatted WGHT command'
        write (*, *) trim(errormsg)
        write (*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        write (*, *) splitbuffer(i)
      end if
    end do
  end subroutine

end module
