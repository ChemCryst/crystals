C $Log: not supported by cvs2svn $
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
C     Description:
C        Inserts a value into a list at loc moving all the elements 
C       which are there already up.
C
C     Precondition:
C        Enough room for all the items plus one must be allocated before
C       hande 
C 
C     returns: 
C        The new length of the list.
C
C  ================   Arguments   ================
      integer list_length
      integer list(list_length)  ! list to insert into
      integer loc                ! location to insert item
      integer item               ! Item to insert

      call xmove(list(loc), list(loc+1), list_length-(loc-1))
      list(loc) = item
      list_insert_item = list_length+1
      end

C======================================================================C
C                        Sorted List routines                          C
C======================================================================C

CODE FOR slist_search_for_bridge
      integer function slist_search_for_bridge(a, b, c, d, e)
      implicit none
C
C     Description:
C        g77 does not handle the recusive functions or subroutines
C       this is a hack to get round it because it obviously can as
C       it's on a turing machine which is closed under primative 
C       recursion
C     Returns:
C        The result of slist_search_for
C
C  ================   Arguments   ================
      integer a, b, c, d, e
C  ================Function calls ================
      integer slist_search_for
      
      slist_search_for_bridge = slist_search_for(a, b, c, d, e)
      end                             

    
CODE FOR slist_search_for
      integer function slist_search_for(list, list_size, 
     1     start, finish, value)
      implicit none
C
C     Description:
C        Searches a sorted list of integers for value
C
C     Returns: 
C        The position of the value in the list or the position 
C       the value should be but negative. if the value -3 is 
C       returned the value should be stored in position 3
C
C  ================   Arguments   ================
      integer list_size
      integer list(list_size)   ! The list to search in
      integer start             ! The start of the list to be searched in
      integer finish            ! The last element in the list to be search to
      integer value             ! The value to find in the list
C  ================Local Variables================      
      integer curr_pos          ! the current position in the list
C  ================Function calls ================
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
      
      if (list_size .gt. 0) then    ! If the list is not empty 
          pos = slist_search_for(list, list_size, 1, list_len, item) ! Find the number we are adding.
      else
         pos = -1
      end if
      slist_add_item = 0
      if (pos .lt. 0) then         ! If there value wasn't found then add it.
            slist_add_item = list_insert_item(list, list_size, -pos,
     1       item)
      end if
      end

C======================================================================C
C                         Param List routines                          C
C======================================================================C     
CODE FOR PARAM_LIST_MAKE
      integer function param_list_make(results,
     1     der_stack_add, size_of_parameter)
C      integer function param_list_make(results, results_size, 
C     1     der_stack_add, size_of_parameter)
C
C     Make the param list describe earlier
C     Memory should not be allocated anywhere withing this function 
C     unless you really know what you are doing
C     Returns the amount of space used    
C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST22.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'QSTORE.INC'
            
      integer results
      integer iresults              ! Just somewhere to put a number
C      integer results_size
C      integer results(results_size)
      integer der_stack_add         ! the address of the derivitive stack. Needed to compute the parameter numbers
      integer size_of_parameter     ! the size of the parameters on the derivitive stack
C  ================Local Variables================
      integer atom_links(N5 + 6)    ! An array of links to the atom and parameter parts in L12 plus some possible extra parameters
      integer I
      integer group_iterator(2)     ! Chain iterators  
      
      integer cur_pos
C --------- Functions called ---------
      integer chain_iter_next
      logical iter_has_next

      integer param_list_add_oa_params
      integer param_list_add_groups_pairs
      integer param_list_add_bonds
      param_list_make = n12 ! set the param list to the number of parameters there are

