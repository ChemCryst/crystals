////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcModelDoc

////////////////////////////////////////////////////////////////////////

//   Filename:  CcModelDoc.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 11:25 Uhr

//BIG NOTICE: ModelDoc is not a CrGUIElement, it's more like a list
//            of drawing commands.
//            You can attach a CrModel to it and it will then draw
//            itself on that CrModel's drawing area.
//            It does contain a ParseInput routine for parsing the
//            drawing commands. Note again - it is not a CrGUIElement,
//            it has no graphical presence, nor a complimentary Cx- class

// $Log: not supported by cvs2svn $
// Revision 1.3  1999/04/26 11:12:39  dosuser
// RIC: Added a bit of code to call Reset() on all views attached to
//      the modeldoc in order that they don't keep pointers to atoms
//      in the modeldoc once it is updated by CRYSTALS.
//



#include	"crystalsinterface.h"
#include	"crconstants.h"
#include	"ccmodeldoc.h"
#include	"ccmodelobject.h"
//insert your own code here.
#include	"crmodel.h"
//#include	"ccrect.h"
#include	"cccoord.h"
#include	"cccontroller.h"	// for sending commands

CcModelDoc::CcModelDoc( )
{
	mAtomList = new CcList();
	mBondList = new CcList();
	mCellList = new CcList();
	mTriList = new CcList();
	m_nAtoms = 0;
	m_TotX = 0;
	m_TotY = 0;
	m_TotZ = 0;
	nSelected = 0;
	centred = false;
}

CcModelDoc::~CcModelDoc()
{
	mAtomList->Reset();
	mBondList->Reset();
	mCellList->Reset();
	mTriList->Reset();
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
	while ( ( theItem = (CcModelObject *)mCellList->GetItem() ) != nil )
	{
		mCellList->RemoveItem();
		delete theItem;
	}
	while ( ( theItem = (CcModelObject *)mTriList->GetItem() ) != nil )
	{
		mTriList->RemoveItem();
		delete theItem;
	}

	delete mAtomList;
	delete mBondList;
	delete mCellList;
	delete mTriList;

	attachedViews.Reset();
	CrModel* aView;
	while( ( aView = (CrModel*)attachedViews.GetItemAndMove() ) != nil)
	{
		aView->DocRemoved();
	}

}

