/*
 *  LaueGroupGraph.cpp
 *  Space Groups
 *
 *  Created by Stefan Pantos on Tue Apr 27 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */

#include "LaueGroupGraph.h"
#include "UnitCell.h"
#include <iterator>
#include "MathFunctions.h"
/*
 * LaueGroupGraph::Link
 */
LaueGroupGraph::Link::Link(Node* pLinkingNode, const Matrix<short>* pRotation, const Matrix<short>* pTransformation):iConnectingNode(pLinkingNode), iRotation(NULL), iTransformation(NULL), iMergedData(NULL), iInvertTransformation(false)
{
	if (pRotation)
	{
		iRotation =  new Matrix<short>(*pRotation);
		if (pTransformation != NULL)
		{
			iTransformation = new Matrix<short>(*pTransformation);
		}
	}
}

LaueGroupGraph::Link::Link(Node* pLinkingNode, const bool pInvertTransformation):iConnectingNode(pLinkingNode), iRotation(NULL), iTransformation(NULL), iMergedData(NULL), iInvertTransformation(pInvertTransformation)
{}


LaueGroupGraph::Link::~Link()
{
	if (iRotation)
		delete iRotation;
	if (iTransformation)
		delete iTransformation;
	if (iMergedData)
		delete iMergedData;
}

std::ostream& LaueGroupGraph::Link::output(std::ostream& pStream)const
{
	pStream << "linked to "; 
	return iConnectingNode->output(pStream);
}

MergedReflections& LaueGroupGraph::Link::merge(HKLData& tReflections)
{
	Matrix<short>* tMatrix = NULL;
	if (!iInvertTransformation)
	{
		if (iRotation == NULL)
		{
			if (iTransformation != NULL)
				tMatrix = new Matrix<short>(*iTransformation);
		}
		else if (iTransformation == NULL)
		{
			if (iRotation != NULL)
					tMatrix = new Matrix<short>(*iRotation);
		}
		else
		{
			tMatrix = new Matrix<short>((*iTransformation)*(*iRotation));
		}
	}
	else
	{
		tMatrix = new Matrix<short>();
		(*tMatrix) = tReflections.transformation();
		tMatrix->inv();
	}
	iMergedData = iConnectingNode->merge(tReflections, tMatrix);
	if (tMatrix)
	{
		delete tMatrix;
	}
	return *iMergedData;
}

float LaueGroupGraph::Link::unitCellRating(HKLData& pReflections)
{
	return iConnectingNode->unitCellRating(pReflections);
}

MergedReflections& LaueGroupGraph::Link::follow(const float pThreshold)
{
	MergedReflections& tResult = (iConnectingNode->follow(*iMergedData, pThreshold));
	std::cout << "Followed " << (*iConnectingNode->laueGroup()) << " with rating " << iMergedData->rFactor() << "\n";
	std::cout << "Data was transformed with: \n" << iMergedData->transformation() << "\n";
	if (&tResult != iMergedData)
	{
		dropReflections();
	}
	return tResult;
}

void LaueGroupGraph::Link::dropReflections() //Releases all the reflections which where generated when merged.
{
	if (iMergedData)
	{
		delete iMergedData;
		iMergedData = NULL;
	}
}

/*
 * LaueGroupGraph::Node
 */
LaueGroupGraph::Node::Node(LaueGroup* pLaueGroup):iLinks(list<Link*>())
{
	iLaueGroup = pLaueGroup;
}

LaueGroupGraph::Node::~Node()
{   
	while (!iLinks.empty())
	{
		delete iLinks.front();
		iLinks.pop_front();
	}
}

LaueGroup* LaueGroupGraph::Node::laueGroup()
{
	return iLaueGroup;
}

void LaueGroupGraph::Node::addLink(Node* pNode, const Matrix<short>* pRotation, const Matrix<short>* pTransformation)
{
	iLinks.push_front(new Link(pNode, pRotation, pTransformation));
}

void LaueGroupGraph::Node::addLink(Node* pNode, const bool pInvertTransformation)
{
	iLinks.push_front(new Link(pNode, pInvertTransformation));
}

size_t LaueGroupGraph::Node::numberOfLinks()
{
	return iLinks.size();
}

std::ostream& LaueGroupGraph::Node::output(std::ostream& pStream)
{
	list<Link*>::iterator tIterator;

	pStream << iLaueGroup << "is linked";
	for (tIterator = iLinks.begin(); tIterator != iLinks.end(); tIterator++)
	{
		pStream << "\t";
		(*tIterator)->output(pStream) << "\n";
	}
	return pStream;
}

