C $Log: not supported by cvs2svn $
C Revision 1.6  2012/08/30 10:24:37  djw
C Clarify on-screen information about illegal constructuion in cif file.
C
C Revision 1.5  2012/06/22 16:36:06  djw
C Tell user at which line the cif file fails
C Include the function ctonum1 from cif2cry.
C even though it is not used for diffractometer data
C
C Revision 1.4  2012/01/03 14:24:18  rich
C Allow longer filenames and filenames with spaces in.
C
C Revision 1.3  2011/09/22 19:49:34  rich
C Some fixes to make this compile with gfortran and align a common block.
C
C Revision 1.2  2011/05/17 16:00:16  djw
C Enable long lines, up to 512 characters
C
C           
C
C    \ | /            /##|    @@@@  @   @@@@@    |      | 
C     \|/ STAR       /###|   @      @   @      __|__    |
C  ----*----        /####|  @       @   @@@@     |      |___  __  __   
C     /|\          /#####|   @      @   @        |      |   \   \/    
C    / | \         |#####|    @@@@  @   @        \___/  \___/ __/\__ 
C                  |#####|________________________________________________ 
C                 ||#####|                 ___________________            |
C        __/|_____||#####|________________|&&&&&&&&&&&&&&&&&&&||          | 
C<\\\\\\\\_ |_____________________________|&&&& Jul 17 94 &&&&||          |
C          \|     ||#####|________________|&&&&&&&&&&&&&&&&&&&||__________|  
C                  |#####|
C                  |#####|
C                  |#####|
C                 /#######\ 
C                |#########|
C                    ====
C                     ||
C           A tool box of fortran routines for manipulating CIF data.
C                     ||
C                     ||
C The latest program source and information is available from:
C                     ||
C Em: syd@crystal.uwa.edu.au       ,-_|\      Sydney R. Hall
C sendcif@crystal.uwa.edu.au      /     \     Crystallography Centre
C Fx: +61 9 380 1118  ||      --> *_,-._/     University of Western Australia
C Ph: +61 9 380 2725  ||               v      Nedlands 6009, AUSTRALIA
C                     ||
C_____________________||_____________________________________________________
C
CDJW  LINE LENGTH INCREASED BY DJW, MAY 2011
C                     
C
C    GENERAL TOOLS
C
C
C    init_      Sets the device numbers of files.   (optional)
C               [logical function always returned .true.]
C
C               <input CIF dev number> Set input CIF device     (def=1)
C
C               <output CIF dev number>Set output CIF device    (def=2)
C
C               <diracc dev number>    Set direct access formatted
C                                      scratch device number    (def=3)
C
C               <error  dev number>    Set error message device (def=6)
C
C
C
C    dict_      Requests a CIF dictionary be used for various data checks.
C               [logical function returned as .true. is the name dictionary
C                was opened; and if the check codes are recognisable.]
C
C               <dictionary filename>  A CIF dictionary in DDL format
C
C               <check code string>    The codes specifying the types of 
C                                      checks to be applied to the CIF.
C
C                                      'valid'  data name validation check.
C                                      'dtype'  data item data type check.
C
C___________________________________________________________________________
C
C
C   CIF ACCESS TOOLS  ("the get_ing commands")
C
C
C
C    open_      Opens the CIF containing the required data.
C               [logical function returned .true. if CIF opened]
C
C               <CIF filename>
C
C
C
C    data_      Identifies the data block containing the data to be requested. 
C               [logical function returned .true. if block found]
C
C               <data block name>     A blank name signals that the next
C                                     encountered block is used (the block
C                                     name is stored in the variable bloc_).
C
C
C
C    test_      Identify the data attributes of the named data item.
C               [logical function returned as .true. if the item is present or
C               .false. if it is not. The data attributes are stored in the
C               the common variables type_ and list_. 
C
C               list_ is an integer variable containing the sequential number
C               of the loop block in the data block. If the item is not within
C               a loop structure this value will be zero.
C
C               type_ is a character*4 variable with the possible values:
C                      'numb'  for number data
C                      'char'  for character data
C                      'text'  for text data
C                      'null'  if data missing or '?']
C
C               <data name>           Name of the data item to be tested.
C
C
C
C    name_      Get the next data name in the current data block.
C               [logical function returned as .true. if a new data name exists
C               in the current data block, and .false. when the end of the data
C               block is reached.]
C
C               <data name>           Returned name of next data item in block.
C
C
C
C    numb_      Extracts the number and its standard deviation (if appended).
C               [logical function returned as .true. if number present. If
C                .false. arguments 2 and 3 are unaltered. If the esd is not
C                attached to the number argument 3 is unaltered.]
C
C               <data name>           Name of the number sought.
C
C               <real variable>       Returned number.
C
C               <real variable>       Returned standard deviation.
C
C
C
C    char_      Extracts character and text strings.
C               [logical function returned as .true. if the string is present.
C                Note that if the character string is text this function is 
C                called repeatedly until the logical variable text_ is .false.]
C
C               <data name>           Name of the string sought.
C
C               <character variable>  Returned string is of length long_.
C
C
C____________________________________________________________________________
C
C
C
C   CIF CREATION TOOLS ("the put_ing commands")
C
C
C
C    pfile_     Create a file with the specified file name.
C               [logical function returned as .true. if the file is opened.
C                The value will be .false. if the file already exists.]
C
C               <file name>
C
C
C
C    pdata_     Put a data block command into the created CIF. 
C               [logical function returned as .true. if the block is created.
C                The value will be .false. if the block name already exists.]
C
C               <block name>
C
C
C
C    ploop_     Put a loop_ data name into the created CIF.             
C               [logical function returned as .true. if the invocation 
C                conforms with the CIF logical structure.]
C
C               <data name>
C
C
C
C    pchar_     Put a character string into the created CIF.             
C               [logical function returned as .true. if the name is unique,
C                AND, if dict_ is invoked, is a name defined in the dictionary, 
C                AND, if the invocation conforms to the CIF logical structure.]
C
C               <data name>         If the name is blank, do not output name.
C
C               <character string>  A character string of 80 chars or less.
C
C
C
C    pnumb_     Put a number and its esd into the created CIF.             
C               [logical function returned as .true. if the name is unique,
C                AND, if dict_ is invoked, is a name defined in the dictionary, 
C                AND, if the invocation conforms to the CIF logical structure.]
C
C               <data name>         If the name is blank, do not output name.
C
C               <real variable>     Number to be inserted.
C
C               <real variable>     Esd number to be appended in parentheses.
C
C
C
C    ptext_     Put a character string into the created CIF.             
C               [logical function returned as .true. if the name is unique,
C                AND, if dict_ is invoked, is a name defined in the dictionary, 
C                AND, if the invocation conforms to the CIF logical structure.]
C                ptext_ is invoked repeatedly until the text is finished. Only
C                the first invocation will insert a data name.
C
C               <data name>         If the name is blank, do not output name.
C
C               <character string>  A character string of 80 chars or less.
C
C
C
C    close_     Close the creation CIF. MUST be used if pfile_ is used.
C               [subroutine call]
C
C
C____________________________________________________________________________
C
C
C
C....The CIF tool box also provides variables for data access control:
C 
C
C    text_       Logical variable signals if another text line is present.
C
C    loop_       Logical variable signals if another loop packet is present.
C
C    bloc_       Character*32 variable: the current block name.
C
C    strg_       Character*80 variable: the current data item.
C
C    type_       Character*4 variable: the data type code (see test_).
C
C    list_       Integer variable: the loop block number (see test_).       
C
C    long_       Integer variable: the length of the data string in strg_.
C
C    file_       Character*80 variable: the filename of the current file.
C
C    longf_      Integer variable: the length of the filename in file_.
C
C    align_      Logical variable signals alignment of loop_ lists during
C                the creation of a CIF. The default is .true.
C
C
C_____________________________________________________________________________
C
C
C >>>>>> Set the device numbers.
C
         function init_(devcif,devout,devdir,deverr)
