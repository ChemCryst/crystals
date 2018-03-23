C $Log: publsh.F,v $
C Revision 1.17  2013/03/14 15:54:55  djw
C Much extended absolute configuration analysis, including the Parsons Quotient test.  More reflection filters added to #TON
C
C Revision 1.16  2012/07/11 13:43:25  djw
C Add command QCKCIF to create a minimal cif for Mercury
C
C Revision 1.15  2009/01/21 17:03:24  djw
C Add keyword to enable output of Friedel pairs
C
C Revision 1.14  2008/10/01 11:08:15  djw
C Support ofr outlier exclusion in Tons code
C
C Revision 1.13  2008/09/08 07:18:10  djw
C Link to Benfords Law
C
C Revision 1.12  2007/11/01 11:04:00  djw
C add access to Tons code
C
C Revision 1.11  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:08  rich
C New CRYSTALS repository
C
C Revision 1.10  2004/02/16 14:17:04  rich
C Output list of missing reflections to GUI during #THLIM calculation, if
C requested.
C
C Revision 1.9  2003/02/14 17:09:02  djw
C Extend codes to work wih list 6 and list 7.  Note that sfls, calc and
C recine have the parameter ityp06, which corresponds to the types
C pickedip for lists 6 and 7  from the command file
C
C Revision 1.8  2002/11/12 15:14:12  rich
C Extended plots from #SUM L 6 to include omitted reflections on the Fo vs Fc
C graph. They appear in blue.
C
C Revision 1.7  2002/07/29 13:01:41  richard
C #THLIM calls completeness code, which inserts values into L30.
C
C Revision 1.6  2001/10/08 12:25:58  ckp2
C
C All program sub-units now RETURN to the main CRYSTL() function inbetween commands.
C The changes made are: in every sub-program the GOTO's that used to loop back for
C the next KNXTOP command have been changed to RETURN's. In the main program KNXTOP is now
C called at the top of the loop, but first the current ProgramName (KPRGNM) array is cleared
C to ensure the KNXTOP knows that it is not in the correct sub-program already. (This
C is the way KNXTOP worked on the very first call within CRYSTALS).
C
C We now have one location (CRYSTL()) where the program flow returns between every command. I will
C put this to good use soon.
C
C Revision 1.5  2001/02/26 10:29:07  richard
C Added changelog to top of file
C
C
CODE FOR PUBLSH
      SUBROUTINE PUBLSH
      CALL XSYSDC(-1,1)
      CALL XPUBL
      RETURN
      END
C
CODE FOR XPUBL
      SUBROUTINE XPUBL
C--MAIN ROUTINE TO CONTROL PUBLICATION LISTINGS
C
C--
      INCLUDE 'XERVAL.INC'
C
C--LOAD THE NEXT '#INSTRUCTION'
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)
C--CHECK IF WE SHOULD RETURN
      IF(NUM.LE.0) RETURN
C--BRANCH ON THE TYPE OF OPERATION
C
C  REFLECTIONS  PARAMETERS  SUMMARY(display) GENERALEDIT  CIFOUT
C  THLIM  TON 
C  BENFORD QCKCIF PROPERTIES ADDARC
C
C      WRITE(123,*)'NUM=',NUM
      GO TO ( 2100, 2200, 2300, 2400, 2600, 2700, 2800, 
     1  2900, 3000, 3050, 3100, 3200, 1500 ) , NUM
1500  CONTINUE
      CALL XERHND ( IERPRG )
C
C--'#REFLECTIONS' INSTRUCTION
2100  CONTINUE
      CALL SPRT6P
      RETURN
C
C--'#PARAMETERS' INSTRUCTION
2200  CONTINUE
      CALL SPRT5P
      RETURN
C
2300  CONTINUE
C
C -- 'SUMMARY'
C
      CALL XSMMRY
      RETURN
C
2400  CONTINUE
C
C -- 'GENERALEDIT'
C
      CALL XGENED
      RETURN
c
2600  CONTINUE
C----- CIFOUT CIF OUTPUT
      CALL XCIFX
      RETURN
c
c
2700  CONTINUE
C----- THLIM - work out completeness, and stick in L30.
      CALL XTHX
      RETURN
c
2800  continue
c----- Ton Speks enantiopole
      call xton
      return
c
2900  continue
c----- Benfords Law
      call bensrt
      return
c
3000  continue
c----QCKCIF
      CALL XCIFQC
      return
C
3050  CONTINUE
C     Cell Properties
      CALL PROPERTIES
      RETURN
C
3100  CONTINUE
C ADD ARCHIVE-HKL.CIF TO cif file
      CALL CIFARCHIVE
      RETURN

3200  CONTINUE
C Create and add new record to List 39.
      CALL ADD39
      RETURN
      END
c
CODE FOR XTHX
      SUBROUTINE XTHX
      DIMENSION IPROCS(3)
      CALL XCSAE
      I = KRDDPV ( IPROCS , 3 )
      IPLOT = IPROCS(1)
      IULN = KTYP06(IPROCS(2))
      IGLST = IPROCS(3)
      IF (I.GE.0) CALL XTHLIM(RICA,RICB,RICC,RICD,RICE,IPLOT,IULN,IGLST)
      RETURN
      END
c
CODE FOR xton
      SUBROUTINE xton
      use absolut_mod, only:tonspkpascal
      DIMENSION FILTER(5)
      PARAMETER (NPROCS=10)
      DIMENSION IPROCS(NPROCS), PROCS(NPROCS)
      EQUIVALENCE (PROCS(1),IPROCS(1))
            
      CALL XCSAE
      I = KRDDPV ( IPROCS , NPROCS )
      KTYP06 = IPROCS(1)
      ITYPE = IPROCS(2)
      IPLOT = IPROCS(3)      
      IPUNCH = IPROCS(4)
      IWEIGHT = IPROCS(10)
      CALL XMOVE(PROCS(5), FILTER(1),5)
      IF (I.GE.0) THEN
        IF(ITYPE==2) THEN
          CALL TONSPKPASCAL(KTYP06,ITYPE,IPLOT,IPUNCH,FILTER,IWEIGHT)
        ELSE
          CALL TONSPK(KTYP06,ITYPE,IPLOT,IPUNCH,FILTER,IWEIGHT)
        END IF
      END IF
      RETURN
      END
c
CODE FOR bensrt
      SUBROUTINE bensrt
      DIMENSION IPROCS(3), PROCS(3)
      EQUIVALENCE (PROCS(1),IPROCS(1))
      CALL XCSAE
      I = KRDDPV ( IPROCS , 3 )
      keywrd = IPROCS(1)
      ktyp06 = IPROCS(2)
      scale  = PROCS(3)
      IF (I.GE.0) CALL benfrd(ktyp06,keywrd,scale)
      RETURN
      END
C
CODE FOR PROPERTIES
      SUBROUTINE PROPERTIES
      DIMENSION A(12)
      DIMENSION IPROCS(1)
      CALL XCSAE
      I = KRDDPV (IPROCS, 1)
      IF (I .GE.0) idummy=KCPROP(A)
      RETURN
      END
C
