      SUBROUTINE SGROUP(file_name, i_value, cspace)
C 
C 
      LOGICAL NOT6
      COMMON /TELLER/ SUMINT(42,15),REFINT,SIGINT,JCODE,DISPLAY_ID
      INTEGER DISPLAY_ID
      COMMON /REF/ JNDEX(3)
cdjwjul2011
      character *1 ctype                  !c/n for centrin/non-centric
      character *20 cutup, cutout
      character*4 bits(4)
      character *20 ccond(42), coper(42)
      common /coperator/ ccond, coper 
      DIMENSION IDUM(3), DUM(3), ITYPE(6), ISPACE(42,2)
      DIMENSION IPERM(42,6), IDUMMY(42), IGS(7)
      DIMENSION IGROUP(20), IEXT(30), ICENT(6)
      DIMENSION ISYS(7,2), NFOUND(100,5), IDOUBLE(6), IFULL(20)
      DIMENSION NSUBFOUND(100,5)
      DIMENSION ORIENT(3,3)
      DIMENSION ISG(306), INC(306), ICEN(306), ICHOICE(306)
      DIMENSION I230(306), J230(306)
      INTEGER*4 JDSEXT,KEXT(306),JDSMASK,JDSUBEXT
      INTEGER*4 KEX1(266),KEX2(40)
      EQUIVALENCE (KEXT(1),KEX1(1))
      EQUIVALENCE (KEXT(267),KEX2(1))
      INTEGER*2 ICENTR,JCENTR(306)
      CHARACTER*1 KAXIS(306)
      CHARACTER*80 BUF
      CHARACTER*4 WORD
      CHARACTER*6 PERM(6)
      CHARACTER*8 SG(306)
      CHARACTER*8 SG1(96),SG2(100),SG3(110)
      EQUIVALENCE (SG(1),SG1(1))
      EQUIVALENCE (SG(97),SG2(1))
      EQUIVALENCE (SG(197),SG3(1))
      CHARACTER*10 JGROUP(20)
      CHARACTER*11 CSYS(10)
      CHARACTER*16 SGFULL(306)
      CHARACTER*16 SGFUL1(54),SGFUL2(54),SGFUL3(54)
      CHARACTER*16 SGFUL4(54),SGFUL5(54),SGFUL6(36)
      EQUIVALENCE (SGFULL(1),SGFUL1(1))
      EQUIVALENCE (SGFULL(55),SGFUL2(1))
      EQUIVALENCE (SGFULL(109),SGFUL3(1))
      EQUIVALENCE (SGFULL(163),SGFUL4(1))
      EQUIVALENCE (SGFULL(217),SGFUL5(1))
      EQUIVALENCE (SGFULL(271),SGFUL6(1))
      CHARACTER*64 LINE
      LOGICAL CHECK,NOT2,NOT3,NOT4,FULL,DOUBLE,NOTM
      LOGICAL ALPHA,BETA,GAMMA
C      INTEGER            STR$TRIM
      CHARACTER*(*) FILE_NAME
      CHARACTER *(*) CSPACE
      CHARACTER*64 FILE_NAME1
      CHARACTER*78 TEXT2(10),TEXT1
      INTEGER SPACE_NUMBER
      COMMON /SPACE_COMMON/ SPACE_LINES,SPACE_FIRST,SPACE_LAST,
     1YES_NO_DISPLAY,YES_NO_LOG,SPACE_DISPLAY_SIZE
      CHARACTER*80 SPACE_LINES(500)
      INTEGER SPACE_FIRST
      INTEGER SPACE_LAST
      LOGICAL YES_NO_DISPLAY
      INTEGER SPACE_DISPLAY_SIZE
      CHARACTER*80 TEXT
      CHARACTER*80 PREFIX,EXTENSION,EXTENSION1
      INTEGER STATUS
      CHARACTER*12 ASTRING(10)/'TRICLINIC','MONOCLINIC','ORTHORHOMBIC','
     1TETRAGONAL','TRIGONAL','R/R','R/H','HEXAGONAL','CUBIC','UNKNOWN'/
      INTEGER ATRANS(10)/8,2,3,4,5,5,5,6,7,1/
      INTEGER BTRANS(12)/1,2,3,4,4,5,5,5,8,8,9,9/
      INTEGER CTRANS(10)/1,2,3,4,8,8,8,9,11,1/
      REAL FOM(14)
      INTEGER IRES_IP(306),IRES_IS(306)
      INTEGER F(306)
      LOGICAL I_FOUND_ONE
      INTEGER SUBSET_FOUND(306)
C 
C SUMINT (1,) for h00 h=2n            2-fold screw along a
C SUMINT (2,) for 0k0 k=2n            2-fold screw along b
C SUMINT (3,) for 00l l=2n            2-fold screw along c
C SUMINT (4,) for 0kl k=2n            b-glide perp. to a
C SUMINT (5,) for 0kl l=2n            c-glide perp. to a
C SUMINT (6,) for 0kl k+l=2n            n-glide perp. to a
C SUMINT (7,) for h0l h=2n            a-glide perp. to b
C SUMINT (8,) for h0l l=2n            c-glide perp. to b
C SUMINT (9,) for h0l h+l+2n            n-glide perp. to b
C SUMINT (10,) for hk0 h=2n            a-glide perp. to c
C SUMINT (11,) for hk0 k=2n            b-glide perp. to c
C SUMINT (12,) for hk0 h+k=2n            n-glide perp. to c
C SUMINT (13,) for hkl k+l=2n            A-centered lattice
C SUMINT (14,) for hkl h+l=2n            B-centered lattice
C SUMINT (15,) for hkl h+k=2n            C-centered lattice
C SUMINT (16,) for hkl h+k+l=2n            I-centered lattice
C SUMINT (17,) for h00 h=4n            4-fold screw along a
C SUMINT (18,) for 0k0 k=4n            4-fold screw along b
C SUMINT (19,) for 00l l=4n            4-fold screw along c
C SUMINT (20,) for h00 h=3n            3-fold screw along a
C SUMINT (21,) for h00 h=6n            6-fold screw along a
C SUMINT (22,) for 0k0 k=3n            3-fold screw along b
C SUMINT (23,) for 0k0 k=6n            6-fold screw along b
C SUMINT (24,) for 00l l=3n            3-fold screw along c
C SUMINT (25,) for 00l l=6n            6-fold screw along c
C SUMINT (26,) for hkl -h+k+l=3n      R-centered lattice
C SUMINT (27,) for hkl h-k+l=3n            R-centered lattice
C SUMINT (28,) for 0kl k+l=4n            d-glide perp. to a
C SUMINT (29,) for h0l h+l=4n            d-glide perp. to b
C SUMINT (30,) for hk0 h+k=4n            d-glide perp. to c
C SUMINT (31,) for hkl h=k l=2n            c,n-glide perp. to c
C SUMINT (32,) for hkl h=k 2h+l=4n      d-glide perp. to c
C SUMINT (33,) for hkl h=-k l=2n      c,n-glide perp. to c
C SUMINT (34,) for hkl h=-k 2h+l=4n      d-glide perp. to c
C SUMINT (35,) for hkl h=l k=2n       b,n-glide perp. to b
C SUMINT (36,) for hkl h=l 2h+k=4n      d-glide perp. to b
C SUMINT (37,) for hkl h=-l k=2n      b,n-glide perp. to b
C SUMINT (38,) for hkl h=-l 2h+k=4n      d-glide perp. to b
C SUMINT (39,) for hkl k=l h=2n       a,n-glide perp. to a
C SUMINT (40,) for hkl k=l 2k+h=4n      d-glide perp. to a
C SUMINT (41,) for hkl k=-l h=2n      a,n-glide perp. to a
C SUMINT (42,) for hkl k=-l 2k+h=4n      d-glide perp. to a
C 
C      permutation data table, 6 times 3 lines of 42 numbers:
C      abc, bac, cab, cba, bca, acb (table 4.3.1, Int. Tables)
C 
      DATA PERM/' a b c',' b a-c',' c a b','-c b a',' b c a',' a-c b'/
C 
C
      DATA IPERM /  1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,
     >                 15,16,17,18,19,20,21,22,23,24,25,26,27,28,
     >                 29,30,31,32,33,34,35,36,37,38,39,40,41,42,
     >                  2, 1, 3, 7, 8, 9, 4, 5, 6,11,10,12,14,13,
     >                 15,16,18,17,19,22,23,20,21,24,25,26,27,29,
     >                 28,30,31,32,33,34,31,32,33,34,35,36,37,38,
     >                  3, 1, 2, 8, 7, 9,11,10,12, 4, 5, 6,14,15,
     >                 13,16,19,17,18,24,25,20,21,22,23,26,27,29,
     >                 30,28,35,36,37,38,39,40,41,42,31,32,33,34,
     >                  3, 2, 1,11,10,12, 8, 7, 9, 5, 4, 6,15,14,
     >                 13,16,19,18,17,24,25,22,23,20,21,26,27,30,
     >                 29,28,39,40,41,42,35,36,37,38,31,32,33,34,
     >                  2, 3, 1,10,11,12, 5, 4, 6, 8, 7, 9,15,13,
     >                 14,16,18,19,17,22,23,24,25,20,21,26,27,30,
     >                 28,29,39,40,41,42,39,40,41,42,35,36,37,38,
     >                  1, 3, 2, 5, 4, 6,10,11,12, 7, 8, 9,13,15,
     >                 14,16,17,19,18,20,21,24,25,22,23,26,27,28,
     >                 30,29,35,36,37,38,31,32,33,34,39,40,41,42 /
C
      data iext / 1, 2, 3, 4, 5, 6, 7, 8, 9,10,
     >               11,12,31,32,33,34,17,18,19,35,
     >               36,39,40,24,25,26,27,28,29,30 /
C
      data igs   / 1, 2, 3, 4, 5, 10, 11/
C
      data icent / 13,14,15,16,26,27 /
C
      data isys / 1,  3, 16,  75, 143, 168, 195,
     >              230, 15, 74, 142, 167, 194, 230 /
C
      data csys / 'unknown    ','monoclinic ','orthorombic',
     >                'tetragonal ','trigonal   ','hexagonal  ',
     >                'cubic      ','triclinic  ','           ',
     >              '           '/
C
      data idouble / 17, 18, 19, 28, 29, 30 /
C
      data ifull / 20, 21, 22, 23, 24, 25, 26, 27, 31, 32,
     >                 33, 34, 35, 36, 37, 38, 39, 40, 41, 42 /
C
      data rad /0.01745329252/
C
      data isg /   1,   2,   3,   3,   4,   4,
     >   5,   5,   5,   5,   5,   5,   6,   6,   7,   7,   7,   7,
     >   7,   7,   8,   8,   8,   8,   8,   8,   9,   9,   9,   9,
     >   9,   9,  10,  10,  11,  11,  12,  12,  12,  12,  12,  12,
     >  13,  13,  13,  13,  13,  13,  14,  14,  14,  14,  14,  14,
     >  15,  15,  15,  15,  15,  15,  16,  17,  18,  19,  20,  21,
     >  22,  23,  24,  25,  26,  27,  28,  29,  30,  31,  32,  33,
     >  34,  35,  36,  37,  38,  39,  40,  41,  42,  43,  44,  45,
     >  46,  47,  48,  48,  49,  50,  50,  51,  52,  53,  54,  55,
     >  56,  57,  58,  59,  59,  60,  61,  62,  63,  64,  65,  66,
     >  67,  68,  68,  69,  70,  70,  71,  72,  73,  74,  75,  76,
     >  77,  78,  79,  80,  81,  82,  83,  84,  85,  85,  86,  86,
     >  87,  88,  88,  89,  90,  91,  92,  93,  94,  95,  96,  97,
     >  98,  99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109,
     > 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121,
     > 122, 123, 124, 125, 125, 126, 126, 127, 128, 129, 129, 130,
     > 130, 131, 132, 133, 133, 134, 134, 135, 136, 137, 137, 138,
     > 138, 139, 140, 141, 141, 142, 142, 143, 144, 145, 146, 146,
     > 147, 148, 148, 149, 150, 151, 152, 153, 154, 155, 155, 156,
     > 157, 158, 159, 160, 160, 161, 161, 162, 163, 164, 165, 166,
     > 166, 167, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176,
     > 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188,
     > 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200,
     > 201, 201, 202, 203, 203, 204, 205, 206, 207, 208, 209, 210,
     > 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222,
     > 222, 223, 224, 224, 225, 226, 227, 227, 228, 228, 229, 230/
