#ifndef __FOO_HOST_MATRIX_H__
#define __FOO_HOST_MATRIX_H__

#include "foo-matrix.h"

namespace foo {
	
	class HostMatrix: public Matrix {
		
		public:
			
			HostMatrix(int row_count, int column_count);
			
			foo::HostMatrix operator*(foo::HostMatrix& m);
		
	};


}


#endif
