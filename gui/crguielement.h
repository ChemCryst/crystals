////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrGUIElement

////////////////////////////////////////////////////////////////////////

//   Filename:  CrGUIElement.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 13:19 Uhr
//   $Log: not supported by cvs2svn $

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
    virtual void SendCommand(CcString theText, Boolean jumpQueue=false);
    virtual void FocusToInput(char theChar);
    virtual void SysKeyUp ( UINT nChar );
    virtual void SysKey ( UINT nChar );
    virtual int GetIdealWidth();
    virtual int GetIdealHeight();
    virtual CrGUIElement *  FindObject( CcString Name );
    virtual void *  GetWidget();
    virtual CrGUIElement *  GetRootWidget();
    virtual void Show( Boolean show );
    virtual void Align();
    virtual void GetValue();
    virtual void GetValue(CcTokenList * tokenList);
    virtual CcRect CalcLayout(bool recalc=false) = 0;
    virtual CcParse ParseInput( CcTokenList * tokenList );
    virtual CcParse ParseInputNoText( CcTokenList * tokenList );

//Pure virtual functions, MUST be implemented in derived classes.
    virtual void CrFocus()=0;
    virtual CcRect  GetGeometry() = 0;
    virtual void SetText( CcString text ) = 0;
    virtual void SetGeometry( const CcRect * objectRect ) = 0;

//Static functions can only act on static variables of the CLASS,
//not member variables of an OBJECT of this CLASS.

    static void SetController( CcController * controller );

    void Rename ( CcString newName );
    void NextFocus(Boolean bPrevious);

// attributes
    static CcController *   mControllerPtr;

    void *  ptr_to_cxObject;
    CcString    mText;
    CcString    mName;
    CrGUIElement *  mParentElementPtr;

    Boolean mXCanResize;
    Boolean mYCanResize;
    Boolean mTabStop;
    Boolean mDisabled;
    int m_InitWidth;
    int m_InitHeight;
  protected:

    Boolean mCallbackState;
    Boolean mSelfInitialised;
    int mAlignment;
};
#endif
