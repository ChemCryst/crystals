/*
 *  MathFunctions.h
 *  Space Groups
 *
 *  Created by Stefan Pantos on Wed Dec 11 2002.
 *  Copyright (c) 2002 . All rights reserved.
 *
 */
#ifndef __MATH_FUNCTIONS_H__
#define __MATH_FUNCTIONS_H__

#include <stdlib.h>

#if !defined(_WIN32)
#define max(A, B) A>B?A:B	/*returns the max of two numbers*/
#define min(A, B) A<B?A:B	/*returns the min of two numbers*/
#endif
#define sqr(A) A*A	/*Squares a number*/
#define deg2rad(A) A/57.2957795130823f  /*Converts degrees to radians*/
#define rad2deg(A) A/0.0174532925199433f  /*Converts radians to degrees*/
#define kSmallValue 1e-4f
#define kVSmallValue 1e-8f


/*!
 * @function cumlNormal 
 * @description Not yet documented.
 * @abstract
 */
float cumlNormal(float pX, float pMean, float pSD);

/*!
 * @function variance 
 * @description Not yet documented.
 * @abstract
 */
float variance(const float pValues[], const size_t pNumValues);

template <class T, class U>

/*!
 * @function maximum 
 * @description Not yet documented.
 * @abstract
 */
U maximum(const T& pValues, const U& pInitialValue, const size_t pNumValues)
{
	U tMax = pInitialValue;
	for (size_t i = 0; i < pNumValues; i++)
	{
		tMax = max(pValues[i], tMax);
	}
	return tMax;
}

template <class T, class U>

/*!
 * @function sum 
 * @description Not yet documented.
 * @abstract
 */
U sum(const T& pValues, const U& pInitialValue, const size_t pNumValues)
{
	U tSum = pInitialValue;
	for (size_t i = 0; i < pNumValues; i++)
	{
		tSum += pValues[i];
	}
	return tSum;
}

template <class T, class U>

/*!
 * @function mean 
 * @description Not yet documented.
 * @abstract
 */
U mean(const T& pValues, const U& pInitialValue, const size_t pNumValues)
{

	/*!
	 * @function sum 
	 * @description Not yet documented.
	 * @abstract
	 */
	return sum(pValues, pInitialValue, pNumValues)/pNumValues;
}


/*!
 * @function smallValue 
 * @description Not yet documented.
 * @abstract
 */
float smallValue(float pValue); //returns 0 if the value is thought of being small and the value otherwise.

/*!
 * @function vSmallValue 
 * @description Not yet documented.
 * @abstract
 */
float vSmallValue(float pValue); //returns 0 if the value is thought of being very small and the value otherwise.

template<class type>

/*!
 * @function length 
 * @description Not yet documented.
 * @abstract
 */
type length(const type pX, const type pY, const type pZ)
{
    return (type)sqrt((double)pX*pX+pY*pY+pZ*pZ);
}
#endif