C
#include "ciftbx.sys"
         logical   init_
         integer   devcif,devout,devdir,deverr
C
         init_=.true.
         cifdev=devcif
         outdev=devout
         dirdev=devdir
         errdev=deverr
         return
         end
C
C
C
C
C
C >>>>>> Read a CIF dictionary and prepare for checks
C
         function dict_(fname,checks)
C
#include "ciftbx.sys"
         logical   dict_,data_,open_,char_
cdjw may2011
         character locase*(linlen)
         character fname*(*),checks*(*)
cdjw may2011
         character temp*24,codes(4)*5,name*(linlen)
         integer   idict,i,j
         data codes /'valid','dtype','     ','     '/
C
C....... Open and store the dictionary
C
         if(nname.gt.0) call err(' dict_ must precede open_')
         dict_=open_(fname)
         if(.not.dict_)              goto 500
         dictfl='yes'
C
C....... Are the codes OK
C
         temp=checks
         i=0         
120      i=i+1
         if(i.ge.24)                 goto 200
         if(temp(i:i).eq.' ')        goto 120
         do 150 j=1,4
         if(temp(i:i+4).eq.codes(j)) goto 170
150      continue
         dict_=.false.
         goto 500
170      i=i+4
         if(j.eq.1) vcheck='yes'
         if(j.eq.2) tcheck='yes'
         goto 120
C
C....... Loop over data blocks; extract _name's, _type etc.
C
200      if(.not.data_(' '))         goto 400
         idict=ndict+1
Cdbg     WRITE(6,*) ndict,bloc_
C
250      if(.not.char_('_name',name))goto 200
         ndict=ndict+1
         if(ndict.gt.1000) call err(' cifdic names > 1000')
         dicnam(ndict)=locase(name(1:long_))
         if(loop_)                   goto 250
C
         if(tcheck.eq.'no ')         goto 200
         if(.not.char_('_type',name))call err(' _type line missing')
         do 270 i=idict,ndict
270      dictyp(i)=name(1:4)
         goto 200
C
400      close(dirdev)
         if(tcheck.eq.'yes') vcheck='yes'
         dictfl='no '
Cdbg     WRITE(6,'(i5,3x,a,2x,a)') (i,dicnam(i),dictyp(i),i=1,ndict)
500      return
         end
C
C
C
C
C
C >>>>>> Open a CIF and copy its contents into a direct access file.
C
         function open_(fname)
C
#include "ciftbx.sys"
         logical   open_,test
         character fname*(*)
         integer   case,i
         character*2 acute, ogonek
         data ogonek/'\;'/
         data acute/'\'''/
C
cdjw may2011
         jchar=(linlen)
         nrecd=0
         lrecd=0
         case=ichar('a')-ichar('A')
         tab=char(05)
         if(case.lt.0) goto 100
         tab=char(09)
C
C....... Make sure the CIF is available to open
C
cdjw may2011 filenames left at 80 characters for the moment
cric oct2011 filenames set to 256 chars
100      continue
c    remove any leading spaces
         do 121 i=1,len(fname)
            if(fname(i:i).ne.' ')goto 122
