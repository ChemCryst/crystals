C   This provides functions for reading and creating a list of paired parameters
C   The list is a list of lists.
C   The first element of the list is the size of the contained list at that point
C   and a pointer to the start of the next list from that point in the list. This
C   value can also be less then zero. If this is the value is a flag and there is
C   no data to follow. 
C   The first list in the list is implicitly the list of parameters paired with 
C   parameter 1. The second list is for the 2nd parameter and so on.
C   Also all parameters are implicitly paired with them selves.
C   A pair is of the for (n, m) where forall n > m 
C   Flags are:
C    -1 :  All paramters are paired with the current parameter
C   An example with the pairs of parameter numbers (1, 1) (1,2) (1, 3) (1, 4) (2, 2) (3, 3) (3, 4) (4, 4) (4, 5)
C   3   <- Number of numbers to follow and pointer to list for param 2. 
C    2   (1, 2)
C    3   (1, 3)
C    4   (1, 4)
C   0   <- Param 2's list. There are no pairs
C   1   <- Param 3's list
C   4   (3, 4)
C   -1  <- Param 4's list. Paired with all parameters.
C       No need for param 5 as it is implicitly paired with it's self

C======================================================================C
C                            List routines                             C
C======================================================================C  

code for list_insert_item
      integer function list_insert_item(list, list_length, loc, 
     1     item)
      implicit none
C
C     Inserts a value into a list at loc moving all the elements 
C     which are there already up.
C
C     Warning: You mush have allocated enough room all ready to 
C     the list leaving space for the new item
C 
C     returns the new length of the list.
C
      integer list_length
      integer list(list_length)  ! list to insert into
      integer loc                ! location to insert item
      integer item               ! Item to insert

      call xmove(list(loc), list(loc+1), list_length-(loc))
      list(loc) = item
      list_insert_item = list_length+1
      end

C======================================================================C
C                        Sorted List routines                          C
C======================================================================C

code for slist_search_for_bridge
      integer function slist_search_for_bridge(a, b, c, d, e)
C
C     g77 does not handle the recusive functions or subroutines
C     this is a hack to get round it because it obviously can as
C     it's on a turing machine which is closed under primative recursion
C
      implicit none
      integer a, b, c, d, e
C --------- Functions called ---------
      integer slist_search_for
      
      slist_search_for_bridge = slist_search_for(a, b, c, d, e)
      end                             

    
Code for slist_search_for
      integer function slist_search_for(list, list_size, 
     1     start, finish, value)
      implicit none
C
C     Searches a sorted list of integers for value
C
C     returns the position of the value in the list or the position 
C     the value should be if negative.
C     if the value -3 is returned the value should be stored in position 3
C
      integer list_size
      integer list(list_size)   ! The list to search in
      integer start             ! The start of the list to be searched in
      integer finish            ! The last element in the list to be search to
      integer value             ! The value to find in the list
      integer curr_pos          ! the current position in the list
C --------- Functions called ---------
      integer slist_search_for_bridge        ! A function to do the recursion with g77
      
      curr_pos = nint(float(finish-start)/2.0)+start
      if (start .lt. finish) then
         if (value .lt. list(curr_pos)) then
            slist_search_for = slist_search_for_bridge(list, list_size,  
     1           start, curr_pos-1, value)
            return
         else if(value .gt. list(curr_pos)) then
            slist_search_for = slist_search_for_bridge(list, list_size, 
     1           curr_pos+1, finish, value)
            return
         end if
      end if

      if (list(curr_pos) .lt. value) then
         slist_search_for = -(curr_pos+1)
      else if(list(curr_pos) .gt. value) then
         slist_search_for = -curr_pos
      else
         slist_search_for = curr_pos
      end if       
      end
 
code for slist_add_item
      integer function slist_add_item(list, list_size, list_len, item)
      implicit none
C
C     Adds an ITEM to a sorted list. Not adding duplicates
C     Returns the new size of the list or 0 if nothing was added to the list
C      
      integer list_size, list_len
      integer list(list_size) ! list to insert into
      integer item            ! Item to insert
      integer pos
C --------- Functions called ---------
      integer slist_search_for, list_insert_item
      
      if (list_size .gt. 0) then
          pos = slist_search_for(list, list_size, 1, list_len, item)
      else
         pos = -1
      end if
      slist_add_item = 0
      if (pos .lt. 0) 
     1  slist_add_item = list_insert_item(list, list_size, -pos, item)
      end

C======================================================================C
C                         Param List routines                          C
C======================================================================C     

