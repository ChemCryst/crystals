/*
 *  cclistenerperformer.h
 *  
 *
 *  Created by Stefan Pantos on 02/02/2005.
 *
 */
 
 //   $Log: not supported by cvs2svn $
 
#if !defined(CcListenerPerformer_H__)
#define CcListenerPerformer_H__
#include <list>
#include <iterator>
#include "ccthreading.h"

using namespace std;

/*
 * Abstract class which all listeners must override.
 */
class CcListener
{
	public:
		/*
		 *  Creates a copy of the object. Returning a pointer created with new.
		 *  This is needed by CcListenerPreformer.
		 */
		virtual CcListener* clone() const = 0;
		
		/*
		 * Called when the listener is activated by the CcListenerPerformer.
		 * pData Some data which is required by the listener. Maybe NULL.
		 */
		virtual void perform(const void* pData) = 0;
};

class AddListener : public CcListener
{};

class RemoveListener : public CcListener
{};

/*
 *  Class which keep a list of listeners and performs them for you. 
 */
class CcListenerPerformer
{
	protected:
		CcMutex iLock;
		list< CcListener* > iListeners;
	public:
		CcListenerPerformer();
		~CcListenerPerformer();
		
		/*
		 * Adds the passed performer to a list of performer.
		 * Creates a copy of the performer using the clone method.
		 */
		void addListener(const CcListener& pListener);
		
		/*
		 *	Calls all the CcListener s which have been added. 
		 *  The performers are called in the order which they are added.
		 *  pData Passed to each of the performers. 
		 */
		void performListeners(const void* pData = NULL);
};
#endif
