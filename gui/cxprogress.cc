////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxProgress

////////////////////////////////////////////////////////////////////////

//   Filename:  CxProgress.cc
//   Authors:   Richard Cooper
//   Created:   05.11.1998 14:24 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.8  2001/06/17 14:33:30  richard
//   CxDestroyWindow function. wx support.
//
//   Revision 1.7  2001/03/08 16:44:10  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//


#include    "crystalsinterface.h"
#include    "ccstring.h"
#include    "cccontroller.h"
#include    "cxprogress.h"
#include    "cxgrid.h"
#include    "crprogress.h"

int CxProgress::mProgressCount = kProgressBase;
CxProgress *    CxProgress::CreateCxProgress( CrProgress * container, CxGrid * guiParent )
{
    CxProgress  *theProgress = new CxProgress( container );
#ifdef __CR_WIN__
    theProgress->Create( WS_CHILD|WS_VISIBLE,CRect(0,0,20,20),guiParent,mProgressCount++);
    theProgress->SetFont(CcController::mp_font);
#endif
#ifdef __BOTHWX__
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
#ifdef __CR_WIN__
        m_TextOverlay->DestroyWindow();
        delete m_TextOverlay;
#endif
#ifdef __WINMSW__
        m_TextOverlay->Destroy();
#endif
    }
}

void CxProgress::CxDestroyWindow()
{
  #ifdef __CR_WIN__
DestroyWindow();
#endif
#ifdef __BOTHWX__
Destroy();
#endif
}


void    CxProgress::SetText( char * text )
{
// Every time we're told to set the text we check if m_textoverlay is present
// If not: create one and set its text; if so: set its text.
// Every time we're told to set the progress, we destroy to textoverlay. Simple.
    if(m_TextOverlay == nil)
    {
#ifdef __CR_WIN__
        m_TextOverlay = new CStatic();
        CRect rectangle;
        GetClientRect(&rectangle);
        m_TextOverlay->Create( text, WS_VISIBLE|WS_CHILD, rectangle, this, 54999) ;
        m_TextOverlay->SetFont(CcController::mp_font);
#endif
#ifdef __WINMSW__
        m_TextOverlay = new wxStaticText();
        cerr << "Creating new static text overlay for the Progress Bar.\n";
        m_TextOverlay->Create( (wxWindow*)this, -1, text, wxPoint(0,0), GetSize(), wxST_NO_AUTORESIZE );
#endif
    }
#ifdef __CR_WIN__
    else
        m_TextOverlay->SetWindowText(text);
#endif
#ifdef __WINMSW__
    else
        m_TextOverlay->SetLabel(text);
#endif
}


void    CxProgress::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __CR_WIN__
    MoveWindow(left,top,right-left,bottom-top,true);
    if(m_TextOverlay != nil)
    {
        CRect rectangle;
        GetClientRect(&rectangle);
        m_TextOverlay->MoveWindow(rectangle) ;
    }
#endif
#ifdef __WINMSW__
    SetSize(left,top,right-left,bottom-top);
    if(m_TextOverlay != nil)
    {
        m_TextOverlay->SetSize( GetRect() ) ;
    }
#endif
}

CXGETGEOMETRIES(CxProgress)


int CxProgress::GetIdealWidth()
{
#ifdef __CR_WIN__
      CClientDC cdc(this);    //Get the device context for this window (edit box).
    CFont* oldFont = cdc.SelectObject(CcController::mp_font); //Select the standard font into the device context, save the old one for later.
    TEXTMETRIC textMetric;
    cdc.GetTextMetrics(&textMetric);   //Get the metrics for this font.
    cdc.SelectObject(oldFont);         //Select the old font back into the DC.
    return mCharsWidth * textMetric.tmAveCharWidth;  //Work out the ideal width.
#endif
#ifdef __BOTHWX__
      return mCharsWidth * GetCharWidth();
#endif
}


int CxProgress::GetIdealHeight()
{
#ifdef __CR_WIN__
      CString text;
    SIZE size;
    CClientDC dc(this);
    CFont* oldFont = dc.SelectObject(CcController::mp_font);
    GetWindowText(text);
    size = dc.GetOutputTextExtent("ql");
    dc.SelectObject(oldFont);
    return ( size.cy + 5);
#endif
#ifdef __BOTHWX__
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
#ifdef __CR_WIN__
        delete m_TextOverlay;
#endif
#ifdef __WINMSW__
        m_TextOverlay->Destroy();
#endif
        m_TextOverlay = nil;
    }

#ifdef __CR_WIN__
    SetPos ( complete );
#endif
#ifdef __BOTHWX__
      SetValue( complete );
#endif
}

void CxProgress::SwitchText ( CcString * text )
{
      if ( text )
      {
            if ( m_oldText.Len() == 0 )
            {
                  if ( m_TextOverlay )
                  {
#ifdef __CR_WIN__
                        CString temp;
                        m_TextOverlay->GetWindowText(temp);
                        m_oldText = (LPCTSTR) temp;
#endif
#ifdef __WINMSW__
                        m_oldText = CcString( m_TextOverlay->GetLabel() );
#endif

                  }
                  else
                  {
                        m_oldText = "";
                  }
            }

            SetText( (char*)text->ToCString() );
      }
      else
      {
            SetText( (char*)m_oldText.ToCString() );
            m_oldText = "";
      }
}
