////////////////////////////////////////////////////////////////////////

//   CRYSALS Interface      Class CcModelDoc

////////////////////////////////////////////////////////////////////////

//   Filename:  CcModelDoc.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr

//BIG NOTICE: ModelDoc is not a CrGUIElement, it's more like a list
//            of drawing commands.
//            You can attach a CrModel to it and it will then draw
//            itself on that CrModel's drawing area.
//            It does contain a ParseInput routine for parsing the
//            drawing commands. Note again - it is not a CrGUIElement,
//            it has no graphical presence, nor a complimentary Cx- class

// $Log: not supported by cvs2svn $
// Revision 1.23  2002/10/02 13:42:00  rich
// Support for more info from GUIBIT (e.g. UEQUIV).
// Ability to act as a source of data for either a MODELWINDOW
// or a MODLIST.
//
// Revision 1.22  2002/07/23 08:25:43  richard
//
// Moved selected, disabled and excluded variables and functions into the base class.
// Added ALL option to DISABLEATOM to enable/disable all atoms.
//
// Revision 1.21  2002/07/18 16:44:34  richard
// Changes to ensure two CrModels can share the same CcModelDoc happily.
//
// Revision 1.20  2002/07/16 14:09:45  richard
// Bug in atom selection fixed: if last digit of two or more character number
// was also last character of the string it would be chopped off by accident.
//
// Revision 1.19  2002/07/04 13:04:44  richard
//
// glPassThrough was causing probs on Latitude notebook. Can only be called in feedback
// mode, which means that it can't be stuck into the display lists which are used
// for drawing aswell. Instead, added feedback logical parameter into all Render calls, when
// true it does a "feedback" render rather than a display list render. Will slow down polygon
// selection a negligble amount.
//
// Revision 1.18  2002/07/03 16:44:05  richard
// Implemented polygon selection in model window.
//
// Improved "genericness" of ccmodelobject class to simplify calls to common
// functions in atom, sphere and donut derived classes.
//
// Revision 1.17  2002/06/28 10:09:53  richard
// Minor gui update enabling vague display of special shapes: ring and sphere.
//
// Revision 1.16  2002/06/25 11:58:09  richard
// Use _F in popup-menu commands to substitute in all atoms in fragment connected
// to clicked-on atom.
//
// Revision 1.15  2002/05/15 17:25:00  richard
// Bug fix.
//
// Revision 1.14  2002/03/13 12:25:45  richard
// Update variable names. Added FASTBOND and FASTATOM routines which can be called
// from the Fortran instead of passing data through the text channel.
//
// Revision 1.13  2002/01/31 15:03:13  ckp2
// RIC: Fix Alexander's OpenGL bug (at last).
//
// Revision 1.12  2001/06/17 15:24:19  richard
//
//
// Lot of functions which used to be called from CxModel and CrModel removed and
// now CcModelDoc does these for itself (lists of selected atoms etc.)
//
// Render groups atoms by drawing style and sends GL attributes only once at beginning
// of each set (e.g. disabled atoms, selected atoms, normal atoms, excluded atoms.)
//
// Revision 1.11  2001/03/08 15:12:17  richard
// Added functions for excluding atoms and bonds, and excluding fragments based on
// known bonding.
//
// Revision 1.10  2001/01/25 17:04:23  richard
// Commented out unused lists of model objects. Triangles and Cells, actually.
//
// Revision 1.9  2000/10/31 15:42:14  ckp2
// Link to atom disabling code.
//
// Revision 1.8  1999/08/25 17:57:41  ckp2
// RIC: Updates from before Glasgow
//
// Revision 1.7  1999/08/03 09:19:18  richard
// RIC: Keep track of number of selected atoms more carefully.
//
// Revision 1.6  1999/06/22 12:57:18  dosuser
// RIC: RenderModel returns a boolean indicating whether anything was drawn.
//
// Revision 1.5  1999/06/13 16:40:32  dosuser
// RIC: No need to keep track of the centre as objects are added. Atoms
// are now centred in XGDBUP. DrawViews and Centre() removed.
// RedrawHighlights() removed. This is done automatically in the atoms
// Render() function. New function RenderModel() is called when
// a Paint event is recieved by CxModel. It calls Render() for each
// of the modelobjects stored in its lists. The argument view lets
// the modelobjects access global settings from the CrModel such as
// RadiusType and Scale. The bool detailed tells the model object
// whether to draw at high or low resolution depending on whether the
// view is currently rotating.
//
// Revision 1.4  1999/04/30 17:09:45  dosuser
// RIC: Changed the ClearHighlights() call before the HighlightAtoms loop
//      to a StartHighlights() before and a FinishHighlights() after.
//
// Revision 1.3  1999/04/26 11:12:39  dosuser
// RIC: Added a bit of code to call Reset() on all views attached to
//      the modeldoc in order that they don't keep pointers to atoms
//      in the modeldoc once it is updated by CRYSTALS.
//



#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "ccmodeldoc.h"
#include    "ccmodelobject.h"
//insert your own code here.
#include    "crmodel.h"
#include    "crmodlist.h"
//#include  "ccrect.h"
#include    "cccoord.h"
#include    "cccontroller.h"    // for sending commands
#include    "cxmodel.h"


CcList CcModelDoc::sm_ModelDocList;
CcModelDoc* CcModelDoc::sm_CurrentModelDoc = nil;


CcModelDoc::CcModelDoc( )
{
    mAtomList = new CcList();
    mBondList = new CcList();
    mSphereList = new CcList();
    mDonutList = new CcList();
//        mCellList = new CcList();
//        mTriList = new CcList();
    m_nAtoms = 0;
    nSelected = 0;
    sm_ModelDocList.AddItem(this);
    sm_CurrentModelDoc = this;
    m_glIDsok = false;

}

