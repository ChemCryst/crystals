////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcLock

////////////////////////////////////////////////////////////////////////

//   Filename:  CcLock.cpp
//   Authors:   Richard Cooper 
//   Created:   9.5.2001 10:12am

#include    "crystalsinterface.h"
#include    "cclock.h"
#include    "ccstring.h"
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
    m_Mutex = CreateMutex(NULL, false, NULL);
#endif
#ifdef __BOTHWX__
    m_EvMutex = nil;
    m_CSMutex = new wxMutex();
#endif
  }
  else
  {
#ifdef __CR_WIN__
    m_Mutex = CreateEvent(NULL, true, false, NULL);
#endif
#ifdef __BOTHWX__
    m_CSMutex = new wxMutex();
    m_EvMutex = new wxCondition(*m_CSMutex);
#endif
  }

}

CcLock::~CcLock()
{

}


void CcLock::Enter()
{
    m_Locked ++;
//    LOGSTAT ("++++Entering critical section: " + CcString(m_Locked) + "\n");
#ifdef __CR_WIN__
    WaitForSingleObject( m_Mutex, INFINITE );
#endif
#ifdef __BOTHWX__
    m_CSMutex -> Lock();
#endif
//    LOGSTAT ("++++Critical section entered: " + CcString(m_Locked) + "\n");
}

void CcLock::Leave()
{
    if ( m_Locked > 0 ) m_Locked --;
//    LOGSTAT ("++++Leaving critical section: " + CcString(m_Locked) + "\n");
#ifdef __CR_WIN__
    ReleaseMutex( m_Mutex );
#endif
#ifdef __BOTHWX__
    m_CSMutex -> Unlock();
#endif
//    LOGSTAT ("++++Critical section left: " + CcString(m_Locked) + "\n");
}

bool CcLock::IsLocked()
{          
//    LOGSTAT ("++++Is Locked: " + CcString(m_Locked) + "\n");
    return ( m_Locked > 0 );
}

bool CcLock::Wait(int timeout_ms)
{
//    LOGSTAT ("++++Waiting for object.");
#ifdef __CR_WIN__
    if ( timeout_ms ) return ( WaitForSingleObject( m_Mutex, timeout_ms) == WAIT_OBJECT_0 );
    return ( WaitForSingleObject( m_Mutex, INFINITE ) == WAIT_OBJECT_0 );
#endif
#ifdef __BOTHWX__
    if ( timeout_ms ) return m_EvMutex -> WaitTimeout( timeout_ms );
    m_EvMutex -> Wait();
    return true;
#endif

}

void CcLock::Signal(bool all)
{
//    LOGSTAT ("++++Signalling object." + CcString(all?"True":"False") );
#ifdef __CR_WIN__
    PulseEvent(m_Mutex);
#endif
#ifdef __BOTHWX__
    if ( all )
        m_EvMutex -> Broadcast();
    else
        m_EvMutex -> Signal();
#endif

}