C
      data inc /  1,  1,  2,  2,  2,  2,
     >  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,
     >  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,
     >  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,
     >  2,  2,  2,  2,  2,  2,  2,  2,  2,  4,  4,  4,  4,  4,  4,
     >  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,
     >  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  8,  4,  4,  8,
     >  4,  4,  4,  4,  4,  4,  4,  4,  4,  8,  4,  4,  4,  4,  4,
     >  4,  4,  4,  4,  8,  4,  4,  8,  4,  4,  4,  4,  4,  4,  4,
     >  4,  4,  4,  4,  4,  4,  4,  4,  8,  4,  8,  4,  4,  8,  4,
     >  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
     >  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,  8,
     >  8,  8,  8,  8,  8,  8, 16,  8, 16,  8,  8,  8, 16,  8, 16,
     >  8,  8,  8, 16,  8, 16,  8,  8,  8, 16,  8, 16,  8,  8,  8,
     > 16,  8, 16,  8,  3,  3,  3,  3,  3,  3,  3,  3,  6,  6,  6,
     >  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,
     >  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,
     > 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12,
     > 12, 12, 12, 12, 12, 12, 12, 12, 12, 24, 12, 12, 24, 12, 12,
     > 12, 12, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24,
     > 24, 24, 48, 24, 24, 48, 24, 24, 24, 48, 24, 48, 24, 24, 24/
C
      data icen / 0, 1, 0, 0, 0, 0,
     > 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     > 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
     > 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0,
     > 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     > 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
     > 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0,
     > 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0,
     > 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     > 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0,
     > 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0,
     > 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     > 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1,
     > 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0,
     > 0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
     > 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1/
C
C The first 96 space groups
      data sg1 /'P1      ',
     1'P-1     ','P2      ','P2      ','P21     ','P21     ','C2      ',
     2'A2      ','I2      ','A2      ','B2      ','I2      ','Pm      ',
     3'Pm      ','Pc      ','Pn      ','Pa      ','Pa      ','Pn      ',
     4'Pb      ','Cm      ','Am      ','Im      ','Am      ','Bm      ',
     5'Im      ','Cc      ','An      ','Ia      ','Aa      ','Bn      ',
     6'Ib      ','P2/m    ','P2/m    ','P21/m   ','P21/m   ','C2/m    ',
     7'A2/m    ','I2/m    ','A2/m    ','B2/m    ','I2/m    ','P2/c    ',
     8'P2/n    ','P2/a    ','P2/a    ','P2/n    ','P2/b    ','P21/c   ',
     9'P21/n   ','P21/a   ','P21/a   ','P21/n   ','P21/b   ','C2/c    ',
     +'A2/n    ','I2/a    ','A2/a    ','B2/n    ','I2/b    ','P222    ',
     1'P2221   ','P21212  ','P212121 ','C2221   ','C222    ','F222    ',
     2'I222    ','I212121 ','Pmm2    ','Pmc21   ','Pcc2    ','Pma2    ',
     3'Pca21   ','Pnc2    ','Pmn21   ','Pba2    ','Pna21   ','Pnn2    ',
     4'Cmm2    ','Cmc21   ','Ccc2    ','Amm2    ','Abm2    ','Ama2    ',
     5'Aba2    ','Fmm2    ','Fdd2    ','Imm2    ','Iba2    ','Ima2    ',
     6'Pmmm    ','Pnnn    ','Pnnn    ','Pccm    ','Pban    '/

C space groups 97 to 196
      data sg2 /'Pban    ','Pmma    ','Pnna    ','Pmna    ','Pcca    ',
     1'Pbam    ','Pccn    ','Pbcm    ','Pnnm    ','Pmmn    ','Pmmn    ',
     2'Pbcn    ','Pbca    ','Pnma    ','Cmcm    ','Cmca    ','Cmmm    ',
     3'Cccm    ','Cmma    ','Ccca    ','Ccca    ','Fmmm    ','Fddd    ',
     4'Fddd    ','Immm    ','Ibam    ','Ibca    ','Imma    ','P4      ',
     5'P41     ','P42     ','P43     ','I4      ','I41     ','P-4     ',
     6'I-4     ','P4/m    ','P42/m   ','P4/n    ','P4/n    ','P42/n   ',
     7'P42/n   ','I4/m    ','I41/a   ','I41/a   ','P422    ','P4212   ',
     8'P4122   ','P41212  ','P4222   ','P42212  ','P4322   ','P43212  ',
     9'I422    ','I4122   ','P4mm    ','P4bm    ','P42cm   ','P42nm   ',
     +'P4cc    ','P4nc    ','P42mc   ','P42bc   ','I4mm    ','I4cm    ',
     1'I41md   ','I41cd   ','P4-2m   ','P4-2c   ','P4-21m  ','P4-21c  ',
     2'P 4-m2  ','P4-c2   ','P4-b2   ','P4-n2   ','I4-m2   ','I4-c2   ',
     3'I4-2m   ','I4-2d   ','P4/mmm  ','P4/mcc  ','P4/nbm  ','P4/nbm  ',
     4'P4/nnc  ','P4/nnc  ','P4/mbm  ','P4/mnc  ','P4/nmm  ','P4/nmm  ',
     5'P4/ncc  ','P4/ncc  ','P42/mmc ','P42/mcm ','P42/nbc ','P42/nbc ',
     6'P42/nnm ','P42/nnm ','P42/mbc ','P42/mnm ','P42/nmc '/

C space groups 197 to 306
      data sg3 / 'P42/nmc ','P42/ncm ','P42/ncm ','I4/mmm  ','I4/mcm  ',
     1'I41/amd ','I41/amd ','I41/acd ','I41/acd ','P3      ','P31     ',
     2'P32     ','R3      ','R3      ','P-3     ','R-3     ','R-3     ',
     3'P312    ','P321    ','P3112   ','P3121   ','P3212   ','3221    ',
     4'R32     ','R32     ','P3m1    ','P31m    ','P3c1    ','P31c    ',
     5'R3m     ','R3m     ','R3c     ','R3c     ','P3-1m   ','P3-1c   ',
     6'P3-m1   ','P3-c1   ','R3-m    ','R3-m    ','R3-c    ','R3-c    ',
     7'P6      ','P61     ','P65     ','P62     ','P64     ','P63     ',
     8'P6-     ','P6/m    ','P63/m   ','P622    ','P6122   ','P6522   ',
     9'P6222   ','P6422   ','P6322   ','P6mm    ','P6cc    ','P63cm   ',
     +'P63mc   ','P6-m2   ','P6-c2   ','P6-2m   ','P6-2c   ','P6/mmm  ',
     1'P6/mcc  ','P63/mcm ','P63/mmc ','P23     ','F23     ','I23     ',
     2'P213    ','I213    ','Pm3-    ','Pn3-    ','Pn3-    ','Fm3-    ',
     3'Fd3-    ','Fd3-    ','Im3-    ','Pa3-    ','Ia3-    ','P432    ',
     4'P4232   ','F432    ','F4132   ','I432    ','P4332   ','P4132   ',
     5'I4132   ','P4-3m   ','F4-3m   ','I4-3m   ','P4-3n   ','F4-3c   ',
     6'I4-3d   ','Pm3-m   ','Pn3-n   ','Pn3-n   ','Pm3-n   ','Pn3-m   ',
     7'Pn3-m   ','Fm3-m   ','Fm3-c   ','Fd3-m   ','Fd3-m   ','Fd3-c   ',
     8'Fd3-c   ','Im3-m   ','Ia3-d   '/
C
      data kaxis /' ',' ','b','c','b','c',
     >'b','b','b','c','c','c','b','c','b','b','b','c','c','c','b',
     >'b','b','c','c','c','b','b','b','c','c','c','b','c','b','c',
     >'b','b','b','c','c','c','b','b','b','c','c','c','b','b','b',
     >'c','c','c','b','b','b','c','c','c',' ',' ',' ',' ',' ',' ',
     >' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
     >' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
     >' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
     >' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
     >' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
     >' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
     >' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
     >' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
     >' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
     >' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
     >' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
     >' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
     >' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
     >' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
     >' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
     >' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '/
C
      data ichoice / 0, 0, 0, 0, 0, 0,
     > 1, 2, 3, 1, 2, 3, 0, 0, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3,
     > 1, 2, 3, 1, 2, 3, 0, 0, 0, 0, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1,
     > 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 0, 0, 0, 0, 0, 0,
     > 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     > 0, 0, 0, 0, 0, 0, 1, 2, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1,
     > 2, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 1, 2, 0, 0, 0, 0, 0, 0,
     > 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 2, 0, 1, 2, 0, 0, 0, 0, 0,
     > 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     > 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 2, 0, 0, 1, 2, 1,
     > 2, 0, 0, 1, 2, 1, 2, 0, 0, 1, 2, 1, 2, 0, 0, 1, 2, 1, 2, 0,
     > 0, 0, 1, 2, 0, 1, 2, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 1,
     > 2, 1, 2, 0, 0, 0, 0, 1, 2, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     > 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     > 0, 0, 0, 0, 1, 2, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     > 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 1, 2, 0, 0, 1, 2, 1, 2, 0, 0/