CcModelDoc::~CcModelDoc()
{
    mAtomList->Reset();
    mBondList->Reset();
    mSphereList->Reset();
    mDonutList->Reset();

//        mCellList->Reset();
//        mTriList->Reset();
    CcModelObject* theItem ;
    while ( ( theItem = (CcModelObject *)mAtomList->GetItem() ) != nil )
    {
        mAtomList->RemoveItem();
        delete theItem;
    }
    while ( ( theItem = (CcModelObject *)mBondList->GetItem() ) != nil )
    {
        mBondList->RemoveItem();
        delete theItem;
    }
    while ( ( theItem = (CcModelObject *)mSphereList->GetItem() ) != nil )
    {
        mSphereList->RemoveItem();
        delete theItem;
    }
    while ( ( theItem = (CcModelObject *)mDonutList->GetItem() ) != nil )
    {
        mDonutList->RemoveItem();
        delete theItem;
    }
//        while ( ( theItem = (CcModelObject *)mCellList->GetItem() ) != nil )
//        {
//                mCellList->RemoveItem();
//                delete theItem;
//        }
//        while ( ( theItem = (CcModelObject *)mTriList->GetItem() ) != nil )
//        {
//                mTriList->RemoveItem();
//                delete theItem;
//        }

    delete mAtomList;
    delete mBondList;
    delete mSphereList;
    delete mDonutList;
//        delete mCellList;
//        delete mTriList;

    attachedViews.Reset();
    CrModel* aView;
    while( ( aView = (CrModel*)attachedViews.GetItemAndMove() ) != nil)
    {
        aView->DocRemoved();
    }
// Remove from list of plotdata objects:
    sm_ModelDocList.FindItem(this);
    sm_ModelDocList.RemoveItem();

}

bool CcModelDoc::ParseInput( CcTokenList * tokenList )
{
    bool retVal = true;
    bool hasTokenForMe = true;

    while ( hasTokenForMe )
    {
        switch ( tokenList->GetDescriptor(kModelClass) )
        {
            case kTModelShow:
            {
                tokenList->GetToken(); // Remove that token!
                DrawViews(true);
                break;
            }
            case kTModelAtom:
            {
                tokenList->GetToken(); // Remove that token!
                CcModelAtom* item = new CcModelAtom(this);
                        item->ParseInput(tokenList);
                mAtomList->AddItem(item);
                m_nAtoms++;
                item->id = m_nAtoms;
                break;
            }
            case kTModelBond:
            {
                tokenList->GetToken(); // Remove that token!
                CcModelBond* item = new CcModelBond(this);
                item->ParseInput(tokenList);
                mBondList->AddItem(item);
                break;
            }
//                        case kTModelCell:
//                        {
//                                tokenList->GetToken(); // Remove that token!
//                                CcModelCell* item = new CcModelCell();
//                                item->ParseInput(tokenList);
//                                mCellList->AddItem(item);
//                                break;
//                        }
//                        case kTModelTri:    //Triangles for those 3D fourier surfaces.
//                        {
//                                tokenList->GetToken(); // Remove that token!
//                                CcModelTri* item = new CcModelTri();
//                                item->ParseInput(tokenList);
//                                mTriList->AddItem(item);
//                                break;
//                        }
            case kTModelClear:
            {
                tokenList->GetToken(); // Remove that token!
                Clear();
                break;
            }
            default:
            {
                hasTokenForMe = false;
                break; // We leave the token in the list and exit the loop
            }
        }
    }

    return retVal;
}


void CcModelDoc::Clear()
{
    mAtomList->Reset();
    mBondList->Reset();
    mSphereList->Reset();
    mDonutList->Reset();
//        mCellList->Reset();
//        mTriList->Reset();


    CcModelObject* theItem ;
    while ( ( theItem = (CcModelObject *)mAtomList->GetItem() ) != nil )
    {
        mAtomList->RemoveItem();
        delete theItem;
    }
    while ( ( theItem = (CcModelObject *)mBondList->GetItem() ) != nil )
    {
        mBondList->RemoveItem();
        delete theItem;
    }
    while ( ( theItem = (CcModelObject *)mSphereList->GetItem() ) != nil )
    {
        mSphereList->RemoveItem();
        delete theItem;
    }
    while ( ( theItem = (CcModelObject *)mDonutList->GetItem() ) != nil )
    {
        mDonutList->RemoveItem();
        delete theItem;
    }
//      while ( ( theItem = (CcModelObject *)mCellList->GetItem() ) != nil )
//      {
//            mCellList->RemoveItem();
//            delete theItem;
//      }
//        while ( ( theItem = (CcModelObject *)mTriList->GetItem() ) != nil )
//        {
//                mTriList->RemoveItem();
//                delete theItem;
//        }

    m_nAtoms = 0;

      nSelected = 0;

      (CcController::theController)->status.SetNumSelectedAtoms( 0 );

//      DrawViews();

}

void CcModelDoc::AddModelView(CrModel * aView)
{
    attachedViews.AddItem(aView);
    aView->Update(true);
}

void CcModelDoc::AddModelView(CrModList * aView)
{
    attachedLists.AddItem(aView);
    aView->Update(0);
}

void CcModelDoc::DrawViews(bool rescaled)
{
    m_glIDsok = false;
    attachedViews.Reset();
    CrModel* aView;
    while( ( aView = (CrModel*)attachedViews.GetItemAndMove() ) != nil)
    {
        aView->Update(rescaled);
    }
    attachedLists.Reset();
    CrModList* lView;
    while( ( lView = (CrModList*)attachedLists.GetItemAndMove() ) != nil)
    {
        lView->Update(mAtomList->ListSize());
    }
}

void CcModelDoc::RemoveView(CrModel * aView)
{
    while ( attachedViews.FindItem( aView ) )
    {
        attachedViews.RemoveItem();
    }
}

void CcModelDoc::Select(bool selected)
{
    if (selected)
        nSelected++;
    else
        nSelected--;
//Update the status flag.
    (CcController::theController)->status.SetNumSelectedAtoms( nSelected );
}


void CcModelDoc::SelectAtomByLabel(CcString atomname, bool select)
{

   CcModelObject* item = FindAtomByLabel(atomname);
   if(item)
   {
      item->Select(select);
      DrawViews();
   }
}

