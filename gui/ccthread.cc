
#include "crystalsinterface.h"
#include "crystals.h"
#include <wx/thread.h>
#include "ccthread.h"

UINT CrystalsThreadProc( void* arg );

void * CcThread::Entry()
{
      CrystalsThreadProc( nil );
      return nil;
}

void CcThread::CcEndThread( int exitcode )
{
      Exit((ExitCode)exitcode);
}