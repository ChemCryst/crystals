/*
 *  Conditions.h
 *  Space Groups
 *
 *  Created by Stefan on Tue Jul 15 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */

#if !defined(__CONDITIONS_H__)
#define __CONDITIONS_H__
#include "Matrices.h"
#include <vector>

/*!
 * @class Condition 
 * @description Not yet documented.
 * @abstract
*/
class Condition:public Matrix<short>
{
    private:
        char* iName;
        int iID;
        float iMult;
    public:
        Condition(char* pLine);
        ~Condition();

        /*!
         * @function getName 
         * @description Not yet documented.
         * @abstract
         */
        char* getName();

        /*!
         * @function getMult 
         * @description Not yet documented.
         * @abstract
         */
        float getMult();

        /*!
         * @function getID 
         * @description Not yet documented.
         * @abstract
         */
        int getID();

        /*!
         * @function output 
         * @description Not yet documented.
         * @abstract
         */
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, Condition& pCondition);

/*!
 * @class Conditions 
 * @description Not yet documented.
 * @abstract
*/
class Conditions:public vector<Condition*>
{
    public:
        Conditions();
        ~Conditions();

        /*!
         * @function getName 
         * @description Not yet documented.
         * @abstract
         */
        char* getName(const size_t pIndex);

        /*!
         * @function getMult 
         * @description Not yet documented.
         * @abstract
         */
        float getMult(const size_t pIndex);

        /*!
         * @function getMatrix 
         * @description Not yet documented.
         * @abstract
         */
        Matrix<short>* getMatrix(const size_t pIndex);

        /*!
         * @function getID 
         * @description Not yet documented.
         * @abstract
         */
        int getID(const size_t pIndex);

        /*!
         * @function addCondition 
         * @description Not yet documented.
         * @abstract
         */
        char* addCondition(char* pLine);

        /*!
         * @function readFrom 
         * @description Not yet documented.
         * @abstract
         */
        void readFrom(filebuf& pFile);

        /*!
         * @function output 
         * @description Not yet documented.
         * @abstract
         */
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, Conditions& pConditions);
#endif

