////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrResizeBar

////////////////////////////////////////////////////////////////////////

//   Filename:  CrResizeBar.h
//   Authors:   Richard Cooper
//   $Log: not supported by cvs2svn $

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

  private:
    int m_offset, m_type, m_InitOffset;
    bool m_firstNonSize, m_secondNonSize, m_NonSizePresent, m_BothNonSize;
    CrGUIElement *m_firstitem, *m_seconditem;
};




#endif
