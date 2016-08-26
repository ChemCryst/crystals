
/* This file contains shared library entry points for access to the CRYSTALS Fortran library.
   Ideally functions should just pass arguments along and return them with minimum interference.
*/

#include <string>
#include <list>

class Crystals
{
public:
		Crystals();
//		~Crystals();
		void command(std::string s);
		static Crystals* theCrystalsClass;  //sad but necessary for now.
		bool get_next_command(std::string &s);
		static std::string m_crysdir;
		static void storecrysdir(std::string c);
private:
		std::list<std::string> m_strings;

	
};