void CcModelDoc::DisableAtomByLabel(CcString atomname, bool select)
{
    CcModelObject* item = FindAtomByLabel(atomname);

    if(item)
    {
      if ( item->Type() == CC_ATOM )
      {
        ((CcModelAtom*)item)->Disable(select);
      }
      else if ( item->Type() == CC_SPHERE )
      {
        ((CcModelSphere*)item)->Disable(select);
      }
      else if ( item->Type() == CC_DONUT )
      {
        ((CcModelDonut*)item)->Disable(select);
      }
      DrawViews();
    }
}


void CcModelDoc::DisableAllAtoms(bool select)
{
    mAtomList->Reset();
    mSphereList->Reset();
    mDonutList->Reset();
    CcModelObject* item;

    while ( item = (CcModelObject*)mAtomList->GetItemAndMove() )
    {
      item->Disable(select);
    }
    while ( item = (CcModelObject*)mSphereList->GetItemAndMove() )
    {
      item->Disable(select);
    }
    while ( item = (CcModelObject*)mDonutList->GetItemAndMove() )
    {
      item->Disable(select);
    }
    DrawViews();

}


CcModelObject* CcModelDoc::FindAtomByLabel(CcString atomname)
{
    CcString nAtomname = Compress(atomname);
    mAtomList->Reset();
    mSphereList->Reset();
    mDonutList->Reset();
    CcModelObject* item;
    while ( (item = (CcModelObject*)mAtomList->GetItemAndMove()) != nil )
    {
        if(item->Label() == nAtomname)
            return item;
    }
    while ( (item = (CcModelObject*)mSphereList->GetItemAndMove()) != nil )
    {
        if(item->Label() == nAtomname)
            return item;
    }
    while ( (item = (CcModelObject*)mDonutList->GetItemAndMove()) != nil )
    {
        if(item->Label() == nAtomname)
            return item;
    }
    return nil;
}

CcModelAtom* CcModelDoc::FindAtomByPosn(int posn)
{
    CcModelAtom* item = nil;
    mAtomList->Reset();
    item = (CcModelAtom*)mAtomList->GetItemAndMove();
    for (int i = 0; i < posn; i++ )
    {
       item = (CcModelAtom*)mAtomList->GetItemAndMove();
    }
    return item;
}



void CcModelDoc::SelectAllAtoms(bool select)
{
    mAtomList->Reset();
    mSphereList->Reset();
    mDonutList->Reset();
    CcModelObject* item;
    int i=0;

    while ( item = (CcModelObject*)mAtomList->GetItemAndMove() )
    {
      i++;
      item->Select(select);
    }
    while ( item = (CcModelObject*)mSphereList->GetItemAndMove() )
    {
      i++;
      item->Select(select);
    }
    while ( item = (CcModelObject*)mDonutList->GetItemAndMove() )
    {
      i++;
      item->Select(select);
    }
    DrawViews();

    if ( select )
    {
      nSelected = i;
    }
    else
    {
      nSelected = 0;
    }
    (CcController::theController)->status.SetNumSelectedAtoms( nSelected );

}

int CcModelDoc::NumSelected()
{
    return nSelected;
}

CcString CcModelDoc::Compress(CcString atomname)
{
    int leng = atomname.Length();
    int index = 0;
    int charstart = 1, charend = 1;
    int numbstart = 1, numbend = 1;
    int i;
//Find first non-space
    for ( i = 1 ; i <= leng; i++)
    {
        if (!(atomname.Sub(i,i) == " "))
        {
            charstart = i;
            i = leng + 1;
        }
    }

//Find next space or number.
    for ( i = charstart ; i <= leng; i++)
    {
        if (   (atomname.Sub(i,i) == " ")
            || (atomname.Sub(i,i) == "(")
            || (atoi(atomname.Sub(i,i).ToCString())!=0)
           )
        {
            charend = i - 1;
            i = leng + 1;
        }
    }

//Find first number.
    for ( i = charend + 1; i <= leng; i++)
    {
        if (atoi(atomname.Sub(i,i).ToCString())!=0)
        {
            numbstart = i;
            i = leng + 1;
        }
    }

//Find next non-number.
    numbend = leng;
    for ( i = numbstart + 1; i <= leng; i++)
    {
        if (    (atoi(atomname.Sub(i,i).ToCString())==0)
             && !(atomname.Sub(i,i) == "0")
           )
        {
            numbend = i - 1;
            i = leng + 1;
        }
    }

    if ( numbend < numbstart ) numbend = numbstart;

//Build string in CRYSTALS format.
    CcString result;
    result = atomname.Sub(charstart,charend);
    result += "(";
    result += atomname.Sub(numbstart,numbend);
    result += ")";

    return result;
}

void CcModelDoc::InvertSelection()
{
    mAtomList->Reset();
    mSphereList->Reset();
    mDonutList->Reset();
    CcModelObject* item;
    int i=0;

    while ( item = (CcModelObject*)mAtomList->GetItemAndMove() )
        if ( item->Select() ) i++;
    while ( item = (CcModelObject*)mSphereList->GetItemAndMove() )
        if ( item->Select() ) i++;
    while ( item = (CcModelObject*)mDonutList->GetItemAndMove() )
        if ( item->Select() ) i++;

    (CcController::theController)->status.SetNumSelectedAtoms( i );

    DrawViews();
}

void CcModelDoc::DocToList( CrModList* ml )
{
   if ( mAtomList->ListSize()  )
   {
      CcModelAtom* aitem;
      CcString row[12];
      mAtomList->Reset();
      while ( (aitem = (CcModelAtom*)mAtomList->GetItemAndMove()) )
      {
          row[0] =  CcString(aitem->id);
          row[1] =  aitem->m_elem;
          row[2] =  CcString(aitem->m_serial);
          row[3] =  CcString(aitem->frac_x);
          row[4] =  CcString(aitem->frac_y);
          row[5] =  CcString(aitem->frac_z);
          row[6] =  CcString((float)aitem->occ/1000.0f);
          row[7] =  aitem->m_IsADP ? CcString("Aniso"):CcString("Iso");
          row[8] =  CcString(aitem->m_ueq);
          row[9] =  CcString(aitem->m_refflag);
          row[10] =  CcString(aitem->m_part);
          row[11] =  CcString(aitem->m_spare);

          ml -> AddRow(aitem->id,    &*row,
                       aitem->IsSelected(),
                       aitem->m_disabled || aitem->m_excluded);
      }
   }
}

