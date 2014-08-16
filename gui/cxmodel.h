////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxModel

////////////////////////////////////////////////////////////////////////

//   Filename:  CxModel.h
//   Author:   Richard Cooper
//  $Log: not supported by cvs2svn $
//  Revision 1.46  2012/03/26 11:40:11  rich
//  New glcontext for wx version.
//
//  Revision 1.45  2011/09/20 13:19:53  rich
//  Fix OpenGL on Linux version
//
//  Revision 1.44  2011/04/21 11:21:28  rich
//  Various WXS improvements.
//
//  Revision 1.43  2011/03/04 06:00:57  rich
//  Don't use 's' in function signature.
//
//  Revision 1.42  2009/09/04 09:25:46  rich
//  Added support for Show/Hide H from model toolbar
//  Fixed atom picking after model update in extra model windows.
//
//  Revision 1.41  2009/07/23 14:15:42  rich
//  Removed all uses of OpenGL feedback buffer - was dreadful slow on some new graphics cards.
//
//  Revision 1.40  2008/09/22 12:31:37  rich
//  Upgrade GUI code to work with latest wxWindows 2.8.8
//  Fix startup crash in OpenGL (cxmodel)
//  Fix atom selection infinite recursion in cxmodlist
//
//  Revision 1.39  2008/06/04 15:21:57  djw
//  More fixes for OpenGL problem.
//
//  Revision 1.37  2005/01/23 10:20:24  rich
//  Reinstate CVS log history for C++ files and header files. Recent changes
//  are lost from the log, but not from the files!
//
//  Revision 1.1.1.1  2004/12/13 11:16:18  rich
//  New CRYSTALS repository
//
//  Revision 1.36  2004/11/09 09:45:03  rich
//  Removed some old stuff. Don't use displaylists on the Mac version.
//
//  Revision 1.35  2004/06/24 09:12:02  rich
//  Replaced home-made strings and lists with Standard
//  Template Library versions.
//
//  Revision 1.34  2004/04/16 12:43:44  rich
//  Speed up for  OpenGL rendering: Use new lighting scheme, drop use of
//  two sets of displaylists for rendering a 'low res' model while rotating -
//  it's faster not too.
//
//  Revision 1.33  2003/05/12 12:01:19  rich
//  RIC: Oops; roll back some unintentional check-ins.
//
//  Revision 1.31  2003/05/07 12:18:58  rich
//
//  RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//  using only free compilers and libraries. Hurrah, but it isn't very stable
//  yet (CRYSTALS, not the compilers...)
//
//  Revision 1.30  2003/01/14 10:27:19  rich
//  Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
//  Revision 1.29  2002/07/03 16:44:05  richard
//  Implemented polygon selection in model window.
//
//  Improved "genericness" of ccmodelobject class to simplify calls to common
//  functions in atom, sphere and donut derived classes.
//
//  Revision 1.28  2002/07/03 14:23:21  richard
//  Replace as many old-style stream class header references with new style
//  e.g. <iostream.h> -> <iostream>. Couldn't change the ones in string however, yet.
//
//  Removed OnStuffToProcess message from WinApp, it doesn't compile under the new
//  stricter C++7.0 compiler. (CWinApp isn't a CWnd, so can't recieve messages?)
//
//  Removed some bits from Steve's Plot classes that were generating (harmless) compiler
//  warning messages.
//
//  Revision 1.27  2002/03/13 12:27:24  richard
//  Detect clicks on bonds.
//
//  Revision 1.26  2002/03/04 13:55:15  ckp2
//  Do something about display of model on 256 colour monitors. (Colours are now weird, instead
//  of just black on black background.
//
//  Revision 1.25  2001/12/12 16:02:26  ckpgroup
//  SH: Reorganised script to allow right-hand y axes.
//  Added floating key if required, some redraw problems.
//
//  Revision 1.24  2001/12/03 14:25:49  ckp2
//  RIC: Bug fixes. Release version no longer crashes on mouse leave.
//
//  Revision 1.23  2001/11/26 16:46:15  ckpgroup
//  SH: Added Mouse_Leave messaging to remove labels when mouse leaves the window.
//
//  Revision 1.22  2001/09/07 14:39:06  ckp2
//
//  New modelwindow function lets the user choose a background bitmap to
//  display behind the model. David is correct; I've been to too many
//  conferences. But it's too late now, I've done it.
//
//  Revision 1.21  2001/07/16 07:33:57  ckp2
//  wx version: Subclassed the little text windows that popup and tell you the atom names,
//  in order that they pass any mouse events to the model window. Otherwise they just get
//  in the way of the user trying to click on the atoms.
//
//  Revision 1.20  2001/06/18 12:51:40  richard
//  New variables to track whether the mouse has been captured, and if the
//  OpenGL context has been initialised (wx only).
//
//  Revision 1.19  2001/06/17 14:39:36  richard
//  Error checking and warning messages on OpenGL window creation in case of error.
//  Removal of draw_to_bitmap method, instead using compiled GL displaylists, and the
//  SwapBuffers function.
//  wx support.
//  Use GL select and feedback buffers for sizing and hit testing rather than trying to emulate it's
//  calculations.
//  Support for spotting mouse over bonds as well as over atoms - bond name and length
//  is displayed.
//  Change way popup boxes are displayed to avoid GL repaint when the popup is CREATED.
//
//  Revision 1.18  2001/03/12 13:53:26  richard
//  Fixed pixel format when only 256 colours. Removed unused accumulation buffers from
//  OpenGL window, speeding up drawing, I think.
//
//  Revision 1.17  2001/03/08 15:54:59  richard
//  Stop using GL double buffers, and do this manually. (Draw to bitmap then
//  bitblt to screen - some performance lost by looks of things, but also
//  a few gains - no need to re-render whenever window is partially covered, for
//  example. Also necessary for:
//  Polygon selection modes - only box selection implemented at the moment.
//