121      continue
         i = 1
122      continue
         file_=fname(i:)
         do 120 i=len(file_),1,-1
           if(file_(i:i).ne.' ') goto 140
120      continue
         i = 0
140      longf_=i

         write(*,*) "File: "
         write(*,*) fname
         write(*,*) file_(1:longf_),longf_

         inquire(file=file_(1:longf_),exist=test)
         write(*,*)'File ',file_(1:longf_),' inquires ',test
         open_=test
         if(.not.open_)         goto 200
C
C....... Open up the CIF and a direct access formatted file as scratch
C
         open(unit=cifdev,file=file_(1:longf_),status='OLD',
     *        access='SEQUENTIAL', form='FORMATTED')
         open(unit=dirdev,status='SCRATCH',access='DIRECT',
     *                    form='FORMATTED',recl=(linlen))
C
C....... Copy the CIF to the direct access file
C
160      read(cifdev,'(a)',end=180) buffer
         do idjw = 1, linlen-1
            if(buffer(idjw:idjw+1) .eq. ogonek(1:2))
     1      buffer(idjw+1:idjw+1)='Z'
            if(buffer(idjw:idjw+1) .eq. acute(1:2)) 
     1      buffer(idjw+1:idjw+1)='Z'
         enddo
         nrecd=nrecd+1
         write(dirdev,'(a)',rec=nrecd) buffer
cdbg         WRITE(6,'(i5,1x,a)') nrecd,buffer(1:70)
         goto 160
C
180      lrecd=0
         close(cifdev)
200      return
         end
C
C
C
C
C
C >>>>>> Store the data names and pointers for the requested data block
C
         function data_(name) 
C
#include "ciftbx.sys"
         logical   data_
         character name*(*),flag*4,temp*32,ltype*4
cdjw may2011
         character locase*(linlen)
         integer   ndata,idata,nitem,npakt,i,j
C
         jchar=(linlen)
         jrecd=0
         nname=0
         ndata=0
         nitem=0
         idata=0
         iname=0
         loopct=0
         loopnl=0
         ltype=' '
         data_=.false.
         loop_=.false.
         text_=.false.
         irecd=lrecd
         lrecd=nrecd
         if(name(1:1).ne.' ') irecd=0
C
C....... Find the requested data block in the file
C
100      call getstr
         if(type_.eq.'fini')           goto 500
         if(type_.ne.'text')           goto 120
110      call getlin(flag)       
         if(buffer(1:1).ne.';')       goto 110
         call getlin(flag)
         goto 100
120      if(type_.ne.'data')           goto 100
         if(name.eq.' ')              goto 150
         if(strg_(6:long_).ne.name)   goto 100
150      data_=.true.
         bloc_=strg_(6:long_)
C
C....... Get the next token and identify
C
200      call getstr
cdebugging write
c         WRITE(6,*) ltype,type_,loop_,nitem,ndata,idata,irecd,lrecd
C
         if(ltype.ne.'name')               goto 201
         if(type_.eq.'numb')                goto 203
         if(type_.eq.'char')                goto 203
         if(type_.eq.'text')                goto 203
         if(type_.eq.'name'.and.loop_)      goto 204
         write(errdev,'(///a,i10//)') 
     1   ' Illegal tag/value construction at about line', irecd
         call err('Aborting ')
201      if(ltype.ne.'valu')               goto 204
         if(type_.eq.'numb')                goto 202
         if(type_.eq.'char')                goto 202
         if(type_.eq.'text')                goto 202
         goto 204
202      if(nitem.gt.0)                    goto 205
         write(errdev,'(///a,i10//)') 
     1   ' Illegal tag/value construction at about line', irecd
         call err('Aborting ')
203      ltype='valu'
         goto 205
204      ltype=type_
C
205      if(type_.eq.'name')           goto 206
         if(type_.eq.'loop')           goto 210
         if(type_.eq.'data')           goto 210
         if(type_.ne.'fini')           goto 220
206      if(loop_)                    goto 270
210      if(nitem.eq.0)               goto 215
C
C....... End of loop detected; save pointers
C
         npakt=idata/nitem
         if(npakt*nitem.ne.idata) call err(' Item miscount in loop')
         loopni(loopct)=nitem
         loopnp(loopct)=npakt
         nitem=0
         idata=0
215      if(type_.eq.'name')           goto 270
         if(type_.eq.'data')           goto 300
         if(type_.eq.'fini')           goto 300
C
C....... Loop_ line detected; incr loop block counter
C
         loop_=.true.
         loopct=loopct+1
         if(loopct.gt.50) call err(' Number of loop_s > 50')
         goto 200
C
C....... This is the data item; store char position and length
C
220      loop_=.false.
         if(nitem.gt.0) idata=idata+1
         if(nname.eq.ndata)           goto 230
         ndata=ndata+1
         if(iloop(ndata).gt.1)        goto 225
         krecd=irecd
         kchar=jchar-long_-1
225      dtype(ndata)=type_
         drecd(ndata)=krecd
         dchar(ndata)=kchar
         if(nloop(ndata).gt.0)        goto 230
         nloop(ndata)=0
         iloop(ndata)=long_
C
C....... Skip text lines if present
C
230      if(type_.ne.'text')           goto 200
         dchar(ndata)=0
cdjw may2011
         if(nloop(ndata).eq.0) iloop(ndata)=(linlen)
250      call getlin(flag)
         if(buffer(1:1).eq.';')       goto 200
         if(flag.eq.'fini') call err(' Unexpected end of data')
         goto 250
