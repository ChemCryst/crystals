/*
 *  cclistenablesequence.h
 *  
 *
 *  Created by Stefan Pantos on 02/02/2005.
 *
 */ 
 
 //   $Log: not supported by cvs2svn $
 
#if !defined(cclistenablesequence_H__)
#define cclistenablesequence_H__
#include "cclistenerperformer.h"

template <typename T, template<typename T> class C>
class CcListenableSequence: public C<T>
{
	protected:
		CcListenerPerformer iAddListeners;
		CcListenerPerformer iRemoveListeners;
	public:
		CcListenableSequence():C<T>(){}
		
		CcListenableSequence(const C<T>& pDeque):C<T>(pDeque)
		{}
		
		virtual void addAddListener(const AddListener& pListener) throw()
		{
			iAddListeners.addListener(pListener);
		}
		
		virtual void addRemoveListener(const RemoveListener& pListener) throw()
		{
			iRemoveListeners.addListener(pListener);
		}
		
		virtual void push_front(const T& pItem) throw()
		{
			C<T>::push_front(pItem);
			iAddListeners.performListeners();
		}
		
		virtual void push_back(const T& pItem) throw() 
		{
			C<T>::push_back(pItem);
			iAddListeners.performListeners();
		}
		
		virtual T pop_front(const unsigned int pWaitTime = kSemaphoreWaitInfinatly)	 throw()
		{
			T result = C<T>::pop_front(pWaitTime);
			iRemoveListeners.performListeners();
			return result;
		}
		
		virtual T pop_back(const unsigned int pWaitTime = kSemaphoreWaitInfinatly) throw()
		{
			T result = C<T>::pop_back(pWaitTime);
			iRemoveListeners.performListeners();
			return result;
		}
};
#endif