C
      data sgful1 /
     1'P 1             ','P -1            ','P 1 2 1         ',
     2'P 1 1 2         ','P 1 21 1        ','P 1 1 21        ',
     3'C 1 2 1         ','A 1 2 1         ','I 1 2 1         ',
     4'A 1 1 2         ','B 1 1 2         ','I 1 1 2         ',
     5'P 1 m 1         ','P 1 1 m         ','P 1 c 1         ',
     6'P 1 n 1         ','P 1 a 1         ','P 1 1 a         ',
     7'P 1 1 n         ','P 1 1 b         ','C 1 m 1         ',
     8'A 1 m 1         ','I 1 m 1         ','A 1 1 m         ',
     9'B 1 1 m         ','I 1 1 m         ','C 1 c 1         ',
     >'A 1 n 1         ','I 1 a 1         ','A 1 1 a         ',
     1'B 1 1 n         ','I 1 1 b         ','P 1 2/m 1       ',
     2'P 1 1 2/m       ','P 1 21/m 1      ','P 1 1 21/m      ',
     3'C 1 2/m 1       ','A 1 2/m 1       ','I 1 2/m 1       ',
     4'A 1 1 2/m       ','B 1 1 2/m       ','I 1 1 2/m       ',
     5'P 1 2/c 1       ','P 1 2/n 1       ','P 1 2/a 1       ',
     6'P 1 1 2/a       ','P 1 1 2/n       ','P 1 1 2/b       ',
     7'P 1 21/c 1      ','P 1 21/n 1      ','P 1 21/a 1      ',
     8'P 1 1 21/a      ','P 1 1 21/n      ','P 1 1 21/b      '/

      data sgful2 /
     1'C 1 2/c 1       ','A 1 2/n 1       ','I 1 2/a 1       ',
     2'A 1 1 2/a       ','B 1 1 2/n       ','I 1 1 2/b       ',
     3'P 2 2 2         ','P 2 2 21        ','P 21 21 2       ',
     4'P 21 21 21      ','C 2 2 21        ','C 2 2 2         ',
     5'F 2 2 2         ','I 2 2 2         ','I 21 21 21      ',
     6'P m m 2         ','P m c 21        ','P c c 2         ',
     7'P m a 2         ','P c a 21        ','P n c 2         ',
     8'P m n 21        ','P b a 2         ','P n a 21        ',
     9'P n n 2         ','C m m 2         ','C m c 21        ',
     >'C c c 2         ','A m m 2         ','A b m 2         ',
     1'A m a 2         ','A b a 2         ','F m m 2         ',
     2'F d d 2         ','I m m 2         ','I b a 2         ',
     3'I m a 2         ','P 2/m 2/m 2/m   ','use other origin',
     4'P 2/n 2/n 2/n   ','P 2/c 2/c 2/m   ','use other origin',
     5'P 2/b 2/a 2/n   ','P 21/m 2/m 2/a  ','P 2/n 21/n 2/a  ',
     6'P 2/m 2/n 21/a  ','P 21/c 2/c 2/a  ','P 21/b 21/a 2/m ',
     7'P 21/c 21/c 2/n ','P 2/b 21/c 21/m ','P 21/n 21/n 2/m ',
     8'use other origin','P 21/m 21/m 2/n ','P 21/b 2/c 21/n '/

      data sgful3 /
     1'P 21/b 21/c 21/a','P 21/n 21/m 21/a','C 2/m 2/c 21/m  ',
     2'C 2/m 2/c 21/a  ','C 2/m 2/m 2/m   ','C 2/c 2/c 2/m   ',
     3'C 2/m 2/m 2/a   ','use other origin','C 2/c 2/c 2/a   ',
     4'F 2/m 2/m 2/m   ','use other origin','F 2/d 2/d 2/d   ',
     5'I 2/m 2/m 2/m   ','I 2/b 2/a 2/m   ','I 21/b 21/c 21/a',
     6'I 21/m 21/m 21/a','P 4             ','P 41            ',
     7'P 42            ','P 43            ','I 4             ',
     8'I 41            ','P -4            ','I -4            ',
     9'P 4/m           ','P 42/m          ','use other origin',
     >'P 4/n           ','use other origin','P 42/n          ',
     1'I 4/m           ','use other origin','I 41/a          ',
     2'P 4 2 2         ','P 4 21 2        ','P 41 2 2        ',
     3'P 41 21 2       ','P 42 2 2        ','P 42 21 2       ',
     4'P 43 2 2        ','P 43 21 2       ','I 4 2 2         ',
     5'I 41 2 2        ','P 4 m m         ','P 4 b m         ',
     6'P 42 c m        ','P 42 n m        ','P 4 c c         ',
     7'P 4 n c         ','P 42 m c        ','P 42 b c        ',
     8'I 4 m m         ','I 4 c m         ','I 41 m d        '/

      data sgful4 /
     1'I 41 c d        ','P -4 2 m        ','P -4 2 c        ',
     2'P -4 21 m       ','P -4 21 c       ','P -4 m 2        ',
     3'P -4 c 2        ','P -4 b 2        ','P -4 n 2        ',
     4'I -4 m 2        ','I -4 c 2        ','I -4 2 m        ',
     5'I -4 2 d        ','P 4/m 2/m 2/m   ','P 4/m 2/c 2/c   ',
     6'use other origin','P 4/n 2/b 2/m   ','use other origin',
     7'P 4/n 2/n 2/c   ','P 4/m 21/b 2/m  ','P 4/m 21/n 2/c  ',
     8'use other origin','P 4/n 21/m 2/m  ','use other origin',
     9'P 4/n 2/c 2/c   ','P 42/m 2/m 2/c  ','P 42/m 2/c 2/m  ',
     +'use other origin','P 42/n 2/b 2/c  ','use other origin',
     1'P 42/n 2/n 2/m  ','P 42/m 21/b 2/c ','P 42/m 21/n 2/m ',
     2'use other origin','P 42/n 21/m 2/c ','use other origin',
     3'P 42/n 21/c 2/m ','I 4/m 2/m 2/m   ','I 4/m 2/c 2/m   ',
     4'use other origin','I 41/a 2/m 2/d  ','use other origin',
     5'I 41/a 2/c 2/d  ','P 3             ','P 31            ',
     6'P 32            ','R 3             ','use other origin',
     7'P -3            ','R -3            ','use other origin',
     8'P 3 1 2         ','P 3 2 1         ','P 31 1 2        '/

      data sgful5 /
     1'P 31 2 1        ','P 32 1 2        ','P 32 2 1        ',
     2'R 3 2           ','use other origin','P 3 m 1         ',
     3'P 3 1 m         ','P 3 c 1         ','P 3 1 c         ',
     4'R 3 m           ','use other origin','R 3 c           ',
     5'use other origin','P -3 1 2/m      ','P -3 1 2/c      ',
     6'P -3 2/m 1      ','P -3 2/c 1      ','R -3 2/m        ',
     7'use other origin','R -3 2/c        ','use other origin',
     8'P 6             ','P 61            ','P 65            ',
     9'P 62            ','P 64            ','P 63            ',
     +'P -6            ','P 6/m           ','P 63/m          ',
     1'P 6 2 2         ','P 61 2 2        ','P 65 2 2        ',
     2'P 62 2 2        ','P 64 2 2        ','P 63 2 2        ',
     3'P 6 m m         ','P 6 c c         ','P 63 c m        ',
     4'P 63 m c        ','P -6 m 2        ','P -6 c 2        ',
     5'P -6 2 m        ','P-6 2 c         ','P 6/m 2/m 2/m   ',
     6'P 6/m 2/c 2/c   ','P 63/m 2/c 2/m  ','P 63/m 2/m 2/c  ',
     7'P 2 3           ','F 2 3           ','I 2 3           ',
     8'P 21 3          ','I 21 3          ','P 2/m -3        '/
      data sgful6 /
     1'P 2/n -3        ','P 2/n -3        ','F 2/m -3        ',
     2'F 2/d -3        ','F 2/d -3        ','I 2/m -3        ',
     3'P 21/a -3       ','I 21/a -3       ','P 4 3 2         ',
     4'P 42 3 2        ','F 4 3 2         ','F 41 3 2        ',
     5'I 4 3 2         ','P 43 3 2        ','P 41 3 2        ',
     6'I 41 3 2        ','P -4 3 m        ','F -4 3 m        ',
     7'I -4 3 m        ','P -4 3 n        ','F -4 3 c        ',
     8'I -4 3 d        ','P 4/m -3 2/m    ','use other origin',
     9'P 4/n -3 2/n    ','P 42/m -3 2/n   ','use other origin',
     +'P 42/n -3 2/m   ','F 4/m -3 2/m    ','F 4/m -3 2/c    ',
     1'use other origin','F 41/d -3 2/m   ','use other origin',
     2'F 41/d -3 2/c   ','I 4/m -3 2/m    ','I 41/a -3 2/d   '/
C
      data jcentr / 0, 0, 0, 0, 0, 0,
     > 8, 2,16, 2, 4,16, 0, 0, 0, 0, 0, 0, 0, 0, 8, 2,16, 2, 4,16,
     > 8, 2,16, 2, 4,16, 0, 0, 0, 0, 8, 2,16, 2, 4,16, 0, 0, 0, 0,
     > 0, 0, 0, 0, 0, 0, 0, 0, 8, 2,16, 2, 4,16, 0, 0, 0, 0, 8, 8,
     >14,16,16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 2, 2, 2, 2,
     >14,14,16,16,16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     > 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8,14,14,14,16,16,16,16, 0, 0,
     > 0, 0,16,16, 0,16, 0, 0, 0, 0, 0, 0,16,16,16, 0, 0, 0, 0, 0,
     > 0, 0, 0,16,16, 0, 0, 0, 0, 0, 0, 0, 0,16,16,16,16, 0, 0, 0,
     > 0, 0, 0, 0, 0,16,16,16,16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     > 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,16,16,16,16,16,16, 0,
     > 0, 0,32, 0, 0,32, 0, 0, 0, 0, 0, 0, 0,32, 0, 0, 0, 0, 0,32,
     > 0,32, 0, 0, 0, 0, 0,32, 0,32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     > 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,14,
     >16, 0,16, 0, 0, 0,14,14,14,16, 0,16, 0, 0,14,14,16, 0, 0,16,
     > 0,14,16, 0,14,16, 0, 0, 0, 0, 0, 0,14,14,14,14,14,14,16,16/
C
C234567890C234567890C234567890C234567890C234567890C234567890C23456789012     
      data kex1/0,0,0,0,4,8,4246,2380,4686,2380,1578,4686,0,0,264,522,13
     >0,1026,4102,2052,4246,2380,4686,2380,1578,4686,5022,3022,5070,7502
     >,7726,7758,0,0,4,8,4246,2380,4686,2380,1578,4686,264,522,130,1026,
     >4102,2052,268,526,134,1034,4110,2060,5022,3022,5070,7502,7726,7758
     >,0,8,6,14,4254,4246,8190,4686,4686,0,264,296,130,170,332,522,150,2
     >06,590,4246,5022,5118,2380,2428,3022,3070,8190,806232062,4686,5118
     >,5070,0,4686,4686,296,4246,4246,1026,1614,1546,1322,150,4398,284,5
     >90,4102,4102,4382,1310,1102,5022,8094,4246,5118,7318,8190,8190,819
     >0,1879973886,1879973886,4686,5118,8190,7758,0,524288,8,524288,4686
     >,528974,0,4686,0,8,4102,4102,4110,4110,4686,532046,532046,0,6,5242
     >88,524294,8,14,524288,524294,4686,528974,0,150,302,590,8488,8782,8
     >200,8350,4686,5118,545358,545406,0,8200,6,8206,0,296,150,590,4686,
     >5118,4686,545358,0,8488,4246,4246,12878,12878,150,8782,4102,4102,1
     >2590,12590,8200,296,12446,12446,4686,4686,8350,590,12302,12302,439
     >8,4398,4686,5118,548430,548430,548478,548478,0,16777216,16777216,0
     >,0,0,0,0,0,0,16777216,16777216,16777216,16777216,0,0,0,0,32776,820
     >0,0,0,33587208,8200,0,8200,0,32776,0,0,32776,8200,0,33554432,33554
     >432,16777216,16777216,8,0,0,8,0,33554432,33554432,16777216,1677721
     >6,8,0,40968,32776,8200,0,32776,0,8200,0,40968,32776,8200,0,8190/
      data kex2 /    4686,        14,      4686,         0,      4686,    
     >               4686,      8190,1879973886,1879973886,      4686,
     >               1310,      5982,         0,        14,      8190,
     >           17178622,      4686,  17170432,  17170432,  17175118,
     >                  0,      8190,      4686,   5251086,   5259262,
     >           11424334,         0,   5255758,   5255758,   5251086,
     >               4686,      4686,      8190,   5259262,1879973886,
     >         1879973886,1885224958,1885224958,      4686,  11425630/
