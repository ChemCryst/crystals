      INTEGER JA,JB,JC,JD,JE,JF,JG,JH,JI,JJ,JK,JL,JM,JN
      INTEGER JO,JP,JQ,JR,JS,JT,JU,JV,JW,JX,JY,JZ,NA,NB,NC,ND,NE,NF,NG
      INTEGER NH,NI,NJ,NK,NL,NM,NN,NO,NP,NQ,NR,NS,NT,NU,NV,NW,NX,NY,NZ
      
      COMMON/XWORKA/JA,JB,JC,JD,JE,JF,JG,JH,JI,JJ,JK,JL,JM,JN, 
     2 JO,JP,JQ,JR,JS,JT,JU,JV,JW,JX,JY,JZ,NA,NB,NC,ND,NE,NF,NG,NH, 
     3 NI,NJ,NK,NL,NM,NN,NO,NP,NQ,NR,NS,NT,NU,NV,NW,NX,NY,NZ

C!  sfls.F xsflsc
C!  JA      SET TO 1 FOR ISO ATOMS ONLY, else N2                           Changed to ISO_ONLY
C!  JB      SET TO -1 FOR NO REFINEMENT, else 0 .                          Replaced by SFLS_TYPE
C!  JC      SET TO -1 FOR ONLY CALCULATE COS, else 0                       REplaced by COS_ONLY
C!  JD      SET TO -1 FOR CENTRO, else 0                                   Replaced by CENTRO
C!  JE      SET TO -1 FOR NO ANOMALOUS DISPERSION, else 0                  Replaced by ANOMAL
C!  JF      CURRENT VALUE OF JB, SET FOR EACH ATOM if JB=0                 Replaced by ATOM_REFINE
C!  JG      SET TO -1 FOR NO PRINT, else THE NUMBER OF LINES BEFORE PAGE   Replaced by REFPRINT
C!  JH      SET TO -1 if THE SCALE FACTOR IS NOT TO BE REFINED, else 0     Replaced by SFLS_TYPE
C!  JI      CYCLE NUMBER                                                   Replaced by cycle_number
C!  JJ      SET TO -1 if ONLY ISO-TERMS REQUIRED, else 0 (SIMILAR TO JA)   Removed (use ISO_ONLY)
C!  JK      SET TO -1 if BOTH LEFT AND RIGHT HAND SIDES ARE NEEDED         Replaced by NEWLHS
C!  JL      SET TO -1 if ENANTIOPOLE PARAMETER NOT USED, else 0            Replaced by ENANTIO
C!      These values above are in xsflsw include file
C!  JM      ??????
C!  JN      DUMMY LOCATION FOR NON-REFINED PARAMETERS                      replaced by non_refined_param
C!  JO      ADDRESS COMPLETE PARTIAL DERIVATIVES                           replaced by address_part_deriv_complete 
C!  JP      LAST ADDRESS COMPLETE PARTIAL DERIVATIVES                      replaced by last_address_part_deriv_complete
C!  JQ      NUMBER OF PARTIAL DERIVATIVES PER REFLECTION (0,1,2 OR 4)      replaced by num_part_deriv_per_refl
C!  JR      ADDRESS PARTIAL DERIVATIVES BEFORE THEY ARE ADDED TOGETHER     replaced by address_part_deriv
C!  JS      ???????
C!  JT      WORK VARIABLES USED DURING ACCUMULATION OF PARTIAL DERIVATIVE  Replaced by LJT
C!  JU                                                                     Replaced by LJU
C!  JV                                                                     Replaced by LJV
C!  JW                                                                     Replaced by LJW
C!  JX      LOOP VARIABLE FOR EQUIVALENT POSITIONS                         Replaced by LJX
C!  JY      LOOP VARIABLE FOR ATOMS                                        Replaced by LJY
C!  JZ                                                                     Replaced by LJZ
