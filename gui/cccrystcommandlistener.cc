/*
 *  cccrystcommandlistener.cpp
 *  
 *
 *  Created by Stefan Pantos on 03/02/2005.
 *
 */
 
 //   $Log: not supported by cvs2svn $
 
#include "crystalsinterface.h"
#include "cccrystcommandlistener.h"

#if defined(__BOTHWX__)
CcCrystalsCommandListener::CcCrystalsCommandListener(wxEvtHandler * pEventHandler, const wxEventType pEvent):iEventHandler(pEventHandler), iEvent(pEvent)
#else
CcCrystalsCommandListener::CcCrystalsCommandListener(CWinThread* pMessageHandler, const UINT pMessage):iMessageHandler(pMessageHandler), iMessage(pMessage)
#endif
{}

CcCrystalsCommandListener::CcCrystalsCommandListener(const CcCrystalsCommandListener& pListener):iEventHandler(pListener.iEventHandler), iEvent(pListener.iEvent)
{}

CcListener* CcCrystalsCommandListener::clone() const
{
	return new CcCrystalsCommandListener(*this);
}

void CcCrystalsCommandListener::perform(const void* pData)
{
#if defined(__BOTHWX__)
	wxCommandEvent tEvent(iEvent);
	iEventHandler->AddPendingEvent(tEvent);
#else
	iMessageHandler->PostThreadMessage(iMessage, pData, 0);
#endif
}