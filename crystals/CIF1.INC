!        These declarations must be included in ciftbx user
!        applications along with CIF2
         integer NUMCHAR
         PARAMETER (NUMCHAR=48)
         integer MAXBUF
         PARAMETER (MAXBUF=200)
         logical   align_        ! Align loop active flag (true/false)
         logical   append_       ! Append next CIF to prior CIF (true/false)
         logical   tabl_         ! Set loop tabs flag (true/false)
         logical   tabx_         ! Input tab expansion flag (true/false)
         logical   ptabx_        ! Output tab expansion flag (true/false)
         logical   text_         ! Text active flag (true/false)
         logical   loop_         ! Loop active flag (true/false)
         logical   save_         ! Save frame active flag (true/false)
         logical   saveo_        ! Save frame output flag (true/false)
         logical   glob_         ! GlobaL block active flag (true/false)
         logical   globo_        ! Global block output flag (true/false)
         logical   alias_        ! Alias use flag (true/false)
         logical   aliaso_       ! Alias output mapping flag (true/false)
         logical   nblank_       ! No blank string flag (true/false)
         logical   nblanko_      ! No blank output string flag (true/false)
         logical   decp_         ! Found decimal point on numeric input (true/false)
         logical   pdecp_        ! Force decimal point on output (true/false)
         logical   lzero_        ! Found leading zero on numeric input (true/false)
         logical   plzero_       ! Force leading zero on output (true/false)
         integer   long_         ! Length of current data item in strg_
         integer   list_         ! Loop block number of current item    
         integer   longf_        ! Length of current filename in file_
         integer   esdlim_       ! Integer limit on esd's (9, 19, 29, etc.)
         integer   esddig_       ! Integer actual esd digits in input
         integer   pesddig_      ! Integer target esd digits in output
         integer   line_         ! User setable input line value
         integer   recbeg_       ! Record number of first input line to use
         integer   recend_       ! Record number of last input line to use
         integer   recn_         ! Record number of last input line in file
         integer   precn_        ! Record number of last last line
         integer   posnam_       ! Character position of data name
         integer   posval_       ! Character position of data value
         integer   posdec_       ! Character position of decimal point
         integer   posend_       ! Character position of end of field
         integer   pposnam_      ! Character position of output data name
         integer   pposval_      ! Character position of output data value
         integer   pposdec_      ! Character position of output decimal point
         integer   pposend_      ! Character position of end of output field
         character tbxver_*32    ! Version and date of CIFtbx
         character bloc_*(NUMCHAR) !Name of current data block
         character strg_*(MAXBUF) !Character image of current data item
         character file_*(MAXBUF) !File name of current CIF
         character type_*4        !Data item type
         character*(NUMCHAR) dictype_  !Data type (May be more precise than type_)
         character*(NUMCHAR) diccat_   !Data category
         character*(NUMCHAR) dicname_  !Data alias root name or dictionary name
         character*(NUMCHAR) dicver_   !Dictionary version
         character*(NUMCHAR) tagname_  !Input CIF tag name
         character quote_*1       !Quoted input string flag
         character pquote_*1      !Quoted output string flag
         common/tbuc/ strg_,bloc_,file_,type_,dictype_,diccat_,
     *     dicname_,dicver_,tagname_,quote_,pquote_,tbxver_
         common/tbui/ list_,long_,longf_,line_,esdlim_,recn_,precn_,
     *     posnam_,posval_,posdec_,posend_,
     *     pposnam_,pposval_,pposdec_,pposend_,
     *     recbeg_,recend_,esddig_,pesddig_
         common/tbul/ loop_,text_,align_,save_,saveo_,aliaso_,alias_,
     *     tabl_,tabx_,ptabx_,nblank_,nblanko_,glob_,globo_,decp_,
     *     pdecp_,lzero_,plzero_,append_

