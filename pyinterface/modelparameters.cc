

#include <string>
#include <iostream>
#include "modelparameters.h"


Atom::Atom(){
	
}

Atom::~Atom(){
	
}	

void Atom::show(Atom *a) {
	std::cout << a->label << " " << a->x << " " << a->y << " " << a->z << std::endl;
}