#ifndef     __CxModel_H__
#define     __CxModel_H__
#include    "crguielement.h"

#ifdef __BOTHWX__
#include  <wx/defs.h>
#include  <wx/app.h>
#include  <wx/menu.h>
#include  <wx/dcclient.h>
#include <wx/dcmemory.h>
#include  <wx/glcanvas.h>
#include  <wx/event.h>
#include <wx/stattext.h>
#include <wx/cursor.h>
#define BASEMODEL wxGLCanvas
#endif

#ifdef __CR_WIN__
#include    <GL\gl.h>
#include    <GL\glu.h>
#include    <afxwin.h>
#define BASEMODEL CWnd
#endif


#define RC_NEXT_LINE_TOKEN 0x0790

#include "ccpoint.h"
#include <list>

class CrModel;
class CxGrid;
class CcModelAtom;
class CcModelObject;

#define CURSORNORMAL  0
#define CURSORZOOMIN  1
#define CURSORZOOMOUT 2
#define CURSORCROSS   3
#define CURSORCOPY    4

#define MODELSMOOTH   0
#define MODELLINE     2
#define MODELPOINT    3

#define CXROTATE      0
#define CXRECTSEL     1
#define CXPOLYSEL     2
#define CXZOOM        3

//#define ATOMLIST      1
//#define BONDLIST      2
//#define STYLIST       3
//#define QATOMLIST     4
//#define QBONDLIST     5
//#define XOBJECTLIST   6
//#define TORUS         7

#define MODELLIST 8
#define PICKLIST 9

#ifdef __BOTHWX__
class mywxStaticText : public wxStaticText
{
  public:
    mywxStaticText(wxWindow* wins,int i,wxString s,wxPoint p,wxSize ss,int f);
    wxWindow * m_parent;
    void OnLButtonUp(wxMouseEvent & event);
    void OnLButtonDown(wxMouseEvent & event);
    void OnRButtonUp(wxMouseEvent & event);
    DECLARE_EVENT_TABLE()
};
#endif


