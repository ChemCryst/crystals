/*
 *  cccrystcommandlistener.cpp
 *  
 *
 *  Created by Stefan Pantos on 03/02/2005.
 *
 */
 
 //   $Log: not supported by cvs2svn $
 //   Revision 1.1  2005/02/04 17:21:40  stefan
 //   1. A set of classes to extent CcSafeDeque to allow easy change notification.
 //   2. A set of classese to more generalise CcSafeDeques uses.
 //
 
#include "crystalsinterface.h"
#include "cccrystcommandlistener.h"

#if defined(__BOTHWX__)
CcCrystalsCommandListener::CcCrystalsCommandListener(wxEvtHandler * pEventHandler, const wxEventType pEvent):iEventHandler(pEventHandler), iEvent(pEvent)
#else
CcCrystalsCommandListener::CcCrystalsCommandListener(CWinThread* pMessageHandler, const UINT pMessage):iMessageHandler(pMessageHandler), iMessage(pMessage)
#endif
{}
#if defined(__BOTHWX__)
CcCrystalsCommandListener::CcCrystalsCommandListener(const CcCrystalsCommandListener& pListener):iEventHandler(pListener.iEventHandler), iEvent(pListener.iEvent)
#else
CcCrystalsCommandListener::CcCrystalsCommandListener(const CcCrystalsCommandListener& pListener):iMessageHandler(pListener.iMessageHandler), iMessage(pListener.iMessage)
#endif
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
	iMessageHandler->PostThreadMessage(iMessage, (WPARAM)pData, 0);
#endif
}