C
      data i230 /    1,    2,    3,    3,    4,    4,
     >  651,  651,  651,  651,  651,  651,    1,    1,  271,  271,
     >  271,  271,  271,  271,   44,   44,   44,   44,   44,   44,
     >  720,  720,  720,  720,  720,  720,   12,   12,  514,  514,
     >  406,  406,  406,  406,  406,  406,  368,  368,  368,  368,
     >  368,  368,26362,26362,26362,26362,26362,26362, 5073, 5073,
     > 5073, 5073, 5073, 5073,    5,    5,  377, 7572,  168,    7,
     >    2,   16,    3,    1,   28,    4,    1,  557,   10,   64,
     >   23, 1237,   28,    2,  130,   10,    1,    6,   20,   71,
     >   14,  257,    9,   68,   12,    1,    4,    4,    1,    3,
     >    3,    8,   65,   13,   28,   25,  261,  117,   73,   43,
     >   43,  707, 2983, 1247,  117,  144,    6,   11,    3,   22,
     >   22,    9,   64,   64,    7,   47,   19,   11,    7,  123,
     >    8,   32,   21,   18,   19,  115,    4,   11,   77,   77,
     >  115,  115,   49,  230,  230,    2,    7,    6,  246,    2,
     >   18,    2,   96,    2,    3,    0,    0,    2,    3,    0,
     >    9,    1,    6,    7,    5,    9,   33,    2,    0,   39,
     >  126,    2,    2,    6,   22,    6,    4,   29,   40,    4,
     >   13,    1,    1,   12,   12,    6,    4,   15,   15,   31,
     >   31,    3,    1,    4,    4,    5,    5,    5,   23,   13,
     >   13,    6,    6,   17,    6,   11,   11,   40,   40,   23,
     >   59,   33,   97,   97,   74,  319,  319,    0,    6,    1,
     >   83,    3,   29,   32,   32,    1,    2,    9,   12,   34,
     >   34,   89,   89,    2,   28,   11,   31,   31,   31,   80,
     >   80,    1,   62,   38,    4,    2,   55,    3,    1,  146,
     >    0,   14,    5,    4,    2,    4,    2,    0,    4,   24,
     >    0,    0,    3,   12,    3,    7,    1,   20,    0,    2,
     >    5,   48,    1,    0,    0,    0,    4,    3,    3,    7,
     >   75,    8,    1,    0,    2,    1,    0,    2,    3,    0,
     >    8,    6,   23,   14,    8,   12,   10,    9,    9,    5,
     >    4,    4,   22,    2,   12,   12,    7,    7,   20,    1/
C
      data j230 / 128,1724,   2,   2, 611, 611,
     >  89,  89,  89,  89,  89,  89,   0,   0,  37,  37,  37,  37,
     >  37,  37,   6,   6,   6,   6,   6,   6,  99,  99,  99,  99,
     >  99,  99,   1,   1,  70,  70,  55,  55,  55,  55,  55,  55,
     >  50,  50,  50,  50,  50,  50,3625,3625,3625,3625,3625,3625,
     > 697, 697, 697, 697, 697, 697,   0,   0,  51,1041,  23,   0,
     >   0,   2,   0,   0,   3,   0,   0,  76,   1,   8,   3, 170,
     >   3,   0,  17,   1,   0,   0,   2,   9,   1,  35,   1,   9,
     >   1,   0,   0,   0,   0,   0,   0,   1,   8,   1,   3,   3,
     >  35,  16,  10,   5,   5,  97, 410, 171,  16,  19,   0,   1,
     >   0,   3,   3,   1,   8,   8,   0,   6,   2,   1,   0,  16,
     >   1,   4,   2,   2,   2,  15,   0,   1,  10,  10,  15,  15,
     >   6,  31,  31,   0,   0,   0,  33,   0,   2,   0,  13,   0,
     >   0,   0,   0,   0,   0,   0,   1,   0,   0,   0,   0,   1,
     >   4,   0,   0,   5,  17,   0,   0,   0,   3,   0,   0,   3,
     >   5,   0,   1,   0,   0,   1,   1,   0,   0,   2,   2,   4,
     >   4,   0,   0,   0,   0,   0,   0,   0,   3,   1,   1,   0,
     >   0,   2,   0,   1,   1,   5,   5,   3,   8,   4,  13,  13,
     >  10,  43,  43,   0,   0,   0,  11,   0,   3,   4,   4,   0,
     >   0,   1,   1,   4,   4,  12,  12,   0,   3,   1,   4,   4,
     >   4,  11,  11,   0,   8,   5,   0,   0,   7,   0,   0,  20,
     >   0,   1,   0,   0,   0,   0,   0,   0,   0,   3,   0,   0,
     >   0,   1,   0,   0,   0,   2,   0,   0,   0,   6,   0,   0,
     >   0,   0,   0,   0,   0,   0,  10,   1,   0,   0,   0,   0,
     >   0,   0,   0,   0,   1,   0,   3,   1,   1,   1,   1,   1,
     >   1,   0,   0,   0,   3,   0,   1,   1,   0,   0,   2,   0/
C
C terminal 
      LP = 6
C LI = CAD4.DAT , LO = SPACE.OUT , ITBL = SPACE.TBL
      LO=2
      LI=7
      ITBL=3
      OPEN( UNIT=LO,FILE='SPACE.OUT',STATUS='UNKNOWN')
      if (I_value .le. 0) then
      WRITE(LP,555)
      WRITE(LO,555)
555   FORMAT (' Possible space group types :',/,' Number:   Group:      
     1       ',/,

     * ' 1         1(bar)   triclinic',/,
     * ' 2         2/m      monoclinic(b)',/,
     * ' 3         mmm      orthorhombic',/,
     * ' 4         4/m      tetragonal',/,
     * ' 5         4/mmm    tetragonal',/,
     * ' 6         3(bar)   trigonal/rhomboedric(hex. setting)',/,
     * ' 7         3(bar)m1 trigonal/rhomboedric(hex. setting)',/,
     * ' 8         3(bar)1m trigonal',/,
     * ' 9         6/m      hexagonal',/,
     * ' 10        6/mmm    hexagonal',/,
     * ' 11        m3(bar)  cubic',/,
     * ' 12        m3(bar)m cubic',/,
     * ' give space group type number :',/)
	write(lo,*)file_name, I_value
      READ (5,100) I_VALUE
100   FORMAT (I5)
      endif

c  ASTRING(10)
C      1 'TRICLINIC',
C      2 'MONOCLINIC',
C      3 'ORTHORHOMBIC',
C      4 'TETRAGONAL',
C      5 'TRIGONAL',
C      6 'R/R',
C      7 'R/H',
C      8 'HEXAGONAL',
C      9 'CUBIC',
C     10 'UNKNOWN'

C                      1 2 3 4 5 6 7 8 9 10
c IPS =     BTRANS(12)/1,2,3,4,4,5,5,5,8,8,9,9/
c ISP =     ATRANS(10)/8,2,3,4,5,5,5,6,7,1/
C
      IF (I_VALUE.LT.1) I_VALUE=1
      IF (I_VALUE.GT.12) I_VALUE=1
      IPS=BTRANS(I_VALUE)
      LI=0
      ISP=ATRANS(IPS)
c      WRITE(LO, '(A,3I5)')'I_VALUE, IPS, ISP',I_VALUE, IPS, ISP
c      WRITE(LP, '(A,3I5)')'I_VALUE, IPS, ISP',I_VALUE, IPS, ISP
      FULL=.FALSE.
      DOUBLE=.FALSE.
      NOTM=.FALSE.
C      WRITE(LO,1899), X
C      WRITE(LP,1899), X
1899  FORMAT(' Accepted ratio int/sigma:', F10.2)
C 
      DO 200 I=1,15
         DO 150 J=1,42
            SUMINT(J,I)=0.0
150      CONTINUE
200   CONTINUE
C 
C 
      IF (ISP.GT.3.OR.ISP.EQ.1) FULL=.TRUE.
      IF (ISP.GT.2.OR.ISP.EQ.1) DOUBLE=.TRUE.
C 
      OPEN (UNIT=LI,FILE=FILE_NAME,STATUS='OLD',ERR=3350)
C 
      WRITE(LP,*) ' File: '//FILE_NAME
250   FORMAT (A)
      IF (ISP.EQ.8) THEN
         J1=2
         F(1)=2
         F(2)=1
         KKKK=0
         IRES_IP(1)=1
         IRES_IP(2)=1
         IRES_IS(1)=1
         IRES_IS(2)=1
         GO TO 1400
      END IF
C 
C 1250 IS THE END OF THE READ CAD4.DAT LOOP
C 
      K=1
300   READ (LI,350,END=1250,ERR=3300) BUF
350   FORMAT (1X,A)
C 
      READ (UNIT=BUF,FMT=400,ERR=450) JNDEX(1),JNDEX(2),JNDEX(3),REFINT,
     1SIGINT
cdjw09400   FORMAT (I3,2I4,F10.1,F10.1)
400   FORMAT (3I4,2F8.2)
      GO TO 750
450   READ (UNIT=BUF,FMT=500,ERR=550) JNDEX(1),JNDEX(2),JNDEX(3),I,
     1SIGINT
      REFINT=I
500   FORMAT (I3,2I4,I10,F10.1)
      GO TO 750
550   READ (UNIT=BUF,FMT=600,ERR=650) JNDEX(1),JNDEX(2),JNDEX(3),REFINT,
     1I
      SIGINT=I
600   FORMAT (I3,2I4,F10.1,I10)
      GO TO 750
650   READ (UNIT=BUF,FMT=700,ERR=300) JNDEX(1),JNDEX(2),JNDEX(3),I,I1
      REFINT=I
      SIGINT=I
700   FORMAT (I3,2I4,I10,I10)
C 
750   K=K+1
      JCODE=0
      IF (REFINT.LT.0.0) REFINT=0.0
      IF (SIGINT.EQ.0.0) SIGINT=0.1
      IF (REFINT.LT.(3.*SIGINT)) JCODE=2
C 
      DO 850 I=1,3
         DUM(I)=FLOAT(IABS(JNDEX(I)))
         IDUM(I)=INT((DUM(I)/99.)+0.99)
850   CONTINUE
C 
      IPAR=4*IDUM(1)+2*IDUM(2)+IDUM(3)
      IF (IPAR.GT.7) GO TO 300
      IF (IPAR.LT.1) GO TO 300
      GO TO (900,950,1000,1050,1100,1150,1200), IPAR
C 
C IPAR = 1 : ( 0 0 L )
C 
900   NOT2=CHECK(0,0,1,2)
      J=5
      IF (NOT2) J=1
      CALL SUMMER (3,J)
      CALL SUMMER (5,J)
      CALL SUMMER (8,J)
      CALL SUMMER (6,J)
      CALL SUMMER (9,J)
      CALL SUMMER (4,5)
      CALL SUMMER (7,5)
      CALL SUMMER (13,J)
      CALL SUMMER (14,J)
      CALL SUMMER (15,5)
      CALL SUMMER (16,J)
      IF (.NOT.DOUBLE) GO TO 300
      NOT4=CHECK(0,0,1,4)
      J=5
      IF (NOT4) J=1
      CALL SUMMER (19,J)
      CALL SUMMER (28,J)
      CALL SUMMER (29,J)
      IF (.NOT.FULL) GO TO 300
      NOT3=CHECK(0,0,1,3)
      J=5
      IF (NOT3) J=1
      CALL SUMMER (24,J)
      NOT6=CHECK(0,0,1,6)
      J=5
      IF (NOT6) J=1
      CALL SUMMER (25,J)
      NOT3=CHECK(-1,1,1,3)
      J=5
      IF (NOT3) J=1
      CALL SUMMER (26,J)
      NOT3=CHECK(1,-1,1,3)
      J=5
      IF (NOT3) J=1
      CALL SUMMER (27,J)
      GO TO 300
