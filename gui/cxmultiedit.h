////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxMultiEdit

////////////////////////////////////////////////////////////////////////

//   Filename:  CxMultiEdit.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   5.3.1998 13:51 Uhr
//   $Log: not supported by cvs2svn $

#ifndef     __CxMultiEdit_H__
#define     __CxMultiEdit_H__

#include "crystalsinterface.h"

#ifdef __BOTHWX__
#include <wx/textctrl.h>
#define BASEMULTIEDIT wxTextCtrl
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASEMULTIEDIT CRichEditCtrl
#endif

class CrMultiEdit;
class CxGrid;
class CrGUIElement;
//End of user code.

class CxMultiEdit : public BASEMULTIEDIT
{
    public:
        void BackALine();
        void Empty();
        void Spew();
        void SetFixedWidth(Boolean fixed);
        void SetItalic(Boolean italic);
        void SetUnderline(Boolean underline);
        void SetBold(Boolean bold);
        void SetColour (int red, int green, int blue);
        void Focus();

        // methods
        static  CxMultiEdit * CreateCxMultiEdit( CrMultiEdit * container, CxGrid * guiParent );
            CxMultiEdit( CrMultiEdit * container );
            ~CxMultiEdit();
            void  SetText( CcString cText );
//            void  SetHyperText( CcString cText, CcString cCommand  );
        void    SetIdealWidth(int nCharsWide);
        void    SetIdealHeight(int nCharsHigh);
        int GetIdealWidth();
        int GetIdealHeight();
        int GetTop();
        int GetWidth();
        int GetHeight();
        int GetLeft();
        void    SetGeometry(int top, int left, int bottom, int right );
        static int AddMultiEdit( void) { mMultiEditCount++; return mMultiEditCount; };
        static void RemoveMultiEdit( void) { mMultiEditCount--; };
        void SetFontHeight( int height );

        // attributes
        static int mMultiEditCount;

    private:
        // attributes
        CrMultiEdit *   ptr_to_crObject;
        int     mIdealHeight;
        int     mIdealWidth;
        int    mHeight;

#ifdef __CR_WIN__
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);

        DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
      public:
            void OnChar(wxKeyEvent & event );
            DECLARE_EVENT_TABLE()
#endif

};
#endif