class CxModel : public BASEMODEL
{
  public:
    void Update(bool rescale=true);
    void GLDrawStyle();
    int IsAtomClicked(int xPos, int yPos, string *atomname, CcModelObject **outObject, bool atomsOnly=false);
    void SelectBoxedAtoms(CcRect rectangle, bool select);
    void Setup();
    void NeedRedraw(bool needrescale = false);
    void ModelChanged(bool needrescale = true);
    void NewSize(int cx, int cy);
    void ChooseCursor( int cursor );
#ifdef __CR_WIN__
    void PaintBannerInstead(CPaintDC *dc);
#endif
#ifdef __BOTHWX__
    void PaintBannerInstead(wxPaintDC *dc);
#endif

// The usual functions:
    static CxModel *    CreateCxModel( CrModel * container, CxGrid * guiParent );
#ifdef __CR_WIN__
    CxModel(CrModel* container);
#endif
#ifdef __BOTHWX__
//    CxModel(wxWindow* parent, wxWindowID id = -1, int* args = NULL, long style = 0, const wxString& name = "GLWindow");
    CxModel(wxWindow* parent, int* args);
#endif
    ~CxModel();
    void SetGeometry( int top, int left, int bottom, int right );
    void CxDestroyWindow();

    int GetTop();
    int GetLeft();
    int GetWidth();
    int GetHeight();
    int GetIdealWidth();
    int GetIdealHeight();
    int mIdealHeight;
    int mIdealWidth;
    void SetIdealWidth(int nCharsWide);
    void SetIdealHeight(int nCharsHigh);
    void Focus();
    void AutoScale();
    void PolyCheck();
    void CameraSetup();
    void ModelSetup();
    void ModelBackground();



    CrGUIElement *  ptr_to_crObject;
    static int mModelCount;

    CcModelObject* m_LitObject;  //  Mouse is over this object

    float m_xTrans;          //
    float m_yTrans;          //  Translation
    float m_zTrans;          //

    float m_xScale;          //  Scaling
    int   m_fbsize;
    int   m_sbsize;

    float * mat;             //  Rotaion
    bool m_fastrotate;    //  Detailed or quick drawing

    CcPoint m_ptLDown;       //  Last mouse position when rotating
    CcPoint m_ptMMove;       //  Last mouse position

    list<CcPoint> m_selectionPoints;
    CcRect m_selectRect;
    CcPoint m_movingPoint;

    int m_mouseMode;

    void SetDrawStyle( int drawStyle );
    void SetAutoSize( bool size )  ;
    void SetHover( bool hover )    ;
    void SetShading( bool shade )  ;

    void SelectTool( int toolType );

    void DeletePopup();
    void CreatePopup(string atomname, CcPoint point);

    void LoadDIBitmap(string filename);

    CcPoint AtomCoordsToScreenCoords(CcPoint atomCoords);


     bool m_initcolourindex;
     GLint m_redBits,     m_greenBits,  m_blueBits;
     GLuint m_redMask,    m_greenMask,  m_blueMask;
     int m_redShift, m_greenShift, m_blueShift;

     inline GLuint makeMask(GLuint bits) {
       return (0xFF >> (8 - bits));
     }

     inline void initColourIndex() {
       glGetIntegerv (GL_RED_BITS, &m_redBits);
       glGetIntegerv (GL_GREEN_BITS, &m_greenBits);
       glGetIntegerv (GL_BLUE_BITS, &m_blueBits);
       m_redMask = makeMask(m_redBits);
       m_greenMask = makeMask(m_greenBits);
       m_blueMask = makeMask(m_blueBits);
       m_redShift =   m_greenBits + m_blueBits;
       m_greenShift =  m_blueBits;
       m_blueShift = 0;
       m_initcolourindex = true;
     };