C--------------Load all the lists we need here-------
C   has to be done here because we are going to write over memory we don't have yet
C
      if (KHUNTR (5, 0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL05
      if (KHUNTR (41, 0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL41 ! Load list 41 if it needs to be.
      
      results = KSTALL(n12)                     !Allocate all the memory once everything has been read in.
      call XZEROF(atom_links(1), N5 + 6)        ! zero all the links.
      call XZEROF(istore(results), n12)         ! zero all the results.
C
C--------------------set up the atom links------------------------
c      
      I = 1
      call chain_iter_create(group_iterator, L12, 0)
      do while (iter_has_next(group_iterator))
         atom_links(I) = chain_iter_next(group_iterator)
         I = I + 1
      end do
           
      
      
      param_list_make = param_list_add_oa_params(istore(results), 
     1 param_list_make, param_list_make, istore(l12o+1), der_stack_add,
     2 size_of_parameter)
      param_list_make = param_list_add_groups_pairs(istore(results), 
     1 param_list_make, param_list_make, atom_links, N5, der_stack_add, 
     2 size_of_parameter)
      param_list_make = param_list_add_bonds(istore(results),
     1 param_list_make, param_list_make, atom_links, N5, der_stack_add,
     2 size_of_parameter)
      iresults = KSTALL(param_list_make-n12)
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
      
c      print *, results ! outputs the raw data
      i = 1
      cur_pos = 1
      do while (cur_pos .le. results_size) ! Run through each parameter print
c         print *, 'Parameter ', i, results(cur_pos)
         if (results(cur_pos) .ge. 0) then
c            print *, (results(j), j=cur_pos+1, ! print the list for the current parameter
     1           cur_pos+results(cur_pos))
            cur_pos = results(cur_pos)+cur_pos+1
         else
c            print *, 'All'
            cur_pos = cur_pos+1
         end if
         i = i + 1
      end do
      if (cur_pos .ge. results_size) then
c       print *, 'The param list is actualy longer then we think it is!'
c       print '(A, I5, A)', 'It is ', cur_pos-results_size, ' larger.'
      end if
      end

CODE FOR param_list_add_pair
      integer function param_list_add_pair(results, results_size, 
     1     results_length, param1, param2, max_param)
      implicit none
C     
C     Description:
C        Adds the parameter id pair to a parampair list. It does not add the same pair in twice.
C       Expands the amount of or results used as appropriat
C     
C     Returns: 
C         The new amount of space used to store the result.
C
C  ================   Arguments   ================
      integer results_size          ! The maximum amount of space available to the results
      integer results_length        ! The current length of the list
      integer results(results_size) ! this is an array for the result to be stored in.
      integer param1, param2        ! The parameters number to be added to the list
      integer max_param             ! The max number of parameters used to know if a full row is used
C  ================Local Variables================      
      integer param_one             ! The minimum of the two parameter numbers
      integer param_two             ! The maximum of the to parameters
      integer cur_loc               ! A pointer to the current possition in the last
      integer i                     ! temporary counter
C  ================Function calls ================
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
C   and time, probably will never happen
               if (results(cur_loc) .ge. max_param-param_one) then 
                  param_list_add_pair = param_list_pair_all(results, 
     2                 results_size, param_list_add_pair, param_one)
               end if
            end if
         end if
         
      else
         param_list_add_pair = results_length   
      end if
      end

CODE FOR param_list_pair_all
      integer function  param_list_pair_all(results, results_size, 
     1     results_length, param)
      implicit none
C
C     Description:
C        Sets the the parameter in results so that it is paired with all 
C       other parameters
C
C     returns:
C        The new amount of space used to store the result.
C
C  ================   Arguments   ================
      integer results_size  ! The maximum amount of space available to the results
      integer results_length ! The current length of the list
      integer results(results_size) ! this is an array for the result to be stored in.
      integer param
C  ================Local Variables================      
      integer cur_pos
      integer old_size
C  ================Function calls ================
      integer param_list_find_param

      cur_pos = param_list_find_param(results, results_size, param)
      old_size = results(cur_pos)
      results(cur_pos) = -1
      if (old_size .gt. 0) 
     1     call xmove(results(cur_pos+old_size+1), results(cur_pos+1), 
     2     results_length-cur_pos-old_size)
      param_list_pair_all = results_length - old_size 
      end

CODE FOR param_list_find_param
      integer function param_list_find_param(results, results_size, 
     1     param)
      implicit none
C
C     Description:
C        Find the position in results where the list of parameters for param
C       are kept
C
C    Returns: 
C        The position of param's list in results
C
C  ================   Arguments   ================
      integer results_size
      integer results(results_size) ! Param list to search
      integer param                 ! Param to find the position of
C  ================Local Variables================      
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
      end
      
code for param_list_count
      integer function  param_list_count(param_list, param_list_len)
C
C     Description:
C        Count the number of parameters which are a in the list param_list
C
C     Returns: 
C        The number of list for parameters which are in the list param_list
C        This should be the same size as param_list_len.
C
      implicit none
C  ================   Arguments   ================            
      integer param_list_len
      integer param_list(param_list_len)
C  ================Local Variables================      
      integer param_count
      integer curr_pos
      
      curr_pos = 1
      param_count = 0
      do while (curr_pos .le. param_list_len)
            param_count = param_count + 1
            if (param_list(curr_pos) .gt. 0) then
                  curr_pos = curr_pos + param_list(curr_pos) + 1
            else
                  curr_pos = curr_pos + 1
            end if
      end do
      param_list_count =param_count
      end
      
      integer function param_list_add_oa_params(results, results_size, 
     1 results_curr_size, oa_first_part_add, der_stack_add, 
     2 size_of_parameter)
C     
C     Description:
C           Adds all the parameter pairs in for the over all parameters.
C
C     Returns: 
C         The new amount of space used to store the result.
C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'QSTORE.INC'
C  ================   Arguments   ================      
      integer results_size          ! The maximum size which the results should have. This is ignored even though it shouldn't be.
      integer results(results_size) ! The param list
      integer results_curr_size     ! The current size of the param lis
      integer oa_first_part_add     ! The address of the first part of the overall parameters group. "istore(l12o+1)"
C      integer param_list_add_oa_params    ! The new current size of the param list is returned
      integer der_stack_add         ! the address of the derivitive stack. Needed to compute the parameter numbers
      integer size_of_parameter     ! the size of the parameters on the derivitive stack

C  ================Local Variables================      
      integer part_iterator1(2)     ! Chain iterators
      integer param_iterator1(3)    ! list iterators
      integer curr_add              ! Temp store for an address
      integer curr_param
C  ================Function calls ================
      integer param_list_pair_all
      integer chain_iter_next
      logical iter_has_next
      
C Add in the over all parameters
      param_list_add_oa_params = results_curr_size
      call chain_iter_create(part_iterator1, oa_first_part_add, 0) ! create an interator to work through the different parts
      do while (iter_has_next(part_iterator1))                     ! Whilest there are still parts to work through
            curr_add = chain_iter_next(part_iterator1)             ! Get the address of the current part
            if (istore(curr_add+1) .gt. 0) then                    ! Check that there is something in this part
                  call part_create_list_iter(param_iterator1,     
     1             istore(curr_add))                               ! create an iterator to work through the parameters in this part
                  do while (iter_has_next(param_iterator1))        ! Whilest there are parameters to work through
                        curr_param = istore(
     1                   list_iter_next(param_iterator1)) 
                     if (curr_param .ge. der_stack_add) then       ! Check that this parameter is to be refined.
                        param_list_add_oa_params = param_list_pair_all(     ! Pair this parameters with all the parameters.
     1                 results, results_size, param_list_add_oa_params, 
     2                   (curr_param-der_stack_add)/
     3                   size_of_parameter+1)
                      end if
                  end do 
            end if
      end do
      end 
      
      integer function param_list_add_groups_pairs(results, 
     2 results_size, results_curr_size, group_adds, num_of_groups, 
     3 der_stack_add, size_of_parameter)
      implicit none
C     
C     Description:
C         Adds all the pairs of parameters from a groups paired with
C        the parameters from the same groups. i.e. Adds in the diagonal elements.
C
C     Arguments:
C           group_adds - an array of addesses in istore which point to the first
C          part of a group. These are the groups to be pairs with them selves
C     
C     Returns: 
C         The new amount of space used to store the result.
C
C  ================   Arguments   ================      
      integer results_size          ! The maximum size which the results should have. This is ignored even though it shouldn't be.
      integer results(results_size) ! The param list
      integer results_curr_size     ! The current size of the param lis
      integer num_of_groups         ! The number of groups.
      integer group_adds(num_of_groups)   ! The addresses of the groups to be added to the param list
      integer der_stack_add         ! the address of the derivitive stack. Needed to compute the parameter numbers
      integer size_of_parameter     ! the size of the parameters on the derivitive stack
C  ================Local Variables================             
      integer I
C  ================Function calls ================      
      integer param_list_add_group_pairs  ! Returns the amount of space the param list is taking up.
      
      param_list_add_groups_pairs = results_curr_size
C Add all group pairs
      do I = 1, num_of_groups       ! Run through all the groups
            param_list_add_groups_pairs = 
     1       param_list_add_group_pairs(results, results_size, 
     2       param_list_add_groups_pairs, group_adds(I)+1,
     3       der_stack_add, size_of_parameter)
      end do
      end
      
      integer function param_list_add_group_pairs(results, 
     2 results_size, results_curr_size, group_add, der_stack_add,
     3 size_of_parameter)
     
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'QSTORE.INC'
C     
C     Description:
C         Adds all the pairs of parameters from a group paired with
C        the parameters from the same group. i.e. Adds in one block along the 
C        diagonal
C
C     Arguments:
C           group_add - The address from within istore of the first part of the group.
C     
C     Returns: 
C         The new amount of space used to store the result.
C
C  ================   Arguments   ================
      integer results_size          ! The maximum size which the results should have. This is ignored even though it shouldn't be.
      integer results(results_size) ! The param list
      integer results_curr_size     ! The current size of the param list
      integer group_add             ! The address of the group to be added to the param list
      integer der_stack_add         ! the address of the derivitive stack. Needed to compute the parameter numbers
      integer size_of_parameter     ! the size of the parameters on the derivitive stack
C  ================Local Variables================ 
      integer atom_one              ! the index of the current first atom
      integer atom_two              ! the index of the current second atom
      
      integer part_iterator1(2)     ! Chain iterators
      integer part_iterator2(2), part_iterator_start2(2)
      integer param_iterator1(3)    ! list iterators
      integer param_iterator2(3)        
      
      integer curr_param1, curr_param2
C  ================Function calls ================      
      integer chain_iter_next
      integer list_iter_next
      integer param_list_add_pair
      logical iter_has_next

      param_list_add_group_pairs = results_curr_size
      call chain_iter_create(part_iterator1, 
     1 istore(group_add), 0)
      do while (iter_has_next(part_iterator1))                       ! Run though the different parts of the current atom
        call xmove(part_iterator1, part_iterator_start2, 2)
        atom_one = chain_iter_next(part_iterator1)                   ! Get the current part of the atom
        call part_create_list_iter(param_iterator1,                  ! Create an iterator to go through the parameters
     1   istore(atom_one))
        do while (iter_has_next(param_iterator1))                    ! Whilst we still have parameters to add
            curr_param1 = list_iter_next(param_iterator1)            ! Get the current parameter
            if (istore(curr_param1) .ge. der_stack_add) then
                call xmove(part_iterator_start2, part_iterator2, 2)  ! We want to go from here onwards
                call xmove(param_iterator1, param_iterator2, 3)
                do while (iter_has_next(part_iterator2))             ! Run though the different parts of the current atom again
                    atom_two = chain_iter_next(part_iterator2)
                    if (atom_two .ne. atom_one) then                 ! This should never happen but as I cannot be bothered thinking about it to make sure I'm just going to leave it here for now.
                        call part_create_list_iter(                  ! Create an iterator to go through the parameters
     1                         param_iterator2, istore(atom_two))
                    end if
                    do while (iter_has_next(param_iterator2))        ! Run though all the parameters in the current part
                        curr_param2 = list_iter_next(
     1                         param_iterator2)                      ! Get the current parameter
                        if (istore(curr_param2) .ge. 
     1                         der_stack_add) then
                  param_list_add_group_pairs = param_list_add_pair(    ! Add in the paramter to the list
     1              results, results_size, param_list_add_group_pairs,
     2                           (istore(curr_param1)-der_stack_add)/
     3                           size_of_parameter+1, 
     4                           (istore(curr_param2)-der_stack_add)/
     5                           size_of_parameter+1, n12+md12o)

                        end if
                    end do
                end do
            end if
       end do
      end do
      end
      
      integer function param_list_add_bonds(results, results_size, 
     1 results_curr_size, atom_array, atom_array_size, der_stack_add,
     2 size_of_parameter)
     
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST41.INC'
      INCLUDE 'QSTORE.INC'

C  ================   Arguments   ================
      integer results_size          ! The maximum size which the results should have. This is ignored even though it shouldn't be.
      integer results(results_size) ! The param list
      integer results_curr_size     ! The current size of the param list
      integer atom_array_size       ! The number of atoms in the atom array
      integer atom_array(atom_array_size) ! The address of the first parts of all the atoms in oder of there number
      integer der_stack_add         ! the address of the derivitive stack. Needed to compute the parameter numbers
      integer size_of_parameter     ! the size of the parameters on the derivitive stack

C  ================Local Variables================  
      integer bond_iter(3)         ! The bond iterator.
      integer bond_add             ! Address of the current bond
C  ================Function calls ================ 
      integer param_list_add_group_group_pairs
      logical iter_has_next
      integer list_iter_next
      
      param_list_add_bonds = results_curr_size
      call list_iter_create1(bond_iter, -MD41B, (MD41B*(N41B-1))+L41B,
     1  L41B)                                                            ! Create iterator to run over the bonds
      do while (iter_has_next(bond_iter))                               ! While there are stil bond to process
            bond_add = list_iter_next(bond_iter)                         ! Get the address of the current bond
            param_list_add_bonds = param_list_add_group_group_pairs(
     1       results, results_size, param_list_add_bonds,
     2       atom_array(istore(bond_add)+1), atom_array(istore(
     3       bond_add+6)+1), der_stack_add, size_of_parameter)
      end do
      end
      
      integer function param_list_add_group_group_pairs(results, 
     1 results_size, results_curr_size, group1_add, group2_add, 
     2  der_stack_add, size_of_parameter)
C     
C     Description:
C           Takes to addresses pointing to the first part of each group and
C          Pairs all the parameters in the first group with all the parameters
C          in the second group
C     
C     Arguments:
C           group1_add - address of the first part of this groups
C           group12_add - address of the first part of this groups
C
C     Returns: 
C         The new amount of space used to store the result.
C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'QSTORE.INC'
C  ================   Arguments   ================
      integer results_size          ! The maximum size which the results should have. This is ignored even though it shouldn't be.
      integer results(results_size) ! The param list
      integer results_curr_size     ! The current size of the param list
      integer der_stack_add         ! the address of the derivitive stack. Needed to compute the parameter numbers
      integer size_of_parameter     ! the size of the parameters on the derivitive stack
      integer group1_add, group2_add! The addresses of the first part of the groups to pair
C      integer param_list_add_group_group_pairs
C  ================Local Variables================    
      integer atom_one              ! the index of the current first atom
      integer atom_two              ! the index of the current second atom
      
      integer group_iterator(2)     ! Chain iterators  
      integer part_iterator1(2)     ! Chain iterators
      integer part_iterator2(2)
      integer param_iterator1(3)    ! list iterators
      integer param_iterator2(3)    
      integer curr_param1, curr_param2
C  ================Function calls ================
      integer param_list_add_pair
      integer chain_iter_next
      integer list_iter_next
      logical iter_has_next
      
      
      param_list_add_group_group_pairs = results_curr_size
      atom_one = group1_add                                       ! Get the atom number and then use it to get the atoms address
      call chain_iter_create(part_iterator1, istore(atom_one+1), 
     1 0)
      do while (iter_has_next(part_iterator1))                    ! Loop though the parts of the first atom
            atom_one = chain_iter_next(part_iterator1)            ! Get the current part
            call part_create_list_iter(param_iterator1, 
     1       istore(atom_one))                                    ! Create an iterater which goes through the parameters of atoms ones part
            do while (iter_has_next(param_iterator1))             ! Whilst we still have parameters to work through
               curr_param1 = istore(list_iter_next(
     1          param_iterator1))                                 ! Get next parameter
               if (curr_param1 .ge. der_stack_add) then           ! Check that this is a parameter which is to be refined. 
               atom_two = group2_add        ! Get Atom 2's first part
               call chain_iter_create(part_iterator2,             ! Make an iterator to run over the different parts of atom two
     1          istore(atom_two+1), 0)
               do while (iter_has_next(part_iterator2))           ! iterator over the parts of atom two
                  atom_two = chain_iter_next(part_iterator2)      ! Get the atom twos current part
                  call part_create_list_iter(param_iterator2,     ! Create iterator to iterator over the parameters in atoms 2's current part
     1             istore(atom_two))
                  do while (iter_has_next(param_iterator2))       ! Whilst we still have parameters to work through in atoms 2's part
                      curr_param2 = istore(list_iter_next(
     1                 param_iterator2))                          ! Get next atom2's parameter
                    if (curr_param2 .ge. der_stack_add) then      ! Check that this is a parameter which is to be refined. 
                    param_list_add_group_group_pairs = 
     1                param_list_add_pair(results, results_size, 
     2               param_list_add_group_group_pairs,
     3               (curr_param1-der_stack_add)/
     4               size_of_parameter+1, 
     5               (curr_param2-der_stack_add)/
     6               size_of_parameter+1, n12)  ! Add parameter to list
                   end if
                  end do
               end do
               end if
            end do
      end do 
      end

C======================================================================C
C                         Iterator routines                            C
C======================================================================C      
C     
C     Functions and subroutines for traversing chains and lists
C

CODE FOR list_iter_create1
      subroutine list_iter_create1(iterator, step, startadd, endadd)
      implicit none
C
C      Creates a list interator specificaly for going through the parts
C     of an atom.
C
C     iterator   -   On return contains the information for iterating 
C                   with. This must be at least 3 words(integers) big.
C     part       -   The first element in the list.
C      
      integer iterator(3)            ! This is of the form [current, step, end]
      integer step, startadd, endadd ! Step size, start address and end address
      
      iterator(1) = startadd  
      iterator(2) = step
      iterator(3) = endadd
      end
      
CODE FOR list_iter_create2
      subroutine list_iter_create2(iterator, list_info, off_step, 
     1 off_start, off_end)
C
C     From a discription of a list this create an iterator. The iterator parameter passed must be 3 words long.
C     To iterate through the list use the function next_address_in_list
C
      implicit none
      
      integer iterator(3)     ! This is of the form [current, step, end]
      integer list_info(10)
      integer off_step, off_start, off_end
      
      call list_iter_create1(iterator, list_info(off_step),  
     1 list_info(off_start), list_info(off_end))            ! Let the other creater handle it
      end

CODE FOR list_iter_revs
      subroutine list_iter_revs(iterator)
      implicit none
C
C     Makes the iterator passed to it move from it's finish to the start
C
      integer iterator(3)
      integer temp
      
      iterator(2) = -iterator(2)    ! Change the direction we go through the list
      temp = iterator(3)            ! Save the now start pointer
      iterator(3) = iterator(1)     ! Make old start pointer new end pointer
      iterator(1) = temp            ! Make old end pointer new start pointer
      end
      
CODE FOR list_iter_next
      function list_iter_next(iterator)
      implicit none
C
C     This method returns the next address istore in the list or -1 if there are not more elements in the list.
C      
      integer list_iter_next  ! The return value is the address in iStore of the next 
                              ! element or -1 if there is no more.
      integer iterator(3)     ! This is of the form [current, step, end]
      
      list_iter_next = iterator(1)
      if (list_iter_next .gt. 0) then     ! Do we still have more to go?
            if (iterator(2) .gt. 0) then  ! Are we going forwards if so?
                  if (iterator(1)+iterator(2) .gt. iterator(3)) then ! Have we finished?
                        iterator(1) = -1  ! Remember we have reached the end
                  else
                        iterator(1) = iterator(1)+iterator(2)     ! Move on to the next one.
                  end if
            else
                  if (iterator(1)+iterator(2) .lt. iterator(3)) then ! Have we finished?
                        iterator(1) = -1  ! Remember we have reached the end
                  else
                        iterator(1) = iterator(1)+iterator(2)     ! Move on to the next one.
                  end if
            end if
      end if
      end
      
CODE FOR list_iter_count
      function list_iter_count(iterator)
      implicit none
      integer iterator(3)
      integer list_iter_count
      
      list_iter_count = (iterator(3) - iterator(1))/iterator(2) + 1
      if (list_iter_count .lt. 0) list_iter_count = 0
      end
      
CODE FOR iter_has_next
      function iter_has_next(iterator)
      implicit none
C
C     Returns true if there is at least one element left to iterate over
C     Should work for any type of iterator defined in this file
C
      logical iter_has_next
      integer iterator(1)
      
      iter_has_next = (iterator(1) .gt. 0)
      end
      
CODE FOR chain_iter_create
      subroutine chain_iter_create(iterator, chain, next_off)
      implicit none
C
C     Creates a chain iterator for iterating through chains
C     
C     iterator   - On return contains the information for iterating over the chain
C
C     chain      - The first element in the chain
C
C     next_off   - The position withing a chain element which contains the
C                  pointer to the next element in the chain
C      
      integer iterator(2) ! On return contains the first address in the chain and the 
                          ! offset of the address in an element [curr_add, offset]
      integer chain       ! Address to the first element in the chain.
      integer next_off    ! The offset within and element to where the next element is.
      
      iterator(1) = chain
      iterator(2) = next_off
      end

CODE FOR chain_iter_next       
      function chain_iter_next(iterator)
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'QSTORE.INC'
C
C     Returns the address of the next element in the chain.
C
C     iterator   -   On return contains the iterator for moving to the next element
C 
      integer chain_iter_next
      integer iterator(2)
      
      chain_iter_next = iterator(1)
      if (iterator(1) .gt. 0) then                          ! If there are still elements left then
            iterator(1) = istore(iterator(1)+iterator(2))   !Move to next element
      end if
      end
      
CODE FOR part_create_list_iter
      subroutine part_create_list_iter(iterator, part_info)
C
C      Creates a list iterator specificaly for going through the parameters in a part
C     of an atom.
C
C     iterator   -   On return contains the information for iterating 
C                   with. This must be at least 3 words(integers) big.
C     part       -   The information about the part
C
      implicit none
      integer iterator(3)
      integer part_info(5)         
      call list_iter_create2(iterator, part_info, 2, 3, 4)
      end

            
