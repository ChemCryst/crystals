#ifndef __CcThread_h_
#define __CcThread_h_

#include <wx/thread.h>

class CcThread : public wxThread
{
      public:
            virtual void * Entry();
};
#endif
