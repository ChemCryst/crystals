/*
 *  cclistenablesafedeque.h
 *  
 *
 *  Created by Stefan Pantos on 02/02/2005.
 *
 */
 
 //   $Log: not supported by cvs2svn $
 
#if !defined(cclistenablesafedeque_H__)
#define cclistenablesafedeque_H__
#include "cclistenerperformer.h"
#include "ccsafedeque.h"
#include "cclistenablesequence.h"

template <typename T>
class CcListenableSafeDeque: public CcListenableSequence<T, CcSafeDeque >
{
	public:
		CcListenableSafeDeque()throw(mutex_error):CcListenableSequence<T, CcSafeDeque >(){}
		
		virtual void push_front(const T& pItem) throw()
		{
			CcListenableSequence<T, CcSafeDeque >::push_front(pItem);
		}
		
		virtual void push_back(const T& pItem) throw()	
		{
			CcListenableSequence<T, CcSafeDeque >::push_back(pItem);
		}
		
		virtual T pop_front(const unsigned int pWaitTime = kSemaphoreWaitInfinatly)  throw()	
		{
			T result = CcListenableSequence<T, CcSafeDeque >::pop_front(pWaitTime);
			return result;
		}
		
		virtual T pop_back(const unsigned int pWaitTime = kSemaphoreWaitInfinatly) throw()
		{
			T result = CcListenableSequence<T, CcSafeDeque >::pop_back(pWaitTime);
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
