C $Log: not supported by cvs2svn $
C Revision 1.42  2002/03/21 17:50:34  richard
C Clear the error flag before doing bond calculations. (In case CRYSTALS had
C an error last instruction).
C
C Revision 1.41  2002/03/13 12:46:26  richard
C HUGE change. Re-written XGDBUP as XGUIUP - now called inbetween commands, so can load
C lists without worrying about use of store. Atoms and bonds now passed through FAST interface.
C List 41 updated as required. Atom types with UNKNOWN colour will revert to the colour in
C PROPWIN.DAT.
C
C Revision 1.40  2002/02/27 19:30:18  ckp2
C RIC: Increase lengths of lots of strings to 256 chars to allow much longer paths.
C RIC: Ensure consistent use of backslash after CRYSDIR:
C
C Revision 1.39  2001/10/18 10:02:49  ckp2
C When mouse hovers over bonds, display the fragment number as well as the length.
C
C Revision 1.38  2001/09/11 08:27:43  ckp2
C Cut down GUI traffic by only sending status updates for flags that have
C actually changed (Flags: L1, L2, L3, L5, L6, QS, IN)
C
C Revision 1.37  2001/07/19 08:01:00  ckp2
C Changed so that ISSUPD flag only stops the updating of List5, the other
C lists still update things in the GUI.
C
C Revision 1.36  2001/06/18 08:25:21  richard
C Platform specific file names were being overridden by a following statement which
C reset file name to the windows specific name.
C
C Revision 1.35  2001/06/17 14:20:27  richard
C Make bonds crossing symmetry elements lighter to distinguish them from normal bonds more.
C
C Revision 1.34  2001/06/08 15:02:51  richard
C Get F/F2 state for status window from L23 rather than L30.
C
C Revision 1.33  2001/03/16 17:10:41  richard
C Re-instate full search of atom list for bonds. Had changed it to pivot onwards,
C but this meant that bonds across symm ops, only one was drawn. Unfortunately, it now
C means that for normal bonds, twice as many as are needed are being sent to the
C GUI and rendered.
C Changed colour of bonds across symm ops to grey.
C
C Revision 1.32  2001/03/08 14:30:58  richard
C
C Remove "Too many contacts" message - failing silently is much much faster.
C XGDBUP is now called with common block address and length allowing
C all lists to be passed through this routine.
C Included calculations for drawing thermal ellipsoids. Speeded up
C bond search. Added atoms labels to bond info passed to GUI.
C Info extracted from LIST 1, LIST 2, LIST 29, LIST 30 and passed
C to the GUI.
C
C Revision 1.31  2001/01/22 16:48:26  richard
C Pass peak height (spare) as value*1000.
C
C Revision 1.30  2001/01/15 12:12:54  richard
C RIC: Prevent array overflow if too many contacts are found to an atom during
C a bond search. (More than 500)
C
C Revision 1.29  2000/12/13 17:47:38  richard
C Support for LINUX.
C
C Revision 1.28  2000/09/19 14:13:16  CKP2
C find colour table in SCRIPT
C
C Revision 1.27  2000/07/19 11:56:56  ckp2
C RIC: Fixed bug where GUI hangs when structure explodes...
C      I think.
C
C Revision 1.26  2000/07/11 11:04:08  ckp2
C Extra argument to KFLOPN, for specifying SEQUENTIAL or DIRECT access
C
C Revision 1.25  2000/07/04 13:43:32  ckp2
C RIC: Better colours for bond deviations using csd checks.
C
C Revision 1.24  2000/02/23 12:22:06  ckp2
C djw abortive attempt to trap NaN values
C
C Revision 1.23  2000/01/20 16:57:58  ckp2
C ric  fix square root problem
C
C Revision 1.22  1999/12/15 14:54:49  ckp2
C djw  Add set autoupdate on/off, force ON in summary.
C
C Revision 1.21  1999/09/22 16:11:37  ckp2
C RIC: Modified bond length tolerances to match Cameron, except that
C bonds shorter than 0.5*(sum of cov radii) will not be drawn.
C
C Revision 1.20  1999/08/03 09:17:18  richard
C RIC: Pass the SPARE value to the GUI (if available), otherwise pass the
C covalent radii. Spare is scaled by 0.01 to display on an angstrom scale.
C
C Revision 1.19  1999/07/30 20:30:13  richard
C RIC: If atoms have negative covalent radii, then don't bond them to
C anything, but still use the absolute value for the radius.
C
C Revision 1.18  1999/07/21 18:11:06  richard
C RIC: Remove defunct code. Fix setting of QSINL5 flag. (Don't set FALSE, if
C not updating list.)
C
C Revision 1.17  1999/07/20 17:58:44  richard
C RIC: There was a problem where any element without a colour assigned
C in propwin.dat, was getting assigned a default radius aswell as a
C default colour. Fixed.
C
C Revision 1.16  1999/07/02 17:53:36  richard
C RIC: Changed bond determining routine to ignore bonds shorter than
C      0.7 * (sum of covalent radii). This makes things a little clearer
C      when there are lots of atoms.
C
C Revision 1.15  1999/07/01 18:09:41  dosuser
C RIC: Changed the largest possible bonding distance of two atoms
C to (COVALENT(1) + COVALENT(2)) * 1.1 to
C    (COVALENT(1) + COVALENT(2)) * 1.3. Should solve problems with
C    metal atoms not bonding to anything.
C
C Revision 1.14  1999/06/22 13:51:27  dosuser
C RIC: Temporarily commented out the eigen vector and axes calculation as
C it doesn't seem to work.
C
C Revision 1.13  1999/06/13 16:18:23  dosuser
C RIC: Centre the molecule on 0,0,0 as it is updated.
C
C Revision 1.12  1999/06/01 13:00:05  dosuser
C RIC: Added commented out debugging code for checking which bonds
C have been found.
C RIC: Commented out some unused variables.
C
C Revision 1.11  1999/05/25 16:03:31  dosuser
C RIC: Changes for UNIX filenames for LIN and GIL targets.
C
C Revision 1.10  1999/05/21 11:18:59  dosuser
C RIC: When drawing bonds colour them according to the deviation from
C the CSD mean, if this info has already been computed.
C
C Revision 1.9  1999/05/10 19:48:44  dosuser
C RIC: It turns out that LGUIL1 and LGUIL5 were a bit useless as they
C     were only set when you call XWININ() from #SET TERM WIN. So I changed
C     things around a bit:
C     There is now no LGUIL5 because XGDBUP can only be called from places
C     which are altering list 5 anyway. Instead there is now an LGUIL2
C     instead, which was a bit overdue. LGUIL1 and LGUIL2 are set in
C     XFAL01 and XFAL02 respectively as the XGUIOV and PERM02 common blocks
C     are filled in. The result: Structure appears when it is supposed to
C     and no crashes in the mean time.
C
C Revision 1.8  1999/05/10 16:53:58  dosuser
C RIC: Removed unused routine GUI()
C
CODE FOR GUIBLK
      BLOCK DATA GUIBLK
\XGUIOV
      DATA ISERIA/0/, NATINF/0/
      DATA LGUIL1/.FALSE./
      DATA LGUIL2/.FALSE./
     1 LUPDAT/.FALSE./, QSINL5/.FALSE./
      DATA KSTAT1 /0/, KSTAT2 /0/, KSTAT3/0/, KSTAT5/0/, KSTAT6/0/,
     1 KSTATQ/0/, KSTATI/0/
      END


CODE FOR MENUUP (Updates the flags for the menus)
      SUBROUTINE MENUUP
\XUNITS
\XIOBUF
      INTEGER LCR
