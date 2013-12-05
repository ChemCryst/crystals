!        For inclusion in 'ciftbx.f'. You should also include CIF1 block.
         integer NUMDICT,NUMHASH,NUMBLOCK,NUMLOOP,NUMITEM,NUMIP1,MAXTAB,
     *     MAXBOOK,NUMPAGE,NUMCPP
         PARAMETER (NUMPAGE=10)   !Number of memory resident pages
         PARAMETER (NUMCPP=16384) !Number of characters per page
         PARAMETER (NUMDICT=3200) !Number of entries in dictionary tables
         PARAMETER (NUMHASH=53)   !Number of hash table entries (a modest prime)
         PARAMETER (NUMBLOCK=500) !Number of entries in data block tables
         PARAMETER (NUMLOOP=50)   !Number of loops in a data block
         PARAMETER (NUMITEM=50)   !Number of items in a loop
         PARAMETER (MAXTAB=10)    !Maximum number of tabs in output cif line
         PARAMETER (MAXBOOK=1000) !Maximum number of simultaneous bookmarks
         PARAMETER (NUMIP1=NUMITEM+1) !Derived value for loop arrays
         character pagebuf(NUMPAGE)*(NUMCPP) !Memory resident page buffer
         character testfl*3       !Flag if test_ last called (yes/no )
         character nametb*(NUMCHAR) !Name of current data item
         character tab*1          !Tab character for this machine
         character buffer*(MAXBUF)!Character buffer for reading lines
         character bufntb*(MAXBUF)!Character buffer for tab-expanded lines
         character vcheck*3       !Dictionary validation check
         character tcheck*3       !Dictionary data type check
         character catchk*3       !Dictionary category check flag
         character dictfl*3       !Dictionary flag             
         character dicnam(NUMDICT)*(NUMCHAR) !Dictionary names
         character dictag(NUMDICT)*(NUMCHAR) !Dictionary names with upper/lower case
         character dictyp(NUMDICT)*4         !Dictionary data types
         character dname(NUMBLOCK)*(NUMCHAR) !Data names in data block
         character dtag(NUMBLOCK)*(NUMCHAR)  !Data names in data block with u/l case
         character dtype(NUMBLOCK)*4         !Data type of data item 
         character pfilef*3       !Flag signalling output CIF open
         character ploopf*3       !Flag signalling loop_ being loaded
         character ptextf*3       !Flag signalling text being loaded
         character obuf*(MAXBUF)  !Output string buffer
         character prefx*(MAXBUF) !Output prefix string
         character dcname(NUMDICT)*(NUMCHAR) !Dictionary category names
         character cname(NUMBLOCK)*(NUMCHAR) !Category names in use
         character dicxtyp(NUMDICT)*(NUMCHAR)!Dictionary extended types
         character dxtyp(NUMBLOCK)*(NUMCHAR) !Datablock extended types
         character*13 esdfmt      !Format for single precision esd's
         character*13 edpfmt      !Format for double precision esd's
         character*8 ndpfmt       !Format for writing double precision numbers
         integer   mppoint(NUMPAGE), drecd(NUMBLOCK), dchar(NUMBLOCK) 
         integer   trecd(NUMBLOCK) , tchar(NUMBLOCK), xchar(NUMBLOCK) 
         integer   nloop(NUMBLOCK) , iloop(NUMBLOCK), lloop(NUMBLOCK) 
         integer   loopni(NUMLOOP) , loopnp(NUMLOOP), loorec(NUMLOOP) 
         integer   loopos(NUMLOOP) , loopox(NUMLOOP) 
         integer   lastch, ploopc, ploopn, loopnl, loopct, nhash , nname          
         integer   iname , ndict , nrecd , irecd , jrecd , jrect , lrecd         
         integer   jchar , pchar , pcharl, nbloc , cifdev, dirdev, errdev        
         integer   outdev, esdcac, esddigx, ndcname       
         integer   ibkmrk(4,MAXBOOK), dcindex(NUMDICT),dchash(NUMHASH) 
         integer   dcchain(NUMDICT),  dichash(NUMHASH),dicchain(NUMDICT)
         integer   dhash(NUMHASH), chash(NUMHASH), dchain(NUMBLOCK) 
         integer   cchain(NUMBLOCK), ncname, numtab
         integer   loopch(NUMIP1), loopln(NUMIP1), looprd(NUMIP1)
         integer   cindex(NUMBLOCK),ddict(NUMBLOCK),aroot(NUMDICT) 
         integer   alias(NUMDICT), xdchk, minexp,lprefx,itabp(MAXTAB)  
         double precision numbtb, sdevtb, dpprc, dpmin
         real      decprc, decmin
         logical   psaveo, catkey(NUMDICT) 
         integer   ccatkey(NUMDICT), keychain(NUMDICT)
         common/tbxc/ buffer,dname,dtype,tab,dicnam,dictag,dictyp,
     *                dictfl,dtag,nametb,testfl,vcheck,tcheck,pfilef,
     *                ploopf,ptextf,dcname,cname,dicxtyp,dxtyp,esdfmt,
     *                edpfmt,ndpfmt,prefx,obuf,bufntb,catchk,pagebuf
         common/tbxi/ nrecd,drecd,trecd,irecd,lrecd,dchar,tchar,xchar,
     *                ndict,outdev,nloop,iloop,lloop,loopct,loopni,
     *                loopnp,loopnl,nname,nhash,cifdev,dirdev,errdev,
     *                jchar,pchar,iname,ploopn,ploopc,nbloc,jrecd,
     *                lastch,esdcac,esddigx,ndcname,dcindex,ncname,
     *                cindex,aroot,alias,dchash,dcchain,dichash,
     *                dicchain,dhash,dchain,ddict,xdchk,loopch,loopln,
     *                looprd,minexp,lprefx,itabp,numtab,pcharl,loopos,
     *                loopox,loorec,jrect,ibkmrk,chash,cchain,mppoint,
     *                keychain,ccatkey
         common/tbxdp/numbtb,sdevtb,dpprc,dpmin
         common/tbxr/ decprc,decmin
         common/tbxl/ catkey,psaveo

