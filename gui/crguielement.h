////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrGUIElement

////////////////////////////////////////////////////////////////////////

//   Filename:  CrGUIElement.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 13:19 Uhr
//   Modified:  30.3.1998 13:33 Uhr

#ifndef     __CrGUIElement_H__
#define     __CrGUIElement_H__
//Insert your own code here.
#include "cctokenlist.h"
#include "ccstring.h"

class CcList;
class CcRect;
class CcController;
//End of user code.

class   CrGUIElement
{
    public:
        virtual void SendCommand(CcString theText, Boolean jumpQueue=false);
        Boolean mDisabled;
        virtual void FocusToInput(char theChar);
            virtual void SysKeyUp ( UINT nChar );
            virtual void SysKey ( UINT nChar );
        Boolean mTabStop;
        virtual void CrFocus()=0;
            void NextFocus(Boolean bPrevious);
        virtual void Resize(int newColWidth, int newRowHeight, int origColWidth, int origRowHeight);
        virtual int GetIdealWidth();
        virtual int GetIdealHeight();
        Boolean mXCanResize;
        Boolean mYCanResize;
        // methods
            CrGUIElement( CrGUIElement * mParentPtr );
        virtual     ~CrGUIElement();
        virtual CrGUIElement *  FindObject( CcString Name );
        virtual void *  GetWidget();
        virtual CrGUIElement *  GetRootWidget();
        virtual void    Show( Boolean show );
        virtual void    Align();
        virtual void    GetValue();
        virtual void    GetValue(CcTokenList * tokenList);
        virtual void    SetText( CcString text ) = 0;
        virtual void    CalcLayout() = 0;
            virtual void      SetOriginalSizes();
        virtual Boolean ParseInput( CcTokenList * tokenList );
        Boolean ParseInputNoText( CcTokenList * tokenList );
        virtual CcRect  GetGeometry() = 0;
        virtual void    SetGeometry( const CcRect * objectRect ) = 0;
        static void SetController( CcController * controller );
            void Rename ( CcString newName );

        // attributes
        static CcController *   mControllerPtr;
        float mHeightFactor;
        float mWidthFactor;
        void *  ptr_to_cxObject;
        CcString    mText;
        CcString    mName;

    protected:
        // methods

        // attributes
        CrGUIElement *  mParentElementPtr;
        Boolean mCallbackState;
        Boolean mSelfInitialised;
        int mAlignment;

};
#endif
