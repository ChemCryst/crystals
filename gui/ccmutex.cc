/*
 *  CcMutex.cpp
 *  
 *
 *  Created by Stefan Pantos on 01/02/2005.
 *
 */
 
 // $Log: not supported by cvs2svn $
 // Revision 1.1  2005/02/02 15:27:23  stefan
 // 1. Initial addition to crystals. A group of classes for threading.
 //

#include "crystalsinterface.h"
#include "ccmutex.h"

/*
 * CcMutex class for windows. wx version just types wxMutex. should have the same interface.
 */
CcMutex::CcMutex()
{
	#if defined(CRY_USEMFC)
		iMutex = CreateMutex(NULL, false, NULL);
	#endif
}

CcMutex::~CcMutex()
{
	#if defined(CRY_USEMFC)
	CloseHandle(iMutex);
	#endif
}

void CcMutex::Lock() //throw(mutex_error)
{
	error_type tError;
	#if defined(CRY_USEMFC)
		if ((tError = WaitForSingleObject( iMutex, INFINITE )) != WAIT_OBJECT_0)
	#else
	    if ((tError = iMutex.Lock()) != wxMUTEX_NO_ERROR)
	#endif
			throw mutex_error(tError);
}

bool CcMutex::TryLock() // throw(mutex_error)
{
	error_type tError;
	#if defined(CRY_USEMFC)
		tError = WaitForSingleObject( iMutex, 0 );
		if (tError == WAIT_TIMEOUT)
			return false;
		else if (tError != WAIT_OBJECT_0)
	#else
		tError = iMutex.TryLock();
		if (tError == wxMUTEX_BUSY)
			return false;
	    else if (tError != wxMUTEX_NO_ERROR)
	#endif
			throw mutex_error(tError);
	return true;
}

void CcMutex::Unlock() //throw(mutex_error)
{
	unsigned int tError;
	#if defined(CRY_USEMFC)
		if ((tError = (unsigned int)ReleaseMutex( iMutex )) == 0)
	#else
		if ((tError = iMutex.Unlock()) != wxMUTEX_NO_ERROR)
	#endif
			throw mutex_error(tError);
}

/*
 * CcLifeTimeLock locking class. Locks the passed lock when it is entered and then unlocked when it's destroyed.
 */
CcLifeTimeLock::CcLifeTimeLock(CcMutex& pLock) /*throw(logic_error)*/:iLock(NULL)
{
	pLock.Lock();
	iLock = &pLock;
}

CcLifeTimeLock::~CcLifeTimeLock()
{
	if (iLock)
		iLock->Unlock();
}