C
C....... This is a data name; store name and loop parameters
C
270      nname=nname+1
         if(nname.gt.500) call err(' Number of data names > 500')
         dname(nname)=locase(strg_(1:long_))
         lloop(nname)=0
         nloop(nname)=0
         iloop(nname)=0
         if(.not.loop_)               goto 200
         nitem=nitem+1
cdjwapr2001         if(nitem.gt.20) call err(' Items per loop packet > 20')
         if(nitem.gt.40) call err(' Items per loop packet > 40')
         nloop(nname)=loopct
         iloop(nname)=nitem
         goto 200
C
C....... Are names checked against dictionary?
C
300      if(dictfl.eq.'yes')          goto 500
         if(vcheck.eq.'no ')          goto 500
C
         do 350 i=1,nname
         temp=dname(i)
         do 330 j=1,ndict
         if(temp.ne.dicnam(j))        goto 330
         if(tcheck.eq.'no ')          goto 350
         if(dtype(i).eq.dictyp(j))    goto 350
         write(errdev,'(2a,1x,2a)') ' Warning: type ',dtype(i),temp,
     *                        ' different to dictionary!'
         goto 350
330      continue
         write(errdev,'(3a)') ' Warning: data name ',temp,
     *                        ' not in dictionary!'
350      continue
C
C....... End of data block; tidy up loop storage
C
500      lrecd=irecd-1
         loop_=.false.
         loopct=0
         if(ndata.ne.nname) call err(' Syntax construction error')
C
Cdbg     WRITE(6,'(a)')
Cdbg *   ' data name                       type recd char loop leng'
Cdbg     WRITE(6,'(a,1x,a,4i5)') (dname(i),dtype(i),drecd(i),dchar(i),
Cdbg *              nloop(i),iloop(i),i=1,nname)
Cdbg     WRITE(6,'(3i5)') (i,loopni(i),loopnp(i),i=1,loopct)
C
         return
         end
C
C
C
C
C
C
C >>>>>> Get the attributes of data item associated with data name
C
         function test_(temp)
C
#include "ciftbx.sys"
         logical    test_
         character  temp*(*),name*32
cdjw may2011
         character  locase*(linlen)
C
         testfl='yes'
         name=locase(temp)
         test_=.true.   
         if(testfl.eq.'no ')  goto 100
         if(name.eq.nametb)   goto 200
100      call getitm(name)        
200      list_ =loopnl
         if(type_.eq.'null') test_=.false.
         return
         end
C
C
C
C
C
C
C >>>>>> Get the next data name in the data block
C
         function name_(temp)              
C
#include "ciftbx.sys"
         logical    name_
         character  temp*(*)
C
         name_=.false.
         temp=' '
         iname=iname+1
         if(iname.gt.nname)  goto 100
         name_=.true.
         temp=dname(iname)
100      return
         end
C
C
C
C
C
C
C >>>>>> Extract a number data item and its standard deviation
C
         function numb_(temp,numb,sdev)
C
#include "ciftbx.sys"
         logical    numb_
         character  temp*(*),name*32
cdjw may2011
         character  locase*(linlen)
         real       numb,sdev
C
         name=locase(temp)
         if(testfl.eq.'no ')  goto 100
         if(name.eq.nametb)   goto 150
C
100      call getitm(name)
C
150      numb_=.false.
         if(type_.ne.'numb') goto 200
         numb_=.true.
         numb =numbtb
         if(sdevtb.ge.0.0) sdev=sdevtb
C
200      testfl='no '
         return
         end
C
C
C
C
C
C
C >>>>>> Extract a character data item.               
C
         function char_(temp,strg)          
C
#include "ciftbx.sys"
         logical    char_
         character  temp*(*),name*32
         character  strg*(*),flag*4
cdjw may2011
         character  locase*(linlen)
C
         name=locase(temp)
         if(testfl.eq.'yes')    goto 100
         if(.not.text_)         goto 120
100      if(name.eq.nametb)     goto 150
C
120      call getitm(name)
C
150      char_=.true.
         text_=.false.
         strg=strg_(1:long_)
         if(type_.eq.'char')   goto 200
         char_=.false.
         if(type_.ne.'text')   goto 200
         char_=.true.
         call getlin(flag)
         if(buffer(1:1).eq.';') goto 200
         text_=.true. 
         strg_=buffer
C
200      testfl='no '
         return
         end
C
C
C
C
C
C >>>>> Convert name string to lower case
C        
         function locase(name)
C
#include "ciftbx.sys"
cdjw may2011
         character    locase*(linlen)
         character    temp*(linlen),name*(*)
         character    low*26,cap*26,c*1
         data  cap /'ABCDEFGHIJKLMNOPQRSTUVWXYZ'/
         data  low /'abcdefghijklmnopqrstuvwxyz'/
C
         temp=name
cdjw may2011
         do 100 i=1,(linlen)
         c=temp(i:i)
         if(c.eq.' ') goto 200
         j=index(cap,c)
         if(j.ne.0) temp(i:i)=low(j:j)        
100      continue
200      locase=temp
         return
         end
C
C
C
C
C
C >>>>>> Get the data item associated with the tag.
C
         subroutine getitm(name)
C
#include "ciftbx.sys"
         SAVE
         character name*(*),lname(20)*32
         character fhash*3,flag*4
         integer   phash(20),ihash
         integer   loopch(21),loopln(21),looprd(21)
         integer   iitem,nitem,npakt
         integer   kchar,loopi,i
         data fhash/'no '/
