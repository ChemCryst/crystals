/*
 *  CcMutex.h
 *  
 *
 *  Created by Stefan Pantos on 01/02/2005.
 *
 */
 
 // $Log: not supported by cvs2svn $
 // Revision 1.2  2005/02/22 22:49:24  stefan
 // 1. Added new line at the end of the file as some compiles aren't to happy not having an empty line
 //
 // Revision 1.1  2005/02/02 15:27:23  stefan
 // 1. Initial addition to crystals. A group of classes for threading.
 //
#if !defined(CcMutex_H__)
#define CcMutex_H__

#ifndef CRY_USEMFC
#include <wx/thread.h>
#endif

#include "ccthreadingexceptions.h"

using namespace std;

class CcMutex
{
	private:
		#if defined(CRY_USEMFC)
		HANDLE iMutex;
		#else
		wxMutex iMutex;
		#endif
	public:
		CcMutex();
		~CcMutex();
		void Lock(); //throw(mutex_error);
		bool TryLock(); //throw(mutex_error);
		void Unlock(); //throw(mutex_error);
};


/*
 *  This class locks when it is created and then releases when deleted.
 *  Very nifty locking mechanisem. The idea was stolen from Boost.
 */
class CcLifeTimeLock
{
	private:
		CcMutex* iLock;
	public:
		CcLifeTimeLock(CcMutex& pLock); //throw(logic_error);
		~CcLifeTimeLock();
};
#endif
