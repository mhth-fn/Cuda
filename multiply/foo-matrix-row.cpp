
#include <iostream>

#include "foo-matrix-row.h"
#include "foo-matrix-except.h"

foo::MatrixRow::MatrixRow() {
	
	this->length = 0;
	this->data = nullptr;

}

double& foo::MatrixRow::operator[](int index) {
	
	if ((index >= 0) && (index < this->length)) {
		
		return (this->data[index]);
		
	} else {
		
		throw MatrixExcept(MatrixExcept::ERROR_INVALID_COLUMN_INDEX);
	}
}