\XGUIOV
      LCR = 1

      IF(KEXIST(1).EQ.1)THEN
        IF (KSTAT1.LE.0) THEN
          WRITE(CMON(LCR),'(A)')'^^ST STATSET   L1'
          LCR = LCR + 1
          KSTAT1 = 1
        END IF
      ELSE
        IF (KSTAT1.GE.0) THEN
          WRITE(CMON(LCR),'(A)')'^^ST STATUNSET L1'
          LCR = LCR + 1
          KSTAT1 = -1
        END IF
      ENDIF

      IF(KEXIST(2).EQ.1)THEN
        IF(KSTAT2.LE.0) THEN
          WRITE(CMON(LCR),'(A)')'^^ST STATSET   L2'
          LCR = LCR + 1
          KSTAT2 = 1
        END IF
      ELSE
        IF ( KSTAT2.GE.0 ) THEN
          WRITE(CMON(LCR),'(A)')'^^ST STATUNSET L2'
          LCR = LCR + 1
          KSTAT2 = -1
        END IF
      ENDIF

      IF(KEXIST(3).EQ.1)THEN
        IF (KSTAT3.LE.0) THEN
          KSTAT3 = 1
          WRITE(CMON(LCR),'(A)')'^^ST STATSET   L3'
          LCR = LCR + 1
        END IF
      ELSE
        IF ( KSTAT3.GE.0 ) THEN
          KSTAT3 = -1
          WRITE(CMON(LCR),'(A)')'^^ST STATUNSET L3'
          LCR = LCR + 1
        END IF
      ENDIF

      IF(KEXIST(5).EQ.1)THEN
        IF(KSTAT5.LE.0) THEN
          KSTAT5 = 1
          WRITE(CMON(LCR),'(A)')'^^ST STATSET   L5'
          LCR = LCR + 1
        END IF
      ELSE
        IF ( KSTAT5.GE.0 ) THEN
          KSTAT5 = -1
          WRITE(CMON(LCR),'(A)')'^^ST STATUNSET L5'
          LCR = LCR + 1
        END IF
      ENDIF

      IF(KEXIST(6).EQ.1)THEN
        IF(KSTAT6.LE.0) THEN
          KSTAT6 = 1
          WRITE(CMON(LCR),'(A)')'^^ST STATSET   L6'
          LCR = LCR + 1
        END IF
      ELSE
        IF ( KSTAT6.GE.0 ) THEN
          KSTAT6 = -1
          WRITE(CMON(LCR),'(A)')'^^ST STATUNSET L6'
          LCR = LCR + 1
        END IF
      ENDIF

      IF(QSINL5)THEN
        IF(KSTATQ.LE.0) THEN
          KSTATQ = 1
          WRITE(CMON(LCR),'(A)')'^^ST STATSET   QS'
          LCR = LCR + 1
        END IF
      ELSE
        IF ( KSTATQ.GE.0 ) THEN
          KSTATQ = -1
          WRITE(CMON(LCR),'(A)')'^^ST STATUNSET QS'
          LCR = LCR + 1
        END IF
      ENDIF

      IF (INSTRC)THEN
        IF (KSTATI.LE.0) THEN
          KSTATI = 1
          WRITE(CMON(LCR),'(A)')'^^ST STATSET   IN'
          LCR = LCR + 1
        END IF
      ELSE
        IF ( KSTATI.GE.0 ) THEN
          KSTATI = -1
          WRITE(CMON(LCR),'(A)')'^^ST STATUNSET IN'
          LCR = LCR + 1
        END IF
      ENDIF
C
C
      IF ( LCR .GT. 1 ) THEN
        WRITE ( CMON(LCR), '(A)')'^^CR'
        CALL XPRVDU(NCVDU, LCR,0)
      END IF
C
      RETURN
      END
C
 
 
 
 
 
 
C
CODE FOR CRDIST2
      SUBROUTINE CRDIST2
C--SET UP A BPD VALUES
\XCONST
\XPDS
\XGUIOV
C--SET UP THE SHIFT DATA
      DO 1050 I=1,3
           K=9+I
         BPD(I)=0.
         DO 1000 J=1,I
            BPD(I)=BPD(I)+GUMTRX(K)*GUMTRX(K)
                  K=K+3
1000     CONTINUE
         BPD(I)=1./SQRT(BPD(I))
1050  CONTINUE
      RETURN
      END



CODE FOR XDSTNCR
      FUNCTION XDSTNCR(A,B)
C--COMPUTE THE DISTANCE SQUARED BETWEEN TWO POINTS
C
C  A  VECTOR CONTAINING THE COORDINATES OF THE FIRST POINT.
C  B  VECTOR CONTAINING THE COORDINATES OF THE SECOND POINT.
C
C--THE RETURN VALUE OF 'XDSTN2' IS THE DISTANCE SQUARED.
C
      DIMENSION A(3),B(3),C(3),D(3)
\XCONST
\XGUIOV
C
C--SUBTRACT THE VECTORS
      CALL XSUBTR(A(1),B(1),C(1),3)
C--ORTHOGONALISE THE DIFFERENCE VECTOR
      CALL XMLTTM(GUMTRX(1),C(1),D(1),3,3,1)
C--COMPUTE THE DISTANCE
      C(1)=D(1)*D(1)+D(2)*D(2)+D(3)*D(3)
C--CHECK THE VALUE
      IF(C(1)-ZEROSQ .LT. 0) C(1)=VALUSQ
C
      XDSTNCR=C(1)
      RETURN
      END
 


CODE FOR KDIST2
      FUNCTION KDIST2(NOC)
C--MOVES AN ATOM POSITIVELY FORWARD ONE UNIT CELL, AND CHECKS IF
C  THE ATOM IS STILL WITHIN THE SEARCH VOLUME FOR THE GIVEN AXIAL DIRECT
C
C  NOC  THE AXIAL DIRECTION ALONG WHICH TO MOVE.
C
C--THE RETURN VALUES OF 'KDIST' ARE :
C
C  -1  ATOM CANNOT BE FITTED IN THE REQUIRED VOLUME ANY MORE.
C   0  ATOM IS STILL WITHIN THE REQUIRED VOLUME FOR THIS DIRECTION.
C
C--THE ATOM IS ASSUMED TO HAVE BEEN POSITIONED OUTSIDE THE VOLUME BY
C  'XSHIFT', AND IT IS ALWAYS MOVED AT LEAST ONE UNIT CELL FOR EACH CALL
C  OF THIS ROUTINE.
C
C--THE COMMON BLOCK 'XPDS' IS USED AS :
C
C  APD(7-9)  CURRENT SET OF ATOMIC COORDINATES TO ALTER.
C  BPD(4-6)  MIINIMUM ALONG EACH OF THE AXIAL DIRECTIONS.
C  BPD(7-9)  MAXIMUM ALONG EACH OF THE AXIAL DIRECTIONS.
C
C--
\XPDS
C
      KDIST2=-1
C--JUMP THE ATOM TO AT LEAST JUST BEFORE THE REQUIRED VOLUME
      APD(NOC+6)=MAX(APD(NOC+6),MOD(APD(NOC+6),1.)+NINT(BPD(NOC+3))-1)
C--MOVE FORWARD ONE UNIT CELL
1000  CONTINUE
      APD(NOC+6)=APD(NOC+6)+1.
C--CHECK IF WE HAVE ARRIVED IN THE REQUIRED VOLUME
      IF(APD(NOC+6)-BPD(NOC+3))1000,1050,1050
C--CHECK IF WE HAVE GONE TOO FAR ALONG THIS AXIAL DIRECTION
1050  CONTINUE
      IF(APD(NOC+6)-BPD(NOC+6))1100,1100,1150
C--WE ARE IN THE REQUIRED VOLUME
1100  CONTINUE
      KDIST2=0
1150  CONTINUE
      RETURN
      END



CODE FOR XSHIFT2
      SUBROUTINE XSHIFT2(NOC)
C--SHIFTS THE ATOM OUT OF RANGE SO THAT IT CAN START COMING BACK
C
C  NOC  THE NUMBER OF THE PARAMETER TO MOVE, IN THE RANGE 1 TO 3.
C
C--THE COMMON BLOCK 'XPDS' IS USED AS :
C
C  APD(7-9)  CURRENT SET OF ATOMIC COORDINATES TO ALTER.
C  BPD(4-6)  MIINIMUM ALONG EACH OF THE AXIAL DIRECTIONS.
C  BPD(7-9)  MAXIMUM ALONG EACH OF THE AXIAL DIRECTIONS.
C
C--
\XPDS
C
C--CHECK IF WE GONE FAR ENOUGH BACKWARDS
1000  CONTINUE
      IF(APD(NOC+6)-BPD(NOC+3))1050,1100,1100
C--SUCCESS  -  NOW RETURN
1050  CONTINUE
      RETURN
C--MOVE BACK ONE MORE UNIT CELL
1100  CONTINUE
      APD(NOC+6)=APD(NOC+6)-1.
      GOTO 1000
      END






CODE FOR XGUIUP
      SUBROUTINE XGUIUP ( IULN )
C----- UPDATE THE GUI
C
C Unlike earlier versions of this subroutine, we can now sometimes claim store
C to load lists and update the GUI.
C
C Updating lists 5 updates the whole model, so lists 1,2,29,40 and 41
C are also loaded or required.
C
C IULN
C   0 - process all list information that needs updating.
C   +ve - update list IULN
C   -ve - update list -IULN, but don't touch store. ( We may use STR11 )
C         for list 5, this means that 1, 2, 5, 29 and 41 must have been
c         loaded by the calling routine.

