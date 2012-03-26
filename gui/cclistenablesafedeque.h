/*
 *  cclistenablesafedeque.h
 *  
 *
 *  Created by Stefan Pantos on 02/02/2005.
 *
 */
 
 //   $Log: not supported by cvs2svn $
 //   Revision 1.2  2011/05/04 12:21:17  rich
 //   Remove throw statements - they are ignored by C++ compiler.
 //
 //   Revision 1.1  2005/02/04 17:21:40  stefan
 //   1. A set of classes to extent CcSafeDeque to allow easy change notification.
 //   2. A set of classese to more generalise CcSafeDeques uses.
 //
 
#if !defined(cclistenablesafedeque_H__)
#define cclistenablesafedeque_H__
#include "cclistenerperformer.h"
#include "ccsafedeque.h"
#include "cclistenablesequence.h"

class CcListenableSafeDeque: public CcListenableSequence
{
	public:
		CcListenableSafeDeque():CcListenableSequence(){}
		
		virtual void push_front(const string& pItem) throw()
		{
			CcListenableSequence::push_front(pItem);
		}
		
		virtual void push_back(const string& pItem) throw()	
		{
			CcListenableSequence::push_back(pItem);
		}
		
		virtual string pop_front(const unsigned int pWaitTime = kSemaphoreWaitInfinatly)  throw()	
		{
			string result = CcListenableSequence::pop_front(pWaitTime);
			return result;
		}
		
		virtual string pop_back(const unsigned int pWaitTime = kSemaphoreWaitInfinatly) throw()
		{
			string result = CcListenableSequence::pop_back(pWaitTime);
			return result;
		}
};

//template <typename T>
//class CcListenableSafeDeque: public CcSafeDeque<T>
//{
//	protected:
//		CcListenerPerformer iAddListeners;
//		CcListenerPerformer iRemoveListeners;
//	public:
//		CcListenableSafeDeque()throw(mutex_error):CcSafeDeque<T>(){}
//		
//		CcListenableSafeDeque(const deque<T>& pDeque) throw(mutex_error):CcSafeDeque<T>(pDeque)
//		{}
//		
//		CcListenableSafeDeque(const size_t n) throw(mutex_error):CcSafeDeque<T>(n)
//		{}
//		
//		CcListenableSafeDeque(const size_t n, const T& t) throw(mutex_error):CcSafeDeque<T>(n, t)
//		{}
//		
//		void addAddListener(const AddListener& pListener)
//		{
//			iAddListeners.addListener(pListener);
//		}
//		
//		void addRemoveListener(const RemoveListener& pListener)
//		{
//			iRemoveListeners.addListener(pListener);
//		}
//		
//		virtual void push_front(const T& pItem) throw(mutex_error, semaphore_error)
//		{
//			CcSafeDeque<T>::push_front(pItem);
//			iAddListeners.performListeners();
//		}
//		
//		virtual void push_back(const T& pItem) throw(mutex_error, semaphore_error)	
//		{
//			CcSafeDeque<T>::push_back(pItem);
//			iAddListeners.performListeners();
//		}
//		
//		virtual T pop_front(const unsigned int pWaitTime = kSemaphoreWaitInfinatly) throw(mutex_error, semaphore_error, semaphore_timeout)	
//		{
//			T result = CcSafeDeque<T>::pop_front(pWaitTime);
//			iRemoveListeners.performListeners();
//			return result;
//		}
//		
//		virtual T pop_back(const unsigned int pWaitTime = kSemaphoreWaitInfinatly) throw(mutex_error, semaphore_error, semaphore_timeout)
//		{
//			T result = CcSafeDeque<T>::pop_back(pWaitTime);
//			iRemoveListeners.performListeners();
//			return result;
//		}
//};
#endif