MergedReflections& LaueGroupGraph::Node::follow(MergedReflections& pHKLs, const float pThreshold) //Make node merge the reflections for all of it's connection Nodes.
{
	float tThreshold = pThreshold;
	Link* tBestLink = NULL;
	list<Link*>::iterator tIterator;

	for (tIterator = iLinks.begin(); tIterator != iLinks.end(); tIterator++)
	{
		float tFinalRating;
		MergedReflections& tLastMergedRef = (*tIterator)->merge(pHKLs);
		if (maximum(tLastMergedRef.unitCellTensor(), -1000000.0f, tLastMergedRef.unitCellTensor().sizeX()*tLastMergedRef.unitCellTensor().sizeY()) > 0) //If the unit cell wasn't set.
		{
			float tUnitCellRating = (*tIterator)->unitCellRating(tLastMergedRef);
			tFinalRating = (tLastMergedRef.rFactor()+tUnitCellRating)/2;
			std::cout << "\tUnit cell match value: " << tUnitCellRating << " producing and average of: " << tFinalRating << "\n";
		}
		else
		{
			tFinalRating = tLastMergedRef.rFactor();
		}
		if (tFinalRating <= tThreshold)
		{
			if (tBestLink != NULL)
			{
				tBestLink->dropReflections(); //Remove the merged reflections as we want need them.
			}
			tBestLink = (*tIterator);  //This probably should be something else
			tThreshold = tFinalRating;
		}
		else
		{
			(*tIterator)->dropReflections(); //Remove the merged reflections as we want need them.
		}
	}
	if (tBestLink != NULL)
	{
		return tBestLink->follow(pThreshold);
	}
	return pHKLs;
}

Matrix<float> transformMatrixTensorRecipricalSpaceTransfomation(const Matrix<float>& pTensor, const Matrix<short>& pTransformation)
{
	Matrix<float> tInverseTrans = pTransformation; 
	Matrix<float> tInverseTransTransp = tInverseTrans.inv();
	Matrix<float> tTempResult;
	
	tInverseTransTransp.transpose();
	tTempResult = (tInverseTransTransp * pTensor) ;
	return tTempResult * tInverseTrans;
}

MergedReflections* LaueGroupGraph::Node::merge(HKLData& pReflections, Matrix<short>* pTransformationMatrix) //pTransformationMatrix is a transformation which is to be applied to the refelctions
{
	MergedReflections* tMergedReflections;
	Matrix<float> tNewUnitCell;
	Matrix<float> tUnitCellTensor = pReflections.unitCellTensor();

	std::cout << (*iLaueGroup) << " being merged";
	if (pTransformationMatrix)
	{
		std::cout <<  "with transformation";
		tUnitCellTensor = transformMatrixTensorRecipricalSpaceTransfomation(tUnitCellTensor, *pTransformationMatrix);
	}
	std::cout <<  "\n";
	//std::cout << "Reflection num: " << pReflections.size() << "\n";
	MergedData tMergedData(pReflections, *iLaueGroup, pTransformationMatrix);
	tMergedReflections = new MergedReflections(tMergedData.rFactor(), iLaueGroup, tUnitCellTensor);
	tMergedData.mergeReflections(*tMergedReflections);
	if (pTransformationMatrix != NULL)
	{
		tMergedReflections->transformation() = (*pTransformationMatrix) * pReflections.transformation();  //Save the transformations applyed to this data.
	}
	else
		tMergedReflections->transformation() = pReflections.transformation();  //Save the transformations applyed to this data.
	std::cout << "R-Factor = " << tMergedReflections->rFactor() << "\n";
	return tMergedReflections;
}

float LaueGroupGraph::Node::unitCellRating(HKLData& pReflections)
{
	return iLaueGroup->ratingForUnitCell(pReflections.unitCellTensor());
}

/*
 * LaueGroupGraph
 */