bool CcModelDoc::RenderModel( CcModelStyle * style, bool feedback )
{

//   if ( m_glIDsok ) { LOGERR ( "Rendering: glIDs OK" ); }
//   else { LOGERR ( "Rendering: glIDs need reset" ); }

   if ( mAtomList->ListSize()   || mBondList->ListSize() ||
        mSphereList->ListSize() || mDonutList->ListSize()  )
   {
      CcModelAtom* aitem;
      CcModelBond* bitem;
      CcModelSphere* sitem;
      CcModelDonut* ditem;
      GLuint glIDCount = 0;

      int nRes = (int) ( 1250.0 / mAtomList->ListSize() );
      nRes = min ( 15, nRes );
      nRes = max ( 4,  nRes );
      int qRes = (int) ( 500.0 / mAtomList->ListSize() );
      qRes = min ( 5, qRes );
      qRes = max ( 3,  qRes );

      style->normal_res = nRes;
      style->quick_res  = qRes;

      if ( style->high_res )
      {
//High res normal atoms:
        mAtomList->Reset();
        mSphereList->Reset();
        mDonutList->Reset();
        if ( !feedback )
        {
           glDeleteLists(ATOMLIST,1);
           glNewList( ATOMLIST, GL_COMPILE);
        }
        {
          GLfloat Specula[] = { 0.0f,0.0f,0.0f,1.0f };
          glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
        }
        while ( (aitem = (CcModelAtom*)mAtomList->GetItemAndMove()) )
        {
//not excluded, not selected, not disabled:
          if ( !(aitem->m_excluded) && !(aitem->IsSelected()) && !(aitem->m_disabled) )
          {
            if ( !m_glIDsok )
            {
              aitem->m_glID = ++ glIDCount;
            }
            glLoadName ( aitem->m_glID );
            aitem->Render(style, feedback);
          }
        }
        while ( (sitem = (CcModelSphere*)mSphereList->GetItemAndMove()) )
        {
//not excluded, not selected, not disabled:
          if ( !(sitem->m_excluded) && !(sitem->IsSelected()) && !(sitem->m_disabled) )
          {
            if ( !m_glIDsok )
            {
              sitem->m_glID = ++ glIDCount;
            }
            glLoadName ( sitem->m_glID );
            sitem->Render(style, feedback);
          }
        }
        while ( (ditem = (CcModelDonut*)mDonutList->GetItemAndMove()) )
        {
//not excluded, not selected, not disabled:
          if ( !(ditem->m_excluded) && !(ditem->IsSelected()) && !(ditem->m_disabled) )
          {
            if ( !m_glIDsok )
            {
              ditem->m_glID = ++ glIDCount;
            }
            glLoadName ( ditem->m_glID );
            ditem->Render(style, feedback);
          }
        }


        mAtomList->Reset();
        mSphereList->Reset();
        mDonutList->Reset();
        {
          GLfloat Diffuse[] = { 0.6f,0.6f,0.6f,1.0f };
          GLfloat Specula[] = { 0.9f,0.9f,0.9f,1.0f };
          glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
          glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
        }
        while ( (aitem = (CcModelAtom*)mAtomList->GetItemAndMove()) )
        {
//not excluded, selected:
          if ( !(aitem->m_excluded) && (aitem->IsSelected()) )
          {
            if ( !m_glIDsok )
            {
              aitem->m_glID = ++ glIDCount;
            }
            glLoadName ( aitem->m_glID );
            aitem->Render(style, feedback);
          }
        }
        while ( (sitem = (CcModelSphere*)mSphereList->GetItemAndMove()) )
        {
//not excluded, selected:
          if ( !(sitem->m_excluded) && (sitem->IsSelected()) )
          {
            if ( !m_glIDsok )
            {
              sitem->m_glID = ++ glIDCount;
            }
            glLoadName ( sitem->m_glID );
            sitem->Render(style);
          }
        }
        while ( (ditem = (CcModelDonut*)mDonutList->GetItemAndMove()) )
        {
//not excluded, selected:
          if ( !(ditem->m_excluded) && (ditem->IsSelected()) )
          {
            if ( !m_glIDsok )
            {
              ditem->m_glID = ++ glIDCount;
            }
            glLoadName ( ditem->m_glID );
            ditem->Render(style);
          }
        }


        mAtomList->Reset();
        mSphereList->Reset();
        mDonutList->Reset();
        {
          GLfloat Surface[] = { 0.0f,0.0f,0.0f,1.0f };
          GLfloat Specula[] = { 0.0f,0.0f,0.0f,1.0f };
          glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
          glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
        }
        while ( (aitem = (CcModelAtom*)mAtomList->GetItemAndMove()) )
        {
//not excluded, not selected, disabled
          if ( !(aitem->m_excluded) && !(aitem->IsSelected()) && (aitem->m_disabled) )
          {
            if ( !m_glIDsok )
            {
              aitem->m_glID = ++ glIDCount;
            }
            glLoadName ( aitem->m_glID );
            aitem->Render(style);
          }
        }
        while ( (sitem = (CcModelSphere*)mSphereList->GetItemAndMove()) )
        {
//not excluded, not selected, disabled
          if ( !(sitem->m_excluded) && !(sitem->IsSelected()) && (sitem->m_disabled) )
          {
            if ( !m_glIDsok )
            {
              sitem->m_glID = ++ glIDCount;
            }
            glLoadName ( sitem->m_glID );
            sitem->Render(style);
          }
        }
        while ( (ditem = (CcModelDonut*)mDonutList->GetItemAndMove()) )
        {
//not excluded, not selected, disabled
          if ( !(ditem->m_excluded) && !(ditem->IsSelected()) && (ditem->m_disabled) )
          {
            if ( !m_glIDsok )
            {
              ditem->m_glID = ++ glIDCount;
            }
            glLoadName ( ditem->m_glID );
            ditem->Render(style);
          }
        }
        if ( !feedback )
        {
           glEndList();
//High res normal bonds:
           glDeleteLists(BONDLIST,1);
           glNewList( BONDLIST, GL_COMPILE);
        }
        {
          GLfloat Diffuse[] = { 0.2f,0.2f,0.2f,1.0f };
          GLfloat Specula[] = { 0.8f,0.8f,0.8f,1.0f };
          GLfloat Shinine[] = {89.6f};
          glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
          glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
          glMaterialfv(GL_FRONT, GL_SHININESS,Shinine);
        }
        mBondList->Reset();
        while ( (bitem = (CcModelBond*)mBondList->GetItemAndMove()) )
        {
          if ( !(bitem->m_excluded) )
          {
            if ( !m_glIDsok )
            {
              bitem->m_glID = ++ glIDCount;
            }
            glLoadName ( bitem->m_glID );
            bitem->Render(style);
          }
        }
        if ( !feedback )
        {
           glEndList();

//High res excluded atoms and bonds:
           glDeleteLists(XOBJECTLIST,1);
           glNewList( XOBJECTLIST, GL_COMPILE);
        }
        mAtomList->Reset();
        while ( (aitem = (CcModelAtom*)mAtomList->GetItemAndMove()) )
        {
          if ( aitem->m_excluded )
          {
            glPolygonMode(GL_FRONT, GL_POINT);
            glPolygonMode(GL_BACK, GL_POINT);
            aitem->m_glID = 0;
            aitem->Render(style);
          }
        }
        mBondList->Reset();
        while ( (bitem = (CcModelBond*)mBondList->GetItemAndMove()) )
        {
          if ( bitem->m_excluded )
          {
            glPolygonMode(GL_FRONT, GL_POINT);
            glPolygonMode(GL_BACK, GL_POINT);
            bitem->m_glID = 0;
            bitem->Render(style);
          }
        }
        if ( !feedback )
        {
           glEndList();
        }
      }
      else
      {
//Low res (non-excluded) atoms
        if ( !feedback )
        {
           glDeleteLists(QATOMLIST,1);
           glNewList( QATOMLIST, GL_COMPILE);
        }
        mAtomList->Reset();
        mSphereList->Reset();
        mDonutList->Reset();
        {
          GLfloat Specula[] = { 0.0f,0.0f,0.0f,1.0f };
          glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
        }
        while ( (aitem = (CcModelAtom*)mAtomList->GetItemAndMove()) )
        {
//not excluded, not selected, not disabled:
          if ( !(aitem->m_excluded) && !(aitem->IsSelected()) && !(aitem->m_disabled) )
          {
            if ( !m_glIDsok )
            {
              aitem->m_glID = ++ glIDCount;
            }
            glLoadName ( aitem->m_glID );
            aitem->Render(style);
          }
        }
        while ( (sitem = (CcModelSphere*)mSphereList->GetItemAndMove()) )
        {
//not excluded, not selected, not disabled:
          if ( !(sitem->m_excluded) && !(sitem->IsSelected()) && !(sitem->m_disabled) )
          {
            if ( !m_glIDsok )
            {
              sitem->m_glID = ++ glIDCount;
            }
            glLoadName ( sitem->m_glID );
            sitem->Render(style);
          }
        }
        while ( (ditem = (CcModelDonut*)mDonutList->GetItemAndMove()) )
        {
//not excluded, not selected, not disabled:
          if ( !(ditem->m_excluded) && !(ditem->IsSelected()) && !(ditem->m_disabled) )
          {
            if ( !m_glIDsok )
            {
              ditem->m_glID = ++ glIDCount;
            }
            glLoadName ( ditem->m_glID );
            ditem->Render(style);
          }
        }
        mAtomList->Reset();
        mSphereList->Reset();
        mDonutList->Reset();
        {
          GLfloat Diffuse[] = { 0.6f,0.6f,0.6f,1.0f };
          GLfloat Specula[] = { 0.9f,0.9f,0.9f,1.0f };
          glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
          glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
        }
        while ( (aitem = (CcModelAtom*)mAtomList->GetItemAndMove()) )
        {
//not excluded, selected:
          if ( !(aitem->m_excluded) && (aitem->IsSelected()) )
          {
            if ( !m_glIDsok )
            {
              aitem->m_glID = ++ glIDCount;
            }
            glLoadName ( aitem->m_glID );
            aitem->Render(style);
          }
        }
        while ( (sitem = (CcModelSphere*)mSphereList->GetItemAndMove()) )
        {
//not excluded, selected:
          if ( !(sitem->m_excluded) && (sitem->IsSelected()) )
          {
            if ( !m_glIDsok )
            {
              sitem->m_glID = ++ glIDCount;
            }
            glLoadName ( sitem->m_glID );
            sitem->Render(style);
          }
        }
        while ( (ditem = (CcModelDonut*)mDonutList->GetItemAndMove()) )
        {
//not excluded, selected:
          if ( !(ditem->m_excluded) && (ditem->IsSelected()) )
          {
            if ( !m_glIDsok )
            {
              ditem->m_glID = ++ glIDCount;
            }
            glLoadName ( ditem->m_glID );
            ditem->Render(style);
          }
        }
        mAtomList->Reset();
        mSphereList->Reset();
        mDonutList->Reset();
        {
          GLfloat Surface[] = { 0.0f,0.0f,0.0f,1.0f };
          GLfloat Specula[] = { 0.0f,0.0f,0.0f,1.0f };
          glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
          glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
        }
        while ( (aitem = (CcModelAtom*)mAtomList->GetItemAndMove()) )
        {
//not excluded, not selected, disabled
          if ( !(aitem->m_excluded) && !(aitem->IsSelected()) && (aitem->m_disabled) )
          {
            if ( !m_glIDsok )
            {
              aitem->m_glID = ++ glIDCount;
            }
            glLoadName ( aitem->m_glID );
            aitem->Render(style);
          }
        }
        while ( (sitem = (CcModelSphere*)mSphereList->GetItemAndMove()) )
        {
//not excluded, not selected, disabled
          if ( !(sitem->m_excluded) && !(sitem->IsSelected()) && (sitem->m_disabled) )
          {
            if ( !m_glIDsok )
            {
              sitem->m_glID = ++ glIDCount;
            }
            glLoadName ( sitem->m_glID );
            sitem->Render(style);
          }
        }
        while ( (ditem = (CcModelDonut*)mDonutList->GetItemAndMove()) )
        {
//not excluded, not selected, disabled
          if ( !(ditem->m_excluded) && !(ditem->IsSelected()) && (ditem->m_disabled) )
          {
            if ( !m_glIDsok )
            {
              ditem->m_glID = ++ glIDCount;
            }
            glLoadName ( ditem->m_glID );
            ditem->Render(style);
          }
        }
        if ( !feedback )
        {
           glEndList();
//Low res (non-excluded) bonds
           glDeleteLists(QBONDLIST,1);
           glNewList( QBONDLIST, GL_COMPILE);
        }
        {
          GLfloat Diffuse[] = { 0.2f,0.2f,0.2f,1.0f };
          GLfloat Specula[] = { 0.8f,0.8f,0.8f,1.0f };
          GLfloat Shinine[] = {89.6f};
          glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
          glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
          glMaterialfv(GL_FRONT, GL_SHININESS,Shinine);
        }
        mBondList->Reset();
        while ( (bitem = (CcModelBond*)mBondList->GetItemAndMove()) )
        {
          if ( !(bitem->m_excluded) )
          {
            if ( !m_glIDsok )
            {
              bitem->m_glID = ++ glIDCount;
            }
            glLoadName ( bitem->m_glID );
            bitem->Render(style);
          }
        }
        if ( !feedback )
        {
           glEndList();
        }
      }

      m_glIDsok = true;
      return true;
   }
   return false;
}

