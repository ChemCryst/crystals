/*
 *  cccrystcommandlistener.h
 *  
 *
 *  Created by Stefan Pantos on 03/02/2005.
 *
 */

//   $Log: not supported by cvs2svn $

#if !defined(cccrystcommandlistener_H__)
#define cccrystcommandlistener_H__

#include "cclistenerperformer.h"
#include "cclistenablesafedeque.h"
#include <wx/event.h>

class CcCrystalsCommandListener : public AddListener
{
	private:
		#if defined(__BOTHWX__)
		wxEvtHandler* iEventHandler;
		WXTYPE iEvent;
		#else
		CWinThread* pMessageHandler;
		UINT pMessage
		#endif
	public:
		#if defined(__BOTHWX__)
		CcCrystalsCommandListener(wxEvtHandler * pEventHandler, const wxEventType pEvent);
		#else
		CcCrystalsCommandListener::CcCrystalsCommandListener(CWinThread* pMessageHandler, const UINT pMessage);
		#endif
		CcCrystalsCommandListener(const CcCrystalsCommandListener& pListener);
		virtual CcListener* clone() const;
		virtual void perform(const void* pData);
};
#endif