C
C....... Find requested dataname in hash list
C
         nametb=name
         if(name(1:1).eq.'_')       goto 100
         type_='null'
         long_=1
         goto 1000
100      if(.not.loop_)             goto 150
         fhash='no '
         do 120 ihash=1,nhash
         if(lname(ihash).eq.nametb) goto 170
120      continue
         if(nhash.eq.20)            goto 150
         fhash='yes'
C
C....... Else find requested dataname in full list
C
150      do 160 iname=1,nname
         if(dname(iname).eq.nametb)  goto 180
160      continue
         type_='null'
         long_=1
         goto 1000
C
C....... Update the hash table if need be
C
170      iname=phash(ihash)
180      if(fhash.eq.'no ')         goto 190
         nhash=nhash+1
         phash(nhash)=iname
         lname(nhash)=name
190      if(nloop(iname).le.0)      goto 500
C
C....... Process loop packet if first item request
C
         if(nloop(iname).ne.loopnl) goto 200
         if(lloop(iname).lt.loopct) goto 300
         if(loop_)                 goto 230
200      loop_=.true.
         nhash=0
         loopct=0
         loopnl=nloop(iname)
         nitem=loopni(loopnl)
         npakt=loopnp(loopnl)
         irecd=drecd(iname)-1
         call getlin(flag)
         jchar=max(0,dchar(iname)-1)
C error          jchar=dchar(iname)-1
Cdbg     if(jchar.lt.0) write(6,'(" dchar ",i5)') jchar
         do 220 i=1,nname
220      lloop(i)=0
         goto 240
C
C....... Read a packet of loop items
C
230      irecd=looprd(nitem+1)-1
         call getlin(flag)
         jchar=loopch(nitem+1)
Cdbg     if(jchar.lt.0) write(6,'(" loopch",i5)') jchar
240      iitem=0
250      iitem=iitem+1
         if(iitem.le.nitem)     goto 255
         loopch(iitem)=jchar
         looprd(iitem)=irecd
         goto 270
255      call getstr
         loopch(iitem)=jchar-long_
         loopln(iitem)=long_
         looprd(iitem)=irecd
         if(type_.ne.'text')     goto 250
260      call getlin(flag)
         if(buffer(1:1).ne.';') goto 260
         call getlin(flag)
         goto 250
270      loopct=loopct+1
         if(loopct.lt.npakt)    goto 300
         loop_=.false.
C
C....... Point to the loop data item
C
300      lloop(iname)=lloop(iname)+1
         loopi=iloop(iname)
         irecd=looprd(loopi)-1
         call getlin(flag)
         long_=loopln(loopi)
         kchar=loopch(loopi)
         goto 550
C
C....... Point to the non-loop data item
C
500      irecd=drecd(iname)-1
         call getlin(flag)
         kchar=dchar(iname)+1
         long_=iloop(iname)
         loop_=.false.
         loopct=0
         loopnl=0
C
C....... Place data item into variable string and make number
C
550      type_=dtype(iname)
         strg_(1:long_)=buffer(kchar:kchar+long_-1)
         if(type_.eq.'numb') call ctonum
         if(type_.eq.'text') strg_(1:1)=' '
         if(long_.eq.1.and.strg_(1:1).eq.'?') type_='null'
C
1000     return
         end
C
C
C
C
C
C
C
C >>>>>> Read the next string from the file
C
         subroutine getstr
C
#include "ciftbx.sys"
         integer   i
         character c*1,num*13,flag*4
         data num/'0123456789+-.'/
C
100      jchar=jchar+1
cdjw may2011
         if(jchar.le.(linlen))     goto 150
C
C....... Read a new line
C
110      call getlin(flag)
         type_='fini'
         if(flag.eq.'fini')  goto 500
C
C....... Test if the new line is the start of a text sequence
C
         if(buffer(1:1).ne.';') goto 150
         type_='text'
cdjw may2011
         jchar=(linlen)+1
cdjw may2011
         long_=(linlen)
         goto 500
