////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcLock

////////////////////////////////////////////////////////////////////////

//   Filename:  CcLock.h
//   Authors:   Richard Cooper 
//   Created:   9.5.2001 10:12am

#ifndef     __CcLock_H__
#define     __CcLock_H__

#ifndef CRY_USEMFC
#include <wx/thread.h>
#endif

class CcLock
{

  public:
    CcLock(bool isMutex = true);
    ~CcLock();
    void Enter();
    void Leave();
    bool IsLocked();

    bool Wait(int timeout_ms = 0);
    void Signal(bool all = false);

  private:
    int m_Locked;

#ifdef CRY_USEMFC
    HANDLE m_CSMutex;
    HANDLE m_EvMutex;
#else
    wxMutex * m_CSMutex;
    wxSemaphore * m_EvMutex;

#endif


};

#endif