LaueGroupGraph::LaueGroupGraph():iNodes(map<const char*, Node*, ltstr>())
{
	LaueGroups* tLaueGroups = LaueGroups::defaultInstance();
	//Node* tTempNodePtr; //temp stores for the nodes. Just for conveniance
	MatrixReader tRotation1("[0 0 1; 1 0 0; 0 1 0]"), tRotation2("[0 1 0; 0 0 1; 1 0 0]"), tInvRotation2("[0  0  1; 1  0  0; 0  1  0]"); //Matrices for rotating the indeces 
	MatrixReader tTransformation("[1 0 1; -1 1 1; 0 -1 1]");
	MatrixReader tTransformToB("[1 0 0; 0 0 1; 0 1 0]");
	
	//-1 links. 
	iRootNode = new Node(tLaueGroups->laueGroupWithSymbol("-1"));
	//create the nodes and put them in a safe place
	iNodes["12/m1"] = new Node(tLaueGroups->laueGroupWithSymbol("12/m1"));
	iNodes["-3"] = new Node(tLaueGroups->laueGroupWithSymbol("-3"));
	iNodes["4/m"] = new Node(tLaueGroups->laueGroupWithSymbol("4/m"));
	iNodes["2/m2/m2/m"] = new Node(tLaueGroups->laueGroupWithSymbol("2/m2/m2/m"));
	iNodes["4/mmm"] = new Node(tLaueGroups->laueGroupWithSymbol("4/mmm"));
	iNodes["-3m1"] = new Node(tLaueGroups->laueGroupWithSymbol("-3m1"));
	iNodes["-31m"] = new Node(tLaueGroups->laueGroupWithSymbol("-31m"));
	iNodes["6/m"] = new Node(tLaueGroups->laueGroupWithSymbol("6/m"));
	iNodes["6/mmm"] = new Node(tLaueGroups->laueGroupWithSymbol("6/mmm"));
	iNodes["m-3"] = new Node(tLaueGroups->laueGroupWithSymbol("m-3"));
	iNodes["m-3m"] = new Node(tLaueGroups->laueGroupWithSymbol("m-3m"));
	//Link the nodes for -1. There are three different versions of 2/m and -3 to get the correct axes 	
	iRootNode->addLink(iNodes["12/m1"]); //Identity
	iRootNode->addLink(iNodes["12/m1"], &tRotation1, NULL); 
	iRootNode->addLink(iNodes["12/m1"], &tRotation2, NULL);
	iRootNode->addLink(iNodes["-3"]);
	iRootNode->addLink(iNodes["-3"], &tRotation1, NULL);
	iRootNode->addLink(iNodes["-3"], &tRotation2, NULL);
	//Link the nodes for 1 2/m 1.
	iNodes["12/m1"]->addLink(iNodes["4/m"]);
	iNodes["12/m1"]->addLink(iNodes["4/m"], &tRotation1, NULL);
	iNodes["12/m1"]->addLink(iNodes["4/m"], &tRotation2, NULL);
	iNodes["12/m1"]->addLink(iNodes["2/m2/m2/m"], true);
	//Link the nodes for -3
	iNodes["-3"]->addLink(iNodes["6/m"]);
	iNodes["-3"]->addLink(iNodes["-3m1"]);
	iNodes["-3"]->addLink(iNodes["-31m"]);
	iNodes["-3"]->addLink(iNodes["m-3"], &tTransformation);
	//Link the nodes for 4/m
	iNodes["4/m"]->addLink(iNodes["4/mmm"]);
	//Link the nodes for 2/m 2/m 2/m
	iNodes["2/m2/m2/m"]->addLink(iNodes["4/mmm"]);
	iNodes["2/m2/m2/m"]->addLink(iNodes["m-3"]);
	//Link the nodes for 6/m
	iNodes["6/m"]->addLink(iNodes["6/mmm"]);
	//Link the nodes for -3 m
	iNodes["-3m1"]->addLink(iNodes["6/mmm"]);
	iNodes["-3m1"]->addLink(iNodes["m-3m"], &tTransformation);
	//Link the nodes for -3 1 m
	iNodes["-31m"]->addLink(iNodes["6/mmm"]);
	iNodes["-31m"]->addLink(iNodes["m-3m"], &tTransformation);
	//Link the nodes for 4/m m m
	iNodes["4/mmm"]->addLink(iNodes["m-3m"]);
	//Link the nodes for m -3
	iNodes["m-3"]->addLink(iNodes["m-3m"]);
}

MergedReflections& LaueGroupGraph::merge(HKLData& tData)
{
	return (iRootNode->follow((*iRootNode->merge(tData)), 0.2/*0.3 old value*/));
}

LaueGroupGraph::~LaueGroupGraph()
{
	map<const char*, Node*, ltstr>::iterator tIterator = iNodes.begin();
	
	for (tIterator = iNodes.begin(); tIterator != iNodes.end(); tIterator++)
	{
		delete tIterator->second;
	}
}

std::ostream& LaueGroupGraph::output(std::ostream& pStream)
{
	map<const char*, Node*, ltstr>::iterator tIterator;
	
	for (tIterator = iNodes.begin(); tIterator != iNodes.end(); tIterator++)
	{
		tIterator->second->output(pStream) << "\n";
	}
	return pStream;
}


std::ostream& operator<<(std::ostream& pStream, LaueGroupGraph& pGraph)
{
	return pGraph.output(pStream);
}
