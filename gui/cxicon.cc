////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxIcon

////////////////////////////////////////////////////////////////////////

//   Filename:  CxIcon.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.6  2003/01/14 10:27:18  rich
//   Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
//   Revision 1.5  2001/06/17 14:41:05  richard
//   CxDestroyWindow function.
//   Icons not available under wx - replace with text strings for now - could eventually
//   use bitmaps instead.
//
//   Revision 1.4  2001/03/08 16:44:09  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//


#include    "crystalsinterface.h"
#include    "crconstants.h" //unusual, but used for kTIcon<Type>.
#include    "cxicon.h"
#include    "cxgrid.h"
#include    "cricon.h"
#include    "cccontroller.h"

#define kIconBase 56000

int   CxIcon::mTextCount = kIconBase;
CxIcon *    CxIcon::CreateCxIcon( CrIcon * container, CxGrid * guiParent )
{
      CxIcon      *theText = new CxIcon( container );
#ifdef CRY_USEMFC
    theText->Create(NULL, SS_ICON|WS_CHILD|WS_VISIBLE,CRect(0,0,20,20),guiParent);
    theText->SetFont(CcController::mp_font);
#else
      theText->Create(guiParent, -1, "");
#endif
      return theText;
}

CxIcon::CxIcon( CrIcon * container )
      :BASETEXT()
{
    ptr_to_crObject = container;
    mCharsWidth = 0;
}

CxIcon::~CxIcon()
{
    RemoveText();
}

void CxIcon::CxDestroyWindow()
{
#ifdef CRY_USEMFC
DestroyWindow();
#else
Destroy();
#endif
}

CXSETGEOMETRY(CxIcon)

CXGETGEOMETRIES(CxIcon)


int   CxIcon::GetIdealWidth()
{
#ifdef CRY_USEMFC
      return GetSystemMetrics(SM_CXICON);
#else
      int cx,cy;
      GetTextExtent( GetLabel(), &cx, &cy );
      return cx;
#endif

}

int   CxIcon::GetIdealHeight()
{
#ifdef CRY_USEMFC
      return GetSystemMetrics(SM_CYICON);
#else
      return GetCharHeight();
#endif
}

int   CxIcon::AddText()
{
    mTextCount++;
    return mTextCount;
}

void  CxIcon::RemoveText()
{
    mTextCount--;
}

void  CxIcon::SetVisibleChars( int count )
{
    mCharsWidth = count;
}


void CxIcon::SetIconType( int iIconId )
{
#ifdef CRY_USEMFC
      HICON icon;
      switch ( iIconId )
      {
            case kTIconInfo:
                 icon = ::LoadIcon(NULL, MAKEINTRESOURCE ( IDI_ASTERISK )) ;
                 break;
            case kTIconWarn:
                 icon = ::LoadIcon(NULL, MAKEINTRESOURCE ( IDI_EXCLAMATION )) ;
                 break;
            case kTIconError:
                 icon = ::LoadIcon(NULL, MAKEINTRESOURCE ( IDI_HAND )) ;
                 break;
            case kTIconQuery:
            default:
                 icon = ::LoadIcon(NULL, MAKEINTRESOURCE ( IDI_QUESTION )) ;
                 break;
      }

      SetIcon ( icon );
#else
      switch ( iIconId )
      {
            case kTIconInfo:
//                 SetLabel("INFORMATION:");
                 break;
            case kTIconWarn:
//                 SetLabel("WARNING:");
                 break;
            case kTIconError:
//                 SetLabel("STOP:");
                 break;
            case kTIconQuery:
            default:
//                 SetLabel("QUESTION:");
                 break;
      }
#endif
}
