////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrResizeBar

////////////////////////////////////////////////////////////////////////

//   Filename:  CrResizeBar.h
//   Authors:   Richard Cooper
//   $Log: not supported by cvs2svn $
//   Revision 1.1  2001/02/26 12:04:49  richard
//   New resizebar class. A resize control has two panes and the bar between them
//   can be dragged to change their relative sizes. If one of the panes is of fixed
//   width or height in the relevant direction, then the resize-bar contains a button
//   which will show or hide the fixed size item.
//

#ifndef         __CrResizeBar_H__
#define         __CrResizeBar_H__

#include    "crguielement.h"

class CcTokenList;

class  CrResizeBar : public CrGUIElement
{
  public:
    CrResizeBar( CrGUIElement * mParentPtr );
    ~CrResizeBar();

    void CrFocus();
    int GetIdealWidth();
    int GetIdealHeight();
    CcParse ParseInput( CcTokenList * tokenList );
    void    SetText ( CcString text );
    void    SetGeometry( const CcRect * rect );
    CcRect  GetGeometry ();
    CcRect CalcLayout(bool recalculate=false);
    CrGUIElement *  FindObject( CcString Name );
    void MoveResizeBar( int offset );
    void Collapse ( bool collapse );
    void SwapPanes();
    void SwapOrient();

  private:
    int m_offset, m_type, m_InitOffset;
    bool m_firstNonSize, m_secondNonSize, m_NonSizePresent, m_BothNonSize, m_Reverse, m_Rotate;
    CrGUIElement *m_firstitem, *m_seconditem;
};




#endif