\ISTORE
\STORE
\XUNITS
\UFILE
\XIOBUF
\XSSVAL
\XOPVAL
\XGUIOV
\QSTORE
\QGUIOV
\XCONST 
\XLST05
\XLST01
\XLST02
\XLST23
\XLST29
\XLST30
\XLST41
\TYPE11
\XSTR11 
\QSTR11
\XDISCB

      DIMENSION JDEV(4)
      REAL TENSOR(3,3), TEMPOR(3,3), ROTN(3,3), AXES(3,3)
      CHARACTER CCOL*6, WCLINE*80, CFILEN*256, CATTYP*4,CLAB*32,CLAB2*32
      CHARACTER * 4 CNAME
      LOGICAL WEXIST
      CHARACTER*8 CINST(6)
      INTEGER IUNKN

      DIMENSION LST(7)
      DIMENSION ICLINF(400)
      DIMENSION TXYZ(9)


      SAVE NCLINF, ICLINF

      DATA ISERnn /50*0/
      DATA NCLINF /0/

      DATA    CINST /'Unknown','CAD4','Mach3','KappaCCD','Dip','Smart'/
      DATA    IUNKN /'UNKN'/

C
C The QSINl5 flag is set here, if there are Q atoms in list 5.
C It is used by the menu update routine.
C
C LUPDAT flag prevents the data from being sent to the GUI.
C

2     FORMAT(A)


C Wait for disk buffers to be allocated, before loading lists.
      IF ( IACC .LT. 0 ) RETURN

      IF ( .NOT. LUPDAT ) RETURN

      IF ( IULN .GE. 0 ) THEN
        CALL XRSL
        CALL XCSAE
      END IF

c      WRITE(CMON,'(a)')' XGUIUP: ENTRY.'
c      CALL XPRVDU (NCVDU,1,0)

C
C -- CLEAR ERROR FLAG
C
      IERFLG = 1



      IF ( IULN .EQ. 0 ) THEN ! decide what needs updating
c         WRITE(CMON,'(a)')' XGUIUP: Setting 6 lists to be updated.'
c         CALL XPRVDU (NCVDU,1,0)
         NLST = 6
         LST(1) = 1
         LST(2) = 2
         LST(3) = 5
         LST(4) = 23
         LST(5) = 29
         LST(6) = 30
      ELSE
         NLST = 1
         LST(1) = ABS(IULN)
         IF ( LST(1) .EQ. 41 ) LST(1) = 5  !Use 5 it will include 41.
      ENDIF

      DO MLST = 1,NLST       !Loop over the lists to be sent up.
         ILST = LST(MLST)

C Branch on type of list that needs sending:

         IF ( ILST .EQ. 5 ) THEN   ! atom coordinates - update model

C 'ISSUPD' CAN  BE RESET BY '#SET AUTO = OFF/ON (VALUE 0/1)
            IF ( ISSUPD .EQ. 0 ) THEN
c      WRITE(CMON,'(a)')' XGUIUP: Model update suppressed by user.'
c      CALL XPRVDU (NCVDU,1,0)
             ISERnn(5)  = 0         ! Ensure update if/when ISSUPD is 
             ISERnn(41) = 0         ! switched back on.
             CYCLE ! The model may be switched off for speed reasons.
            ENDIF

            IF ( IULN .LT. 0 ) THEN ! not allowed to load lists, ensure
                                    ! already loaded.

c               WRITE(CMON,'(a)')' XGUIUP: L5: Sneaky update.'
c               CALL XPRVDU (NCVDU,1,0)

               IF(KEXIST(1).LE.0) CYCLE
               IF(KEXIST(2).LE.0) CYCLE
               IF(KEXIST(5).LE.0) CYCLE
               IF(KEXIST(29).LE.0) CYCLE
               IF(KEXIST(41).LE.0) CYCLE
               IF(KHUNTR(1,0,IADDL,IADDR,IADDD,-1).NE.0) CYCLE
               IF(KHUNTR(2,0,IADDL,IADDR,IADDD,-1).NE.0) CYCLE
               IF(KHUNTR(5,0,IADDL,IADDR,IADDD,-1).NE.0) CYCLE
               IF(KHUNTR(29,0,IADDL,IADDR,IADDD,-1).NE.0) CYCLE
C In this mode, we can't run XBCALC so the existing 41 will have to do.
               IF(KHUNTR(41,0,IADDL,IADDR,IADDD,-1).NE.0) CYCLE

            ELSE

c               WRITE(CMON,'(a)')' XGUIUP: L5: Full update.'
c               CALL XPRVDU (NCVDU,1,0)

               IF(KEXIST(1).LE.0) CYCLE
               IF(KEXIST(2).LE.0) CYCLE
               IF(KEXIST(5).LE.0) CYCLE
               IF(KEXIST(29).LE.0) CYCLE

