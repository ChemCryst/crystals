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
#if defined(__BOTHWX__)
#include <wx/event.h>
#endif

class CcCrystalsCommandListener : public AddListener
{
	private:
		#if defined(__BOTHWX__)
		wxEvtHandler* iEventHandler;
		WXTYPE iEvent;
		#else
		CWinThread* iMessageHandler;
		UINT iMessage;
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


