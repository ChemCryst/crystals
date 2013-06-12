////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrGUIElement

////////////////////////////////////////////////////////////////////////

//   Filename:  CrGUIElement.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 13:19 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.13  2013/06/11 12:30:39  pascal
//   Linux changes
//
//   Revision 1.12  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:17  rich
//   New CRYSTALS repository
//
//   Revision 1.11  2004/06/28 13:26:57  rich
//   More Linux fixes, stl updates.
//
//   Revision 1.10  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.9  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.8  2001/10/10 12:44:50  ckp2
//   The PLOT classes!
//
//   Revision 1.7  2001/03/08 15:38:29  richard
//   ParseInput now defined to return a CcParse object, which contains three boolean
//   values , success, xCanResize and yCanResize. This means that resize info filters
//   back down to each level as the objects are created.
//   Removed SetOriginalSizes subroutine - no longer needed.
//

#ifndef     __CrGUIElement_H__
#define     __CrGUIElement_H__

#include <string>
#include <deque>
using namespace std;


class CcRect;
class CcController;

class CcParse
{
 public:
   CcParse(bool ok=true, bool xCanResize = true, bool yCanResize = true) { m_ok=ok; m_xCanResize = xCanResize; m_yCanResize = yCanResize; };
   bool OK() { return m_ok; };
   bool CanXResize() { return m_xCanResize; };
   bool CanYResize() { return m_yCanResize; };
   bool m_ok;
   bool m_xCanResize;
   bool m_yCanResize;
};


class   CrGUIElement
{
  public:
    CrGUIElement( CrGUIElement * mParentPtr );
    virtual     ~CrGUIElement();

//Virtual functions, may be overridden in derived classes if reqd.
//Overridden function can then be called using a pointer to the base class.
    virtual void SendCommand(const string & theText, bool jumpQueue=false);
    virtual void FocusToInput(char theChar);
    virtual void SysKeyUp ( UINT nChar );
    virtual void SysKey ( UINT nChar );
    virtual int GetIdealWidth();
    virtual int GetIdealHeight();
    virtual CrGUIElement *  FindObject( const string & Name );
    virtual void *  GetWidget();
    virtual CrGUIElement *  GetRootWidget();
    virtual void Show( bool show );
    virtual void Align();
    virtual void GetValue();
    virtual void GetValue(deque<string> &  tokenList);
    virtual CcParse ParseInput( deque<string> &  tokenList );
    virtual CcParse ParseInputNoText( deque<string> &  tokenList );

//Pure virtual functions, MUST be implemented in derived classes.
    virtual CcRect CalcLayout(bool recalc=false) = 0;
    virtual void CrFocus()=0;
    virtual CcRect  GetGeometry() = 0;
    virtual void SetText( const string &text ) = 0;
    virtual void SetGeometry( const CcRect * objectRect ) = 0;

//Static functions can only act on static variables of the CLASS,
//not member variables of an OBJECT of this CLASS.

    static void SetController( CcController * controller );

    void Rename ( const string & newName );
    void NextFocus(bool bPrevious);

// attributes
    static CcController *   mControllerPtr;

    void *  ptr_to_cxObject;
    string    mText;
    string    mName;
    CrGUIElement *  mParentElementPtr;

    bool mXCanResize;
    bool mYCanResize;
    bool mTabStop;
    bool mDisabled;
    int m_InitWidth;
    int m_InitHeight;
  protected:

    bool mCallbackState;
    bool mSelfInitialised;
    int mAlignment;
};
#endif