CODE FOR PARAM_LIST_MAKE
      integer function param_list_make(results, results_size, 
     1     der_stack_add, size_of_parameter)
C
C     Make the param list describe earlier
C     Returns the amount of space used    
C
\ISTORE
\STORE
\XLST05
\XLST41
\XLST22
\XLST12
\QSTORE
      integer results_size
      integer results(results_size)
      integer atom_links(N5+md12o)    ! An array of links to the atom and parameter parts in L12
      integer atom_one          ! the index of the current first atom
      integer atom_two          ! the index of the current second atom
      integer der_stack_add     ! the address of the derivitive stack. Needed to compute the parameter numbers
      integer size_of_parameter ! the size of the parameters on the derivitive stack
C --------- Functions called ---------
      integer param_list_pair_all
      integer param_list_add_pair

      param_list_make = n12+md12o ! set the param list to the number of parameters there are

      call XZEROF(atom_links(1), N5+md120) ! zero all the links.
      call XZEROF(results, results_size) ! zero all the results.

      if (KHUNTR (5, 0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL05
C
C--------------------set up the atom links------------------------
c      
      I = 1
      M12 = L12
      do while (M12 .ge. 0)
         atom_links(I) = ISTORE(m12+1)
         M12 = ISTORE(M12)
         I = I + 1
      end do
c      
      if (KHUNTR (41, 0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL41 ! Load list 40 if it needs to be.
      
C Add in the over all parameters
      atom_one = istore(l12o+1)
      do curr_param1 = istore(atom_one + 2), istore(atom_one + 3),
     1     istore(atom_one + 1)
         if ((istore(curr_param1)-der_stack_add)/size_of_parameter+1 
     1        .gt. 0)
     2        param_list_make = param_list_pair_all(results, 
     3        results_size, param_list_make, 
     4        (istore(curr_param1)-der_stack_add)/size_of_parameter+1)
      end do      
C Add all atom pairs 
      do I = 1, n5 ! Run though all the atoms in the list
         atom_one = atom_links(I) ! Atom 1's current part
         do while (atom_one .gt. 0) ! loop though the parts         
C     Loop though the parameters for this part 
            do curr_param1 = istore(atom_one + 2), istore(atom_one + 3),
     1           istore(atom_one + 1)
               do curr_param2 = curr_param1 + istore(atom_one + 1),
     1              istore(atom_one + 3), istore(atom_one + 1) 
                  param_list_make = param_list_add_pair(
     1                 results, results_size, param_list_make,
     2                 (istore(curr_param1)-der_stack_add)/
     3                 size_of_parameter+1, 
     4                 (istore(curr_param2)-der_stack_add)/
     5                 size_of_parameter+1, n12+md12o)
               end do
            end do
            atom_one = istore(atom_one) 
         end do
      enddo
C Add the bond pairs 
      do M41B = (MD41B*(N41B-1))+L41B, L41B, -MD41B ! Run though all the atoms pairs in the list. For the bottom up
         atom_one = atom_links(istore(M41B)+1) ! Atom 1's current part
         do while (atom_one .gt. 0) ! loop though the parts
C     Loop though the parameters for this part of atom_one
            do curr_param1 = istore(atom_one + 2), istore(atom_one + 3), 
     1           istore(atom_one + 1)
               atom_two = atom_links(istore(M41B+6)+1) ! Atom 2's current part
               do while (atom_two .gt. 0) ! loop though the parts
C     Loop though the parameters for this part of atom_two
                  if (atom_two .ne. atom_one) then
                     do curr_param2 = istore(atom_two + 2), 
     1                    istore(atom_two + 3), istore(atom_two + 1)
                        param_list_make = param_list_add_pair(
     1                       results, results_size, param_list_make,
     2                       (istore(curr_param1)-der_stack_add)/
     3                       size_of_parameter+1, 
     4                       (istore(curr_param2)-der_stack_add)/
     5                       size_of_parameter+1, n12+md12o)
                        
                     end do
                  end if
                  atom_two = istore(atom_two) ! Move to next part or atom 2
               end do
            end do
            atom_one = istore(atom_one) ! Move to next part of atom 1
         end do
      end do
C      call param_list_print(results, param_list_make)
      return 
      end

code for param_list_print
      subroutine param_list_print(results, results_size)
C
C     Outputs a param list to the standard output.
C
      implicit none
      integer results_size
      integer results(results_size)
      integer cur_pos
      integer i, j    
      
      print *, results ! outputs the raw data
      i = 1
      cur_pos = 1
      do while (cur_pos .le. results_size) ! Run through each parameter print
         print *, 'Parameter ', i, results(cur_pos)
         if (results(cur_pos) .ge. 0) then
            print *, (results(j), j=cur_pos+1, ! print the list for the current parameter
     1           cur_pos+results(cur_pos))
            cur_pos = results(cur_pos)+cur_pos+1
         else
            print *, 'All'
            cur_pos = cur_pos+1
         end if
         i = i + 1
      end do
      end

code for param_list_add_pair
      integer function param_list_add_pair(results, results_size, 
     1     results_length, param1, param2, max_param)
      implicit none
C     
C     Adds the parameter id pair to a parampair list. It doesn't check to see if the pair has been added before.
C     Expands the amount of or results used as appropriat
C     
C     return - returns the new amount of space used to store the result.
C
      integer results_size  ! The maximum amount of space available to the results
      integer results_length ! The current length of the list
      integer results(results_size) ! this is an array for the result to be stored in.
      integer param1, param2 ! The parameters number to be added to the list
      integer param_one ! The minimum of the two parameter numbers
      integer param_two ! The maximum of the to parameters
      integer cur_loc   ! A pointer to the current possition in the last
      integer max_param ! The max number of parameters used to know if a full row is used
      integer i         ! temporary counter
C --------- Functions called ---------
      integer param_list_find_param, slist_add_item 
      integer param_list_pair_all
      

      if (param1 .ne.  param2) then ! we don't want to include the diagonal because it's implicit
         param_one = min(param1, param2)
         param_two = max(param1, param2)
         
         cur_loc = param_list_find_param(results, results_size, 
     1        param_one)

         if (cur_loc .gt. results_length) then 
C     If the param being added to is past the current length of the
C     results
            param_list_add_pair = cur_loc
         else
            param_list_add_pair = results_length
         end if
         
         if (results(cur_loc) .ge. 0) then ! check that they haven't all, already include
            if (slist_add_item(results(cur_loc+1), param_list_add_pair-
     1           (cur_loc), results(cur_loc), param_two) .gt. 0) then 
C If something has been added to the list then
               results(cur_loc) = results(cur_loc) + 1
               param_list_add_pair = param_list_add_pair + 1
C   If all the parameters are included set the number to -1 to save space 
C   and time probably will never happen
               if (results(cur_loc) .ge. max_param-param_one) then 
                  param_list_add_pair = param_list_pair_all(results, 
     2                 results_size, param_list_add_pair, param_one)
               end if
            end if
         end if
         

c         call xmove(results(results(cur_loc)+cur_loc+1), 
c     1        results(results(cur_loc)+cur_loc+2), 
c     2        results_length-(results(cur_loc)+cur_loc))
c         results(cur_loc) = results(cur_loc) + 1
c         results(results(cur_loc)+cur_loc) = param_two
c         param_list_add_pair = max(results_length + 1, results(cur_loc)+
c     1        cur_loc)
      else
         param_list_add_pair = results_length   
      end if
      return
      end

code for param_list_pair_all
      integer function  param_list_pair_all(results, results_size, 
     1     results_length, param)
      implicit none
C
C     Sets the the parameter in results so that it is paired with all 
C     other parameters
C
C     return - returns the new amount of space used to store the result.
C
      integer results_size  ! The maximum amount of space available to the results
      integer results_length ! The current length of the list
      integer results(results_size) ! this is an array for the result to be stored in.
      integer param
      integer cur_pos
      integer old_size
C --------- Functions called ---------
      integer param_list_find_param

      cur_pos = param_list_find_param(results, results_size, param)
      old_size = results(cur_pos)
      results(cur_pos) = -1
      if (old_size .gt. 0) 
     1     call xmove(results(cur_pos+old_size+1), results(cur_pos+1), 
     2     results_size-cur_pos-old_size)
      param_list_pair_all = results_length - old_size
      return 
      end

code for param_list_find_param
      integer function param_list_find_param(results, results_size, 
     1     param)
C
C    Find the position in results where the list of parameters for param are kept
C    Returns the position of param's list in results
C
      implicit none
      integer results_size
      integer results(results_size) ! Param list to search
      integer param                 ! Param to find the position of
      integer cur_pos               ! current position in the list
      integer i                     
      
      cur_pos = 1
      do i = 1, (param-1)
         if (results(cur_pos) .gt. 0) then
            cur_pos = results(cur_pos) + cur_pos + 1
         else
            cur_pos = cur_pos+1
         end if
      end do
      param_list_find_param = cur_pos
      return 
      end
      
