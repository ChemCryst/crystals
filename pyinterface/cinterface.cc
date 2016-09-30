
	/* This file contains shared library entry points for access to the CRYSTALS Fortran library.
   Ideally functions should just pass arguments along and return them with minimum interference.
*/


#define DLLEXP __cdecl __declspec(dllexport)

#include <string.h>
//#include <stdio.h>
//#include <setjmp.h>
#include <exception>
#include <iostream>

#include "cinterface.h"

extern "C" {
	void crinitwrap();
	void commandwrap();
}

class CrException: public std::exception
{
public:
	virtual const char* what() const throw()
	{
		return "CrException occured";
	}
} crex;

class CrErrorException: public std::exception
{
public:
	virtual const char* what() const throw()
	{
		return "CrErrorException occured";
	}
	void setcode(int i){
		error_code = i;
	}
	int error_code;
};

class CrEndException: public std::exception
{
public:
	virtual const char* what() const throw()
	{
		return "CrEndException occured";
	}
} crendex;

class CrInitException: public std::exception
{
public:
	virtual const char* what() const throw()
	{
		return "CrInitException occured";
	}
} crinitex;

Crystals* Crystals::theCrystalsClass ;
std::string Crystals::m_crysdir;

Crystals::Crystals() {
// Ideally we want to initialize with a path to a .dsc file (existing or not).
		theCrystalsClass = this;
	try{
		crinitwrap();
		commandwrap(); //Process the startup files.
	}
	catch (CrEndException& e) {    // This exception means that Crystals was closed with a #FINISH or #END.
		std::cout << "Crystals finished OK" << '\n';
	}
	catch (CrErrorException& e) {  // This exception means that the Fortran called GUEXIT routine (in the old days a 'STOP') after an error.
		std::cout << "Severe CRYSTALS error caught. Check output files. Error code: " << e.what() << '\n';
	}
	catch (CrInitException& e) {  // This exception means that the startup folder was not set.
		std::cout << "Initialisation files not found. " << e.what() << '\n';
	}
	catch (std::exception& e) {    // This exception means that Crystals was closed with a #FINISH or #END.
		std::cout << "Unhandled exception " << e.what() <<'\n';
	}

}
		
void Crystals::command(std::string str) {

// Split the string at newlines into a list of strings. Store this list in the member variable m_strings.

    std::string::size_type pos = 0;
    std::string::size_type prev = 0;
    while ((pos = str.find('\n', prev)) != std::string::npos)
    {
        m_strings.push_back(str.substr(prev, pos - prev));
        prev = pos + 1;
    }

    // To get the last substring (or only, if delimiter is not found)
    m_strings.push_back(str.substr(prev));
	
	try{
	
		while ( true ) {
	
			int nstrings = m_strings.size();
			if ( nstrings == 0 ) break;
			
			commandwrap();   // CALL THE FORTRAN - it will fetch commands via get_command function.
			
			if ( nstrings == m_strings.size() ) {  // No strings processed before return. Abandon processing.
				
				std::cout << "Processing error - no commands read by crystals routines in last call.";
				std::list<std::string>::iterator it;
				for (it=m_strings.begin(); it!=m_strings.end(); ++it)
					std::cout << ' ' << *it << '\n';
				m_strings.clear();
			}
	
		}
	
	}
	catch (CrException& e) {    // This exception means that the command line interpreter ran out of things to fetch (in getcommand() - see below).
//		std::cout << e.what() << '\n';
	}
	catch (CrEndException& e) {    // This exception means that Crystals was closed with a #FINISH or #END.
		std::cout << "Crystals finished OK" << '\n';
	}
	catch (CrErrorException& e) {  // This exception means that the Fortran called GUEXIT routine (in the old days a 'STOP') after an error.
		std::cout << "Severe CRYSTALS error caught. Check output files. Error code: " << e.what() << '\n';
	}
	
	
}

void Crystals::storecrysdir(std::string crysdir) {   // Called from python to store resources location}
	m_crysdir = crysdir;
}




bool Crystals::get_next_command(std::string &s)
{
	bool ret = false;
	if ( m_strings.size() > 0 ) {
		s = m_strings.front();
		m_strings.pop_front();
		ret = true;
	}
	return ret;
}

extern "C" {
// Called from CRYSTALS to get next command
// If run out - throw exception / longjmp back to start.
	long getcommand(char *commandline)
	{
		int inputlen = strlen(commandline);
		std::string command;
		int retOK = 0;
	
		if ( Crystals::theCrystalsClass->get_next_command(command) ){
			std::cout << command << '\n';
			int commandlen = command.length();
			int outputlen = (inputlen < commandlen) ? inputlen : commandlen;  //Minimum of the two string lengths
			strncpy( commandline, command.c_str(), outputlen ); 		
		//PAD
			for (int j = commandlen; j<inputlen; j++)   //Copy
			{
				*(commandline + j) = ' ';
			}
		} else {
//			printf("No more commands - raising endofcommands exception\n");
			throw crex;
// Should never get here:
			printf("No exception raised. Returning -1\n");
			retOK = -1;
		}
		return retOK;
	}

	void exitpythread (int ivar) {
		if ( ivar == 0 ) {
			throw crendex;    // just a normal '#end' exit.
		}
		CrErrorException err;
		err.setcode(ivar);
		throw err;  // some kind of error

	}
	
	long getcrysdir(char *crysdir)   // Called from CRYSTALS to get Crysdir (or, eventually, any env_var lookup - TODO)
	{
		int inputlen = strlen(crysdir);
		int retOK = 0;
	
		if ( Crystals::m_crysdir.length() > 0 ){
			std::cout << Crystals::m_crysdir << '\n';
			int crysdirlen = Crystals::m_crysdir.length();
			int outputlen = (inputlen < crysdirlen) ? inputlen : crysdirlen;  //Minimum of the two string lengths
			strncpy( crysdir, Crystals::m_crysdir.c_str(), outputlen );
		//PAD
			for (int j = crysdirlen; j<inputlen; j++)   //Copy
			{
				*(crysdir + j) = ' ';
			}
		} else {
//			printf("No more commands - raising endofcommands exception\n");
			throw crinitex;
// Should never get here:
			printf("No exception raised. Returning -1\n");
			retOK = -1;
		}
		return retOK;
	}
}

