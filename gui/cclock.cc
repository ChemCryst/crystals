////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcLock

////////////////////////////////////////////////////////////////////////

//   Filename:  CcLock.cpp
//   Authors:   Richard Cooper 
//   Created:   9.5.2001 10:12am

#include    "crystalsinterface.h"
#include    "cclock.h"
#include    <string>
#include    <sstream>
using namespace std;
#include    "cccontroller.h"

#ifdef __CR_WIN__
#include <iostream>
#include <iomanip>
#include <cstdio>
#include <direct.h>
#include <process.h>
#endif

#ifdef __BOTHWX__
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
#ifdef __CR_WIN__
    m_EvMutex = nil;
    m_CSMutex = CreateMutex(NULL, false, NULL);
#endif
#ifdef __BOTHWX__
    m_EvMutex = nil;
    m_CSMutex = new wxMutex();
#endif
  }
  else
  {
#ifdef __CR_WIN__
    m_CSMutex = CreateMutex(NULL, false, NULL);
    m_EvMutex = CreateSemaphore(NULL, 0, 99999, NULL);
#endif
#ifdef __BOTHWX__
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
#ifdef __CR_WIN__
    WaitForSingleObject( m_CSMutex, INFINITE );
    m_Locked ++;
#endif
#ifdef __BOTHWX__
    if (!( m_CSMutex -> Lock() == wxMUTEX_NO_ERROR) )
    {
       ostringstream strm;
       strm << "----Failed to lock mutex " << (int)this << "\n";
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
#ifdef __CR_WIN__
    ReleaseMutex( m_CSMutex );
#endif
#ifdef __BOTHWX__
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
//    LOGSTAT ("++++Waiting for object." + string((int)this) + "\n");
    if ( m_Locked > 0 ) m_Locked --;
#ifdef __CR_WIN__
    bool ret = (WaitForSingleObject( m_EvMutex, timeout_ms?timeout_ms:INFINITE ) == WAIT_OBJECT_0 ) ;
    return ret;
#endif
#ifdef __BOTHWX__
    if ( timeout_ms ) return m_EvMutex -> WaitTimeout( timeout_ms );
    m_EvMutex -> Wait();
//    LOGSTAT ("++++Object was signalled." + string((int)this) + "\n");
    return true;
#endif

}

void CcLock::Signal(bool all)
{
//  LOGSTAT ("++++Signalling object." + string(all?"True ":"False ") +  string((int)this) + "\n");
#ifdef __CR_WIN__
       ReleaseSemaphore( m_EvMutex, 1, NULL );
#endif
#ifdef __BOTHWX__
       m_EvMutex -> Post();
#endif

}
