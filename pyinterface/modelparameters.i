%module crystals
%include "std_string.i"
%{
#include "modelparameters.h"
%}

class Atom {
public:
	Atom();
	~Atom();
	std::string label;
	int serial;
	int flag;
	double occ;
	double x;
	double y;
	double z;
	double U11;
	double U22;
	double U33;
	double U32;
	double U31;
	double U21;
	double spare;
	int part;
    static void show(Atom *a);
};