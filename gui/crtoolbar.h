////////////////////////////////////////////////////////////////////////
//
//   CRYSTALS Interface      Class CrToolBar
//
////////////////////////////////////////////////////////////////////////
//   Filename:  CrToolBar.h
//   Authors:   Richard Cooper
//   Created:   27.1.2001 09:44
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.2  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.1  2001/02/26 12:02:14  richard
//   New toolbar classes.
//

#ifndef         __CrToolBar_H__
#define         __CrToolBar_H__
#include    "crguielement.h"
#include   <list>
using namespace std;

class CrToolBar;
class CcStatus;

class CcTool
{
public:
  string tName;
  string tImage;
  string tText;
  string tCommand;
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
   CcParse ParseInput( deque<string> &  tokenList );
   void    SetGeometry( const CcRect * rect );
   CcRect  GetGeometry();
   CcRect CalcLayout(bool recalculate=false);
   void    CrFocus();
   void    SetText( const string &text );
   CcTool* FindTool(int ID);
   void    CxEnable(bool enable, int id);


   static int FindFreeToolId();
   static void AddTool( CcTool * tool );
   static void RemoveTool( CcTool * tool );
//    static void RemoveTool ( const string & toolname );
   static CcTool* FindAnyTool( int id );
   static CcTool* FindAnyTool( const string & name );
   static void UpdateToolBars(CcStatus& status);

// attributes
   list<CcTool*>  m_ToolList;   // The tools in this toolbar
//   static list<CcTool*>  m_AllToolsList;   // All tools in all toolbars.
//   static int     m_next_tool_id_to_try;

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
