/*
 *  cccrystcommandlistener.h
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

#if !defined(cccrystcommandlistener_H__)
#define cccrystcommandlistener_H__

#include "cclistenerperformer.h"
#include "cclistenablesafedeque.h"

#ifndef CRY_USEMFC
#include <wx/event.h>
#endif

class CcCrystalsCommandListener : public AddListener
{
	private:
		#ifdef CRY_USEMFC
		CWinThread* iMessageHandler;
		UINT iMessage;
		#else
		wxEvtHandler* iEventHandler;
		WXTYPE iEvent;
		#endif
	public:
		#ifdef CRY_USEMFC
		CcCrystalsCommandListener::CcCrystalsCommandListener(CWinThread* pMessageHandler, const UINT pMessage);
		#else
		CcCrystalsCommandListener(wxEvtHandler * pEventHandler, const wxEventType pEvent);
		#endif
		CcCrystalsCommandListener(const CcCrystalsCommandListener& pListener);
		virtual CcListener* clone() const;
		virtual void perform(const void* pData);
};
#endif


