/*
 *  Wrappers.h
 *  Space Groups
 *
 *  Created by Stefan on Fri Jun 20 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(__WRAPPERS_H__)
#define __WRAPPERS_H__
template <class numberType>
/*!
 * @class Number 
 * @description Not yet documented.
 * @abstract
*/
class Number
{
    protected:
        numberType iValue;
    public:
        Number(const numberType pNumber):iValue(pNumber)
        {
            iValue = pNumber;
        }
        
		Number(const Number<numberType>& pNumber):iValue(pNumber.iValue)
        {
        }
        
        virtual numberType value() const
        {
            return iValue;
        }
        
        virtual bool operator<(const Number<numberType>& pNumber) const
        {
            return iValue < (pNumber.iValue);
        }
        
        virtual bool operator>(const Number<numberType>& pNumber) const
        {
            return iValue > (pNumber.iValue);
        }
        
        virtual bool operator==(Number<numberType>& pNumber) const 
        {
            return iValue == (pNumber.iValue);
        }
        
        virtual bool operator!=(Number<numberType>& pNumber) const
        {
            return iValue != (pNumber.iValue);
        }
                
        virtual Number<numberType>& operator=(const Number<numberType>& pNumber)
        {
            iValue = (pNumber.iValue);
            return *this;
        }
        
        virtual Number<numberType>& operator+=(const Number<numberType>& pNumber)
        {
            iValue += (pNumber.iValue);
            return *this;
        }
        
        virtual Number<numberType>& operator-=(const Number<numberType>& pNumber)
        {
            iValue -= (pNumber.iValue);
            return *this;
        }
        
        virtual Number<numberType>& operator*=(const Number<numberType>& pNumber)
        {
            iValue *= (pNumber.iValue);
            return *this;
        }
        
        virtual Number<numberType>& operator/=(const Number<numberType>& pNumber)
        {
            iValue /= (pNumber.iValue);
            return *this;
        }
        
        virtual Number<numberType>& operator++()
        {
            iValue++;
            return *this;
        }
        
        virtual Number<numberType>& operator--()
        {
            iValue--;
            return *this;
        }
};
        
/*!
 * @class Float 
 * @description Not yet documented.
 * @abstract
*/
class Float:public Number<float>
{
    public:
        Float(float pValue):Number<float>(pValue)
        {}
        

        /*!
         * @function float 
         * @description Not yet documented.
         * @abstract
         */
        operator float() const{return this->value();}
};

/*!
 * @class Integer 
 * @description Not yet documented.
 * @abstract
*/
class Integer:public Number<int>
{
    public:
        Integer(int pValue):Number<int>(pValue)
        {}
};
#endif
