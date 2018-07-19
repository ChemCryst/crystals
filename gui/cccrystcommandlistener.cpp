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

#ifdef CRY_USEMFC
  CcCrystalsCommandListener::CcCrystalsCommandListener(CWinThread* pMessageHandler, const UINT pMessage):iMessageHandler(pMessageHandler), iMessage(pMessage)
#else
  CcCrystalsCommandListener::CcCrystalsCommandListener(wxEvtHandler * pEventHandler, const wxEventType pEvent):iEventHandler(pEventHandler), iEvent(pEvent)
#endif
{}
#ifdef CRY_USEMFC
  CcCrystalsCommandListener::CcCrystalsCommandListener(const CcCrystalsCommandListener& pListener):iMessageHandler(pListener.iMessageHandler), iMessage(pListener.iMessage)
#else
  CcCrystalsCommandListener::CcCrystalsCommandListener(const CcCrystalsCommandListener& pListener):iEventHandler(pListener.iEventHandler), iEvent(pListener.iEvent)
#endif
{}

CcListener* CcCrystalsCommandListener::clone() const
{
	return new CcCrystalsCommandListener(*this);
}

void CcCrystalsCommandListener::perform(const void* pData)
{
#ifdef CRY_USEMFC
	iMessageHandler->PostThreadMessage(iMessage, (WPARAM)pData, 0);
#else
	wxCommandEvent tEvent(iEvent);
	iEventHandler->AddPendingEvent(tEvent);
#endif
}