/*
 *  cclistenerperformer.cpp
 *  
 *
 *  Created by Stefan Pantos on 02/02/2005.
 *
 */
 
 //   $Log: not supported by cvs2svn $
 
#include "crystalsinterface.h"
#include "CcListenerPerformer.h"

CcListenerPerformer::CcListenerPerformer():iListeners(){}

CcListenerPerformer::~CcListenerPerformer()
{
	CcLifeTimeLock tFunctionLock(iLock);
	while (!iListeners.empty())
	{
		delete iListeners.back();
		iListeners.pop_back();
	}	
}

void CcListenerPerformer::addListener(const CcListener& pListener)
{
	CcLifeTimeLock tFunctionLock(iLock);
	iListeners.push_back(pListener.clone());
}

void CcListenerPerformer::performListeners(const void* pData)
{
	CcLifeTimeLock tFunctionLock(iLock);
	for (list< CcListener* >::iterator tCurrentElement = iListeners.begin(); tCurrentElement != iListeners.end(); tCurrentElement++)
	{
		(*tCurrentElement)->perform(pData);
	}			
}