C Ensure list 41 dependencies are up to date:
               IF ( K41DEP() .LT. 0 ) THEN
                 CALL XRSL
                 CALL XCSAE
                 CALL XBCALC(1)
                 CALL XRSL
                 CALL XCSAE
               ENDIF

               IF(KHUNTR(1,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL01
               IF(KHUNTR(2,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL02
               IF(KHUNTR(5,0,IADDL,IADDR,IADDD,-1).NE.0)  CALL XFAL05
               IF(KHUNTR(29,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL29
               IF(KHUNTR(41,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL41
               IF ( IERFLG .LT. 0 ) GO TO 9920
            END IF

            CALL XRLIND(5, L05SR, NFW, LL, IOW, NOS, ID)
            CALL XRLIND(41,L41SR, NFW, LL, IOW, NOS, ID)

C If the current list is is the same as one sent before then
C don't update the GUI.

            IF ( (L05SR.EQ.ISERnn(5)).AND.(L41SR.EQ.ISERnn(41)) ) THEN
c      WRITE(CMON,'(a)')' XGUIUP: Model serial unchanged.'
c      CALL XPRVDU (NCVDU,1,0)

              CYCLE
            ENDIF

C Set old list number to current list number.
            ISERnn(5)  = L05SR
            ISERnn(41) = L41SR

            QSINL5 = .FALSE.


C Calculate and store orthogonal coords....
C Calculate sum of x, y and z as we go.
            XMAX = -100000.0
            XMIN =  100000.0 
            YMAX = -100000.0
            YMIN =  100000.0
            ZMAX = -100000.0
            ZMIN =  100000.0
            IPLACE = 1
            J = L5
            KNF11 = 1

            DO I = L5, L5+(N5-1)*MD5, MD5
              CALL XMLTTM(STORE(L1O1),STORE(I+4),STR11(IPLACE),3,3,1)
              XMIN = MIN(XMIN,STR11(IPLACE))
              YMIN = MIN(YMIN,STR11(IPLACE+1))
              ZMIN = MIN(ZMIN,STR11(IPLACE+2))
              XMAX = MAX(XMAX,STR11(IPLACE))
              YMAX = MAX(YMAX,STR11(IPLACE+1))
              ZMAX = MAX(ZMAX,STR11(IPLACE+2))
              IPLACE = IPLACE + 3
            END DO

            KNF11 = IPLACE

C Calculate the centre of the molecule
            GCENTX = (XMIN + XMAX) / 2.0
            GCENTY = (YMIN + YMAX) / 2.0
            GCENTZ = (ZMIN + ZMAX) / 2.0

C Find atom furthest from the center to set scaling.
C NB, it is quicker to find the center and longest distance from it
C (two loops through the list), than to find the longest distance
C between all pairs of atoms (n squared / 2 loops through the list...)
C
C Centre the molecule on 0,0,0 at the same time!

            RLENTH = 0
            DO I = 1, 3*N5,3
              STR11(I)   = STR11(I)   - GCENTX
              STR11(I+1) = STR11(I+1) - GCENTY
              STR11(I+2) = STR11(I+2) - GCENTZ
              TMPLEN =  ( (STR11(I  )**2)
     1                 + (STR11(I+1)**2)
     2                 + (STR11(I+2)**2) )
              RLENTH = MAX (TMPLEN,RLENTH)
            END DO

            IF (RLENTH.LT.0.1)THEN
              GSCALE = 5000.0
            ELSE
              GSCALE = 5000.0 / (SQRT (RLENTH) + 2)
            ENDIF

c      WRITE ( CMON, '(A,I5)')'GUI-UP: L5: Updating N atoms:', N5
c      CALL XPRVDU(NCVDU, 1,0)

            IF ( N5 .GT. 0 ) THEN     !Only do if there are some atoms.

             WRITE ( CMON, '(A/A)')'^^GR MODEL L5','^^CW'
             CALL XPRVDU(NCVDU, 2,0)


             IPLACE = 1
             DO I5 = L5,L5+(N5-1)*MD5, MD5

C Get atom type.

               LSPARE = .FALSE.
               IATTYP = ISTORE(I5)
               WRITE(CATTYP,'(A4)')IATTYP
               IF(CATTYP(1:1).EQ.'Q') THEN
                 QSINL5 = .TRUE.
                 IF ( STORE (I5+13).GT.0.0001 ) LSPARE = .TRUE.
               END IF

               KFNDPR = 0

C Look for properties in L29:
               DO M29 = L29, L29+(N29-1)*MD29, MD29
                 IF ( ISTORE(M29) .EQ. ISTORE(I5) ) THEN
                    COV = STORE(M29+1)
                    VDW = STORE(M29+2)
                    ICOL = ISTORE(M29+7)
                    KFNDPR = 1
                    EXIT
                 ENDIF
               END DO

               IF ( ICOL .EQ. IUNKN ) KFNDPR = 0 !UNKNOWN colour. (L29 default)

C Look for properties in our cache: (things like Q, which are not in 29).
               IF ( KFNDPR .EQ. 0 ) THEN
                 DO K = 1, NATINF * 4, 4
                   IF(IATINF(K).EQ.ISTORE(I5)) THEN
                      VDW =  ATINF(K+1)
                      COV =  ATINF(K+2)
                     ICOL = IATINF(K+3)
                     KFNDPR = 1
                     EXIT
                   ENDIF
                 ENDDO
               ENDIF

               IF ( KFNDPR .EQ. 0 ) THEN
C Atom info not found. Load it and cache it. The info is stored
C in common, so only needs loading once.

##LINGIL             CFILEN = 'CRYSDIR:script\propwin.dat'
&&LINGIL             CFILEN = 'CRYSDIR:script/propwin.dat'
                  CALL MTRNLG(CFILEN,'OLD',ILENG)
                  INQUIRE(FILE=CFILEN(1:ILENG),EXIST=WEXIST)
                  IF(WEXIST) THEN
                    CALL XMOVEI(KEYFIL(1,2), JDEV, 4)
                    CALL XRDOPN (6, JDEV, CFILEN(1:ILENG), ILENG)
                    IF ( IERFLG .LT. 0) GOTO 9900
C Read the properties file and extract cov, vdw and colour.
                    DO WHILE ( KFNDPR .EQ. 0 )
                      READ(NCARU,'(A80)',END=89) WCLINE
                      IF((WCLINE(1:3).NE.'CON').AND.
     1                   (WCLINE(1:3).NE.'   ')) THEN

                        IF(WCLINE(1:2).EQ.CATTYP) THEN
                          CCOL = WCLINE(62:67)
                          READ(WCLINE(13:16),'(F4.2)') COV
                          READ(WCLINE(35:38),'(F4.2)') VDW
                          READ(WCLINE(62:65),'(A4)') ICOL
                          IATINF((NATINF*4)+1) = IATTYP
                          ATINF((NATINF*4)+2)  = VDW
                          ATINF((NATINF*4)+3)  = COV
                          IATINF((NATINF*4)+4) = ICOL
                          NATINF = NATINF + 1
                          KFNDPR = 1
                          EXIT
                        END IF
                      ENDIF
                    END DO
89                  CONTINUE !End of file
                    CLOSE(NCARU)
                  END IF
               END IF

               IF ( KFNDPR .EQ. 0 ) THEN
C Atom info still not found. Store default values in cache.
                  IATINF((NATINF*4)+1) = IATTYP
                  ATINF((NATINF*4)+2)  = 1.8
                  ATINF((NATINF*4)+3)  = 0.8
                  IATINF((NATINF*4)+4) = 0
                  NATINF = NATINF + 1
                  COV = 0.8
                  VDW = 1.8
                  ICOL = 0
                  KFNDPR = 1
               END IF


C Get colour definition from our cache:
               KFNDPR = 0
               DO K = 1, NCLINF * 4, 4
                 IF(ICLINF(K).EQ.ICOL) THEN
                   IRED  = ICLINF(K+1)
                   IGRE  = ICLINF(K+2)
                   IBLU  = ICLINF(K+3)
                   KFNDPR = 1
                   EXIT
                 ENDIF
               ENDDO

               IF ( KFNDPR .EQ. 0 ) THEN

C Get the colour definition for this colour from colour.cmn and cache it.
##GILLIN                  CFILEN = 'CRYSDIR:SCRIPT\COLOUR.CMN'
&&GILLIN                  CFILEN = 'CRYSDIR:script/colour.cmn'
                  CALL MTRNLG(CFILEN,'OLD',ILENG)
                  INQUIRE(FILE=CFILEN(1:ILENG),EXIST=WEXIST)
                  IF(WEXIST) THEN
                    IF (KFLOPN (NCARU, CFILEN(1:ILENG), ISSOLD, ISSREA,
     1                  1, ISSSEQ) .EQ. -1) GOTO 9900
                    DO WHILE ( KFNDPR .EQ. 0 )
                      READ(NCARU,'(A4,3X,A21)',END=88) IICOL, WCLINE
                      IF(IICOL.EQ.ICOL)THEN
                         READ(WCLINE(1:15),'(3I5)')IRED,IGRE,IBLU
                         ICLINF((NCLINF*4)+1) = ICOL
                         ICLINF((NCLINF*4)+2) = IRED
                         ICLINF((NCLINF*4)+3) = IGRE
                         ICLINF((NCLINF*4)+4) = IBLU
                         NCLINF = NCLINF + 1
                         KFNDPR = 1
                         EXIT
                      ENDIF
                    END DO
88                  CONTINUE !End of file
                    CLOSE(NCARU)
                  ENDIF
               ENDIF

               IF ( KFNDPR .EQ. 0 ) THEN
C Colour info still not found, use and cache default values:
                  IRED = 0
                  IGRE = 0
                  IBLU = 0
                  ICLINF((NCLINF*4)+1) = ICOL
                  ICLINF((NCLINF*4)+2) = IRED
                  ICLINF((NCLINF*4)+3) = IGRE
                  ICLINF((NCLINF*4)+4) = IBLU
                  NCLINF = NCLINF + 1
               END IF

               CALL CATSTR (STORE(I5),STORE(I5+1),1,1,0,0,0,CLAB,LLAB)

               IF ( NINT(STORE(I5+3)) .EQ. 0 ) THEN

                 TENSOR(1,1) = STORE(I5+7)
                 TENSOR(2,2) = STORE(I5+8)
                 TENSOR(3,3) = STORE(I5+9)
                 TENSOR(2,3) = STORE(I5+10)
                 TENSOR(1,3) = STORE(I5+11)
                 TENSOR(1,2) = STORE(I5+12)
                 TENSOR(3,2) = TENSOR(2,3)
                 TENSOR(3,1) = TENSOR(1,3)
                 TENSOR(2,1) = TENSOR(1,2)
      
c                WRITE(99,'(A)') 'CRY: TENSOR, ORTHTENSOR, AXES, ELOR: '
c                WRITE(99,'(9(1X,F7.4))') ((TENSOR(KI,KJ),KI=1,3),KJ=1,3)
                     
                 CALL XMLTMM(GUMTRX(19), TENSOR,     TEMPOR,3,3,3)
                 CALL XMLTMT(TEMPOR,     GUMTRX(19), TENSOR,3,3,3)

C We now have an orthogonal tensor in TENSOR(3,3).

c                WRITE(99,'(9(1X,F7.4))') ((TENSOR(KI,KJ),KI=1,3),KJ=1,3)

##DVFLIN         CALL ZEIGEN(TENSOR,ROTN)

C Filter out tiny axes
                 TENSOR(1,1) = MAX ( TENSOR(1,1), TENSOR(2,2)/100 )
                 TENSOR(1,1) = MAX ( TENSOR(1,1), TENSOR(3,3)/100 )
                 TENSOR(2,2) = MAX ( TENSOR(2,2), TENSOR(1,1)/100 )
                 TENSOR(2,2) = MAX ( TENSOR(2,2), TENSOR(3,3)/100 )
                 TENSOR(3,3) = MAX ( TENSOR(3,3), TENSOR(1,1)/100 )
                 TENSOR(3,3) = MAX ( TENSOR(3,3), TENSOR(2,2)/100 )
            
                 DO KI=1,3
                   DO KJ=1,3
                     AXES(KI,KJ) =   ROTN(KJ,KI)
     1                             * SQRT(ABS(TENSOR(KJ,KJ)))
     2                             * GSCALE
     3                             * 1.5
                   END DO
                 END DO

C                WRITE(99,'(9(1X,F7.4))') ((AXES(KI,KJ)/GSCALE,KI=1,3),KJ=1,3)
C                WRITE(99,'(9(1X,F7.4))') (GUMTRX(KI),KI=19,27)

               ELSE
                 DO KI=1,3
                   DO KJ=1,3
                     AXES(KI,KJ) = 0
                   END DO
                 END DO
                 AXES(1,1) = SQRT(ABS(STORE(I5+7))) * GSCALE
               END IF


               IF ( LSPARE ) THEN
                  ISPARE = NINT(1000 * STORE(I5+13) )
                  SPARE = 0.297 * (STORE(I5+13)**(1.0/3.0))
                  AXES (1,1) = ( GSCALE * SPARE )
                  AXES (2,2) = ( GSCALE * SPARE )
                  AXES (3,3) = ( GSCALE * SPARE )
                  AXES (1,2) = 0.0
                  AXES (1,3) = 0.0
                  AXES (2,1) = 0.0
                  AXES (2,3) = 0.0
                  AXES (3,1) = 0.0
                  AXES (3,2) = 0.0
                  STORE(I5+3) = 0.0

c                  WRITE (CMON,'(3F15.8,I8,A4,I4)') SPARE, AXES(1,1),
c     1                   STORE(I5+13), I5, ISTORE(I5),NINT(STORE(I5+1))
c                  CALL XPRVDU(NCVDU,1,0)

               ELSE
                   ISPARE = NINT(COV*GSCALE)
               END IF

c96             FORMAT (A,I4,1X,A,/,A,8(1X,I6),/,A,3(1X,I6),/,A,9(1X,I6))
c               WRITE ( CMON,96 )
c     1         '$$GR ATOM ',
c     2         1,  CLAB(1:LLAB),
c     3         '$$GR ',
c     4         NINT(STR11(IPLACE)*GSCALE),
c     5         NINT(STR11(IPLACE+1)*GSCALE),
c     6         NINT(STR11(IPLACE+2)*GSCALE),
c     7         NINT(IRED*2.55),NINT(IGRE*2.55),NINT(IBLU*2.55),
c     8         NINT(1000*STORE(I5+2)), NINT(COV*GSCALE),
c     1         '$$GR',
c     2         NINT(VDW*GSCALE),ISPARE,NINT(STORE(I5+3)),
c     1         '$$GR',
c     3         ((NINT(AXES(KI,KJ)),KI=1,3),KJ=1,3)
c               CALL XPRVDU(NCVDU, 4,0)
c              WRITE(NCAWU,'(A)') (CMON(IDJW),IDJW=1,3)


               CALL FSTATM( LLAB,CLAB,NINT(STR11(IPLACE)*GSCALE),
     5         NINT(STR11(IPLACE+1)*GSCALE),
     6         NINT(STR11(IPLACE+2)*GSCALE),
     7         NINT(IRED*2.55),NINT(IGRE*2.55),NINT(IBLU*2.55),
     8         NINT(1000*STORE(I5+2)), NINT(COV*GSCALE),
     2         NINT(VDW*GSCALE),ISPARE,NINT(STORE(I5+3)),
     3         NINT(AXES(1,1)),NINT(AXES(2,1)),NINT(AXES(3,1)),
     3         NINT(AXES(1,2)),NINT(AXES(2,2)),NINT(AXES(3,2)),
     3         NINT(AXES(1,3)),NINT(AXES(2,3)),NINT(AXES(3,3)) )



               IPLACE = IPLACE + 3
             END DO


C Output bonds:

c       WRITE ( CMON, '(A,I4)')'GUI-UP: L5: Updating N Bonds: ',N41B
c       CALL XPRVDU(NCVDU, 1,0)

             DO M41B = L41B, L41B+(N41B-1)*MD41B, MD41B

               IA1 = ISTORE(M41B)
               IA2 = ISTORE(M41B+6)

               IAT1P = L5 + IA1 * MD5
               IAT2P = L5 + IA2 * MD5

C Set colour to black:
               KR = 0
               KG = 0
               KB = 0

C If a symm related atom, colour bond bright white, and calculate real
C co-ordinates for bond end.
               ISSYM = 0
               DO I = 1,2
                  IF ((ISTORE(M41B+I).NE.1).OR.
     1                (ISTORE(M41B+I+6).NE.1)) ISSYM=1
               END DO
               DO I = 3,5
                  IF ((ISTORE(M41B+I).NE.0).OR.
     1                (ISTORE(M41B+I+6).NE.0)) ISSYM=1
               END DO
C Should be 1,1,0,0,0 and 1,1,0,0,0
               IF ( ISSYM .NE. 0 ) THEN
                  KR = 230
                  KG = 230
                  KB = 230
C -- Apply symmetry to atom 1:
                  M2 = L2 + ( MIN(N2,ABS(ISTORE(M41B+1))) - 1) * MD2
                  M2P =L2P+ ( MIN(N2P,ISTORE(M41B+2))     - 1) * MD2P

c              WRITE(CMON,'(A,3F9.3)')'Atom1:',(STORE(IAT1P+L),L=4,6)
c              CALL XPRVDU(NCVDU,1,0)

                  CALL XMLTTM(STORE(M2),STORE(4+IAT1P),TXYZ(1),3,3,1)
c              WRITE(CMON,'(A,3F9.3)')'symm:',(TXYZ(L),L=1,3)
c              CALL XPRVDU(NCVDU,1,0)
                  IF (ISTORE(M41B+1).LT.0)CALL XNEGTR(TXYZ(1),TXYZ(1),3)
c              WRITE(CMON,'(A,3F9.3)')'negt:',(TXYZ(L),L=1,3)
c              CALL XPRVDU(NCVDU,1,0)
C -- Translate
                  DO L = 0,2
                     TXYZ(7+L) = TXYZ(1+L) +STORE(M2P+L) +STORE(M2+9+L)
     1                          +ISTORE(M41B+3+L)
                  END DO
c              WRITE(CMON,'(A,3F9.3)')'trans:',(TXYZ(L),L=7,9)
c              CALL XPRVDU(NCVDU,1,0)

C -- Orthogonalise
                  CALL XMLTTM(STORE(L1O1),TXYZ(7),TXYZ(1),3,3,1)
c              WRITE(CMON,'(A,3F9.3)')'ortho:',(TXYZ(L),L=1,3)
c              CALL XPRVDU(NCVDU,1,0)

C -- Centre with the rest of the molecule.
                  TXYZ(1)   = TXYZ(1) - GCENTX
                  TXYZ(2)   = TXYZ(2) - GCENTY
                  TXYZ(3)   = TXYZ(3) - GCENTZ

C -- Apply symmetry to atom 2:
                  M2 =  L2 + (MIN(N2,ABS(ISTORE(M41B+7))) - 1) * MD2 
                  M2P = L2P+ (MIN(N2P,ISTORE(M41B+8))    - 1) * MD2P
                  CALL XMLTTM(STORE(M2),STORE(4+IAT2P),TXYZ(4),3,3,1)
                  IF(ISTORE(M41B+7).LT.0)CALL XNEGTR(TXYZ(4),TXYZ(4),3)
C -- Translate
                  DO L = 0,2
                     TXYZ(7+L) = TXYZ(4+L) +STORE(M2P+L) +STORE(M2+9+L)
     1                          +ISTORE(M41B+9+L)
                  END DO
C -- Orthogonalise
                  CALL XMLTTM(STORE(L1O1),TXYZ(7),TXYZ(4),3,3,1)
C -- Centre with the rest of the molecule.
                  TXYZ(4) = TXYZ(4) - GCENTX
                  TXYZ(5) = TXYZ(5) - GCENTY
                  TXYZ(6) = TXYZ(6) - GCENTZ

               ELSE
                  CALL XMOVE ( STR11((IA1*3)+1), TXYZ(1), 3)
                  CALL XMOVE ( STR11((IA2*3)+1), TXYZ(4), 3)
               END IF

C See if this bond is in CSD list. If so, use it's deviation to colour it.
               IF ( KBDDEV(IAT1P,IAT2P,DEVN) .GT. 0 )THEN

C As deviation goes positive, KB and KG should decrease giving a red colour
C As deviation goes negative, KR and KG should decrease giving a blue colour
C i.e. +ve devn. KR 255, KB ->0  KG ->0
C      -ve devn  KR ->0, KB 255  KG ->0
C But, the deviation starts being coloured from 1.0, rather than 0.0
C DEVN = DEVN - 1
                  KR = MAX ( 0, MIN (255, NINT (383+128*DEVN) ) )
                  KG = MAX ( 0, MIN (255, NINT (383-128*ABS(DEVN))))
                  KB = MAX ( 0, MIN (255, NINT (383-128*DEVN) )  )
               ENDIF

               CALL CATSTR (STORE(IAT1P),STORE(IAT1P+1),
     1                       ISTORE(M41B+1),ISTORE(M41B+2),
     1                       ISTORE(M41B+3),ISTORE(M41B+4),
     1                       ISTORE(M41B+5), CLAB, LLAB )
               CALL CATSTR (STORE(IAT2P),STORE(IAT2P+1),
     1                       ISTORE(M41B+7),ISTORE(M41B+8),
     1                       ISTORE(M41B+9),ISTORE(M41B+10),
     1                       ISTORE(M41B+11), CLAB2, LLAB2 )


c               WRITE ( CMON,'(A,10(1X,I5),/,5A,1X,F6.3,1X,I4)')
c     1                 '$$GR BOND ',
c     1                  (NINT(TXYZ(KJ)*GSCALE),KJ=1,6),
c     3                  KR,KG,KB,
c     1                  NINT(GSCALE*0.25),
c     1                  '$$GR ''',CLAB(1:LLAB),''' ''',
c     1                            CLAB2(1:LLAB2),'''',
c     1                  STORE(M41B+13), ISTORE(M41B+12)
c               CALL XPRVDU(NCVDU, 2,0)

               ISTR11(KNF11) = IA1
               ISTR11(KNF11+1) = IA2

               WRITE(CMON(1),'(3A,F6.3)')CLAB(1:LLAB),'-',
     1                                  CLAB2(1:LLAB2), STORE(M41B+13)
               CALL XCTRIM( CMON(1), LTMN )

               IF ( ISSYM .EQ. 0 ) THEN   !Normal bond
                 CALL FSTBND( NINT(TXYZ(1)*GSCALE),NINT(TXYZ(2)*GSCALE),
     1             NINT(TXYZ(3)*GSCALE),NINT(TXYZ(4)*GSCALE),
     1             NINT(TXYZ(5)*GSCALE),NINT(TXYZ(6)*GSCALE),
     1             KR,KG,KB,NINT(GSCALE*0.25),ISTORE(M41B+12),
     1             2,ISTR11(KNF11),LTMN,CMON(1),0,'')
               ELSE                       !Bond across symm op.
                 CALL FSTBND( NINT(TXYZ(1)*GSCALE),NINT(TXYZ(2)*GSCALE),
     1             NINT(TXYZ(3)*GSCALE),NINT(TXYZ(4)*GSCALE),
     1             NINT(TXYZ(5)*GSCALE),NINT(TXYZ(6)*GSCALE),
     1             KR,KG,KB,NINT(GSCALE*0.25),-ISTORE(M41B+12),
     1             2,ISTR11(KNF11),LTMN,CMON(1),LLAB2,CLAB2(1:LLAB2))
               END IF
             END DO

             IF ( MD41S .EQ. 0 ) MD41S = 1 !Catch old List 41's (during development only).
             DO M41S = L41S, L41S+(N41S-1)*MD41S, MD41S

               KNF11 = 1
               DO I = 1,ISTORE(M41S)
                 IA  = ISTORE(M41S+I)
                 IAP = L5 + IA * MD5
c                 WRITE(CMON,'(A4,I4)')ISTORE(IAP),NINT(STORE(IAP+1))
c                 CALL XPRVDU(NCVDU,1,0)
                 CALL XMOVE(STORE(IAP+4),STR11(KNF11),4)
                 STR11(KNF11+3) = 1.0
                 KNF11 = KNF11 + 4
               ENDDO
               IA1 = ISTORE(M41S+1)
               IA2 = ISTORE(M41S+MIN(4,ISTORE(M41S)))
               IAT1P = L5 + IA1 * MD5
               IAT2P = L5 + IA2 * MD5
               CALL CATSTR (STORE(IAT1P),STORE(IAT1P+1),1,1,0,0,0,
     1                      CLAB,LLAB)
               CALL CATSTR (STORE(IAT2P),STORE(IAT2P+1),1,1,0,0,0,
     1                      CLAB2,LLAB2)

               ICENT = KNF11     
               IROOT = KNF11 + 3 
               IVECT = KNF11 + 6 
               ICSNE = KNF11 + 15
               IWORK = KNF11 + 24
               KNF11 = KNF11 + 28

               I = KMOLAX(STR11(1),ISTORE(M41S),4,STR11(ICENT),
     1             STR11(IROOT),STR11(IVECT),STR11(ICSNE),STR11(IWORK))

C Transform centroid into orthogonal (gui) coords.
               CALL XMLTTM(STORE(L1O1),STR11(ICENT),  TXYZ(1),3,3,1)

C Work out matrix for best-plane -> crystal fractions (wrt centroid).
               CALL XMLTMT(STR11(IVECT),STORE(L1O1),STR11(ICSNE),3,3,3)
               I=KINV2(3,STR11(ICSNE),STR11(KNF11),9,0,
     1                   STR11(IROOT),STR11(IROOT),3)
C The orientation of the torus is defined by the centroid and a normal
C vector. The length of this vector is interpreted as the radius of the
C ring. Take 0.7* the distance from centroid to any of the ring atoms.
               STR11(KNF11+9) =0.0
               STR11(KNF11+10)=0.0
               STR11(KNF11+11)=0.7*SQRT(XDSTN2(STR11(ICENT),
     +                                         STORE(IAT1P+4)))
C Transform {0,0,1} bp coords to crystal fractions.
               CALL XMLTMT(STR11(KNF11),STR11(KNF11+9),
     +                                     STR11(KNF11+12),3,3,1)
C Convert crystal fractions into orthogonal.
               CALL XMLTTM (STORE(L1O1),STR11(KNF11+12),TXYZ(4),3,3,1)
               TXYZ(1)   = TXYZ(1) - GCENTX
               TXYZ(2)   = TXYZ(2) - GCENTY
               TXYZ(3)   = TXYZ(3) - GCENTZ
C TXYZ(4-6) is relative to TXYZ(1-3)
               TXYZ(4)   = TXYZ(1) + TXYZ(4)
               TXYZ(5)   = TXYZ(2) + TXYZ(5)
               TXYZ(6)   = TXYZ(3) + TXYZ(6)

c               WRITE ( CMON,'(A,10(1X,I5),/,5A,1X,A,1X,I4)')
c     1                 '^^GR BOND ',
c     1                  (NINT(TXYZ(KJ)*GSCALE),KJ=1,6),
c     3                  0,0,0,
c     1                  NINT(GSCALE*0.25),
c     1                  '^^GR ''',CLAB(1:LLAB),''' ''',
c     1                            CLAB2(1:LLAB2),'''',
c     1                  ' ''et al. Aromatic Ring'' ', 101
c               CALL XPRVDU(NCVDU, 2,0)

               CALL FSTBND( NINT(TXYZ(1)*GSCALE),NINT(TXYZ(2)*GSCALE),
     1             NINT(TXYZ(3)*GSCALE),NINT(TXYZ(4)*GSCALE),
     1             NINT(TXYZ(5)*GSCALE),NINT(TXYZ(6)*GSCALE),
     1             0,0,0,NINT(GSCALE*0.25),101,
     1             ISTORE(M41S),ISTORE(M41S+1),13,
     1             'Aromatic Ring',0,'' )


c               WRITE ( CMON,'(A,6F8.5)')
c     1                 '  AROMATIC RING: ',
c     1                  (STR11(ICENT+KJ),KJ=0,2),
c     1                  (STR11(IVECT+KJ),KJ=6,8)
c               CALL XPRVDU(NCVDU, 1,0)
             ENDDO

             WRITE (CMON,'(A/A)')'^^GR SHOW','^^CW'
             CALL XPRVDU(NCVDU, 2,0)


            ELSE

             WRITE (CMON,'(A,2(/A))')'^^GR MODEL L5','^^GR SHOW','^^CW'
             CALL XPRVDU(NCVDU, 3,0)
c             WRITE ( CMON, '(A)')'GUI-UP: Empty L5'
c             CALL XPRVDU(NCVDU, 1,0)


            END IF

         ELSE IF ( ILST .EQ. 1 ) THEN   ! cell params - update info tab.

            IF ( IULN .LT. 0 ) THEN ! not allowed to load lists, ensure loaded
               IF(KEXIST(1).LE.0) CYCLE
               IF(KHUNTR(1,0,IADDL,IADDR,IADDD,-1).NE.0) GOTO 9910
            ELSE
               IF(KEXIST(1).LE.0) CYCLE
               IF(KHUNTR(1,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL01
            END IF
            CALL XRLIND(1, L01SR, NFW, LL, IOW, NOS, ID)
            IF ( L01SR.NE.ISERnn(1) )THEN
              ISERnn(1)  = L01SR

211           FORMAT ('^^WI SET _MT_CELL_A TEXT ',F8.4,/,
     1                '^^WI SET _MT_CELL_B TEXT ',F8.4,/,
     1                '^^WI SET _MT_CELL_C TEXT ',F8.4,/,
     1                '^^WI SET _MT_CELL_AL TEXT  ',F7.3,/,
     1                '^^WI SET _MT_CELL_BE TEXT  ',F7.3,/,
     1                '^^WI SET _MT_CELL_GA TEXT ',F7.3,/,
     1                '^^CR')
              WRITE ( CMON, 211 ) (STORE(L1P1+J),J=0,2),
     1                          (STORE(L1P1+J)*RTD,J=3,5)
              CALL XPRVDU(NCVDU, 7,0)
            ENDIF

         ELSE IF ( ILST .EQ. 2 ) THEN   ! space group - update info tab.

            IF ( IULN .LT. 0 ) THEN ! not allowed to load lists, ensure loaded
               IF(KEXIST(2).LE.0) CYCLE
               IF(KHUNTR(2,0,IADDL,IADDR,IADDD,-1).NE.0) GOTO 9910
            ELSE
               IF(KEXIST(2).LE.0) CYCLE
               IF(KHUNTR(2,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL02
            END IF
            CALL XRLIND(2, L02SR, NFW, LL, IOW, NOS, ID)
            IF ( L02SR.NE.ISERnn(2) )THEN
              ISERnn(2)  = L02SR
221           FORMAT ('^^CO SET _MT_SPACEGROUP TEXT ''',4(A4,1X),'''')
              WRITE ( CMON, 221 ) (STORE(L2SG+J),J=0,MD2SG-1)
              CALL XPRVDU(NCVDU, 1,0)
            ENDIF

         ELSE IF ( ILST .EQ. 23 ) THEN   ! SFLS control - get F or F2.

            IF ( IULN .LT. 0 ) THEN ! not allowed to load lists, ensure loaded
               IF(KEXIST(23).LE.0) CYCLE
               IF(KHUNTR(23,0,IADDL,IADDR,IADDD,-1).NE.0) GOTO 9910
            ELSE
               IF(KEXIST(23).LE.0) CYCLE
               IF(KHUNTR(23,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL23
            END IF
            CALL XRLIND(23, L23SR, NFW, LL, IOW, NOS, ID)
            IF ( L23SR.NE.ISERnn(23) )THEN
              ISERnn(23)  = L23SR
              IF ( ISTORE ( L23MN + 1 ) .EQ. -1 ) THEN
               WRITE (CMON,2) '^^CO SET _MT_REF_COEF TEXT ''F'''
              ELSE IF ( ISTORE ( L23MN + 1 ) .EQ. 0 ) THEN
               WRITE (CMON,2) '^^CO SET _MT_REF_COEF TEXT ''F squared'''
              ELSE
               WRITE (CMON,2) '^^CO SET _MT_REF_COEF TEXT ''Unknown'''
              END IF
              CALL XPRVDU(NCVDU, 1, 0)
            ENDIF

         ELSE IF ( ILST .EQ. 29 ) THEN   ! asymm unit - update info tab.
            IF ( IULN .LT. 0 ) THEN ! not allowed to load lists, ensure loaded
               IF(KEXIST(29).LE.0) CYCLE
               IF(KHUNTR(29,0,IADDL,IADDR,IADDD,-1).NE.0) GOTO 9910
            ELSE
               IF(KEXIST(29).LE.0) CYCLE
               IF(KHUNTR(29,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL29
            END IF
            CALL XRLIND(29, L29SR, NFW, LL, IOW, NOS, ID)
            IF ( L29SR.NE.ISERnn(29) )THEN
              ISERnn(29)  = L29SR

              WRITE( CMON(1),'(A)')'^^WI SET _MT_FORMULA TEXT'
              WRITE( CMON(2),'(A)')'^^WI'''
              WRITE( CMON(3),'(A)')'^^CR'
231           FORMAT (A4,F7.3,'-')
              K = 6
              DO M29=L29,L29+(N29-1)*MD29,MD29
                WRITE (CMON(2)(K:),231) STORE(M29), STORE(M29+4)
                CALL XCRAS ( CMON(2),K )
                DO L = K-1,K-6,-1              !Remove trailing zeroes.
                  IF (CMON(2)(L:L).EQ.'0') THEN
                    CMON(2)(L:L)=' '
                  ELSE
                     EXIT
                  END IF
                END DO
                K = K + 1
                IF ( K .GT. 70 ) EXIT
              END DO
              WRITE(CMON(2)(K:K),'(A)') ''''
              DO J = 1,K
                IF (CMON(2)(J:J).EQ.'-') CMON(2)(J:J)=' '
              END DO
              CALL XPRVDU(NCVDU, 3, 0)
            END IF
         ELSE IF ( ILST .EQ. 30 ) THEN   ! goodies - update info tab.
            IF ( IULN .LT. 0 ) THEN ! not allowed to load lists, ensure loaded
               IF(KEXIST(30).LE.0) CYCLE
               IF(KHUNTR(30,0,IADDL,IADDR,IADDD,-1).NE.0) GOTO 9910
            ELSE
               IF(KEXIST(30).LE.0) CYCLE
               IF(KHUNTR(30,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL30
            END IF
            CALL XRLIND(30, L30SR, NFW, LL, IOW, NOS, ID)
            IF ( L30SR.NE.ISERnn(30) )THEN
              ISERnn(30)  = L30SR

241           FORMAT ('^^WI SET _MT_CR_MIN TEXT ',F8.4,
     1                ' SET _MT_CR_MED TEXT ',F8.4,/,
     1                '^^WI SET _MT_CR_MAX TEXT ',F8.4,
     1                ' SET _MT_CR_TEMP TEXT  ',F5.1,/,
     1                '^^WI SET _MT_CR_DCALC TEXT ',F7.3,
     1                ' SET _MT_CR_MOLWT TEXT  ',F7.2,/,
     1                '^^WI SET _MT_CR_CELLZ TEXT ',F4.0,/,
     1                '^^CR')
              WRITE ( CMON,241 ) STORE(L30CD), STORE(L30CD+1),
     1           STORE(L30CD+2), STORE(L30CD+6), STORE(L30GE+1),
     1           STORE(L30GE+4), STORE(L30GE+5)
              CALL XPRVDU(NCVDU, 5, 0)
242           FORMAT ('^^WI SET _MT_CR_SHAPE TEXT ''',8A4,'''',/,
     1                '^^WI SET _MT_CR_COLOUR TEXT ''',8A4,'''',/,
     1                '^^CR')
              WRITE ( CMON, 242 ) (ISTORE(K),K=L30SH,L30SH+MD30SH-1),
     1                            (ISTORE(K),K=L30CL,L30CL+MD30CL-1)
              CALL XPRVDU(NCVDU, 3, 0)
243           FORMAT ('^^WI SET _MT_OBS_MEAS TEXT ',F7.0,
     1                    ' SET _MT_OBS_NMRG TEXT ',F7.0,/,
     1               '^^WI SET _MT_OBS_RMRG TEXT ',F8.5,
     1                    ' SET _MT_OBS_NFMRG TEXT ',F7.0,/,
     1                '^^WI SET _MT_OBS_RFMRG TEXT ',F8.5,/,
     1                '^^CR')
              WRITE ( CMON,243 ) STORE(L30DR), STORE(L30DR+2),
     1           STORE(L30DR+3), STORE(L30DR+4), STORE(L30DR+5)
              CALL XPRVDU(NCVDU, 4, 0)
244           FORMAT ('^^WI SET _MT_OBS_HMIN TEXT ',F4.0,
     1                    ' SET _MT_OBS_HMAX TEXT ',F4.0,/,
     1                '^^WI SET _MT_OBS_KMIN TEXT ',F4.0,
     1                    ' SET _MT_OBS_KMAX TEXT ',F4.0,/,
     1                '^^WI SET _MT_OBS_LMIN TEXT ',F4.0,
     1                    ' SET _MT_OBS_LMAX TEXT ',F4.0,/,
     1                '^^WI SET _MT_OBS_THMIN TEXT ',F4.0,
     1                    ' SET _MT_OBS_THMAX TEXT ',F4.0,/,
     1                '^^CR')
              WRITE ( CMON, 244 ) ( STORE(L30IX+J), J=0,7)
              CALL XPRVDU(NCVDU, 5, 0)
245           FORMAT ('^^CO SET _MT_OBS_INST TEXT ''',A8,'''')
              INS = ISTORE(L30CD+12) + 1
              IF (( INS .GT. 0 ) .AND. (INS. LE. 6)) THEN
                WRITE ( CMON, 245 ) CINST(INS)
              ELSE
                WRITE ( CMON, 245 ) 'New Type'
              END IF
              CALL XPRVDU ( NCVDU, 1, 0 )
246           FORMAT ('^^WI SET _MT_REF_R TEXT ',F8.5,
     1                    ' SET _MT_REF_RW TEXT ',F8.5,/,
     1                '^^WI SET _MT_REF_NPAR TEXT ',F5.0,
     1                    ' SET _MT_REF_SCUT TEXT ',F5.2,/,
     1                  '^^WI SET _MT_REF_GOOF TEXT ',F6.3,
     1                    ' SET _MT_REF_MAXRMS TEXT ',F8.4,/,
     1                '^^WI SET _MT_REF_NREF TEXT ',F7.0,/,
     1                '^^CR')
              WRITE ( CMON, 246 ) STORE(L30RF), STORE(L30RF+1),
     1            STORE(L30RF+2), STORE(L30RF+3),  STORE(L30RF+4),
     1            STORE(L30RF+7),STORE(L30RF+8)
              CALL XPRVDU(NCVDU, 5, 0)
            ENDIF
         ENDIF
      END DO

      RETURN

9900  CONTINUE
      WRITE ( CMON, '(A,/,A)')'Failed to open file : ',CFILEN(1:ILENG)
      CALL XPRVDU(NCVDU, 2,0)
      RETURN
9910  CONTINUE
c      WRITE ( CMON, '(A)')'GUI-UP: Some required lists not loaded.'
c      CALL XPRVDU(NCVDU, 1,0)
      RETURN
9915  CONTINUE
c      WRITE ( CMON, '(A)')'GUI-UP: Some required lists not present.'
c      CALL XPRVDU(NCVDU, 1,0)
      RETURN
9920  CONTINUE
      WRITE ( CMON, '(A)')'GUI-UP: Error loading list 41.'
      CALL XPRVDU(NCVDU, 1,0)
      RETURN

      END





CODE FOR KBDDEV
      FUNCTION KBDDEV ( IAT1P, IAT2P, DEVN )

C Return bond type (1-9) if it is found in the list.
C Return number of stdev's of actual value from mean.

\STORE
\ISTORE
\QSTORE
\TLST18                           

      KBDDEV = 0
      DEVN = 0.0

      IAT1N = ISTORE(IAT1P)     
      IAT1S = NINT(STORE(IAT1P+1))     
      IAT2N = ISTORE(IAT2P)     
      IAT2S = NINT(STORE(IAT2P+1))     
      
        DO 800 I = 1, NB18
                        
            JAT1N = IBLK(I,1)
            JAT1S = NINT(BBLK(I,2))
            JAT2N = IBLK(I,3)
            JAT2S = NINT(BBLK(I,4))

            IF( ( (IAT1N.EQ.JAT1N) .AND. (IAT1S.EQ.JAT1S) .AND.
     1            (IAT2N.EQ.JAT2N) .AND. (IAT2S.EQ.JAT2S) ) .OR.
     2          ( (IAT1N.EQ.JAT2N) .AND. (IAT1S.EQ.JAT2S) .AND.
     3            (IAT2N.EQ.JAT1N) .AND. (IAT2S.EQ.JAT1S) ) ) THEN

               BLEN = BBLK(I,5)
               KBDDEV = NINT(BBLK(I,6))
               DEVN = BBLK(I,8)
               RETURN
            END IF
800   CONTINUE

      RETURN
      END





&&GILGID      SUBROUTINE FSTBND(IX1,IY1,IZ1,IX2,IY2,IZ2,IR,IG,IB,IRAD,
&&GILGID     1 IBT,INP,LPTS,ILLEN,CLABL,ISLEN,CSLABL)
C
&GID      INTERFACE
&GID          SUBROUTINE FASTBOND (JX1, JY1, JZ1, JX2, JY2, JZ2,
&GID     1 JR,JG,JB,JRAD,JBT,JNP,KPTS,DLABL,DSLABL)
&GID          !DEC$ ATTRIBUTES C :: fastbond
&GID          !DEC$ ATTRIBUTES VALUE :: JX1
&GID          !DEC$ ATTRIBUTES VALUE :: JY1
&GID          !DEC$ ATTRIBUTES VALUE :: JZ1
&GID          !DEC$ ATTRIBUTES VALUE :: JX2
&GID          !DEC$ ATTRIBUTES VALUE :: JY2
&GID          !DEC$ ATTRIBUTES VALUE :: JZ2
&GID          !DEC$ ATTRIBUTES VALUE :: JR
&GID          !DEC$ ATTRIBUTES VALUE :: JG
&GID          !DEC$ ATTRIBUTES VALUE :: JB
&GID          !DEC$ ATTRIBUTES VALUE :: JRAD
&GID          !DEC$ ATTRIBUTES VALUE :: JBT
&GID          !DEC$ ATTRIBUTES VALUE :: JNP
&GID          !DEC$ ATTRIBUTES REFERENCE :: KPTS
&GID          !DEC$ ATTRIBUTES REFERENCE :: DLABL
&GID          !DEC$ ATTRIBUTES REFERENCE :: DSLABL
&GID          INTEGER JX1, JY1, JZ1, JX2, JY2, JZ2
&GID          INTEGER JR, JG, JB, JRAD, JBT, JNP, KPTS(*)
&GID          CHARACTER DLABL, DSLABL
&GID          END SUBROUTINE FASTBOND
&GID      END INTERFACE
C
&&GILGID      INTEGER IX1, IX2, IZ1, IY1, IY2, IZ2
&&GILGID      INTEGER IR,IG,IB,IRAD,IBT,INP,LPTS(*),ILLEN
&&GILGID      CHARACTER*(*) CLABL
&&GILGID      CHARACTER*(ILLEN+1) BLABL
&&GILGID      CHARACTER*(*) CSLABL
&&GILGID      CHARACTER*(ISLEN+1) BSLABL
C
&&GILGID      BLABL = CLABL(1:ILLEN)  // CHAR(0)
&&GILGID      BSLABL= CSLABL(1:ISLEN) // CHAR(0)
&GID      CALL FASTBOND(IX1,IY1,IZ1,IX2,IY2,IZ2,IR,IG,IB,IRAD,
&GID     1 IBT,INP,LPTS,BLABL,BSLABL)
&GIL      CALL FASTBOND(%VAL(IX1),%VAL(IY1),%VAL(IZ1),%VAL(IX2),
&GIL     1 %VAL(IY2),%VAL(IZ2),%VAL(IR),%VAL(IG),%VAL(IB),%VAL(IRAD),
&GIL     1 %VAL(IBT),%VAL(INP),LPTS,BLABL,BSLABL)
&&GILGID      RETURN
&&GILGID      END


&&GILGID      SUBROUTINE FSTATM(LL,CL,IX,IY,IZ,IR,IG,IB,IOC,ICO,IVD,
&&GILGID     1 ISP,IFL,IU1,IU2,IU3,IU4,IU5,IU6,IU7,IU8,IU9)
C
&GID      INTERFACE
&GID          SUBROUTINE FASTATOM (DL,JX,JY,JZ,JR,JG,JB,JOC,JCO,JVD,
&&GILGID     1 JSP,JFL,JU1,JU2,JU3,JU4,JU5,JU6,JU7,JU8,JU9)
&GID          !DEC$ ATTRIBUTES C :: fastatom
&GID          !DEC$ ATTRIBUTES VALUE :: JX
&GID          !DEC$ ATTRIBUTES VALUE :: JY
&GID          !DEC$ ATTRIBUTES VALUE :: JZ
&GID          !DEC$ ATTRIBUTES VALUE :: JR
&GID          !DEC$ ATTRIBUTES VALUE :: JG
&GID          !DEC$ ATTRIBUTES VALUE :: JB
&GID          !DEC$ ATTRIBUTES VALUE :: JOC
&GID          !DEC$ ATTRIBUTES VALUE :: JCO
&GID          !DEC$ ATTRIBUTES VALUE :: JVD
&GID          !DEC$ ATTRIBUTES VALUE :: JSP
&GID          !DEC$ ATTRIBUTES VALUE :: JFL
&GID          !DEC$ ATTRIBUTES VALUE :: JU1
&GID          !DEC$ ATTRIBUTES VALUE :: JU2
&GID          !DEC$ ATTRIBUTES VALUE :: JU3
&GID          !DEC$ ATTRIBUTES VALUE :: JU4
&GID          !DEC$ ATTRIBUTES VALUE :: JU5
&GID          !DEC$ ATTRIBUTES VALUE :: JU6
&GID          !DEC$ ATTRIBUTES VALUE :: JU7
&GID          !DEC$ ATTRIBUTES VALUE :: JU8
&GID          !DEC$ ATTRIBUTES VALUE :: JU9
&GID          !DEC$ ATTRIBUTES REFERENCE :: DL
&GID          INTEGER JL,JX,JY,JZ,JR,JG,JB,JOC,JCO,JVD
&GID          INTEGER JSP,JFL,JU1,JU2,JU3,JU4,JU5,JU6,JU7,JU8,JU9
&GID          CHARACTER DL
&GID          END SUBROUTINE FASTATOM
&GID      END INTERFACE
C
&&GILGID      INTEGER LL,IX,IY,IZ,IR,IG,IB,IOC,ICO,IVD
&&GILGID      INTEGER ISP,IFL,IU1,IU2,IU3,IU4,IU5,IU6,IU7,IU8,IU9
&&GILGID      CHARACTER*(*) CL
&&GILGID      CHARACTER*(LL+1) BL
C
&&GILGID      BL = CL(1:LL)  // CHAR(0)
&GID      CALL FASTATOM(BL,IX,IY,IZ,IR,IG,IB,IOC,ICO,IVD,
&GID     1 ISP,IFL,IU1,IU2,IU3,IU4,IU5,IU6,IU7,IU8,IU9)
&GIL      CALL FASTATOM(BL,%VAL(IX),%VAL(IY),%VAL(IZ),%VAL(IR),%VAL(IG),
&GIL     1 %VAL(IB),%VAL(IOC),%VAL(ICO),%VAL(IVD),%VAL(ISP),%VAL(IFL),
&GIL     1 %VAL(IU1),%VAL(IU2),%VAL(IU3),%VAL(IU4),%VAL(IU5),%VAL(IU6),
&GIL     1 %VAL(IU7),%VAL(IU8),%VAL(IU9))
&&GILGID      RETURN
&&GILGID      END