void CcModelDoc::ExcludeBonds()
{
  if ( mBondList->ListSize() )
  {
    mBondList->Reset();
    CcModelBond* bitem;

    while ( (bitem = (CcModelBond*)mBondList->GetItemAndMove()) )
    {
      bitem->SelfExclude();
    }
   }
}


void CcModelDoc::FlagFrag(CcString atomname)
{
   CcModelAtom *aitem;
   CcModelBond *bitem;
   CcModelSphere *sitem;
   CcModelDonut *ditem;
   CcModelObject *oitem;

// Set spare to false for all atoms

   if ( mAtomList->ListSize() )
   {
      mAtomList->Reset();
      while ((aitem = (CcModelAtom*)mAtomList->GetItemAndMove()))
      {
        aitem->spare = false;
      }
   }
   if ( mSphereList->ListSize() )
   {
      mSphereList->Reset();
      while ((sitem = (CcModelSphere*)mSphereList->GetItemAndMove()))
      {
        sitem->spare = false;
      }
   }
   if ( mDonutList->ListSize() )
   {
      mDonutList->Reset();
      while ((ditem = (CcModelDonut*)mDonutList->GetItemAndMove()))
      {
        ditem->spare = false;
      }
   }

// Set spare to true for the passed in atom.

   int nChanged=0;

   if ( oitem = FindAtomByLabel(atomname) )
   {
     if ( oitem->Type() == CC_ATOM )
     {
       ((CcModelAtom*)oitem)->spare = true;
       nChanged = 1;
     }
     else if ( oitem->Type() == CC_SPHERE )
     {
       ((CcModelSphere*)oitem)->spare = true;
       nChanged = 1;
     }
     else if ( oitem->Type() == CC_DONUT )
     {
       ((CcModelDonut*)oitem)->spare = true;
       nChanged = 1;
     }
   }

// Loop setting spare to true for any atoms bonded to other atoms
// that also have spare true, until no more changes.

   while ( nChanged )
   {
     nChanged = 0;

     if ( mBondList->ListSize() )
     {
       mBondList->Reset();
       while ((bitem = (CcModelBond*)mBondList->GetItemAndMove()) )
       {
         if (( bitem->m_atom1 ) && ( bitem->m_atom2 ))
         {
           if (( bitem->m_atom1->spare ) && ( ! bitem->m_atom2->spare ))
           {
              bitem->m_atom2->spare = true;
              nChanged++;
           }
           else if (( bitem->m_atom2->spare ) && ( ! bitem->m_atom1->spare ))
           {
              bitem->m_atom1->spare = true;
              nChanged++;
           }
         }
       }
     }
   }
}


