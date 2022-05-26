#ifndef __FOO_SHARE_MATRIX_H__
#define __FOO_SHARE_MATRIX_H__

#include "foo-matrix.h"

namespace foo {

	class ShareMatrix: public Matrix {
	
		private:
			
			void* p;
		
		public:
			
			ShareMatrix(int matrix_len);
			~ShareMatrix();
			
			void toDevice();
			void toHost();
			
			foo::ShareMatrix operator*(foo::ShareMatrix& m);
	
	};
}


#endif
