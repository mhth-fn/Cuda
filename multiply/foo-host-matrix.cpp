
#include "foo-host-matrix.h"



foo::HostMatrix::HostMatrix(int row_count, int column_count) {
	
	this->count_column = column_count;
	this->count_row = row_count;

	(*this).init();
}

foo::HostMatrix foo::HostMatrix::operator*(foo::HostMatrix& m) {
	
	HostMatrix res(this->count_row, m.count_column);
	
	int i, j, r;

	if (this->profiler != nullptr) {
		
		(*(this->profiler)).start();
	}
	
	for (i = 0; i < this->count_row; i++) {
		
	
		for (j = 0; j < m.count_column; j++) {
			
			
			res.data[i*res.count_column + j] = 0.0;
			
			for (r = 0; r < this->count_column; r++) {
				
				res.data[i*res.count_column + j] = res.data[i*res.count_column + j] +
				                                    (this->data[i*this->count_column + r])*(m.data[r*m.count_row + j]);
			}
			
		}
	}
	
	if (this->profiler != nullptr) {
		
		(*(this->profiler)).stop();
	}
	
	return res;
}