C 
C IPAR = 2 :  ( 0 K 0 )
C 
950   NOT2=CHECK(0,1,0,2)
      J=5
      IF (NOT2) J=1
      CALL SUMMER (2,J)
      CALL SUMMER (4,J)
      CALL SUMMER (11,J)
      CALL SUMMER (6,J)
      CALL SUMMER (12,J)
      CALL SUMMER (5,5)
      CALL SUMMER (10,5)
      CALL SUMMER (13,J)
      CALL SUMMER (14,5)
      CALL SUMMER (15,J)
      CALL SUMMER (16,J)
      IF (.NOT.DOUBLE) GO TO 300
      NOT4=CHECK(0,1,0,4)
      J=5
      IF (NOT4) J=1
      CALL SUMMER (18,J)
      CALL SUMMER (28,J)
      CALL SUMMER (30,J)
      IF (.NOT.FULL) GO TO 300
      NOT3=CHECK(0,1,0,3)
      J=5
      IF (NOT3) J=1
      CALL SUMMER (22,J)
      NOT6=CHECK(0,1,0,6)
      J=5
      IF (NOT6) J=1
      CALL SUMMER (23,J)
      NOT3=CHECK(-1,1,1,3)
      J=5
      IF (NOT3) J=1
      CALL SUMMER (26,J)
      NOT3=CHECK(1,-1,1,3)
      J=5
      IF (NOT3) J=1
      CALL SUMMER (27,J)
      GO TO 300
C 
C IPAR = 3 :  ( 0 K L )
C 
1000  NOT2=CHECK(0,1,1,2)
      J=5
      IF (NOT2) J=1
      CALL SUMMER (6,J)
      CALL SUMMER (13,J)
      CALL SUMMER (16,J)
      NOT2=CHECK(0,0,1,2)
      J=5
      IF (NOT2) J=1
      CALL SUMMER (5,J)
      CALL SUMMER (14,J)
      NOT2=CHECK(0,1,0,2)
      J=5
      IF (NOT2) J=1
      CALL SUMMER (4,J)
      CALL SUMMER (15,J)
      IF (.NOT.DOUBLE) GO TO 300
      NOT4=CHECK(0,1,1,4)
      J=5
      IF (NOT4) J=1
      CALL SUMMER (28,J)
      NOT3=CHECK(-1,1,1,3)
      J=5
      IF (.NOT.FULL) GO TO 300
      IF (NOT3) J=1
      CALL SUMMER (26,J)
      NOT3=CHECK(1,-1,1,3)
      J=5
      IF (NOT3) J=1
      CALL SUMMER (27,J)
      GO TO 300
C 
C IPAR = 4 :  ( H 0 0 )
C 
1050  NOT2=CHECK(1,0,0,2)
      J=5
      IF (NOT2) J=1
      CALL SUMMER (1,J)
      CALL SUMMER (7,J)
      CALL SUMMER (10,J)
      CALL SUMMER (9,J)
      CALL SUMMER (12,J)
      CALL SUMMER (8,5)
      CALL SUMMER (11,5)
      CALL SUMMER (13,5)
      CALL SUMMER (14,J)
      CALL SUMMER (15,J)
      CALL SUMMER (16,J)
      IF (.NOT.DOUBLE) GO TO 300
      NOT4=CHECK(1,0,0,4)
      J=5
      IF (NOT4) J=1
      CALL SUMMER (17,J)
      CALL SUMMER (29,J)
      CALL SUMMER (30,J)
      IF (.NOT.FULL) GO TO 300
      NOT3=CHECK(1,0,0,3)
      J=5
      IF (NOT3) J=1
      CALL SUMMER (20,J)
      NOT6=CHECK(1,0,0,6)
      J=5
      IF (NOT6) J=1
      CALL SUMMER (21,J)
      NOT3=CHECK(-1,1,1,3)
      J=5
      IF (NOT3) J=1
      CALL SUMMER (26,J)
      NOT3=CHECK(1,-1,1,3)
      J=5
      IF (NOT3) J=1
      CALL SUMMER (27,J)
      GO TO 300
C 
C IPAR = 5 :  ( H 0 L )
C 
1100  NOT2=CHECK(1,0,1,2)
      J=5
      IF (NOT2) J=1
      CALL SUMMER (9,J)
      CALL SUMMER (14,J)
      CALL SUMMER (16,J)
      NOT2=CHECK(0,0,1,2)
      J=5
      IF (NOT2) J=1
      CALL SUMMER (8,J)
      CALL SUMMER (13,J)
      NOT2=CHECK(1,0,0,2)
      J=5
      IF (NOT2) J=1
      CALL SUMMER (7,J)
      CALL SUMMER (15,J)
      IF (.NOT.DOUBLE) GO TO 300
      NOT4=CHECK(1,0,1,4)
      J=5
      IF (NOT4) J=1
      CALL SUMMER (29,J)
      IF (.NOT.FULL) GO TO 300
      NOT3=CHECK(-1,1,1,3)
      J=5
      IF (NOT3) J=1
      CALL SUMMER (26,J)
      NOT3=CHECK(1,-1,1,3)
      J=5
      IF (NOT3) J=1
      CALL SUMMER (27,J)
      GO TO 300
C 
C IPAR = 6 :  ( H K 0 )
C 
1150  NOT2=CHECK(1,1,0,2)
      J=5
      IF (NOT2) J=1
      CALL SUMMER (12,J)
      CALL SUMMER (15,J)
      CALL SUMMER (16,J)
      NOT2=CHECK(0,1,0,2)
      J=5
      IF (NOT2) J=1
      CALL SUMMER (11,J)
      CALL SUMMER (13,J)
      NOT2=CHECK(1,0,0,2)
      J=5
      IF (NOT2) J=1
      CALL SUMMER (10,J)
      CALL SUMMER (14,J)
      IF (.NOT.DOUBLE) GO TO 300
      NOT4=CHECK(1,1,0,4)
      J=5
      IF (NOT4) J=1
      CALL SUMMER (30,J)
      IF (.NOT.FULL) GO TO 300
      NOT3=CHECK(-1,1,1,3)
      J=5
      IF (NOT3) J=1
      CALL SUMMER (26,J)
      NOT3=CHECK(1,-1,1,3)
      J=5
      IF (NOT3) J=1
      CALL SUMMER (27,J)
      GO TO 300
C 
C IPAR = 7 :  ( H K L )
C 
1200  CONTINUE
      NOT2=CHECK(0,1,1,2)
      J=5
      IF (NOT2) J=1
      CALL SUMMER (13,J)
      NOT2=CHECK(1,0,1,2)
      J=5
      IF (NOT2) J=1
      CALL SUMMER (14,J)
      NOT2=CHECK(1,1,0,2)
      J=5
      IF (NOT2) J=1
      CALL SUMMER (15,J)
      NOT2=CHECK(1,1,1,2)
      J=5
      IF (NOT2) J=1
      CALL SUMMER (16,J)
      IF (.NOT.FULL) GO TO 300
C 
      IF (JNDEX(1).EQ.JNDEX(2)) THEN
         NOT2=CHECK(0,0,1,2)
         J=5
         IF (NOT2) J=1
         CALL SUMMER (31,J)
         NOT4=CHECK(2,0,1,4)
         J=5
         IF (NOT4) J=1
         CALL SUMMER (32,J)
      END IF
C 
      IF (JNDEX(1).EQ.-1*JNDEX(2)) THEN
         NOT2=CHECK(0,0,1,2)
         J=5
         IF (NOT2) J=1
         CALL SUMMER (33,J)
         NOT4=CHECK(2,0,1,4)
         J=5
         IF (NOT4) J=1
         CALL SUMMER (34,J)
      END IF
C 
      IF (JNDEX(1).EQ.JNDEX(3)) THEN
         NOT2=CHECK(0,1,0,2)
         J=5
         IF (NOT2) J=1
         CALL SUMMER (35,J)
         NOT4=CHECK(2,1,0,4)
         J=5
         IF (NOT4) J=1
         CALL SUMMER (36,J)
      END IF
C 
      IF (JNDEX(1).EQ.-1.*JNDEX(2)) THEN
         NOT2=CHECK(0,1,0,2)
         J=5
         IF (NOT2) J=1
         CALL SUMMER (37,J)
         NOT4=CHECK(2,1,0,4)
         J=5
         IF (NOT4) J=1
         CALL SUMMER (38,J)
      END IF
C 
      IF (JNDEX(2).EQ.JNDEX(3)) THEN
         NOT2=CHECK(1,0,0,2)
         J=5
         IF (NOT2) J=1
         CALL SUMMER (39,J)
         NOT4=CHECK(1,2,0,4)
         J=5
         IF (NOT4) J=1
         CALL SUMMER (40,J)
      END IF
C 
      IF (JNDEX(1).EQ.-1.*JNDEX(2)) THEN
         NOT2=CHECK(1,0,0,2)
         J=5
         IF (NOT2) J=1
         CALL SUMMER (41,J)
         NOT4=CHECK(1,2,0,4)
         J=5
         IF (NOT4) J=1
         CALL SUMMER (42,J)
      END IF
C 
      NOT3=CHECK(-1,1,1,3)
      J=5
      IF (NOT3) J=1
      CALL SUMMER (26,J)
      NOT3=CHECK(1,-1,1,3)
      J=5
      IF (NOT3) J=1
      CALL SUMMER (27,J)
      GO TO 300
C 
C end of CAD4 file, start averaging and processing
C 
C 
1250  CONTINUE
         WRITE(LP,800) K
800      FORMAT (I10,' reflections read')
C 
      IAVI=0
      DO 1350 J=1,5,4
         DO 1300 I=1,42
            IF (SUMINT(I,J).LT.0.1) SUMINT(I,J)=0.1
            SUMINT(I,J+1)=SUMINT(I,J+1)/SUMINT(I,J)
            SUMINT(I,J+2)=SUMINT(I,J+2)/SUMINT(I,J)
CJDS      if (sumint(i,14) .eq. sumint(i,1)) goto 55
            IF (J.EQ.1.AND.SUMINT(I,J).NE.0.1) THEN
               AVI=SUMINT(I,J+1)
               SAVI=SUMINT(I,J+2)
               QASAVI=AVI/SAVI
               IF (QASAVI.LT.10.0) SUMINT(I,15)=SUMINT(I,J)
               IF (QASAVI.LT.10.0) IAVI=IAVI+1
            END IF
            IF (SUMINT(I,J).LT.0.2) SUMINT(I,J)=0.0
1300     CONTINUE
1350  CONTINUE
C 
C      write output
C 
12    format(11x,'Group',13x,'condition',13x,'condition'/
     1 'class',3x,'condition:',
     2 12x,'true',19x,'False',/)
13    format(23x,'nref   weak   <I>  <s(I)>  nref  ',
     1 ' weak   <I>  <s(I)>')
      write(lp,12)
      write(lp,13)
      write(lo,12)
      write(lo,13)
