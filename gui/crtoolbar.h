////////////////////////////////////////////////////////////////////////
//
//   CRYSTALS Interface      Class CrToolBar
//
////////////////////////////////////////////////////////////////////////
//   Filename:  CrToolBar.h
//   Authors:   Richard Cooper
//   Created:   27.1.2001 09:44
//   $Log: not supported by cvs2svn $

#ifndef         __CrToolBar_H__
#define         __CrToolBar_H__
#include    "crguielement.h"
#include    "cctokenlist.h"
#include        "cclist.h"

class CrToolBar;

class CcTool
{
public:
  CcString tName;
  CcString tImage;
  CcString tText;
  CcString tCommand;
  int tEnableFlags;
  int tDisableFlags;
  int toolType;
  bool toggleable;
  int CxID;
  CrToolBar* tTool;
};

#define CT_NORMAL 0
#define CT_APPICON 1
#define CT_SEP 2



class   CrToolBar : public CrGUIElement
{
  public:
// methods
   CrToolBar( CrGUIElement * mParentPtr );
   ~CrToolBar();
   CcParse ParseInput( CcTokenList * tokenList );
   void    SetGeometry( const CcRect * rect );
   CcRect  GetGeometry();
   CcRect CalcLayout(bool recalculate=false);
   void    CrFocus();
   void    SetText( CcString text );
   CcTool* FindTool(int ID);
   void    CxEnable(bool enable, int id);

// attributes

   CcList  m_ToolList;

};

#define kSAddTool   "TOOL"
#define kSToggle    "TOGGLE"
#define kSAppIcon   "APPICON"

enum
{
 kTAddTool = 2050,
 kTToggle,
 kTAppIcon
};



#endif
