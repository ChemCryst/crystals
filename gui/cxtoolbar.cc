////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxToolBar
////////////////////////////////////////////////////////////////////////
//   Filename:  CxToolBar.cc
//   Authors:   Richard Cooper
//   Created:   27.1.2001 09:48
//   $Log: not supported by cvs2svn $
//   Revision 1.2  2001/06/17 14:27:40  richard
//   wx Support.
//   Catch bad bitmaps.
//   Destroy window function.
//
//   Revision 1.1  2001/02/26 12:02:15  richard
//   New toolbar classes.
//

#include    "crystalsinterface.h"
#include    "crtoolbar.h"
#include    "cxtoolbar.h"
#include    "cxgrid.h"
#include    "cxwindow.h"
#include    "cccontroller.h"

#ifdef __BOTHWX__
#include <wx/settings.h>
#endif


#ifdef __BOTHWX__
BEGIN_EVENT_TABLE(mywxToolBar, wxToolBar)
      EVT_CHAR( mywxToolBar::OnChar )
END_EVENT_TABLE()

void mywxToolBar::OnChar(wxKeyEvent &event){CcController::theController->FocusToInput((char)event.KeyCode());}
#endif


int CxToolBar::mToolBarCount = kToolBarBase;

CxToolBar * CxToolBar::CreateCxToolBar( CrToolBar * container, CxGrid * guiParent )
{
// You won't see many examples like this. The CxToolBar is just a plain
// CWnd or wxWindow ( a base class general purpose window ). After it's
// creation we create an actual toolbar and make the CxToolBar its parent.
// MFC likes to move the toolbar to the top or bottom of the parent window,
// so this gets around that by letting us control the position of the
// parent window.

    CxToolBar *theCxToolBar = new CxToolBar( container );

#ifdef __CR_WIN__
    theCxToolBar->Create(NULL, NULL, WS_CHILD| WS_VISIBLE, CRect(0,0,5,5), guiParent, ++mToolBarCount);
    theCxToolBar->SetFont(CcController::mp_font);

    theCxToolBar->m_ToolBar->Create(WS_CHILD| WS_VISIBLE|TBSTYLE_FLAT|CCS_NODIVIDER, CRect(0,0,5,5), theCxToolBar, mToolBarCount);
    theCxToolBar->m_ToolBar->SetFont(CcController::mp_font);
#endif
#ifdef __BOTHWX__
    theCxToolBar->Create(guiParent,-1);
    theCxToolBar->m_ToolBar->Create(theCxToolBar, ++mToolBarCount);
#endif
    return theCxToolBar;

}

CxToolBar::CxToolBar( CrToolBar * container )
      : BASETOOLBAR()
{
    ptr_to_crObject = container;
#ifdef __CR_WIN__
    m_ImageList = new CImageList();
    m_ImageList->Create(16,15,ILC_COLOR24|ILC_MASK,0,2);
    m_ToolBar = new CToolBarCtrl();
#endif
#ifdef __BOTHWX__
    m_ToolBar = new mywxToolBar();
#endif
    m_ImageIndex = 0;
}

CxToolBar::~CxToolBar()
{
  mToolBarCount--;
#ifdef __CR_WIN__
  delete m_ImageList;
  m_ToolBar->DestroyWindow();
  delete m_ToolBar;
#endif
#ifdef __BOTHWX__
  m_ToolBar->Destroy();
#endif
}

void CxToolBar::CxDestroyWindow()
{
  #ifdef __CR_WIN__
DestroyWindow();
#endif
#ifdef __BOTHWX__
Destroy();
#endif
}

