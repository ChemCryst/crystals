////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrResizeBar

////////////////////////////////////////////////////////////////////////

//   Filename:  CrResizeBar.h
//   Authors:   Richard Cooper
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.3  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.2  2001/08/14 10:20:36  ckp2
//   Quirky new feature: Hold down CTRL and click on a resize-bar and the panes
//   will swap sides. Hold down SHIFT and click, and the panes will rotate by 90
//   degrees. Gives more control over screen layout, but is not intuitive as the
//   user can't SEE which panes belong to a given resize bar. Try it and see.
//   The new layout is not stored and will revert to original layout when window
//   is reopened (for the time being).
//
//   Revision 1.1  2001/02/26 12:04:49  richard
//   New resizebar class. A resize control has two panes and the bar between them
//   can be dragged to change their relative sizes. If one of the panes is of fixed
//   width or height in the relevant direction, then the resize-bar contains a button
//   which will show or hide the fixed size item.
//

#ifndef         __CrResizeBar_H__
#define         __CrResizeBar_H__

#include    "crguielement.h"


class  CrResizeBar : public CrGUIElement
{
  public:
    CrResizeBar( CrGUIElement * mParentPtr );
    ~CrResizeBar();

    void CrFocus();
    int GetIdealWidth();
    int GetIdealHeight();
    CcParse ParseInput( deque<string> & tokenList );
    void    SetText ( const string &text );
    void    SetGeometry( const CcRect * rect );
    CcRect  GetGeometry ();
    CcRect CalcLayout(bool recalculate=false);
    CrGUIElement *  FindObject( const string & Name );
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
