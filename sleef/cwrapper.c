#include "sleef.h"

void sleef_sincosf(float input, float sincosi[])
{
    float2 sincos;

    sincos=xsincosf(input);
    sincosi[0]=sincos.x;
    sincosi[1]=sincos.y;
}
