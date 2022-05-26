#ifndef __FOO_MATRIX_ROW_H__
#define __FOO_MATRIX_ROW_H__

#include <cstdlib>

#define nullptr (NULL)

namespace foo {

	class MatrixRow {
			
		
		public:
		
			double* data;
			int length;
			
			MatrixRow();
			
			double& operator[](int index);
			
	};

}


#endif