void CcModelDoc::SelectFrag(CcString atomname, bool select)
{
   CcModelObject *item;

   FlagFrag ( atomname );

// Select or unselect all spare-flagged atoms.

   mAtomList->Reset();
   while (item = (CcModelObject*)mAtomList->GetItemAndMove())
      if ( item->spare ) item->Select(select);

   mSphereList->Reset();
   while (item = (CcModelObject*)mSphereList->GetItemAndMove())
      if ( item->spare ) item->Select(select);

   mDonutList->Reset();
   while (item = (CcModelObject*)mDonutList->GetItemAndMove())
      if ( item->spare ) item->Select(select);

   DrawViews();
}


CcString CcModelDoc::FragAsString( CcString atomname, CcString delimiter )
{
  CcString result;
  CcModelObject * item;

  FlagFrag ( atomname );


  mAtomList->Reset();
  while (item = (CcModelObject*)mAtomList->GetItemAndMove())
        if ( item->spare ) result += item->Label() + delimiter;

  mSphereList->Reset();
  while (item = (CcModelObject*)mSphereList->GetItemAndMove())
        if ( item->spare ) result += item->Label() + delimiter;

  mDonutList->Reset();
  while (item = (CcModelObject*)mDonutList->GetItemAndMove())
        if ( item->spare ) result += item->Label() + delimiter;

  return result;
}