void    CxToolBar::AddTool( CcTool* newTool )
{
// Check if this is a separator.

  if ( newTool->toolType == CT_SEP )
  {
#ifdef __CR_WIN__
    TBBUTTON sepButton;
    sepButton.idCommand = 0;
    sepButton.fsStyle = TBSTYLE_SEP;
    sepButton.fsState = TBSTATE_ENABLED;
    sepButton.iString = 0;
    sepButton.iBitmap = 0;
    sepButton.dwData = 0;
    m_ToolBar->AddButtons(1,&sepButton);
#endif
#ifdef __BOTHWX__
    m_ToolBar->AddSeparator();
#endif
    newTool->CxID = 0;
    return;
  }

//Find bitmap and add to list
//Check bitmap type

  int bitmapIndex=-1;
  newTool->CxID = (CcController::theController)->FindFreeToolId();


  if ( newTool->toolType == CT_APPICON )
  {
    CcString file = newTool->tImage;
#ifdef __CR_WIN__
    HICON hIcon = ExtractIcon( AfxGetInstanceHandle( ), file.ToCString(), 0 );
    if( hIcon )
    {
      m_ImageList->Add( hIcon );
      bitmapIndex = m_ImageIndex++;
      DestroyIcon(hIcon);
    }
#endif
#ifdef __BOTHWX__
    wxIcon mycon( file.ToCString(), wxBITMAP_TYPE_ICO_RESOURCE, -1, -1 );
    if ( mycon.Ok() )
    {
      m_ToolBar->AddTool(newTool->CxID, mycon, newTool->tText.ToCString());
      m_ToolBar->Realize();
      m_ImageIndex++;
    }
#endif
  }
  else
  {
#ifdef __CR_WIN__
    CBitmap* abitmap = new CBitmap();
    HBITMAP hBmp;
#endif
    CcString crysdir ( getenv("CRYSDIR") );
    if ( crysdir.Length() == 0 )
    {
      cerr << "You must set CRYSDIR before running crystals.\n";
      return;
    }
    int nEnv = (CcController::theController)->EnvVarCount( crysdir );
    int i = 0;
    bool noLuck = true;
    while ( noLuck )
    {
      CcString dir = (CcController::theController)->EnvVarExtract( crysdir, i );
      i++;
#ifdef __LINUX__
      CcString file = dir + "/script/" + newTool->tImage;
#endif
#ifdef __BOTHWIN__
      CcString file = dir + "\\script\\" + newTool->tImage;
#endif

#ifdef __BOTHWX__
      wxBitmap mymap ( file.ToCString(), wxBITMAP_TYPE_BMP );
      if( mymap.Ok() )
      {
        noLuck = false;
        m_ToolBar->AddTool(newTool->CxID, mymap, newTool->tText.ToCString(), "" );
        m_ToolBar->Realize();
        m_ImageIndex++;
      }
      else if ( i >= nEnv )
      {
        LOGERR ( "Bitmap not found " + newTool->tImage );
        return;
      }
    }
#endif
#ifdef __CR_WIN__
      hBmp = (HBITMAP)::LoadImage( NULL, file.ToCString(), IMAGE_BITMAP, 0,0, LR_LOADFROMFILE|LR_CREATEDIBSECTION);
      if( hBmp )
      {
        noLuck = false;
      }
      else if ( i >= nEnv )
      {
        LOGERR ( "Bitmap not found " + newTool->tImage );
        return;
      }
    }
    abitmap->Attach( hBmp );

    BITMAP bm;
    abitmap->GetBitmap(&bm);
    if ( bm.bmWidth == 16 && bm.bmHeight == 15)
    {
      ReplaceBackgroundColor ( *abitmap );
      m_bitmapList.AddItem( abitmap );
      m_ImageList->Add( abitmap,  ::GetSysColor (COLOR_BTNFACE));
      bitmapIndex = m_ImageIndex++;
    }
    else
    {
       LOGERR ("Bitmap, "+newTool->tImage+" is wrong height or width, must be 16 wide and 15 high.");
    }
    delete abitmap;
#endif
  }

#ifdef __CR_WIN__
  m_ToolBar->SetImageList(m_ImageList);
  TBBUTTON tbbutton;
  tbbutton.iBitmap = bitmapIndex;
  tbbutton.iString = m_ToolBar->AddStrings(newTool->tText.ToCString());
  tbbutton.dwData = 0;
  tbbutton.fsState = TBSTATE_ENABLED;
  tbbutton.fsStyle = TBSTYLE_BUTTON;
  tbbutton.idCommand = newTool->CxID;
  if ( newTool->toggleable ) tbbutton.fsStyle = TBSTYLE_BUTTON|TBSTYLE_CHECK   ;
  m_ToolBar->AddButtons(1,&tbbutton);
#endif

}

void    CxToolBar::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __CR_WIN__
      MoveWindow(left,top,right-left,bottom-top);
      m_ToolBar->MoveWindow(0,0,right-left,bottom-top);
#endif
#ifdef __BOTHWX__
      SetSize(left,top,right-left,bottom-top);
      m_ToolBar->SetSize(0,0,right-left,bottom-top);
#endif

}

CXGETGEOMETRIES(CxToolBar)


