////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrPlot

////////////////////////////////////////////////////////////////////////

//   Filename:  CrPlot.h
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:28
//
//   $Log: not supported by cvs2svn $
//

#ifndef     __CrPlot_H__
#define     __CrPlot_H__
#include    "crguielement.h"

class CcPlotData;
class CcTokenList;

class   CrPlot : public CrGUIElement
{
    public:
//Functions for drawing on the window:
        void DrawLine(int x1, int y1, int x2, int y2);
        void DrawText(int x, int y, CcString text);
        void DrawRect(int x1, int y1, int x2, int y2, Boolean fill);
        void DrawPoly(int nVertices, int* vertices, Boolean fill);
        void DrawEllipse(int x, int y, int w, int h, Boolean fill);
        void Clear();

//Creation and adding data:
        void Attach(CcPlotData* doc);
        CrPlot( CrGUIElement * mParentPtr );
        ~CrPlot();

        void ReDrawView();
        void Display();
        void CrFocus();
        CcParse ParseInput( CcTokenList * tokenList );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect  CalcLayout(bool recalculate=false);
        void    SetText( CcString text );
        int GetIdealWidth();
        int GetIdealHeight();

//attributes
        CcPlotData* attachedPlotData;
        
};


#endif
