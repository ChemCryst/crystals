
#include "crystals.h"
#include "crystalsinterface.h"
#include <wx/thread.h>
#include "ccthread.h"

UINT CrystalsThreadProc( void* arg );

void * CcThread::Entry()
{
      CrystalsThreadProc( nil );
}