int CxToolBar::GetIdealWidth()
{
#ifdef __CR_WIN__
   SIZE tbs;
   m_ToolBar->GetMaxSize(&tbs);
   return tbs.cx;
#endif
#ifdef __BOTHWX__
//   LOGSTAT ( "Toolsize = " + CcString ( m_ToolBar->GetToolBitmapSize().GetWidth() ) );
//   LOGSTAT ( "Toolsep = " + CcString ( m_ToolBar->GetToolSeparation() ) );
//   LOGSTAT ( "m_ImageIndex = " + CcString ( m_ImageIndex ) );
   return (( 18 + m_ToolBar->GetToolSeparation() ) * m_ImageIndex ) ;
#endif
}

int CxToolBar::GetIdealHeight()
{
#ifdef __CR_WIN__
   SIZE tbs;
   m_ToolBar->GetMaxSize(&tbs);
   return tbs.cy+2;
#endif
#ifdef __BOTHWX__
   return 15 + 10;
#endif
}

#ifdef __CR_WIN__
BEGIN_MESSAGE_MAP(CxToolBar, BASETOOLBAR)
    ON_COMMAND_RANGE (kToolButtonBase, kToolButtonBase+5000, OnToolSelected)
    ON_WM_CHAR()
END_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
//wx Message Map
BEGIN_EVENT_TABLE(CxToolBar, BASETOOLBAR)
      EVT_CHAR( CxToolBar::OnChar )
END_EVENT_TABLE()
#endif

void CxToolBar::Focus()
{
   m_ToolBar->SetFocus();
}


CXONCHAR(CxToolBar)


#ifdef __CR_WIN__
void CxToolBar::ReplaceBackgroundColor (CBitmap& ioBM)
{
// figure out how many pixels there are in the bitmap

  BITMAP                bmInfo;
  ioBM.GetBitmap (&bmInfo);

// add support for additional bit depths if you choose
  const UINT numPixels (bmInfo.bmHeight * bmInfo.bmWidth);

// get a pointer to the pixels
  DIBSECTION  ds;
  ioBM.GetObject (sizeof (DIBSECTION), &ds);

  RGBTRIPLE* pixels = reinterpret_cast<RGBTRIPLE*>(ds.dsBm.bmBits);

// get the user's preferred button color from the system
  const COLORREF            buttonColor (::GetSysColor (COLOR_BTNFACE));
  const RGBTRIPLE          kBackgroundColor = {
  pixels [0].rgbtBlue, pixels [0].rgbtGreen, pixels [0].rgbtRed};
  const RGBTRIPLE          userBackgroundColor = {
  GetBValue (buttonColor), GetGValue (buttonColor), GetRValue (buttonColor)};


// search through the pixels, substituting the button
// color for any pixel that has the magic background color
  for (UINT i = 0; i < numPixels; ++i)
  {
    if (pixels [i].rgbtBlue == kBackgroundColor.rgbtBlue
     && pixels [i].rgbtGreen == kBackgroundColor.rgbtGreen
     && pixels [i].rgbtRed == kBackgroundColor.rgbtRed)
    {
      pixels [i] = userBackgroundColor;
    }
  }
}
#endif


void CxToolBar::CxEnable(bool enable, int id)
{
#ifdef __CR_WIN__
  bool invcurrent = ( m_ToolBar->IsButtonEnabled(id) == 0 );
#endif
#ifdef __BOTHWX__
  bool invcurrent = ! (m_ToolBar->GetToolEnabled(id));
#endif

  if  ( invcurrent == enable )
  {
#ifdef __CR_WIN__
     m_ToolBar->EnableButton(id, enable);
#endif
#ifdef __BOTHWX__
     m_ToolBar->EnableTool(id, enable);
#endif
  }
}

void CxToolBar::CheckTool(bool check, int id)
{
#ifdef __CR_WIN__
 int cstate = m_ToolBar->GetState(id);
 if(check)
   m_ToolBar->SetState ( id, cstate | TBSTATE_CHECKED);
 else
   m_ToolBar->SetState ( id, cstate & ~TBSTATE_CHECKED);
#endif
#ifdef __BOTHWX__
 m_ToolBar->ToggleTool(id, check);
#endif


}


#ifdef __CR_WIN__
void CxToolBar::OnToolSelected(int nID)
{
#endif
#ifdef __BOTHWX__
void CxToolBar::OnToolSelected(wxCommandEvent & event)
{
      int nID = event.m_id;
#endif
    ((CrWindow*)(ptr_to_crObject->GetRootWidget()) )->ToolSelected( nID );
}
