
#include "crystalsinterface.h"

#if !defined (CRY_USEMFC)

#include <string>
#include "crystals.h"
#include <wx/thread.h>
#include "ccthread.h"

UINT CrystalsThreadProc( void* arg );


void * CcThread::Entry()
{
      CrystalsThreadProc( nil );
      return nil;
}

#endif
