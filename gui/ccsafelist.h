/*
 *  ccsafelist.h
 *  
 *
 *  Created by Stefan Pantos on 04/02/2005.
 *
 */
 
 //   $Log: not supported by cvs2svn $

#if !defined(ccsafelist_H__)
#define ccsafelist_H__
#include <list>
#include "ccsafesequences.h"

template <typename _Tp>
class  CcSafeList:public CcSafeSequence<_Tp, list >
{
	public:
		CcSafeList() : CcSafeSequence<_Tp, list >()
		{}
		
		CcSafeList(const deque<_Tp>& a): CcSafeSequence<_Tp, list >(a)
		{}
};
#endif