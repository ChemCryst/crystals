////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrGUIElement

////////////////////////////////////////////////////////////////////////

//   Filename:  CrGUIElement.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 13:19 Uhr
//   $Log: not supported by cvs2svn $
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

#include "cctokenlist.h"
#include "ccstring.h"

class CcList;
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
    virtual void SendCommand(CcString theText, bool jumpQueue=false);
    virtual void FocusToInput(char theChar);
    virtual void SysKeyUp ( UINT nChar );
    virtual void SysKey ( UINT nChar );
    virtual int GetIdealWidth();
    virtual int GetIdealHeight();
    virtual CrGUIElement *  FindObject( CcString Name );
    virtual void *  GetWidget();
    virtual CrGUIElement *  GetRootWidget();
    virtual void Show( bool show );
    virtual void Align();
    virtual void GetValue();
    virtual void GetValue(CcTokenList * tokenList);
    virtual CcParse ParseInput( CcTokenList * tokenList );
    virtual CcParse ParseInputNoText( CcTokenList * tokenList );

//Pure virtual functions, MUST be implemented in derived classes.
    virtual CcRect CalcLayout(bool recalc=false) = 0;
    virtual void CrFocus()=0;
    virtual CcRect  GetGeometry() = 0;
    virtual void SetText( CcString text ) = 0;
    virtual void SetGeometry( const CcRect * objectRect ) = 0;

//Static functions can only act on static variables of the CLASS,
//not member variables of an OBJECT of this CLASS.

    static void SetController( CcController * controller );

    void Rename ( CcString newName );
    void NextFocus(bool bPrevious);

// attributes
    static CcController *   mControllerPtr;

    void *  ptr_to_cxObject;
    CcString    mText;
    CcString    mName;
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
