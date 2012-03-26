/*
 *  cclistenablesequence.h
 *  
 *
 *  Created by Stefan Pantos on 02/02/2005.
 *
 */ 
 
 //   $Log: not supported by cvs2svn $
 //   Revision 1.1  2005/02/04 17:21:40  stefan
 //   1. A set of classes to extent CcSafeDeque to allow easy change notification.
 //   2. A set of classese to more generalise CcSafeDeques uses.
 //
 
#if !defined(cclistenablesequence_H__)
#define cclistenablesequence_H__
#include "cclistenerperformer.h"

class CcListenableSequence: public CcSafeDeque
{
	protected:
		CcListenerPerformer iAddListeners;
		CcListenerPerformer iRemoveListeners;
	public:
		CcListenableSequence():CcSafeDeque(){}
		
//		CcListenableSequence(const CcSafeDeque &pDeque):CcSafeDeque(pDeque)
//		{}
		
		virtual void addAddListener(const AddListener& pListener) throw()
		{
			iAddListeners.addListener(pListener);
		}
		
		virtual void addRemoveListener(const RemoveListener& pListener) throw()
		{
			iRemoveListeners.addListener(pListener);
		}
		
		virtual void push_front(const string& pItem) throw()
		{
			CcSafeDeque::push_front(pItem);
			iAddListeners.performListeners();
		}
		
		virtual void push_back(const string& pItem) throw() 
		{
			CcSafeDeque::push_back(pItem);
			iAddListeners.performListeners();
		}
		
		virtual string pop_front(const unsigned int pWaitTime = kSemaphoreWaitInfinatly)	 throw()
		{
			string result = CcSafeDeque::pop_front(pWaitTime);
			iRemoveListeners.performListeners();
			return result;
		}
		
		virtual string pop_back(const unsigned int pWaitTime = kSemaphoreWaitInfinatly) throw()
		{
			string result = CcSafeDeque::pop_back(pWaitTime);
			iRemoveListeners.performListeners();
			return result;
		}
};
#endif
