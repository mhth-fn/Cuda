
#include "foo-matrix.h"
#include "foo-matrix-except.h"

foo::Matrix::Matrix() {
	
	int i = 0;

	this->count_column = 0;
	this->count_row = 0;
	this->data = nullptr;
	this->rows = nullptr;
	

}

void foo::Matrix::init() {
	
	int i = 0;

	this->data = new double[(this->count_column)*(this->count_row)]();
	this->rows = new MatrixRow[this->count_row];
	
	for (i = 0; i < this->count_row; i++) {
		
		this->rows[i].length = this->count_column;
		this->rows[i].data = &(this->data[i*(this->count_column)]);
		
	}

}

void foo::Matrix::setProfiler(foo::Profiler& prof) {
	
	this->profiler = &prof;

}

foo::Matrix::~Matrix() {
	
	
	int i = 0;
	
	delete[] this->data;
	this->data = nullptr;
	
	delete[] this->rows;
	this->rows = nullptr;
}

foo::MatrixRow& foo::Matrix::operator[](int index) {
	
	if ((index >= 0) && (index < this->count_row)) {
		
		return this->rows[index];
	
	} else {
		
		throw MatrixExcept(MatrixExcept::ERROR_INVALID_ROW_INDEX);
	}

}

int foo::Matrix::getColumnCount() {
	
	return this->count_column;
}

int foo::Matrix::getRowCount() {
	
	return this->count_row;
}