C 
                  CALL PRIRES (4,1,1,1,0)
      IF (DOUBLE) CALL PRIRES (4,1,5,17,1)
        IF (FULL) CALL PRIRES (4,1,3,20,1)
        IF (FULL) CALL PRIRES (4,1,7,21,1)
                  CALL PRIRES (2,2,1,2,0)
      IF (DOUBLE) CALL PRIRES (2,2,5,18,1)
        IF (FULL) CALL PRIRES (2,2,3,22,1)
        IF (FULL) CALL PRIRES (2,2,7,23,1)
                  CALL PRIRES (1,3,1,3,0)
      IF (DOUBLE) CALL PRIRES (1,3,5,19,1)
        IF (FULL) CALL PRIRES (1,3,3,24,1)
        IF (FULL) CALL PRIRES (1,3,7,25,1)
                  CALL PRIRES (3,2,1,4,0)
                  CALL PRIRES (3,3,1,5,1)
                  CALL PRIRES (3,6,1,6,1)
      IF (DOUBLE) CALL PRIRES (3,6,5,28,1)
                  CALL PRIRES (5,1,1,7,0)
                  CALL PRIRES (5,3,1,8,1)
                  CALL PRIRES (5,5,1,9,1)
      IF (DOUBLE) CALL PRIRES (5,5,5,29,1)
                  CALL PRIRES (6,1,1,10,0)
                  CALL PRIRES (6,2,1,11,1)
                  CALL PRIRES (6,4,1,12,1)
      IF (DOUBLE) CALL PRIRES (6,4,5,30,1)
                  CALL PRIRES (7,6,1,13,0)
                  CALL PRIRES (7,5,1,14,1)
                  CALL PRIRES (7,4,1,15,1)
                  CALL PRIRES (7,7,1,16,1)
        IF (FULL) CALL PRIRES (7,8,3,26,0)
        IF (FULL) CALL PRIRES (7,9,3,27,1)
        IF (FULL) CALL PRIRES (8,3,1,31,0)
        IF (FULL) CALL PRIRES (8,10,5,32,1)
        IF (FULL) CALL PRIRES (9,3,1,33,0)
        IF (FULL) CALL PRIRES (9,10,5,34,1)
        IF (FULL) CALL PRIRES (10,2,1,35,0)
        IF (FULL) CALL PRIRES (10,11,5,36,1)
        IF (FULL) CALL PRIRES (11,2,1,37,0)
        IF (FULL) CALL PRIRES (11,11,5,38,1)
        IF (FULL) CALL PRIRES (12,1,1,39,0)
        IF (FULL) CALL PRIRES (12,12,5,40,1)
        IF (FULL) CALL PRIRES (13,1,1,41,0)
        IF (FULL) CALL PRIRES (13,12,5,42,1)
C 
        write(lo,'(a)') 'Sumint '
        write(lo, 9876)
     1'nfalse    <I>     S(I)  nfweak   ntrue    <I>     s(I)  ntweak'
9876  format(5x,a)
        write(lo,'(i3, 8f8.2,3x,a)')  (i, (sumint(i,j), j=1,8), 
     1  ccond(i), i=1,42)
c
        write(lo,'(/a)') ' Systematic absences are:'
        write(lp,'(/a)') ' Systematic absences are:'
        do 123 i=24,1,-1
         if((sumint(i,1) .gt. 0) .and. 
     1      (sumint(i,2) .le. 0.1*sumint(i,6)) )
     1      call operators(i,lo,lp)
123     continue
        write(lp,'(//a//)') 'See the file SPACE.OUT for more info'
C 
CJDS      open (itbl,file='dka0:[jd.space]space.tbl;1',status='unknown')
CJDS      do 444 i = 1,306
CJDS      read (itbl,740,end=445) isg(i),inc(i),icen(i),sg(i),
CJDS     >  kaxis(i),ichoice(i),sgfull(i),jcentr(i),kext(i),i230(i),j230
CJDS444      continue
CJDS445      continue
CJDSD      do 446 i = 1,306
CJDSD      write (lo,740) isg(i),inc(i),icen(i),sg(i),
CJDSD    >  kaxis(i),ichoice(i),sgfull(i),jcentr(i),kext(i),i230(i),j230
CJDSD446      continue
CJDS740      format(4x,3i4,a8,a1,i2,a16,i2,o12,i6,i8)
C 
1400  CONTINUE
cold      IF (ISP.EQ.8) GO TO 3050
c
      IF(ISP .EQ. 8) THEN                         !triclinic
cdjwmar-11  - only output if order is a b c
        idjws = 0
        cspace = ' '
cnot for triclinic            write(lp,1450) csys(isp)
          write(lp,1452)
          write(lp,1453)
c            write(lo,1450) csys(isp)
          write(lo,1452)
          write(lo,1453)
          DO 1401 J=1,J1
            if(perm(ires_ip(f(j))) .eq. ' a b c' ) then
CDJWAPR11 only write out text if there are any SG found. 
            WRITE(LP,*) ' '
CDJWAPR11 only write out text if there are any SG found
1450  format     (/' For the ',a11,' system, possible space groups ',
     1       'are as follows:'/)

1451  format(' If the SG is not a standard setting, you should',
     1       ' re-index the data')

1452  format(/,' spacegr', 26x,'standard',4x ,'frequency of',7x,
     1       'possible')

1453  format(' number setting cen axis choice   symbol',4x,
     1'  occurrence sigma',3x,'symbol')

c
             if(icen(f(j)) .eq. 1) then
                  ctype = 'C'
             else
                  ctype = 'N'
             endif

              WRITE(lo,3100)isg(F(J)),perm(IRES_IP(F(J))),ctype
     &,kaxis(F(J)),
     *                           ichoice(F(J)),sgfull(F(J)),FLOAT(J230
     &(F(J)))*.01,igs(IRES_IS(F(J)))
              WRITE(lP,3100)isg(F(J)),perm(IRES_IP(F(J))),ctype
     &,kaxis(F(J)),
     *                           ichoice(F(J)),sgfull(F(J)),FLOAT(J230
     &(F(J)))*.01,igs(IRES_IS(F(J)))
c
3100           FORMAT (2X,I4,3X,A6,2X,A1,4X,A1,3X,I2,5X,A16,1X,
     1          F5.2,1X,I3,1X,A16)
c
               IF(KKKK .EQ. 0) THEN
                  KKKK=1
               ENDIF
               if (idjws .eq. 0)then
                 cspace = sgfull(f(j))
                 idjws = 1
               endif
            endif
1401      CONTINUE
          GOTO 3250                   !triclinic done with
      ENDIF
C 
C      extinction is true if average int is lt x times the average
C      of the sigma of the intensity
C      x = 1.0, 2.0, 3.0, 4.0, 5.0, 10.0, <i>/<sig>
C 
C  is  =     1    2    3    4    5     6      7
C 
C      loop over 7 sigma ratio's
C 
      IFOUND=0
      ISUBFOUND=0
C 
C      Construct a F(igure) O(f) M(erit) for each sigma level
C      The higher the FOM, the greater the preference.
C 
      DO 1550 L=9,15
         FOM(L-8)=0.
         DO 1500 K=1,42
C ---  if MORE THAN 1 measurement
            IF (SUMINT(K,1).GT.0) THEN
C ---  and no more than two found
C            IF(SUMINT(K,1) -SUMINT(K,L) .LE. 2) THEN
C ---  AND ALL EXTINCT
               IF (SUMINT(K,1).EQ.SUMINT(K,L)) THEN
C ---  add to FOM
C             FOM(L-8)=FOM(L-8)+(SUMINT(K,L)/SUMINT(K,1))
C ---  add to FOM
                  FOM(L-8)=FOM(L-8)+1
               END IF
            END IF
1500     CONTINUE
1550  CONTINUE
      DO 1600 I=1,306
         IRES_IS(I)=0
         IRES_IP(I)=0
         SUBSET_FOUND(I)=0
1600  CONTINUE
      I_FOUND_ONE=.FALSE.
C 
C 
CDJW LOOP 7 SYSTEMS OVER SYSTEMS
C
      ITYPE_WAR=0
      DO 2500 IS=1,7
C 
         DO 1650 J=1,16
            ISL=IS+8
            IF (SUMINT(J,1).EQ.0.AND.SUMINT(J,5).NE.0) THEN
               NOTM=.TRUE.
            END IF
            IF (SUMINT(J,1).LE.SUMINT(J,ISL)) THEN
               ISPACE(J,2)=1
            ELSE
               ISPACE(J,2)=0
            END IF
C 
1650     CONTINUE
C 
C 
         DO 1800 J=17,42
            ISL=IS+8
            ISPACE(J,2)=0
            IF (DOUBLE) THEN
               DO 1700 K=1,6
                  IF (J.NE.IDOUBLE(K)) GO TO 1700
                  IF (SUMINT(J,5).EQ.0) GO TO 1700
                  IF (SUMINT(J,1).LE.SUMINT(J,ISL)) then
                        ISPACE(J,2)=1
                  ENDIF
1700           CONTINUE
            END IF
            IF (FULL) THEN
               DO 1750 K=1,20
                  IF (J.NE.IFULL(K)) GO TO 1750
                  IF (SUMINT(J,5).EQ.0) GO TO 1750
                  IF (SUMINT(J,1).LE.SUMINT(J,ISL)) then
                        ISPACE(J,2)=1
                  ENDIF

1750           CONTINUE
            END IF
C 
1800     CONTINUE
C 
         IF (FULL) THEN
            J=26
            IF (SUMINT(J,5).NE.0) THEN
C 
               IF (SUMINT(J,1).EQ.0) NOTM=.TRUE.
               ISPACE(J,2)=0
CjdsD            write (lo,*) sumint(j,1),sumint(j,isl)
               IF (SUMINT(J,1).LE.SUMINT(J,ISL)) then
                        ISPACE(J,2)=1
                  ENDIF
C 
            ELSE
               ISPACE(J,2)=0
            END IF
C 
            J=27
            IF (SUMINT(J,5).NE.0) THEN
C 
               IF (SUMINT(J,1).EQ.0) NOTM=.TRUE.
               ISPACE(J,2)=0
               IF (SUMINT(J,1).LE.SUMINT(J,ISL)) then
                        ISPACE(J,2)=1
                  ENDIF
            ELSE
               ISPACE(J,2)=0
            END IF
C 
         END IF
C 
C      WE ARE INSIDE OF LOOP OVER IS = 1,7 SYSTEMS
C      LOOP OVER 6 POSSIBLE PERMUTATIONS
C      abc, ba-c, cab, -cba, bca, a-cb (table 4.3.1, Int. Tables)
C 
C  ip =  1    2    3    4    5    6
C 
         IP=0
         JDSEXT=1
CDJW LOOP OVER PERMUTATION CLASSES
1850     CONTINUE
         IP=IP+1
         IF (IP.GT.6) GO TO 2450
CDJW - TRIED  AVOIDING PERMUTATING AXES BY RESTRICTING IP TO 1.
c         IF (IP.GT.1) GO TO 2450
         IF (JDSEXT.EQ.0) GO TO 2450
C      if (isp .eq. 1 .or. isp .eq. 3 .or. isp .eq. 7) goto 512
C 
C 
C 
         DO 1900 J=1,42
            IDUMMY(J)=ISPACE(J,2)
1900     CONTINUE
         DO 1950 J=1,42
            ISPACE(J,1)=IDUMMY(IPERM(J,IP))
1950     CONTINUE
c
cdjw08 
c      write(lo,'(/a,6i5)') 'ip, is =', ip, is
c      write (lo,'(3i6)') (j,ispace(j,1),ispace(j,2),iperm(j,ip),j=1,42)
cdjw08
c
         ICENTR=0
         JDSEXT=0
C 
C      construct centering symbol A=1,B=2,C=3,I=4,Rrev=5,Robv=6
C 
C      if (is.ne.7) then
         DO 2000 J=1,6
            IF (ISPACE(ICENT(J),1).EQ.1) THEN
               ICENTR=IBSET(ICENTR,J)
            END IF
