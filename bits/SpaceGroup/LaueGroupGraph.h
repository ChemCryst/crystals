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

/*!
 * @class LaueGroupGraph 
 * @description Not yet documented.
 * @abstract
*/
class LaueGroupGraph
{
	protected:
		class Node;
		/*!
		 * @class Link 
		 * @description Not yet documented.
		 * @abstract
		*/
		class Link
		{
			protected:
				Node* iConnectingNode;
				Matrix<short>* iRotation; //If NULL then assumed to be identity
				Matrix<short>* iTransformation; //If NULL assumed to be identity
				MergedReflections* iMergedData;
				bool iInvertTransformation; //Remove the transformation applied to the data already.
			public:
				Link(Node* pLinkingNode, const Matrix<short>* pRotation = NULL, const Matrix<short>* pTransformation = NULL);
				Link(Node* pNode, const bool pInvertTransformation);

				/*!
				 * @function output 
				 * @description Not yet documented.
				 * @abstract
				 */
				std::ostream& output(std::ostream& pStream) const;
				Node *node();
				~Link();
				//Methods for the merging

				/*!
				 * @function unitCellRating 
				 * @description Not yet documented.
				 * @abstract
				 */
				float unitCellRating(HKLData& pReflections);

				/*!
				 * @function dropReflections 
				 * @description Not yet documented.
				 * @abstract
				 */
				void dropReflections(); //Releases all the reflections which where generated when merged.

				/*!
				 * @function merge 
				 * @description Not yet documented.
				 * @abstract
				 */
				MergedReflections& merge(HKLData& tReflections);

				/*!
				 * @function follow 
				 * @description Not yet documented.
				 * @abstract
				 */
				MergedReflections& follow(const float pThreshold);
		};
			
		/*!
		 * @class Node 
		 * @description Not yet documented.
		 * @abstract
		*/
		class Node
		{
			protected:
				LaueGroup* iLaueGroup; //A reference to the LaueGroup this node represents. Not to be released by this class
				list<Link*> iLinks; //A list of the links from this node to the others.
			public:
				Node(LaueGroup* pLaueGroup);
				~Node();

				/*!
				 * @function addLink 
				 * @description Not yet documented.
				 * @abstract
				 */
				void addLink(Node* pNode, const Matrix<short>* pRotation = NULL, const Matrix<short>* pTransformation = NULL);

				/*!
				 * @function addLink 
				 * @description Not yet documented.
				 * @abstract
				 */
				void addLink(Node* pNode, const bool pInvertTransformation); //remove any transformations applied to the data already.

				/*!
				 * @function numberOfLinks 
				 * @description Not yet documented.
				 * @abstract
				 */
				size_t numberOfLinks();

				/*!
				 * @function laueGroup 
				 * @description Not yet documented.
				 * @abstract
				 */
				LaueGroup* laueGroup();

				/*!
				 * @function output 
				 * @description Not yet documented.
				 * @abstract
				 */
				std::ostream& output(std::ostream& pStream);
				//Methods for the merging
//				void dropReflections(); //Releases all the reflections which where generated when merged.

				/*!
				 * @function unitCellRating 
				 * @description Not yet documented.
				 * @abstract
				 */
				float unitCellRating(HKLData& pReflections);

				/*!
				 * @function follow 
				 * @description Not yet documented.
				 * @abstract
				 */
				MergedReflections& follow(MergedReflections& tReflections, const float pThreshold); //Make node merge the reflections for all of it's connection Nodes.

				/*!
				 * @function merge 
				 * @description Not yet documented.
				 * @abstract
				 */
				MergedReflections* merge(HKLData& tReflections, Matrix<short>* pTransformationMatrix = NULL);
		};
		
		Node* iRootNode; //The first node in the graph which all nodes are connected to. This should be -1
		map<const char*, Node*, ltstr> iNodes; //A list of all the nodes which are created. this is really just a store for releasing all of them.
	public:
		LaueGroupGraph();
		~LaueGroupGraph();

		/*!
		 * @function output 
		 * @description Not yet documented.
		 * @abstract
		 */
		std::ostream& output(std::ostream& pStream);

		/*!
		 * @function merge 
		 * @description Not yet documented.
		 * @abstract
		 */
		MergedReflections& merge(HKLData& tData);
		//std::ostream& LaueGroupGraph::operator<<(std::ostream& pStream, const LaueGroupGraph::Link& pLink);
};

std::ostream& operator<<(std::ostream& pStream, const LaueGroupGraph& pGraph);
#endif
