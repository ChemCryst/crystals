/*
 *  LaueGroupGraph.h
 *  Space Groups
 *
 *  Created by Stefan Pantos on Tue Apr 27 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef __LAUE_GROUP_GRAPH_H__
#define __LAUE_GROUP_GRAPH_H__

#include <list>
#include <map>
#include <iostream>
#include "LaueClasses.h"
#include "Matrices.h"
#include "HKLData.h"
#include "MergedData.h"

class LaueGroupGraph
{
	protected:
		class Node;
		 
		class Link
		{
			protected:
				Node* iConnectingNode;
				Matrix<short>* iRotation; //If NULL then assumed to be identity
				Matrix<short>* iTransformation; //If NULL assumed to be identity
				MergedReflections* iMergedData;
			public:
				Link(Node* pLinkingNode, const Matrix<short>* pRotation = NULL, const Matrix<short>* pTransformation = NULL);
				std::ostream& output(std::ostream& pStream) const;
				Node *node();
				~Link();
				//Methods for the merging
				void dropReflections(); //Releases all the reflections which where generated when merged.
				MergedReflections& merge(HKLData& tReflections);
				MergedReflections& follow(const float pThreshold);
		};
			
		class Node
		{
			protected:
				JJLaueGroup* iLaueGroup; //A reference to the LaueGroup this node represents. Not to be released by this class
				list<Link*> iLinks; //A list of the links from this node to the others.
			public:
				Node(JJLaueGroup* pLaueGroup);
				~Node();
				void addLink(Node* pNode, const Matrix<short>* pRotation = NULL, const Matrix<short>* pTransformation = NULL);
				size_t numberOfLinks();
				JJLaueGroup* laueGroup();
				std::ostream& output(std::ostream& pStream);
				//Methods for the merging
//				void dropReflections(); //Releases all the reflections which where generated when merged.
				MergedReflections& follow(MergedReflections& tReflections, const float pThreshold); //Make node merge the reflections for all of it's connection Nodes.
				MergedReflections* merge(HKLData& tReflections, Matrix<short>* pTransformationMatrix = NULL);
		};
		
		Node* iRootNode; //The first node in the graph which all nodes are connected to. This should be -1
		map<const char*, Node*, ltstr> iNodes; //A list of all the nodes which are created. this is really just a store for releasing all of them.
	public:
		LaueGroupGraph();
		~LaueGroupGraph();
		std::ostream& output(std::ostream& pStream);
		MergedReflections& merge(HKLData& tData);
		//std::ostream& LaueGroupGraph::operator<<(std::ostream& pStream, const LaueGroupGraph::Link& pLink);
};

std::ostream& operator<<(std::ostream& pStream, const LaueGroupGraph& pGraph);
#endif
