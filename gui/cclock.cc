////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcLock

////////////////////////////////////////////////////////////////////////

//   Filename:  CcLock.cpp
//   Authors:   Richard Cooper 
//   Created:   9.5.2001 10:12am

#include    "crystalsinterface.h"
#include <cstdint>
#include    "cclock.h"
#include    <string>
#include    <sstream>
using namespace std;
#include    "cccontroller.h"

#ifdef CRY_USEMFC
 #include <iostream>
 #include <iomanip>
 #include <cstdio>
 #include <direct.h>
 #include <process.h>
#else
 #include <wx/thread.h>
#endif


/* Critical Sections and Signals 

Both use mutexes, but it is useful to think of them differently:

  A CS may be Entered and Left. A thread will wait forever to enter
  a critical section if the other thread doesn't leave it.

  A signal may be 'signalled' or 'wait'ed for. There is a timeout
  on the wait - just in case.
*/


CcLock::CcLock(bool isMutex )   //true for CS, false for signal.
{
  if (isMutex)
  {
    m_Locked = 0;
#ifdef CRY_USEMFC
    m_EvMutex = nil;
    m_CSMutex = CreateMutex(NULL, false, NULL);
#else
    m_EvMutex = nil;
    m_CSMutex = new wxMutex();
#endif
  }
  else
  {
#ifdef CRY_USEMFC
    m_CSMutex = CreateMutex(NULL, false, NULL);
    m_EvMutex = CreateSemaphore(NULL, 0, 99999, NULL);
#else
    m_CSMutex = new wxMutex();
    m_EvMutex = new wxSemaphore();
#endif
  }

}

CcLock::~CcLock()
{

}


void CcLock::Enter()
{
//    LOGSTAT ("++++Entering critical section: " + string(m_Locked)  + " " + string((int)this) + "\n");
#ifdef CRY_USEMFC
    WaitForSingleObject( m_CSMutex, INFINITE );
    m_Locked ++;
#else
    if (!( m_CSMutex -> Lock() == wxMUTEX_NO_ERROR) )
    {
       ostringstream strm;
       strm << "----Failed to lock mutex " << (uintptr_t)this << "\n";
       LOGSTAT (strm.str());
    }
    m_Locked ++;
    wxASSERT ( m_Locked == 1 );
#endif
//    LOGSTAT ("++++Critical section entered: " + string(m_Locked)  + " " + string((int)this) + "\n");
}

void CcLock::Leave()
{
    if ( m_Locked > 0 ) m_Locked --;
//    LOGSTAT ("++++Leaving critical section: " + string(m_Locked)  + " " + string((int)this) + "\n");
#ifdef CRY_USEMFC
    ReleaseMutex( m_CSMutex );
#else
    m_CSMutex -> Unlock();
#endif
//    LOGSTAT ("++++Critical section left: " + string(m_Locked)  + " " + string((int)this) + "\n");
}

bool CcLock::IsLocked()
{          
//    LOGSTAT ("++++Is Locked: " + string(m_Locked)  + " " + string((int)this) + "\n");
    return ( m_Locked > 0 );
}


bool CcLock::Wait(int timeout_ms)
{
//    LOGSTAT ("++++Waiting for object.\n");
//    if ( m_Locked > 0 ) m_Locked --;
#ifdef CRY_USEMFC
    bool ret = (WaitForSingleObject( m_EvMutex, timeout_ms?timeout_ms:INFINITE ) == WAIT_OBJECT_0 ) ;
    return ret;
#else
    if ( timeout_ms ) {
      wxSemaError result =  m_EvMutex -> WaitTimeout( timeout_ms );

      if ( result == wxSEMA_TIMEOUT ) {
//        LOGSTAT ("++++WaitTimeout timed out, no signal.\n");
        return false;
      } 
      else if ( result == wxSEMA_NO_ERROR ) {
//        LOGSTAT ("++++WaitTimeout no error, object was signalled.\n");
        return true;
      }
      else if ( result == wxSEMA_INVALID ) {
//        LOGSTAT ("++++WaitTimeout error: Invalid semaphore\n");
        return false;
      }
      else if ( result == wxSEMA_MISC_ERROR ) {
//        LOGSTAT ("++++WaitTimeout error. Miscellaneous error\n");
        return false;
      }
      else
      {
//        LOGSTAT ("++++WaitTimeout error. Unknown error\n");
        return false; // But imagine that the object timed out.
      }
    }

    m_EvMutex -> Wait();
//    LOGSTAT ("++++Object was signalled.\n");
    return true;
#endif

}

void CcLock::Signal(bool all)
{
//  LOGSTAT ("++++Signalling object." + string(all?"True ":"False "));
#ifdef CRY_USEMFC
       ReleaseSemaphore( m_EvMutex, 1, NULL );
#else
       m_EvMutex -> Post();
#endif

}