Boolean	CcModelDoc::ParseInput( CcTokenList * tokenList )
{
	Boolean retVal = true;
	Boolean hasTokenForMe = true;
	
	while ( hasTokenForMe )
	{
		CcCoord cotemp(0,0,0);
		switch ( tokenList->GetDescriptor(kModelClass) )
		{
			case kTModelShow:
			{
				tokenList->GetToken(); // Remove that token!
				DrawViews();
				break;
			}
			case kTModelAtom:
			{
				tokenList->GetToken(); // Remove that token!
				CcModelAtom* item = new CcModelAtom(this);
				cotemp = item->ParseInput(tokenList);
				mAtomList->AddItem(item);
				m_nAtoms++;
				m_TotX += cotemp.X();
				m_TotY += cotemp.Y();
				m_TotZ += cotemp.Z();
				centred = false;
				break;
			}
			case kTModelBond:
			{
				tokenList->GetToken(); // Remove that token!
				CcModelBond* item = new CcModelBond();
				item->ParseInput(tokenList);
				mBondList->AddItem(item);
				centred = false;
				break;
			}
			case kTModelCell:
			{
				tokenList->GetToken(); // Remove that token!
				CcModelCell* item = new CcModelCell();
				item->ParseInput(tokenList);
				mCellList->AddItem(item);
				centred = false;
				break;
			}
			case kTModelTri:    //Triangles for those 3D fourier surfaces.
			{
				tokenList->GetToken(); // Remove that token!
				CcModelTri* item = new CcModelTri();
				item->ParseInput(tokenList);
				mTriList->AddItem(item);
				break;

			}
			case kTModelClear:
			{
				tokenList->GetToken(); // Remove that token!
				Clear();
				centred = false;
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

void CcModelDoc::DrawView(CrModel* aView)
{
	mAtomList->Reset();
	mBondList->Reset();
	mCellList->Reset();
	mTriList->Reset();
	CcModelObject* item;
	aView->Start();
	while ( (item = (CcModelObject*)mAtomList->GetItemAndMove()) != nil )
		item->Draw(aView);
	while ( (item = (CcModelObject*)mBondList->GetItemAndMove()) != nil )
		item->Draw(aView);
	while ( (item = (CcModelObject*)mCellList->GetItemAndMove()) != nil )
		item->Draw(aView);
	while ( (item = (CcModelObject*)mTriList->GetItemAndMove()) != nil )
		item->Draw(aView);
	aView->Display();

}

void CcModelDoc::Clear()
{
	mAtomList->Reset();
	mBondList->Reset();
	mCellList->Reset();
	mTriList->Reset();

	
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
	while ( ( theItem = (CcModelObject *)mCellList->GetItem() ) != nil )
	{
		mCellList->RemoveItem();
		delete theItem;
	}
	while ( ( theItem = (CcModelObject *)mTriList->GetItem() ) != nil )
	{
		mTriList->RemoveItem();
		delete theItem;
	}

	m_nAtoms = 0;
	m_TotX = 0;
	m_TotY = 0;
	m_TotZ = 0;

	attachedViews.Reset();
	CrModel* aView;
	while( ( aView = (CrModel*)attachedViews.GetItemAndMove() ) != nil)
	{
            aView->Reset();
	}


}

void CcModelDoc::AddModelView(CrModel * aView)
{
	attachedViews.AddItem(aView);
	Centre();
	DrawView(aView);
}

void CcModelDoc::DrawViews()
{
	Centre();
	attachedViews.Reset();
	CrModel* aView;
	while( ( aView = (CrModel*)attachedViews.GetItemAndMove() ) != nil)
	{
		DrawView(aView);
	}
}

void CcModelDoc::RemoveView(CrModel * aView)
{
	while ( attachedViews.FindItem( aView ) )
	{
		attachedViews.RemoveItem();
	}
}

void CcModelDoc::Centre()
{
	if(!centred)
	{
		CcModelObject* item;
		if(m_nAtoms > 0)
		{
			int x = (int)( (float)m_TotX / (float)m_nAtoms );
			int y = (int)( (float)m_TotY / (float)m_nAtoms );
			int z = (int)( (float)m_TotZ / (float)m_nAtoms );
			while ( (item = (CcModelObject*)mAtomList->GetItemAndMove()) != nil )
				item->Centre(x,y,z);
			while ( (item = (CcModelObject*)mBondList->GetItemAndMove()) != nil )
				item->Centre(x,y,z);
			while ( (item = (CcModelObject*)mCellList->GetItemAndMove()) != nil )
				item->Centre(x,y,z);
			while ( (item = (CcModelObject*)mTriList->GetItemAndMove()) != nil )
				item->Centre(x,y,z);
		}
		centred = true;
	}
}

void CcModelDoc::ReDrawHighlights(Boolean notify)
{
	attachedViews.Reset();
	CrModel* aView;
	while( ( aView = (CrModel*)attachedViews.GetItemAndMove() ) != nil)
	{
		HighlightView(aView);
		if(notify)
			aView->UpdateHighlights();
	}

}

void CcModelDoc::HighlightView(CrModel * aView)
{
	mAtomList->Reset();
	CcModelAtom* item;
      aView->StartHighlights();
	while ( (item = (CcModelAtom*)mAtomList->GetItemAndMove()) != nil )
		item->Highlight(aView);
      aView->FinishHighlights();
}

void CcModelDoc::Select(Boolean selected)
{
	if (selected)
		nSelected++;
	else
		nSelected--;
//Update the status flag.
	(CcController::theController)->status.SetNumSelectedAtoms( nSelected );
}

void CcModelDoc::PrepareToGetAtoms()
{
	mAtomList->Reset();
}

CcModelAtom* CcModelDoc::GetModelAtom()
{
	CcModelAtom* item = nil;
	item = (CcModelAtom*)mAtomList->GetItemAndMove();
	return item;
}

void CcModelDoc::SelectAtomByLabel(CcString atomname, Boolean select)
{
	CcModelAtom* item = FindAtomByLabel(atomname);
	if(item)
		item->Select(select);
	ReDrawHighlights(true);
}

CcModelAtom* CcModelDoc::FindAtomByLabel(CcString atomname)
{
	CcString nAtomname = Compress(atomname);
	mAtomList->Reset();
	CcModelAtom* item;
	while ( (item = (CcModelAtom*)mAtomList->GetItemAndMove()) != nil )
	{
		if(item->Label() == nAtomname)
			return item;
	}
	return nil;
}



void CcModelDoc::SelectAllAtoms(Boolean select)
{
	mAtomList->Reset();
	CcModelAtom* item;
	while ( (item = (CcModelAtom*)mAtomList->GetItemAndMove()) != nil )
	{
		item->Select(select);
	}
	ReDrawHighlights(true);
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
	CcModelAtom* item;
	while ( (item = (CcModelAtom*)mAtomList->GetItemAndMove()) != nil )
	{
		item->Select();
	}
	ReDrawHighlights(true);
}
