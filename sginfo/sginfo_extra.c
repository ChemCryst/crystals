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
