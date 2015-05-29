////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxProgress

////////////////////////////////////////////////////////////////////////

//   Filename:  CxProgress.cc
//   Authors:   Richard Cooper
//   Created:   05.11.1998 14:24 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.15  2004/11/08 16:48:36  stefan
//   1. Replaces some #ifdef (__WXGTK__) with #if defined(__WXGTK__) || defined(__WXMAC) to make the code compile correctly on the mac version.
//
//   Revision 1.14  2004/10/06 13:57:26  rich
//   Fixes for WXS version.
//
//   Revision 1.13  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.12  2003/05/07 12:18:58  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.11  2002/01/31 14:36:42  ckp2
//   Delete text overlay in progress bar properly.
//
//   Revision 1.10  2001/07/16 07:30:02  ckp2
//   Let the linux version resize.
//
//   Revision 1.9  2001/06/18 12:55:46  richard
//   The wxGauge class can't have child windows inserted. For now removed text appearing
//   on progress bar in wx versions. Long term will parent both controls in a standard
//   wxWindow.
//
//   Revision 1.8  2001/06/17 14:33:30  richard
//   CxDestroyWindow function. wx support.
//
//   Revision 1.7  2001/03/08 16:44:10  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//


#include    "crystalsinterface.h"
#include    <string>
using namespace std;
#include    "cccontroller.h"
#include    "cxprogress.h"
#include    "cxgrid.h"
#include    "crprogress.h"


#ifdef CRY_USEWX
// These macros are being defined somewhere. They shouldn't be.

#ifdef GetCharWidth
 #undef GetCharWidth
#endif

#endif


int CxProgress::mProgressCount = kProgressBase;
CxProgress *    CxProgress::CreateCxProgress( CrProgress * container, CxGrid * guiParent )
{
    CxProgress  *theProgress = new CxProgress( container );
#ifdef CRY_USEMFC
    theProgress->Create( WS_CHILD|WS_VISIBLE,CRect(0,0,20,20),guiParent,mProgressCount++);
    theProgress->SetFont(CcController::mp_font);
#else
      theProgress->Create( guiParent, -1, 100, wxPoint(0,0), wxSize(10,10));
#endif
    return theProgress;
}

CxProgress::CxProgress( CrProgress * container )
      :BASEPROGRESS()
{
    ptr_to_crObject = container;
    mCharsWidth = 10;
    m_TextOverlay = nil;
    m_oldText = "";
}

CxProgress::~CxProgress()
{
    RemoveProgress();
    if(m_TextOverlay != nil)
    {
#ifdef CRY_USEMFC
        m_TextOverlay->DestroyWindow();
        delete m_TextOverlay;
#else
        m_TextOverlay->Destroy();
#endif
    }
}

void CxProgress::CxDestroyWindow()
{
  #ifdef CRY_USEMFC
DestroyWindow();
#endif
#ifdef CRY_USEWX
Destroy();
#endif
}


void    CxProgress::SetText( const string & text )
{
// Every time we're told to set the text we check if m_textoverlay is present
// If not: create one and set its text; if so: set its text.
// Every time we're told to set the progress, we destroy to textoverlay. Simple.
    if(m_TextOverlay == nil)
    {
#ifdef CRY_USEMFC
        m_TextOverlay = new CStatic();
        CRect rectangle;
        GetClientRect(&rectangle);
        m_TextOverlay->Create( text.c_str(), WS_VISIBLE|WS_CHILD, rectangle, this, 54999) ;
        m_TextOverlay->SetFont(CcController::mp_font);
	}
    else
        m_TextOverlay->SetWindowText(text.c_str());
#else
        m_TextOverlay = new wxStaticText();
//        cerr << "Creating new static text overlay for the Progress Bar.\n";
        m_TextOverlay->Create( (wxWindow*)this, -1, text.c_str(), wxPoint(0,0), GetSize(), wxST_NO_AUTORESIZE );
    }
    else
        m_TextOverlay->SetLabel(text.c_str());
#endif
}


void    CxProgress::SetGeometry( int top, int left, int bottom, int right )
{ 
#ifdef CRY_USEMFC
    MoveWindow(left,top,right-left,bottom-top,true);
    if(m_TextOverlay != nil)
    {
        CRect rectangle;
        GetClientRect(&rectangle);
        m_TextOverlay->MoveWindow(rectangle) ;
    }
#elif defined CRY_OSWIN32
    SetSize(left,top,right-left,bottom-top);
    if(m_TextOverlay != nil)
    {
        m_TextOverlay->SetSize( GetRect() ) ;
    }
#else
    SetSize(left,top,right-left,bottom-top);
#endif
}

CXGETGEOMETRIES(CxProgress)


int CxProgress::GetIdealWidth()
{
#ifdef CRY_USEMFC
      CClientDC cdc(this);    //Get the device context for this window (edit box).
    CFont* oldFont = cdc.SelectObject(CcController::mp_font); //Select the standard font into the device context, save the old one for later.
    TEXTMETRIC textMetric;
    cdc.GetTextMetrics(&textMetric);   //Get the metrics for this font.
    cdc.SelectObject(oldFont);         //Select the old font back into the DC.
    return mCharsWidth * textMetric.tmAveCharWidth;  //Work out the ideal width.
#endif
#ifdef CRY_USEWX
      return mCharsWidth * GetCharWidth();
#endif
}


int CxProgress::GetIdealHeight()
{
#ifdef CRY_USEMFC
      CString text;
    SIZE size;
    CClientDC dc(this);
    CFont* oldFont = dc.SelectObject(CcController::mp_font);
    GetWindowText(text);
    size = dc.GetOutputTextExtent("ql");
    dc.SelectObject(oldFont);
    return ( size.cy + 5);
#endif
#ifdef CRY_USEWX
      return GetCharHeight() + 5;
#endif

}
int CxProgress::AddProgress()
{
    mProgressCount++;
    return mProgressCount;
}
void    CxProgress::RemoveProgress()
{
    mProgressCount--;
}
void    CxProgress::SetVisibleChars( int count )
{
    mCharsWidth = count;
}

void CxProgress::SetProgress(int complete)
{
    if(m_TextOverlay != nil)
    {
#ifdef CRY_USEMFC
        m_TextOverlay->DestroyWindow();
        delete m_TextOverlay;
#else
        m_TextOverlay->Destroy();
#endif
        m_TextOverlay = nil;
    }

#ifdef CRY_USEMFC
    SetPos ( complete );
#else
      SetValue( complete );
#endif
}

void CxProgress::SwitchText ( const string & text )
{
      if ( ! text.empty() )
      {
            if ( m_oldText.length() == 0 )
            {
                  if ( m_TextOverlay )
                  {
#ifdef CRY_USEMFC
                        CString temp;
                        m_TextOverlay->GetWindowText(temp);
                        m_oldText = (LPCTSTR) temp;
#else
                        m_oldText = string( m_TextOverlay->GetLabel() );
#endif

                  }
                  else
                  {
                        m_oldText = "";
                  }
            }

            SetText( text );
      }
      else
      {
            SetText( m_oldText );
            m_oldText = "";
      }
}