2000     CONTINUE
C      endif
C 
C      prepare extinction word
C 
         DO 2050 J=1,30
C 
            IF (J.EQ.13.AND.SUMINT(IPERM(31,IP),1).EQ.0.0) GO TO 2050
            IF (J.EQ.14.AND.SUMINT(IPERM(32,IP),1).EQ.0.0) GO TO 2050
            IF (J.EQ.15.AND.SUMINT(IPERM(33,IP),1).EQ.0.0) GO TO 2050
            IF (J.EQ.16.AND.SUMINT(IPERM(34,IP),1).EQ.0.0) GO TO 2050
            IF (J.EQ.20.AND.SUMINT(IPERM(35,IP),1).EQ.0.0) GO TO 2050
            IF (J.EQ.21.AND.SUMINT(IPERM(36,IP),1).EQ.0.0) GO TO 2050
            IF (J.EQ.22.AND.SUMINT(IPERM(39,IP),1).EQ.0.0) GO TO 2050
            IF (J.EQ.26.AND.SUMINT(IPERM(26,IP),1).EQ.0.0) GO TO 2050
            IF (J.EQ.27.AND.SUMINT(IPERM(27,IP),1).EQ.0.0) GO TO 2050
C 
            IF (ISPACE(IEXT(J),1).EQ.1) JDSEXT=IBSET(JDSEXT,J)
2050     CONTINUE
C 
C      restrict search on table to given crystal system
C 
         DO 2200 I=1,306
C 
            IF (ISG(I).LT.ISYS(ISP,1)) GO TO 2200
            IF (ISG(I).GT.ISYS(ISP,2)) GO TO 2200
C 
            IF (KEXT(I).EQ.JDSEXT.AND.JCENTR(I).EQ.ICENTR) THEN
C 
C      we have a possible candidate
C      maybe we have found this group already
C 
               IF (IFOUND.EQ.0) GO TO 2150
               DO 2100 J=1,IFOUND
                  IF (I.EQ.NFOUND(J,1)) GO TO 2200
2100           CONTINUE
2150           CONTINUE
               IFOUND=IFOUND+1
               NFOUND(IFOUND,1)=I
               NFOUND(IFOUND,2)=IP
               NFOUND(IFOUND,3)=IS
               NFOUND(IFOUND,4)=J230(I)
               NFOUND(IFOUND,5)=ISG(I)
               O230=FLOAT(J230(I))*0.01
C 
               IF (IS.EQ.7.AND.IFOUND.EQ.1) THEN
                  ITYPE_WAR=1
               END IF
               IRES_IP(I)=IP
               IRES_IS(I)=IS
               IF (KEXT(I).NE.0) I_FOUND_ONE=.TRUE.
            END IF
C 
2200     CONTINUE
C 
C subsetsearch only for is = 6 or 7, i.e. 10 sigma or i/sigi
C 
         IF (IS.LT.6) GO TO 2450
C 
         DO 2400 JDSMASK=2,14,2
C 
C      ieor = xor
C 
            JDSUBEXT=JDSEXT
            JDSUBEXT=IEOR(JDSUBEXT,JDSMASK)
C 
            DO 2350 I=1,306
C 
C subsetsearch
C 
C      restrict search on table to given crystal system
C 
               IF (ISG(I).LT.ISYS(ISP,1).OR.ISG(I).GT.ISYS(ISP,2)) GO
     1          TO 2350
C 
C 
               IF (KEXT(I).EQ.JDSUBEXT.AND.JCENTR(I).EQ.ICENTR) THEN
C 
C      we have a possible candidate
C      maybe we have found this group already
C 
                  IF (ISUBFOUND.EQ.0) GO TO 2300
                  DO 2250 J=1,ISUBFOUND
                     IF (I.EQ.NSUBFOUND(J,1)) GO TO 2350
2250              CONTINUE
2300              CONTINUE
                  ISUBFOUND=ISUBFOUND+1
                  NSUBFOUND(ISUBFOUND,1)=I
                  NSUBFOUND(ISUBFOUND,2)=IP
                  NSUBFOUND(ISUBFOUND,3)=IS
                  NSUBFOUND(ISUBFOUND,4)=J230(I)
                  NSUBFOUND(ISUBFOUND,5)=ISG(I)
                  O230=FLOAT(J230(I))*0.01
                  IRES_IP(I)=IP
                  IRES_IS(I)=IS
                  SUBSET_FOUND(I)=1
C            TYPE 842, perm(ip), igs(is),isg(i),inc(i),icen(i),sg(i),kax
               END IF
2350        CONTINUE
C 
2400     CONTINUE
C 
C 
C 
C 
C 
C      CLOSE (UNIT=ITBL)
       GO TO 1850
C 
2450     CONTINUE
C 
CDJW LOOP BACK TO ABOUT LABEL 1600
2500  CONTINUE
c
C If there are extinctions skip all entries with no extinctions
      ianyfound = 0
      DO 2600 I=1,306
         IF (IRES_IS(I).NE.0) THEN
            IF (KEXT(I).NE.0) THEN
               ianyfound = 1
               DO 2550 J=1,306
                  IF (IRES_IS(J).NE.0.AND.KEXT(J).EQ.0) IRES_IS(J)=0
2550           CONTINUE
               GO TO 2650
            END IF
            IF (I_FOUND_ONE.AND.SUBSET_FOUND(I).EQ.1) IRES_IS(I)=0
         END IF
2600  CONTINUE
C FIND HIGHEST FOM. IF MORE THAN ONE IDENTICAL FOM TAKE THE LOWEST NUMBE
2650  IS_NOW=8
      KKKK=0
c set SG to nothing
      idjws = 0
      cspace = ' '
c
      if (ianyfound .gt.0) then
         write(lp,1450) csys(isp)
c        write(lp,1451)
         write(lp,1452)
         write(lp,1453)

         write(lo,1450) csys(isp)
         write(lo,1451)
         write(lo,1452)
         write(lo,1453)
      endif
c
2700  FOM_KEEP=-1.
      J1=IS_NOW-1
      DO 2750 J=1,J1
         IF (FOM_KEEP.LT.FOM(J)) THEN
            IS_NOW=J
            FOM_KEEP=FOM(IS_NOW)
         END IF
2750  CONTINUE
      IS_NOW1=IS_NOW
      IF (FOM_KEEP.GE.0.) THEN
C
2800     J1=0
C ---  PICK UP ALL SPACE GROUPS WITH THIS SIGMA
         DO 2850 I=1,306
            IF (IRES_IS(I).EQ.IS_NOW) THEN
               J1=J1+1
               F(J1)=I
            END IF
2850     CONTINUE
         IF (J1.NE.0) THEN
2900        CONTINUE
            DO 3000 J4=1,J1
C ---  F77
               DO 2950 J5=J4+1,J1
C ---  SORT ON DECREASING PROBABILITY
                  IF (J230(F(J4)).LT.J230(F(J5))) THEN
                     J=F(J4)
                     F(J4)=F(J5)
                     F(J5)=J
                     GO TO 2900
C ---  SORT ON INCREASING CHOICE
                  ELSE IF (J230(F(J4)).EQ.J230(F(J5))) THEN
                     IF (ICHOICE(F(J4)).GT.ICHOICE(F(J5))) THEN
                        J=F(J4)
                        F(J4)=F(J5)
                        F(J5)=J
                        GO TO 2900
                     END IF
                  END IF
2950           CONTINUE
3000        CONTINUE
3050        CONTINUE
c
        DO 3150 J=1,J1
cdjwjul2011 - try to un-permutate symbol
c this is truely horrid. 
C split symbol then re-assemble it usig ires_ip as key
            cutout = ' '
            if ((isp .eq. 2) .or. (isp .eq.3)) then
            icase = ires_ip(f(j))
            cutup = sgfull(f(j))
            kkdjw = 1
            do iidjw = 1,4
                  jjdjw = index (cutup(kkdjw:),' ')
                  if (jjdjw .eq. 0) exit
                  bits(iidjw)=' '
                  bits(iidjw)(:) = cutup(kkdjw:kkdjw+jjdjw-1)
                  call xcrems(bits(iidjw), bits(iidjw), lcut)
                  kkdjw = kkdjw+ jjdjw 
            enddo 
             if (icase .eq.1 ) then
               write(cutout,'(4a5)') bits(1),bits(2),bits(3),bits(4)
             else if (icase .eq. 2) then
               write(cutout,'(4a5)') bits(1),bits(3),bits(2),bits(4)
             else if (icase .eq. 3) then
               write(cutout,'(4a5)') bits(1),bits(3),bits(4),bits(2)
             else if (icase .eq. 4) then
               write(cutout,'(4a5)') bits(1),bits(4),bits(3),bits(2)
             else if (icase .eq. 5) then
               write(cutout,'(4a5)') bits(1),bits(4),bits(2),bits(3)
             else if (icase .eq. 6) then
               write(cutout,'(4a5)') bits(1),bits(2),bits(4),bits(3)
             endif
             call xcrems(cutout,cutout,lcut)
             write(cutup,'(a)')cutout(1:lcut)
            endif
c
               if(icen(f(j)) .eq. 1) then
                  ctype = 'C'
               else
                  ctype = 'N'
               endif

cdjwjan2012 - try to output only abc settings ^.
                if(perm(ires_ip(f(j))) .eq. perm(1)) then
                  WRITE(LP,3100) ISG(F(J)),PERM(IRES_IP(F(J))),
     1             ctype,KAXIS(F(J)),ICHOICE(F(J)),SGFULL(F(J)),
     2             FLOAT(J230(F(J)))*.01,IGS(IRES_IS(F(J)))
     3             , CUTUP(1:LCUT)
cdjwjan2012 Save first SG found
               if (idjws .eq. 0)then
                 cspace = sgfull(f(j))
                 idjws = 1
               endif
                endif

                  WRITE(LO,3100) ISG(F(J)),PERM(IRES_IP(F(J))),
     1             ctype,KAXIS(F(J)),ICHOICE(F(J)),SGFULL(F(J)),
     2             FLOAT(J230(F(J)))*.01,IGS(IRES_IS(F(J)))
     3             , CUTUP(1:LCUT)
C
               IF (KKKK.EQ.0) THEN
                  KKKK=1
               END IF
C 
CJDS            write (lo,742) perm(ip), igs(is),isg(i),inc(i),icen(i),
CJDS     1          sg(i),kaxis(i),ichoice(i),sgfull(i),o230,jcentr(i),
CJDS     2          kext(i)
3150    CONTINUE
c
            IF (ISP.EQ.8) GO TO 3250
         END IF
         IF (IS_NOW.LT.7) THEN
            IF (FOM(IS_NOW).EQ.FOM(IS_NOW+1)) THEN
               IS_NOW=IS_NOW+1
               GO TO 2800
            END IF
         END IF
C        ENDIF
         IS_NOW=IS_NOW1
         GO TO 2700
      END IF
      IF (ITYPE_WAR.EQ.1) THEN
         WRITE(LP,*) '  Warning: the intensity of some reflections withi
     1n'
         WRITE(LP,*) ' a group is bigger then 10 times the sigma of the'
     1    ,' intensity'
         WRITE(LP,*) ' of those reflections.'
         WRITE(LP,*) ' The average intensity of the whole group is less'
     1    ,' then 10 '
         WRITE(LP,*) ' times the average sigma of the whole group.'
         WRITE(LO,*) '  Warning: the intensity of some reflections withi
     1n'
         WRITE(LO,*) ' a group is bigger then 10 times the sigma of the'
     1    ,' intensity'
         WRITE(LO,*) ' of those reflections.'
         WRITE(LO,*) ' The average intensity of the whole group is less'
     1    ,' then 10 '
         WRITE(LO,*) ' times the average sigma of the whole group.'
      END IF
