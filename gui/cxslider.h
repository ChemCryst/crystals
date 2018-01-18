////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxSlider

////////////////////////////////////////////////////////////////////////

//   Filename:  CxSlider.h
//   Authors:   Richard Cooper 
//   Created:   22.8.2017 08:11 Uhr

#ifndef     __CxSlider_H__
#define     __CxSlider_H__

#include    "crguielement.h"
#include <wx/slider.h>
#define BASESLIDER wxSlider

class CrSlider;
class CxGrid;

class CxSlider : public BASESLIDER
{
// The interface exposed to the CrClass:
    public:
        void Disable(bool disable);
        void Focus();
        // methods
        static CxSlider *  CreateCxSlider( CrSlider * container, CxGrid * guiParent );
            CxSlider( CrSlider * container);
            ~CxSlider();
        void    SetGeometry( const int top, const int left, const int bottom, const int right );
        void CxDestroyWindow();
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        static int AddSlider( void ) { mSliderCount++; return mSliderCount; };
        static void RemoveSlider( void ) { mSliderCount--; };

		string GetText();  // return slider value as text
		void SetCharWidth(int w);
		void SetValue(float percent);
		void SetSteps(int steps);
		
// The private parts:
      public:
        static int mSliderCount;
        CrGUIElement *  ptr_to_crObject;
        int mCharsWidth;

      private:
 
		int m_slidersteps;
// The private machine specific parts:
        void SliderChanged();

        void OnSlide(wxCommandEvent & event);
        DECLARE_EVENT_TABLE()



};
#endif