C
C....... Process this character in the line
C
150      c=buffer(jchar:jchar)
         if(c.eq.' ')       goto 100
         if(c.eq.tab)       goto 100
         if(c.eq.'#')       goto 110
         if(c.eq.'''')      goto 300
         if(c.eq.'"')       goto 300
         if(c.ne.'_')       goto 200
         type_='name'
         goto 210
C
C....... Test if the start of a number or a character string
C
200      type_='numb'
         if(index(num,c).eq.0) type_='char'
cdjw may2011
210      do 250 i=jchar,(linlen)
         if(buffer(i:i).eq.' ')       goto 400
         if(buffer(i:i).eq.tab)       goto 400
250      continue
cdjw may2011
         i=(linlen)+1
         goto 400
C
C....... Span quoted character string
C
300      type_='char'
         jchar=jchar+1
cdjw may2011
         do 320 i=jchar,(linlen)
         if(buffer(i:i).eq.c)         goto 400
320      continue
         call err('Quoted string not closed')
C
C....... Store the string for the getter
C
400      long_=i-jchar
         strg_(1:long_)=buffer(jchar:i-1)
         jchar=i
Cdbg     if(jchar.lt.0) write(6,'(" i     ",i5)') jchar
         if(type_.ne.'char') goto 500
         if(strg_(1:5).eq.'data_') type_='data'
         if(strg_(1:5).eq.'loop_') type_='loop'
C
500      return
         end
C
C
C
C
C
C
C >>>>>> Convert a character string into a number and its esd
C
C           number string        -xxxx.xxxx+xxx(x)
C           component count CCNT 11111222223333444
C
         Function ctonum1(name)
C
#include   "ciftbx.sys"
         character test*15,c*1,name*15
         integer*4 m,nchar
         integer*4 ccnt,mant,expn,msin,esin,ndec
         real      numb,sdev,ctonum1
         data test /'0123456789+.-()'/
C
         numbtb=0.
         sdevtb=-1.
         numb=1.
         sdev=0. 
         ccnt=0
         mant=0
         expn=0.
         msin=+1
         esin=+1
         ndec=0
         type_='char'
	   ctonum1=0
C
C....... Loop over the string and identify components
C
       do 400 nchar=1,long_
C
	   c=name(nchar:nchar)
	   if(c.eq. ' ')    goto 410
	   m=index(test,c)
         if(m.eq.0)     goto 410
         if(m.gt.10)    goto 300
C
C....... Process the digits
C
         if(ccnt.eq.0)  ccnt=1
         if(ccnt.eq.2)  ndec=ndec+1
         if(ccnt.gt.2)  goto 220
         mant=mant*10+m-1
         goto 400
220      if(ccnt.gt.3)  goto 240
         expn=expn*10+m-1
         goto 400
240      sdev=sdev*10.+float(m-1)
         sdevtb=1.
         goto 400
C
C....... Process the characters    . + - ( ) E D
C
300      if(c.ne.'.')  goto 320
         if(ccnt.gt.1) goto 500
         ccnt=2
         goto 400
C
320      if(c.ne.'(')  goto 340
         ccnt=4
         goto 400
C
340      if(c.eq.'E') m=10
         if(c.eq.'D') m=10
         if(ccnt.eq.3) goto 500
         if(ccnt.gt.0) goto 360
         ccnt=1
         msin=12-m
         goto 400
360      ccnt=3
         esin=12-m
C
400    continue
C
C....... String parsed; construct the numbers
C
410      expn=expn*esin-ndec
         if(abs(expn).gt.21) expn=sign(21,expn)
         if(expn.lt.0) numb=1./10.**abs(expn)
         if(expn.gt.0) numb=10.**expn
         if(sdevtb.gt.0.0) sdevtb=numb*sdev
450      numb=numb*float(mant*msin)
	   ctonum1 = numb
         type_='numb'
C
500      End function ctonum1
         





Convert a character string into a number and its esd
C
C           number string        -xxxx.xxxx+xxx(x)
C           component count CCNT 11111222223333444
C
         subroutine ctonum
C
#include "ciftbx.sys"
         character test*15,c*1
         integer*4 nchar
         integer*4 ccnt,expn,msin,esin,ndec
		 integer*8 mant, m
         real      numb,sdev
         data test /'0123456789+.-()'/
C
         numbtb=0.
         sdevtb=-1.
         numb=1.
         sdev=0. 
         ccnt=0
         mant=0
         expn=0.
         msin=+1
         esin=+1
         ndec=0
         type_='char'
C
C....... Loop over the string and identify components
C
         do 400 nchar=1,long_
C
         c=strg_(nchar:nchar)
         m=index(test,c)
         if(m.eq.0)     goto 500
         if(m.gt.10)    goto 300
C
C....... Process the digits
C
         if(ccnt.eq.0)  ccnt=1
         if(ccnt.eq.2)  ndec=ndec+1
         if(ccnt.gt.2)  goto 220
         mant=mant*10+m-1
         goto 400
220      if(ccnt.gt.3)  goto 240
         expn=expn*10+m-1
         goto 400
240      sdev=sdev*10.+float(m-1)
         sdevtb=1.
         goto 400
C
C....... Process the characters    . + - ( ) E D
C
300      if(c.ne.'.')  goto 320
         if(ccnt.gt.1) goto 500
         ccnt=2
         goto 400
C
320      if(c.ne.'(')  goto 340
         ccnt=4
         goto 400
C
340      if(c.eq.'E') m=10
         if(c.eq.'D') m=10
         if(ccnt.eq.3) goto 500
         if(ccnt.gt.0) goto 360
         ccnt=1
         msin=12-m
         goto 400
360      ccnt=3
         esin=12-m
C
400      continue
C
C....... String parsed; construct the numbers
C
         expn=expn*esin-ndec
         if(abs(expn).gt.21) expn=sign(21,expn)
         if(expn.lt.0) numb=1./10.**abs(expn)
         if(expn.gt.0) numb=10.**expn
         if(sdevtb.gt.0.0) sdevtb=numb*sdev
         numbtb=numb*float(mant*msin)
         type_='numb'
C
500      return
         end
C
C
C
C
C
C
C >>>>>> Read a new line from the direct access file
C
         subroutine getlin(flag)
C
#include "ciftbx.sys"
         character flag*4
C
         irecd=irecd+1
         if(irecd.eq.jrecd)  goto 200
         if(irecd.le.lrecd)  goto 100
         flag='fini'
         goto 200
100      read(dirdev,'(a)',rec=irecd) buffer
         jchar=1
         jrecd=irecd
         flag=' '
200      return
         end
C
C
C
C
C
C
C >>>>>> Write error message and exit.
C
         subroutine err(mess)
C
#include "ciftbx.sys"
         character mess*(*)
C
         write(errdev,'(5a,i5)') ' ciftbx error in  ',
     *   file_(1:longf_),'  data_',bloc_,'  line',irecd
         write(errdev,'(//1X,a)') mess
         write(errdev,'(a)') 'READING CIF ABORTED'
         write(errdev,'(a,i12//)') 'At about line ', irecd
         stop
         end
C
C
C
C
C >>>>>> Create a named file.
C
         function pfile_(fname)
C
#include "ciftbx.sys"
         logical   pfile_,test
         integer   i
         character fname*(*)
C
C....... Test if a file by this name is already open.
C
         if(pfilef.eq.'yes') call close_
         pfilef='no '
         file_=fname
cdjw may2011 not yet changed
         do 120 i=1,80
         if(file_(i:i).eq.' ') goto 140
120      continue
140      inquire(file=file_(1:i-1),exist=test)
         pfile_=.false.
         if(test)              goto 200
C
C....... Open up a new CIF
C
         open(unit=outdev,file=fname,status='NEW',access='SEQUENTIAL',
     *                    form='FORMATTED')
         pfile_=.true.  
         pfilef='yes'
         nbloc=0
200      return
         end
C
C
C
C
C
C >>>>>> Store a data block command in the CIF
C
         function pdata_(name) 
C
#include "ciftbx.sys"
         logical   pdata_
         character name*(*),temp*32
         character dbloc(100)*32
         integer   i
C
         if(ploopn.gt.0)     call eoloop
         if(ptextf.eq.'yes') call eotext
C
C....... Check for duplicate data name
C
         temp=name
         pdata_=.false.
         do 120 i=1,nbloc
         if(temp.eq.dbloc(i))   goto 200
120      continue
C
C....... Save block name and put data_ statement
C
         nbloc=nbloc+1
         if(nbloc.le.100) dbloc(nbloc)=temp
cdjw may2011
         pchar=(linlen)+1
         temp='data_'//name
         call putstr(temp)         
cdjw may2011
         pchar=(linlen)+1
         call putstr(' ')          
         pdata_=.true.
C
200      return
         end
C
C
C
C
C
C
C >>>>>> Put a number into the CIF, perhaps with an esd appended
C
         function pnumb_(name,numb,sdev)
C
#include "ciftbx.sys"
         logical    pnumb_,flag
         character  name*(*),temp*32
         real       numb,sdev
C
         pnumb_=.true.
         flag  =.true.
         temp=name
         if(ptextf.eq.'yes') call eotext
C
         if(name(1:1).eq.' ')   goto 120
         if(vcheck.eq.'no ')    goto 100
         call dcheck(temp,'numb',flag)
         pnumb_=flag
100      if(ploopn.gt.0)        call eoloop
cdjw may2011
         pchar=(linlen)+1
         call putstr(temp)
         pchar=35
C
120      ploopf='no '
         call putnum(numb,sdev)
         if(flag)               goto 150
         pchar=60
         call putstr('#< not in dictionary')
C
150      return
         end
C
C
C
C
C
C
C >>>>>> Put a character string into the CIF.
C
         function pchar_(name,string)      
C
#include "ciftbx.sys"
         logical    pchar_,flag
         character  name*(*),temp*32,string*(*)
cdjw may2011
         character  line*(linlen),strg*(linlen)
         integer    i,j
C
         pchar_=.true.
         flag  =.true.
         temp=name
         if(ptextf.eq.'yes') call eotext
C
         if(name(1:1).eq.' ')   goto 110
         if(vcheck.eq.'no ')    goto 100
         call dcheck(temp,'numb',flag)
         pchar_=flag
100      if(ploopn.gt.0)        call eoloop
cdjw may2011
         pchar=(linlen)+1
         call putstr(temp)
         pchar=35
C
110      ploopf='no '
         line=string
cdjw may2011
         do 120 i=(linlen),2,-1
         if(line(i:i).ne.' ') goto 130
120      continue
130      do 140 j=i,1,-1
         if(line(j:j).eq.' ') goto 150
140      continue
         strg=line(1:i)
         goto 200
150      do 160 j=1,i
         if(line(j:j).eq.'''')goto 170
160      continue
         strg=''''//line(1:i)//''''
         goto 200
170      strg='"'//line(1:i)//'"'
C
200      call putstr(strg)   
         if(flag)               goto 250
         pchar=60
         call putstr('#< not in dictionary')
250      return
         end
C
C
C
C
C
C
C >>>>>> Put a text sequence into the CIF.
C
         function ptext_(name,string)      
C
#include "ciftbx.sys"
         logical    ptext_,flag
         character  name*(*),temp*32,string*(*),store*32
         data store/'                                '/
C
         ptext_=.true.
         flag  =.true.
         ploopf='no '
         temp=name
         if(ptextf.eq.'no ')    goto 100
         if(temp.eq.store)      goto 150
         call eotext
C
100      if(name(1:1).ne.' ')   goto 110
         if(ptextf.eq.'yes')    goto 150
         goto 130
C
110      if(ploopn.gt.0)        call eoloop
         if(vcheck.eq.'no ')    goto 120
         call dcheck(name,'char',flag)
         ptext_=flag
120      continue
cdjw may2011
         pchar=(linlen)+1
         call putstr(temp)
         if(flag)               goto 130
         pchar=60
         call putstr('#< not in dictionary')
cdjw may2011
130      pchar=(linlen)+1
         call putstr(' ')
         ptextf='yes'
         store=temp
         write(outdev,'(a)') ';'
150      write(outdev,'(a)') string
         return
         end
C
C
C
C
C
C
C >>>>>> Put a loop_ data name into the CIF.
C
         function ploop_(name)      
C
#include "ciftbx.sys"
         logical    ploop_,flag
         character  name*(*),temp*32
C
         ploop_=.true.
         flag  =.true.
         if(ptextf.eq.'yes')    call eotext
         if(name(1:1).eq.' ')   goto 150
C
         temp='    '//name
         if(ploopf.eq.'no ')    call eoloop
         if(vcheck.eq.'no ')    goto 100
         call dcheck(name,'    ',flag)
         ploop_=flag
100      if(ploopn.gt.0)        goto 120
         ploopf='yes'
cdjw may2011
         pchar=(linlen)+1
         call putstr(' ')
cdjw may2011
         pchar=(linlen)+1
         call putstr('loop_')
cdjw may2011
         pchar=(linlen)+1
120      call putstr(temp)
         if(flag)               goto 130
         pchar=60
         call putstr('#< not in dictionary')
cdjw may2011
130      pchar=(linlen)+1
         ploopn=ploopn+1
C
150      return
         end
C
C
C
C
C
C
C >>>>>> Close the CIF
C
         subroutine close_
C
#include "ciftbx.sys"
C
         if(ptextf.eq.'yes') call eotext
         if(ploopn.gt.0)     call eoloop
cdjw may2011
         pchar=(linlen)+1
         call putstr(' ')
         close(outdev)
         return
         end
C
C
C
C
C
C >>>>>> Put the string into the output CIF buffer 
C
         subroutine putstr(string)     
C
#include "ciftbx.sys"
         SAVE
cdjw may2011
         character  string*(*),temp*(linlen),obuf*(linlen)
         integer    ichar,i
         data       ichar /0/
C
         temp=string
cdjw may2011
         do 100 i=(linlen),1,-1
         if(temp(i:i).ne.' ')   goto 110
100      continue
C
C....... Organise the output of loop_ items
C
110      if(i.eq.0)             goto 130
         if(ploopf.eq.'yes')    goto 130
         if(ploopn.eq.0)        goto 130
         ploopc=ploopc+1
         if(ploopc.le.ploopn)   goto 130
         ploopc=1
         if(.not.align_)        goto 130
cdjw may2011
         pchar=(linlen)+1
C
C....... Is the buffer full and needs flushing?
C
130      if(pchar.lt.ichar)     goto 140
cdjw may2011
         if(pchar+i.le.(linlen))      goto 150
         pchar=1
140      if(ichar.gt.0) write(outdev,'(a)') obuf(1:ichar)
         obuf=' '
C
C....... Load the next item into the buffer
C
150      ichar=pchar+i
         if(i.eq.0)            goto 200
         obuf(pchar:ichar)=string(1:i)
         pchar=ichar+1
C
200      return
         end
C
C
C
C
C
C >>>>>> Convert the number and esd to string nnnn(m)
C
         subroutine putnum(numb,sdev)  
C
#include "ciftbx.sys"
         character  string*60,digit*9,temp*20
         real       numb,sdev
         integer    i,j
         data       digit /'123456789'/
C
         write(string,'(2f30.10)') numb,sdev
         do 120 i=1,30
         if(string(i:i).ne.' ')            goto 140
120      continue
140      if(sdev.lt.0.0000001)             goto 240
C
C....... Numbers with standard deviations
C
         do 160 j=31,60
         if(index(digit,string(j:j)).gt.0) goto 200
160      continue
200      if(j.lt.50)              goto 220
         temp=string(i:j-30)//'('//string(j:j)//')'
         goto 300
220      temp=string(i:19)//'('//string(j:49)//')'
         goto 300
C
C....... Numbers without standard deviations
C
240      do 250 j=21,30
         if(string(j:j).ne.'0')            goto 260
250      continue
260      if(j.gt.26)                       goto 280
         temp=string(i:26)
         goto 300
280      temp=string(i:19)
C
300      call putstr(temp)
         return
         end
C
C
C
C
C
C >>>>>> Check dictionary for data name validation    
C
         subroutine dcheck(name,type,flag)
C
#include "ciftbx.sys"
         logical    flag
         character  name*(*),temp*32,type*4
         integer    i
C
         flag=.true.
         temp=name
         do 100 i=1,ndict
         if(temp.ne.dicnam(i))        goto 100
         if(tcheck.eq.'no ')          goto 200
         if(type.eq.dictyp(i))        goto 200
         goto 150
100      continue
150      flag=.false.
200      continue
         return
         end
C
C
C
C
C
C >>>>>> End of text string
C
         subroutine eotext
C
#include "ciftbx.sys"
C
         ptextf='no '
         call putstr(';')
cdjw may2011
         pchar=(linlen)
         return
         end
C
C
C
C
C
C >>>>>> End of loop detected; check integrity and tidy up pointers
C
         subroutine eoloop
C
#include "ciftbx.sys"
         integer   i
C
         if(ploopn.eq.0)          goto 200
         if(ploopn.eq.ploopc)     goto 200
         do 150 i=1,ploopc
150      call putstr('DUMMY')
         write(errdev,'(a)')    
     *         ' Missing: missing loop_ items set as DUMMY'
C
200      ploopc=0
         ploopn=0
         return
         end
C
C
C
C
C
C
C >>>>>> Set common default values
C
         block data
C
#include "ciftbx.sys"
         data cifdev /1/
         data outdev /2/
         data dirdev /3/
         data errdev /6/
         data loopct /0/
         data nhash  /0/
         data ndict  /0/
         data nname  /0/
         data nbloc  /0/
         data ploopn /0/
         data ploopc /0/
         data ploopf /'no '/
         data ptextf /'no '/
         data pfilef /'no '/
         data testfl /'no '/
         data vcheck /'no '/
         data tcheck /'no '/
         data align_ /.true./ 
         data text_  /.false./
         data loop_  /.false./
         end
C
C

