////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxSlider

////////////////////////////////////////////////////////////////////////

//   Filename:  CxSlider.cc
//   Authors:   Richard Cooper
//   Created:   22.8.2017 08:13 Uhr

#include    "crystalsinterface.h"
#include    <string>
#include    <sstream>
using namespace std;
#include    "cxslider.h"
#include    "cccontroller.h"
#include    "cxgrid.h"
#include    "cxwindow.h"
#include    "crslider.h"
#ifdef CRY_USEWX
 #include <ctype.h> //for proto of iscntrl()

// These macros are being defined somewhere. They shouldn't be.

 #ifdef GetCharWidth
  #undef GetCharWidth
 #endif
 #ifdef DrawText
  #undef DrawText
 #endif
#endif


int CxSlider::mSliderCount = kSliderBase;


CxSlider * CxSlider::CreateCxSlider( CrSlider * container, CxGrid * guiParent )
{
//As with all these Cx classes, this is a static funtion. Call it to create an Slider,
//and it will do the initialisation for you.

    CxSlider   *theSlider = new CxSlider( container );
    theSlider->Create(guiParent, kSliderBase+1, 0, 0, 100, wxDefaultPosition, wxDefaultSize);
    return theSlider;
}
CxSlider::CxSlider( CrSlider * container )
      :BASESLIDER()
{
  ptr_to_crObject = container;      //This is the container (CrSlider)
  mCharsWidth = 50;          //This is the default width if none is specified.
  m_slidersteps = 100;
}

CxSlider::~CxSlider()
{
    RemoveSlider();
}

void CxSlider::SetSteps(int s) {
    m_slidersteps = s;
    SetMax(s);
}

void CxSlider::CxDestroyWindow()
{
Destroy();
}

CXSETGEOMETRY(CxSlider)
CXGETGEOMETRIES(CxSlider)


int CxSlider::GetIdealWidth()
{
      return mCharsWidth;
}

int CxSlider::GetIdealHeight()
{
      int cx, cy;
      GetTextExtent( "Some text", &cx, &cy ) ;
      return cy + 5;
}

string CxSlider::GetText()
{
      float frac = GetValue() / (float)m_slidersteps;
      ostringstream strm;
      strm << frac;
      return strm.str();
}

void    CxSlider::SetCharWidth( int count )
{
      mCharsWidth = count * GetCharWidth();
}

void CxSlider::SetValue(float frac)
{
      int step = frac * m_slidersteps;
      SetValue(step);
}

void CxSlider::OnSlide(wxCommandEvent & event) {
    ((CrSlider*)ptr_to_crObject)->SliderChanged();  //Inform container that the text has changed.

}



//wx Message Table
BEGIN_EVENT_TABLE(CxSlider, BASESLIDER)
      EVT_SLIDER( kSliderBase+1, CxSlider::OnSlide )
END_EVENT_TABLE()


void CxSlider::Focus()
{
    SetFocus();
}



void CxSlider::Disable(bool disable)
{
      if(disable)
            Enable(false);
    else
            Enable(true);
}



