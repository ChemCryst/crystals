////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrSlider

////////////////////////////////////////////////////////////////////////

//   Filename:  CrSlider.h
//   Authors:   Richard Cooper 
//   Created:   22.8.2017 08:07 Uhr

#ifndef     __CrSlider_H__
#define     __CrSlider_H__
#include    "crguielement.h"
#include    <deque>
using namespace std;

class   CrSlider : public CrGUIElement
{
    public:
//        void ClearBox();
//        void SysKey ( UINT nChar );
//        void AddText(string theText);
//        void ReturnPressed();
        void CrFocus();
        int GetIdealWidth();
        // methods
            CrSlider( CrGUIElement * mParentPtr );
            ~CrSlider();
        CcParse ParseInput( deque<string> & tokenList );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void    GetValue();
		void SetText( const string& s );

        void    GetValue( deque<string> & tokenList);
//        void    BoxChanged();
        // attributes
		void SliderChanged();

		void SetValue(float perc);
		
private:

};



#endif