CcString CcModelDoc::SelectedAsString( CcString delimiter )
{
  CcString result;
  CcModelObject * item;

  mAtomList->Reset();
  mSphereList->Reset();
  mDonutList->Reset();

  while ( item = (CcModelObject*)mAtomList->GetItemAndMove() ) 
     if( item->IsSelected() ) result += item->Label() + delimiter;

  while ( item = (CcModelObject*)mDonutList->GetItemAndMove() ) 
     if( item->IsSelected() ) result += item->Label() + delimiter;

  while ( item = (CcModelObject*)mSphereList->GetItemAndMove() ) 
     if( item->IsSelected() ) result += item->Label() + delimiter;

  return result;

}



void CcModelDoc::SendAtoms( int style, bool sendonly )
{

   CcModelObject* item;

   mAtomList->Reset();
   while ( item = (CcModelObject*)mAtomList->GetItemAndMove() )
        if ( item->IsSelected() ) item->SendAtom (style, sendonly);

   mSphereList->Reset();
   while ( item = (CcModelObject*)mSphereList->GetItemAndMove() )
        if ( item->IsSelected() ) item->SendAtom (style, sendonly);

   mDonutList->Reset();
   while ( item = (CcModelObject*)mDonutList->GetItemAndMove() )
        if ( item->IsSelected() ) item->SendAtom (style, sendonly);
}

void CcModelDoc::ZoomAtoms( bool doZoom )
{
  if ( mAtomList->ListSize() )
  {
     mAtomList->Reset();
     CcModelAtom* aitem;
     while ( (aitem = (CcModelAtom*)mAtomList->GetItemAndMove()) )
     {
        if ( aitem->IsSelected() )
        {
          aitem->m_excluded = false;
        }
        else
        {
          aitem->m_excluded = doZoom;
        }
     }
  }
  if ( mSphereList->ListSize() )
  {
     mSphereList->Reset();
     CcModelSphere* sitem;
     while ( (sitem = (CcModelSphere*)mSphereList->GetItemAndMove()) )
     {
        if ( sitem->IsSelected() )
        {
          sitem->m_excluded = false;
        }
        else
        {
          sitem->m_excluded = doZoom;
        }
     }
  }
  if ( mDonutList->ListSize() )
  {
     mDonutList->Reset();
     CcModelDonut* ditem;
     while ( (ditem = (CcModelDonut*)mDonutList->GetItemAndMove()) )
     {
        if ( ditem->IsSelected() )
        {
          ditem->m_excluded = false;
        }
        else
        {
          ditem->m_excluded = doZoom;
        }
     }
  }
  if ( mBondList->ListSize() )
  {
     mBondList->Reset();
     CcModelBond* bitem; 
     while ( (bitem = (CcModelBond*)mBondList->GetItemAndMove()) )
     {
       bitem->SelfExclude();
     }
  }
}

CcModelObject * CcModelDoc::FindObjectByGLName(GLuint name)
{
  CcModelObject* aitem;
  if ( mAtomList->ListSize() )
  {
     mAtomList->Reset();
     while ( (aitem = (CcModelObject*)mAtomList->GetItemAndMove()) )
     {
        if ( aitem->m_glID == name )  return aitem;
     }
  }
  if ( mBondList->ListSize() )
  {
     mBondList->Reset();
     while ( (aitem = (CcModelObject*)mBondList->GetItemAndMove()) )
     {
        if ( aitem->m_glID == name )  return aitem;
     }
  }
  if ( mSphereList->ListSize() )
  {
     mSphereList->Reset();
     while ( (aitem = (CcModelObject*)mSphereList->GetItemAndMove()) )
     {
        if ( aitem->m_glID == name )  return aitem;
     }
  }
  if ( mDonutList->ListSize() )
  {
     mDonutList->Reset();
     while ( (aitem = (CcModelObject*)mDonutList->GetItemAndMove()) )
     {
        if ( aitem->m_glID == name )  return aitem;
     }
  }
  return nil;
}



void CcModelDoc::FastBond(int x1,int y1,int z1, int x2, int y2, int z2,
                          int r, int g, int b,  int rad,int btype,
                          int np, int * ptrs, CcString label, CcString cslabl)
{
    CcModelBond* item = new CcModelBond(x1,y1,z1,x2,y2,z2,
                          r, g, b,  rad, btype,
                          np, ptrs, label, cslabl, this);
    mBondList->AddItem(item);
}

void CcModelDoc::FastAtom(CcString label,int x1,int y1,int z1, 
                          int r, int g, int b, int occ,float cov, int vdw,
                          int spare, int flag,
                          float u1,float u2,float u3,float u4,float u5,
                          float u6,float u7,float u8,float u9,
                          float frac_x, float frac_y, float frac_z,
                          CcString elem, int serial, int refflag,
                          int part, float ueq, float fspare)

{
    CcModelAtom* item = new CcModelAtom(label,x1,y1,z1, 
                          r,g,b,occ,cov,vdw,spare,flag,
                          u1,u2,u3,u4,u5,u6,u7,u8,u9,frac_x,
                          frac_y,frac_z,elem,serial,refflag,
                          part,ueq,fspare,this);
    mAtomList->AddItem(item);
    m_nAtoms++;
    item->id = m_nAtoms;
}

void CcModelDoc::FastSphere(CcString label,int x1,int y1,int z1, 
                          int r, int g, int b, int occ,int cov, int vdw,
                          int spare, int flag, int iso, int irad)
{
    CcModelSphere* item = new CcModelSphere(label,x1,y1,z1, 
                          r,g,b,occ,cov,vdw,spare,flag,
                          iso,irad,this);
    mSphereList->AddItem(item);
}

void CcModelDoc::FastDonut(CcString label,int x1,int y1,int z1,
                          int r, int g, int b, int occ,int cov, int vdw,
                          int spare, int flag, int iso, int irad, int idec, int iaz)
{
    CcModelDonut* item = new CcModelDonut(label,x1,y1,z1, 
                          r,g,b,occ,cov,vdw,spare,flag,
                          iso,irad,idec,iaz,this);
    mDonutList->AddItem(item);
}



