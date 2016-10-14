#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "sginfo.h"

int MemoryInit(T_SgInfo *SgInfo) 
{
  SgInfo->MaxList = 192; /* absolute maximum number of symops */

  SgInfo->ListSeitzMx
    = malloc(SgInfo->MaxList * sizeof (*SgInfo->ListSeitzMx));

  if (SgInfo->ListSeitzMx == NULL) {
    SetSgError("Not enough core");
    return -1;
  }

  SgInfo->ListRotMxInfo
    = malloc(SgInfo->MaxList * sizeof (*SgInfo->ListRotMxInfo));

  if (SgInfo->ListRotMxInfo == NULL) {
    SetSgError("Not enough core");
    return -1;
  }
  return 0;
}

int AddLatticeCode(T_SgInfo *SgInfo, char code)
{
  T_LatticeInfo LatticeInfo;
  int Lattice_t[6];

    LatticeInfo.Code='B';
    LatticeInfo.nTrVector=2;
    for(int i=0; i<6; i++) 
    {
        Lattice_t[i]=0;
    }
    Lattice_t[3]=(int) 0.5*12;
    Lattice_t[5]=(int) 0.5*12;
    LatticeInfo.TrVector=Lattice_t;
    int a=AddLatticeTr2ListSeitzMx(SgInfo, &LatticeInfo);
    
  return 0;
}