     void ApplyIndexColour( GLuint indx ) {

       if ( ! m_initcolourindex ) {
          initColourIndex();
       }

       int red_int   = indx & (m_redMask << m_redShift);
       GLubyte red   = red_int >> (m_redShift     - (8 - m_redBits));

       int green_int = indx & (m_greenMask << m_greenShift);
       GLubyte green = green_int >> (m_greenShift - (8 - m_greenBits));

       // Blue shift will typically be 0, so we need to avoid  negative bitshifting.
       int blue_int  = indx & (m_blueMask << m_blueShift);
       GLubyte blue  = blue_int << (8 - m_blueBits);

       glColor3ub(red, green, blue); 

     };

     GLuint DecodeColour ( unsigned char *pixel ) {
  
        if ( ! m_initcolourindex ) {
           initColourIndex();
        }

        GLubyte red = pixel[0] >> (8 - m_redBits);
        GLubyte green = pixel[1] >> (8 - m_greenBits);
        GLubyte blue = pixel[2] >> (8 - m_blueBits);
  
     // Reconstruct original index
        unsigned int ic = red;
        ic <<= m_greenBits;
        ic += green;
        ic <<= m_blueBits;
        ic += blue;

        return ic;
     };


	
#ifdef __CR_WIN__
    BYTE * m_bitmapbits;
    BITMAPINFO * m_bitmapinfo;
#endif

protected:
    int m_DrawStyle;         // Rendering style
    bool m_Autosize;      // Resize when rotating?
    bool m_Hover;         // Highlight atoms on hover?
    bool m_Shading;       // Use fancy shading?
    bool m_bNeedReScale;
    bool m_bPickListOK;
    bool m_bOkToDraw;
    bool m_bFullListOK;
//    bool m_bQuickListOk;
    float m_stretchX ;
    float m_stretchY ;
    bool  m_bitmapok;
    bool m_bMouseLeaveInitialised;

    bool setCurrentGL();

    



#ifdef __CR_WIN__
    HPALETTE m_hPalette;
    CStatic* m_TextPopup;

    HGLRC m_hGLContext;                                  //The rendering context handle.
    HDC m_hdc;
    static HDC last_hdc;   //only one thread, so static approximates thread based object.

    BOOL SetWindowPixelFormat();
    BOOL CreateViewGLContext();

    CBitmap m_bitmap;
    CPalette m_pal;

    afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
    afx_msg void OnPaint();
    afx_msg void OnLButtonUp( UINT nFlags, CPoint point );
    afx_msg void OnRButtonUp( UINT nFlags, CPoint point );
    afx_msg void OnMouseMove( UINT nFlags, CPoint point );
    afx_msg void OnLButtonDown( UINT nFlags, CPoint point );
    afx_msg BOOL OnEraseBkgnd( CDC* pDC );
    afx_msg void OnMenuSelected (UINT nID);
    afx_msg LRESULT OnMouseLeave(WPARAM wParam, LPARAM lParam);
    DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
    mywxStaticText * m_TextPopup;
    bool m_DoNotPaint;
    bool m_NotSetupYet;
    bool m_MouseCaught;
    wxBitmap m_bitmap;

	wxGLContext*	m_context;
    void OnEraseBackground(wxEraseEvent & evt);
    void OnLButtonUp(wxMouseEvent & event);
    void OnLButtonDown(wxMouseEvent & event);
    void OnRButtonUp(wxMouseEvent & event);
    void OnMouseMove(wxMouseEvent & event);
    void OnChar(wxKeyEvent & event );
    void OnPaint(wxPaintEvent & event );
    void OnMenuSelected(wxCommandEvent &event );
	void OnMouseLeave(wxMouseEvent & event);
    DECLARE_EVENT_TABLE()

	wxCursor m_selectcursor;
#endif

};
#endif
