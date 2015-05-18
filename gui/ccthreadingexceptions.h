/*
 *  ThreadingExceptions.h
 *  
 *
 *  Created by Stefan Pantos on 01/02/2005.
 *
 */
 
 // $Log: not supported by cvs2svn $
 // Revision 1.1  2005/02/02 15:27:23  stefan
 // 1. Initial addition to crystals. A group of classes for threading.
 //
 
// Not using __ prefix for this as they are usualy resurved for the system libraries I think
#if !defined(CcThreadingExceptions_H__) 
#define CcThreadingExceptions_H__

#include <exception>
#include <stdexcept>
#include <sstream>
#include <string>

#if defined(CRY_USEMFC)
typedef DWORD error_type;
#else
typedef unsigned int error_type;
#endif

namespace std 
{
	class semaphore_timeout : public runtime_error
	{
		public:
			semaphore_timeout() : runtime_error("Semaphore timed out."){}
			virtual ~semaphore_timeout() throw(){}
	};
	
	class thread_error:public logic_error
	{
		protected:
			error_type iError;
		public:
			thread_error(const string& pErrorType, const error_type pErrorNum):
				logic_error(pErrorType), iError(pErrorNum)
			{}
			virtual ~thread_error() throw(){} 
			virtual const unsigned int number() const
			{
				return iError;
			}
	};
	
	class semaphore_error : public thread_error
	{
		public:
			semaphore_error(const error_type pError):thread_error("Semaphore Error", pError)
			{}
			virtual ~semaphore_error() throw(){}
	};
	
	class mutex_error : public thread_error
	{
		public:
			mutex_error(const error_type pError):thread_error("Mutex Error", pError)
			{};
			virtual ~mutex_error() throw() {};
	};
}

#endif