extern "C" {

//declarations:

#ifdef __CR_WIN__
void fastbond  (int x1,int y1,int z1, int x2, int y2, int z2,
                int r, int g, int b,  int rad,int btype,
                int np, int * ptrs, char label[80], char slabel[80] );
#endif
#ifdef __BOTHWX__
void fastbond_ (int x1,int y1,int z1, int x2, int y2, int z2,
                int r, int g, int b,  int rad,int btype,
                int np, int * ptrs, char label[80], char slabel[80] );
#endif
#ifdef __CR_WIN__
void fastatom  (char* elem,int serial,char* label,int x1,int y1,int z1, 
                int r, int g, int b, int occ,float cov, int vdw,
                int spare, int flag, float u1,float u2,float u3,float u4,float u5,
                float u6,float u7,float u8,float u9, float fx, float fy, float fz,
                int refflag, int part, float ueq, float fspare);
#endif
#ifdef __BOTHWX__
void fastatom_  (char* elem,int serial,char* label,int x1,int y1,int z1, 
                int r, int g, int b, int occ,float cov, int vdw,
                int spare, int flag, float u1,float u2,float u3,float u4,float u5,
                float u6,float u7,float u8,float u9, float fx, float fy, float fz,
                int refflag, int part, float ueq, float fspare);
#endif
#ifdef __CR_WIN__
void fastsphere  (char* label,int x1,int y1,int z1, 
                int r, int g, int b, int occ,int cov, int vdw,
                int spare, int flag, int iso, int irad);
#endif
#ifdef __BOTHWX__
void fastsphere_  (char* label,int x1,int y1,int z1, 
                int r, int g, int b, int occ,int cov, int vdw,
                int spare, int flag, int iso, int irad);
#endif
#ifdef __CR_WIN__
void fastdonut  (char* label,int x1,int y1,int z1, 
                int r, int g, int b, int occ,int cov, int vdw,
                int spare, int flag, int iso, int irad, int idec, int iaz);
#endif
#ifdef __BOTHWX__
void fastdonut_  (char* label,int x1,int y1,int z1, 
                int r, int g, int b, int occ,int cov, int vdw,
                int spare, int flag, int iso, int irad, int idec, int iaz);
#endif

//implementations:

#ifdef __CR_WIN__
void fastbond  (int x1,int y1,int z1, int x2, int y2, int z2,
                int r, int g, int b,  int rad,int btype,
                int np, int * ptrs,
                char label[80], char slabel[80] )
#endif
#ifdef __BOTHWX__
void fastbond_ (int x1,int y1,int z1, int x2, int y2, int z2,
                int r, int g, int b,  int rad,int btype,
                int np, int * ptrs,
                char label[80], char slabel[80] )
#endif
{
      CcString clabel = label;
      LOGSTAT ( "-----------Fastbond added:" + clabel );
      if ( CcModelDoc::sm_CurrentModelDoc )
            CcModelDoc::sm_CurrentModelDoc->FastBond(x1,y1,z1,x2,y2,z2,r,g,b,rad,btype,
                                         np,ptrs,clabel,slabel);
}

#ifdef __CR_WIN__
void fastatom  (char* elem,int serial,char* label,int x1,int y1,int z1, 
                int r, int g, int b, int occ,float cov, int vdw,
                int spare, int flag, float u1,float u2,float u3,float u4,float u5,
                float u6,float u7,float u8,float u9, float fx, float fy, float fz,
                int refflag, int part, float ueq, float fspare)
#endif
#ifdef __BOTHWX__
void fastatom_  (char* elem,int serial,char* label,int x1,int y1,int z1, 
                int r, int g, int b, int occ,float cov, int vdw,
                int spare, int flag, float u1,float u2,float u3,float u4,float u5,
                float u6,float u7,float u8,float u9, float fx, float fy, float fz,
                int refflag, int part, float ueq, float fspare)
#endif
{
      CcString clabel = label;
      CcString celem  = elem;
      LOGSTAT ( "-----------Fastatom added:" + clabel );
      if ( CcModelDoc::sm_CurrentModelDoc )
            CcModelDoc::sm_CurrentModelDoc->FastAtom(clabel,x1,y1,z1, 
                          r,g,b,occ,cov,vdw,spare,flag,
                          u1,u2,u3,u4,u5,u6,u7,u8,u9,fx,fy,fz,
                          celem,serial,refflag,part,ueq, fspare) ;

}

#ifdef __CR_WIN__
void fastsphere  (char* label,int x1,int y1,int z1, 
                int r, int g, int b, int occ,int cov, int vdw,
                int spare, int flag, int iso, int irad)
#endif
#ifdef __BOTHWX__
void fastsphere_  (char* label,int x1,int y1,int z1, 
                int r, int g, int b, int occ,int cov, int vdw,
                int spare, int flag, int iso, int irad)
#endif
{
      CcString clabel = label;
      LOGSTAT ( "-----------Fastsphere added:" + clabel );
      if ( CcModelDoc::sm_CurrentModelDoc )
            CcModelDoc::sm_CurrentModelDoc->FastSphere(clabel,x1,y1,z1, 
                          r,g,b,occ,cov,vdw,spare,flag,iso,irad) ;

}

#ifdef __CR_WIN__
void fastdonut  (char* label,int x1,int y1,int z1, 
                int r, int g, int b, int occ,int cov, int vdw,
                int spare, int flag, int iso, int irad, int idec, int iaz)
#endif
#ifdef __BOTHWX__
void fastdonut_  (char* label,int x1,int y1,int z1, 
                int r, int g, int b, int occ,int cov, int vdw,
                int spare, int flag, int iso, int irad, int idec, int iaz)
#endif
{
      CcString clabel = label;
      LOGSTAT ( "-----------Fastdonut added:" + clabel );
      if ( CcModelDoc::sm_CurrentModelDoc )
            CcModelDoc::sm_CurrentModelDoc->FastDonut(clabel,x1,y1,z1, 
                          r,g,b,occ,cov,vdw,spare,flag,iso,irad,idec,iaz) ;

}

}
