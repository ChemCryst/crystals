////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcLock

////////////////////////////////////////////////////////////////////////

//   Filename:  CcLock.cpp
//   Authors:   Richard Cooper 
//   Created:   9.5.2001 10:12am

#include    "crystalsinterface.h"
#include    "cclock.h"

#ifdef __CR_WIN__
#include <iostream.h>
#include <iomanip.h>
#include <stdio.h>
#include <direct.h>
#include <process.h>
#endif

#ifdef __BOTHWX__
#include <wx/thread.h>
#endif



CcLock::CcLock(bool isMutex )
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
    m_EvMutex = new wxCondition();
    m_CSMutex = nil;
#endif
  }

}

CcLock::~CcLock()
{

}


void CcLock::Enter()
{
    m_Locked ++;
#ifdef __CR_WIN__
    WaitForSingleObject( m_Mutex, INFINITE );
#endif
#ifdef __BOTHWX__
    m_CSMutex -> Lock();
#endif
  
}

void CcLock::Leave()
{
    if ( m_Locked > 0 ) m_Locked --;
#ifdef __CR_WIN__
    ReleaseMutex( m_Mutex );
#endif
#ifdef __BOTHWX__
    m_CSMutex -> Unlock();
#endif

}

bool CcLock::IsLocked()
{          
    return ( m_Locked > 0 );
}

bool CcLock::Wait(int timeout_ms)
{
#ifdef __CR_WIN__
    if ( timeout_ms ) return ( WaitForSingleObject( m_Mutex, timeout_ms) == WAIT_OBJECT_0 );
    return ( WaitForSingleObject( m_Mutex, INFINITE ) == WAIT_OBJECT_0 );
#endif
#ifdef __BOTHWX__
    int secs = timeout_ms / 1000;
    int nano = (timeout_ms - ( secs * 1000 )) * 1000000;
    if ( timeout_ms ) return m_EvMutex -> Wait( secs, nano ); //wx version is in nanoseconds.
    m_EvMutex -> Wait();
    return true;
#endif

}

void CcLock::Signal(bool all)
{
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