C 
C 
C      count the zero's as true in case the extinctions
C      have not been measured and give a warning
C 
      IF (.NOT.NOTM) GO TO 3200
      WRITE(LP,*) 'Beware! one or more groups of reflections have'
     1,' not been measured'
      WRITE(LO,*) 'Beware! one or more groups of reflections have'
     1,' not been measured'
3200  CONTINUE
C 
C sort the array found, and print
3250  CONTINUE
      CLOSE (UNIT=LI)
      CLOSE (UNIT=LO)
C 
      RETURN
      STOP
C ---  READ ERROR
3300  CLOSE (UNIT=LI)
      RETURN
      STOP
C 
C 
3350  CONTINUE
      WRITE(LP,*) ' NO SUCH INPUT FILE'
      WRITE(LO,*) ' NO SUCH INPUT FILE'
      RETURN
      STOP
      END
C***********************************************************************
      INTEGER FUNCTION SPACE_NUMBER(IRES_IP)
      CHARACTER*2 IRES_IP
      IF (IRES_IP(2:2).EQ.'a') THEN
         SPACE_NUMBER=1
      ELSE IF (IRES_IP(2:2).EQ.'b') THEN
         SPACE_NUMBER=2
      ELSE IF (IRES_IP(2:2).EQ.'c') THEN
         SPACE_NUMBER=3
      ELSE
         SPACE_NUMBER=0
      END IF
      IF (IRES_IP(1:1).EQ.'-') THENSPACE_NUMBER=-SPACE_NUMBER
      RETURN
      END
C***********************************************************************
      LOGICAL FUNCTION CHECK(I1,I2,I3,ICHECK)
      INTEGER CHECKS
      COMMON /REF/ JNDEX(3)
      CHECK=.FALSE.
      CHECKS=I1*JNDEX(1)+I2*JNDEX(2)+I3*JNDEX(3)
      IF (MOD(CHECKS,ICHECK).NE.0) CHECK=.TRUE.
      RETURN
      END
C***********************************************************************
      SUBROUTINE SUMMER (I,J)
      COMMON /TELLER/ SUMINT(42,15),REFINT,SIGINT,JCODE,DISPLAY_ID
      INTEGER DISPLAY_ID
C 
C      sumint contains the statistical information
C      i runs from 1 to 42 and is related to the extinction
C      j = 1,5      number of reflections in group i
C      j = 2,6      average intensity
C      j = 3,7      average sigma intensity
C      j = 4,8      number of less-than reflections
C 
C      j = 1,2,3,4 for the odd indices
C      j = 5,6,7,8 for the even indices
C      j = 9,10,11,12,13,14 for the 6 sigma(i) groups
C      j = 15 for <i>/<sig> .lt. 10.0
C 
      SUMINT(I,J)=SUMINT(I,J)+1.0
      SUMINT(I,J+1)=SUMINT(I,J+1)+REFINT
      SUMINT(I,J+2)=SUMINT(I,J+2)+SIGINT
      IF (JCODE.EQ.2) SUMINT(I,J+3)=SUMINT(I,J+3)+1.0
      IF (J.EQ.5) GO TO 50
      SIGF=REFINT/SIGINT
      IF (SIGF.LT.10.0) SUMINT(I,14)=SUMINT(I,14)+1.0
      IF (SIGF.LT.5.0) SUMINT(I,13)=SUMINT(I,13)+1.0
      IF (SIGF.LT.4.0) SUMINT(I,12)=SUMINT(I,12)+1.0
      IF (SIGF.LT.3.0) SUMINT(I,11)=SUMINT(I,11)+1.0
      IF (SIGF.LT.2.0) SUMINT(I,10)=SUMINT(I,10)+1.0
      IF (SIGF.LT.1.0) SUMINT(I,9)=SUMINT(I,9)+1.0
50    CONTINUE
      RETURN
      END
C***********************************************************************
C      OPTIONS/EXTEND_SOURCE
      SUBROUTINE PRIRES (NPAR,NCON1,NCON2,NSUM,IPRINT)
      COMMON /TELLER/ SUMINT(42,15),REFINT,SIGINT,JCODE,DISPLAY_ID
      CHARACTER*4 PARGRO(13)
      CHARACTER*6 COND1(12)
      CHARACTER*5 COND2(9)
      CHARACTER*80 TEXT
C 
      DATA PARGRO/'00l','0k0','0kl','h00','h0l','hk0','hkl','hhl','h-hl'
     1,'hkh','h-kh','hkk','h-kk'/
C 
      DATA COND1/'  h   ','  k   ','  l   ',' h+k  ',' h+l  ',' k+l  ','
     1h+k+l ','-h+k+l','h-k+l ',' 2h+l ',' 2h+k ',' 2k+h '/
C 
      DATA COND2/'ne 2 ','= 2n ','ne 3 ','= 3n ','ne 4 ','= 4n ','ne 6 '
     1,'= 6n ','all  '/
C 
      LP = 6
      LI=1
      LO=2
      TOTREF=SUMINT(NSUM,1)+SUMINT(NSUM,5)
      IF (TOTREF.LT.0.1) TOTREF=0.1
      TOTLT=SUMINT(NSUM,4)+SUMINT(NSUM,8)
      AVINT=(SUMINT(NSUM,2)*SUMINT(NSUM,1)+SUMINT(NSUM,6)*SUMINT(NSUM,5)
     1)/TOTREF
      AVSIG=(SUMINT(NSUM,3)*SUMINT(NSUM,1)+SUMINT(NSUM,7)*SUMINT(NSUM,5)
     1)/TOTREF
      IF (TOTREF.LT.0.2) TOTREF=0.0
      IF (IPRINT.EQ.0) THEN
         WRITE(LP,50) PARGRO(NPAR),COND2(9),IFIX(TOTREF),IFIX(TOTLT),
     1    IFIX(AVINT),IFIX(AVSIG)
         WRITE(LO,50) PARGRO(NPAR),COND2(9),IFIX(TOTREF),IFIX(TOTLT),
     1    IFIX(AVINT),IFIX(AVSIG)
      END IF
Cjds      WRITE (LO,9) COND1(NCON1),COND2(NCON2 + 1),IFIX(SUMINT(NSUM,5)
Cjds     1 IFIX(SUMINT(NSUM,8)),IFIX(SUMINT(NSUM,6)),IFIX(SUMINT(NSUM,7)
Cjds     2 ifix(sumint(nsum,1)),
Cjds     3 ifix(sumint(nsum,4)),ifix(sumint(nsum,2)),ifix(sumint(nsum,3)
Cjds     4 ifix(sumint(nsum,9)),ifix(sumint(nsum,10)),ifix(sumint(nsum,1
Cjds     5 ifix(sumint(nsum,12)),ifix(sumint(nsum,13)),
Cjds     6 ifix(sumint(nsum,14)),ifix(sumint(nsum,15))
      WRITE(LP,100) COND1(NCON1),COND2(NCON2+1),IFIX(SUMINT(NSUM,5)),
     1IFIX(SUMINT(NSUM,8)),IFIX(SUMINT(NSUM,6)),IFIX(SUMINT(NSUM,7)),
     2IFIX(SUMINT(NSUM,1)),IFIX(SUMINT(NSUM,4)),IFIX(SUMINT(NSUM,2)),
     3IFIX(SUMINT(NSUM,3))
      WRITE(LO,100) COND1(NCON1),COND2(NCON2+1),IFIX(SUMINT(NSUM,5)),
     1IFIX(SUMINT(NSUM,8)),IFIX(SUMINT(NSUM,6)),IFIX(SUMINT(NSUM,7)),
     2IFIX(SUMINT(NSUM,1)),IFIX(SUMINT(NSUM,4)),IFIX(SUMINT(NSUM,2)),
     3IFIX(SUMINT(NSUM,3))
C 
50    FORMAT (' *',A4,1X,'*',2X,A5,7X,I6,I6,I6,I6)
100   FORMAT (' ',9X,A6,A5,1X,I6,I6,I6,I6,2X,I6,I6,I6,I6)
      RETURN
      END

      subroutine operators(i,lp,lo)
      character *20 ccond(42), coper(42)
      common /coperator/ ccond, coper 
      data ccond/
     *  'h00 h=2n',
     *  '0k0 k=2n',
     *  '00l l=2n',
     *  '0kl k=2n',
     *  '0kl l=2n',
     *  '0kl k+l=2n',
     *  'h0l h=2n',
     *  'h0l l=2n',
     *  'h0l h+l+2n',
     *  'hk0 h=2n',
     *  'hk0 k=2n',
     *  'hk0 h+k=2n',
     *  'hkl k+l=2n',
     *  'hkl h+l=2n',
     *  'hkl h+k=2n',
     *  'hkl h+k+l=2n',
     *  'h00 h=4n',
     *  '0k0 k=4n',
     *  '00l l=4n',
     *  'h00 h=3n',
     *  'h00 h=6n',
     *  '0k0 k=3n',
     *  '0k0 k=6n',
     *  '00l l=3n',
     *  '00l l=6n',
     *  'hkl -h+k+l=3n',
     *  'hkl h-k+l=3n',
     *  '0kl k+l=4n',
     *  'h0l h+l=4n',
     *  'hk0 h+k=4n',
     *  'hkl h=k l=2n',
     *  'hkl h=k 2h+l=4n',
     *  'hkl h=-k l=2n',
     *  'hkl h=-k 2h+l=4n',
     *  'hkl h=l k=2n',
     *  'hkl h=l 2h+k=4n',
     *  'hkl h=-l k=2n',
     *  'hkl h=-l 2h+k=4n',
     *  'hkl k=l h=2n',
     *  'hkl k=l 2k+h=4n',
     *  'hkl k=-l h=2n',
     *  'hkl k=-l 2k+h=4n'/



      data coper/
     *  '2-fold screw along a',
     *  '2-fold screw along b',
     *  '2-fold screw along c',
     *  'b-glide perp. to a',
     *  'c-glide perp. to a',
     *  'n-glide perp. to a',
     *  'a-glide perp. to b',
     *  'c-glide perp. to b',
     *  'n-glide perp. to b',
     *  'a-glide perp. to c',
     *  'b-glide perp. to c',
     *  'n-glide perp. to c',
     *  'A-centered lattice',
     *  'B-centered lattice',
     *  'C-centered lattice',
     *  'I-centered lattice',
     *  '4-fold screw along a',
     *  '4-fold screw along b',
     *  '4-fold screw along c',
     *  '3-fold screw along a',
     *  '6-fold screw along a',
     *  '3-fold screw along b',
     *  '6-fold screw along b',
     *  '3-fold screw along c',
     *  '6-fold screw along c',
     *  'R-centered lattice',
     *  'R-centered lattice',
     *  'd-glide perp. to a',
     *  'd-glide perp. to b',
     *  'd-glide perp. to c',
     *  'c,n-glide perp. to c',
     *  'd-glide perp. to c',
     *  'c,n-glide perp. to c',
     *  'd-glide perp. to c',
     *  'b,n-glide perp. to b',
     *  'd-glide perp. to b',
     *  'b,n-glide perp. to b',
     *  'd-glide perp. to b',
     *  'a,n-glide perp. to a',
     *  'd-glide perp. to a',
     *  'a,n-glide perp. to a',
     *  'd-glide perp. to a'/
      write(lp,'(a,a)') ccond(i), coper(i)
      write(lo,'(a,a)') ccond(i), coper(i)
      return
      end
